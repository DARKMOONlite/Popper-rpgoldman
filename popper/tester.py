import os
from importlib import resources
from janus_swi import TruthVal, query, query_once as janus_query_once, consult
from functools import cache, lru_cache
from contextlib import contextmanager
from . util import order_prog, prog_is_recursive, rule_is_recursive, calc_rule_size, calc_prog_size, get_raw_prog, format_rule, Literal, mdl_score, order_rule, canonicalise_prog_hash
from . bkcons import deduce_neg_example_recalls
from bitarray import frozenbitarray
from bitarray.util import ones, zeros
from collections import defaultdict
from itertools import combinations
from typing import NamedTuple
from . import logger
import numpy as np
from . compact_hash import CompactHashTable, IndexedInternPool
import uuid 
import tempfile
import shutil
# MAXIMUM TESTING TIME FOR A RECURSIVE HYPOTHESIS
EVAL_TIMEOUT=0.001
COMPACT_CACHE_EXPECTED_ENTRIES = 1_000_000

def compact_capacity_for_entries(expected_entries):
    return (expected_entries * 4) // 3 + 1

# should be immutable
class TestResult(NamedTuple):
    tp: int
    fn: int
    tn: int
    fp: int
    pos_covered : frozenbitarray
    neg_covered : frozenbitarray
    inconsistent: bool
    conf_matrix: tuple
    mdl: int = None
    too_few_tp: bool = False
    too_many_fp: bool = False

def query_once(query,inputs={},keep=False,truth_vals=TruthVal.PLAIN_TRUTHVALS,module_name=None):
    """A wrapper function for janus_swi.query_once that formats the query string and passes the module name.
    """
    if module_name is None: # if no module name is provided, just call the original query_once function
        return janus_query_once(query, inputs=inputs, keep=keep, truth_vals=truth_vals)
    return janus_query_once(f"{module_name}:({query.strip().rstrip('.')})", inputs=inputs, keep=keep, truth_vals=truth_vals)


def bool_query(query, module_name):
    return query_once('term_string(_G, QStr), call(_G)', {'QStr': query}, module_name=module_name)['truth']

@cache
def format_literal_janus(literal):
    args = ','.join(f'_V{i}' for i in literal.arguments)
    return f'{literal.predicate}({args})'

def rule_has_redundant_literal(rule,module_name=None):
    head, body = rule
    lits = tuple(format_literal_janus(lit) for lit in body)
    if head:
        lits = (f"not_{format_literal_janus(head)}",) + lits
    lits_str = f"[{','.join(lits)}]"
    return query_once('redundant_literal_str(S)', {'S': lits_str}, module_name=module_name)['truth']

def frozen_bits_from_indices(size, indices):
    bits = zeros(size)
    bits[indices] = 1
    return frozenbitarray(bits)

class Tester():

    @lru_cache(50_000)
    def parse_rule(self, rule):
        head, ordered_body = order_rule(rule, self.settings)
        atom_str = format_literal_janus(head) if head else ""
        body_str = ','.join(format_literal_janus(lit) for lit in ordered_body)
        return atom_str, body_str

    @lru_cache(50_000)
    def parse_body(self, body):
        return self.parse_rule((None, body))[1]

    def __init__(self, settings, state):
        self.settings = settings
        self.state = state
        self.module_name = 'popper_tester_module_' + str(uuid.uuid4().int)
        self.prog_file = f'{self.module_name}_prog'
        
        if not janus_query_once('use_module(library(modules))')['truth']:
            raise Exception('library(modules) not loaded')
        
        if not janus_query_once(f'modules:prepare_temporary_module({self.module_name})')['truth']:
            raise Exception(f'module {self.module_name} not created')

        bk_pl_path = self.settings.bk_file
        exs_pl_path = self.settings.ex_file
        test_pl_path = str(resources.files(__package__).joinpath("lp/test.pl"))

        if not self.settings.pi_enabled:
            consult(
                self.prog_file,
                f':- dynamic {self.settings.head_literal.predicate}/{len(self.settings.head_literal.arguments)}.',
                module=self.module_name,
            )

        # create temporary test_pl_file 
        with tempfile.NamedTemporaryFile(delete=False, suffix=".pl") as tmp:
            tmp.close()
            shutil.copyfile(test_pl_path, tmp.name)
            
            for x in [exs_pl_path, bk_pl_path, tmp.name]:
                if os.name == 'nt': # if on Windows, SWI requires escaped directory separators
                    x = x.replace('\\', '\\\\')
                logger.info(f'Consulting {x}')
                consult(x,module=self.module_name) # this shouldn't be loaded into a module as otherwise other modules cant read these shared files

        logger.info(f'Loading examples')
        query_once('load_examples', module_name=self.module_name)

        neg_literal = Literal('neg_fact', tuple(range(len(self.settings.head_literal.arguments))))
        self.neg_fact_str = format_literal_janus(neg_literal)
        self.neg_literal_set = frozenset([neg_literal])

        q = 'findall(_Atom2, (neg_index(_K, _Atom1), term_string(_Atom1, _Atom2)), S)'
        res = query_once(q, module_name=self.module_name)['S']
        atoms = []
        for x in res:
            x = x[:-1].split('(')[1].split(',')
            atoms.append(x)

        if atoms:
            try:
                logger.info(f'Deducing neg example recalls')
                deduce_neg_example_recalls(settings, atoms)
            except Exception as e:
                print(e)

        logger.info(f'Determining number of examples')
        self.num_pos = query_once('findall(_K, pos_index(_K, _Atom), _S), length(_S, N)', module_name=self.module_name)['N']
        self.num_neg = query_once('findall(_K, neg_index(_K, _Atom), _S), length(_S, N)', module_name=self.module_name)['N']

        self.pos_examples_ = ones(self.num_pos)
        self.empty_pos_covered = frozenbitarray(self.num_pos)
        self.empty_neg_covered = frozenbitarray(self.num_neg)
        compact_cache_capacity = compact_capacity_for_entries(COMPACT_CACHE_EXPECTED_ENTRIES)
        self.compact_pos_covered = CompactHashTable(np.int32, compact_cache_capacity)
        self.compact_prog_inconsistent = CompactHashTable(np.uint8, compact_cache_capacity)
        self._intern_pool = IndexedInternPool()

        if self.settings.recursion_enabled:
            query_once(f'assert(timeout({EVAL_TIMEOUT})), fail', module_name=self.module_name)

    def __del__(self):
        self.clear_janus_cache()
        if not janus_query_once('modules:destroy_module(Module)', {'Module': self.module_name})['truth']:
            raise RuntimeError(f'module {self.module_name} not destroyed')

    @staticmethod
    def clear_janus_cache():
        janus_query_once(
            'retractall(janus:py_call_cache(_String, _Input, _TV, _M, _Goal, _Dict, _Truth, _OutVars))'
        )

    # main entry point for calling prolog without noise and we call this method for every program
    def test_prog(self, prog, prog_size=None):
        inconsistent = False

        pos_covered = self._test_prog_pos(prog)
        if self.num_neg > 0 and (len(prog) > 1 or pos_covered.any()):
            inconsistent = self.test_prog_inconsistent(prog)

        tp = pos_covered.count(1)
        fn = self.num_pos - tp

        return TestResult(
            tp=tp,
            fn=fn,
            tn=None,
            fp=None,
            pos_covered=pos_covered,
            neg_covered=None,
            inconsistent=inconsistent,
            conf_matrix=(tp, fn, None, None)
        )

    # main entry point for calling prolog with noise
    # we call this method for every noisy program
    def test_prog_noisy(self, prog, prog_size):
        settings = self.settings
        neg_covered = None
        too_few_tp = False
        too_many_fp = False
        inconsistent = False

        if len(prog) == 1:
            # AC: we could push all this reasoning to Prolog to only need a single call
            pos_covered = self._test_prog_pos(prog)
            tp = pos_covered.count(1)

            if tp > prog_size:
                # maximum size of specialisations allowed
                max_k_neg1 = min(settings.max_body - (prog_size - 1), self.state.max_literals - prog_size)
                # conditions which determine whether a program can be part of a solution
                max_k_neg2 = min(self.state.best_hypothesis_mdl - prog_size, tp - prog_size)
                max_k_neg = max(max_k_neg1, max_k_neg2)
                neg_covered = []
                if self.num_neg > 0:
                    (rule,) = prog
                    atom_str, body_str = self.parse_rule(rule)
                    neg_covered = query_once('find_neg_firstn(K, R, S)', {'K': max_k_neg, 'R': f'{atom_str}:-{body_str}'}, module_name=self.module_name)['S']
                neg_covered = frozen_bits_from_indices(self.num_neg, neg_covered)
                if neg_covered.count(1) == max_k_neg:
                    too_many_fp = True

                inconsistent = neg_covered.any()
            else:
                too_few_tp = True
        else:
            pos_covered, neg_covered = self.test_prog_all(prog)
            inconsistent = neg_covered.any()
            tp = pos_covered.count(1)

        # Calculate final metrics
        fn = self.num_pos - tp
        fp = None
        tn = None
        mdl = None

        if not too_few_tp:
            fp = neg_covered.count(1)
            tn = self.num_neg - fp
            mdl = mdl_score(fn, fp, prog_size)

        return TestResult(
            tp=tp,
            fn=fn,
            tn=tn,
            fp=fp,
            pos_covered=pos_covered,
            neg_covered=neg_covered,
            inconsistent=inconsistent,
            conf_matrix=(tp, fn, tn, fp),
            mdl=mdl,
            too_few_tp=too_few_tp,
            too_many_fp=too_many_fp
        )

    def test_prog_inconsistent(self, prog):
        if self.num_neg == 0:
            return False

        prog_hash = canonicalise_prog_hash(prog, self.settings.max_vars)
        res = self.compact_prog_inconsistent.get(prog_hash)
        if res is not None:
            return bool(res)

        if len(prog) == 1:
            (rule,) = prog
            atom_str, body_str = self.parse_rule(rule)
            q = f'neg_index(_ID, {atom_str}), {body_str}'
            res = bool_query(q, module_name=self.module_name)
        else:
            with self.using(prog):
                res = bool_query("inconsistent", module_name=self.module_name)

        self.compact_prog_inconsistent[prog_hash] = int(res)
        return res

    def is_body_sat(self, body):
        return bool_query(self.parse_body(body), module_name=self.module_name)

    # used by the unsat core checker to see if a rule is satisfiable
    def is_sat(self, prog):

        prog_hash = canonicalise_prog_hash(prog, self.settings.max_vars)
        idx = self.compact_pos_covered.get(prog_hash, -1)
        if idx >= 0:
            return self._intern_pool.lookup(idx).any()

        if len(prog) == 1:
            (rule,) = prog
            head, _body = rule
            head_str = format_literal_janus(head)
            _, ordered_body = self.parse_rule(rule)

            if self.settings.noisy:
                return query_once('pos_succeeds_k(R, K)', {'R': f'{head_str}:-{ordered_body}', 'K': calc_rule_size(rule)}, module_name=self.module_name)['truth']
            else:
                if self.state.min_pos_coverage == 1:
                    return bool_query(f'pos_index(_ID, {head_str}),{ordered_body}',module_name=self.module_name)
                else:
                    return query_once('pos_succeeds_k(R, K)', {'R': f'{head_str}:-{ordered_body}', 'K': self.state.min_pos_coverage}, module_name=self.module_name)['truth']
        else:
            with self.using(prog):
                if self.settings.noisy:
                    return query_once(f'covers_at_least_k_pos(K)',{'K':calc_prog_size(prog)}, module_name=self.module_name)['truth']
                else:
                    return bool_query('sat', module_name=self.module_name)

    # called by the allsat code
    # tries to determine whether literal is implied by body for the negative examples
    # AC: we do not cache as we can never see body + neg_literal again
    def is_neg_reducible(self, body, literal):
        body_str = self.parse_body(body.union(self.neg_literal_set))
        literal_str = format_literal_janus(literal)
        q = f'{body_str}, \\+ {literal_str}'
        return not bool_query(q, module_name=self.module_name)

    # called by the allsat code
    # checks whether a literal is implied by the body
    def is_literal_redundant(self, body, literal):
        q = f'{self.parse_body(body)}, \\+ {format_literal_janus(literal)}'
        return not bool_query(q, module_name=self.module_name)

    # also called by the allsat code
    def diff_subs_single(self, literal):
        literal_str = format_literal_janus(literal)
        q = f'{self.neg_fact_str}, \\+ {literal_str}'
        return not bool_query(q, module_name=self.module_name)

    # ONLY CALLED BY THE COMBINER WHEN THERE IS MORE THAN ONE RULE
    # also called internally by test_prog_noisy
    def test_prog_all(self, prog):
        pos_covered = self._test_prog_pos(prog)
        neg_covered = self.test_prog_neg(prog)
        return pos_covered, neg_covered

    # ONLY CALLED BY THIS CLASS
    def _test_prog_pos(self, prog):
        prog_hash = canonicalise_prog_hash(prog, self.settings.max_vars)
        idx = self.compact_pos_covered.get(prog_hash, -1)
        if idx >= 0:
            return self._intern_pool.lookup(idx)

        if len(prog) == 1:
            (rule,) = prog
            atom_str, body_str = self.parse_rule(rule)
            pos_covered = query_once('find_pos_covered(R, S)', {'R': f'{atom_str}:-{body_str}'}, module_name=self.module_name)['S']
        else:
            with self.using(prog):
                pos_covered = query_once('pos_covered(S)', module_name=self.module_name)['S']

        if not pos_covered:
            idx = self._intern_pool.intern(self.empty_pos_covered)
            self.compact_pos_covered[prog_hash] = idx
            return self.empty_pos_covered

        pos_covered = frozen_bits_from_indices(self.num_pos, pos_covered)
        idx = self._intern_pool.intern(pos_covered)
        self.compact_pos_covered[prog_hash] = idx
        return self._intern_pool.lookup(idx)

    # ONLY CALLED BY JOINER AND THIS CLASS
    def test_prog_neg(self, prog):

        if len(prog) == 1:
            (rule,) = prog
            atom_str, body_str = self.parse_rule(rule)
            neg_covered = query_once('find_neg_covered(R, S)', {'R': f'{atom_str}:-{body_str}'}, module_name=self.module_name)['S'] if self.num_neg > 0 else []
        else:
            with self.using(prog):
                neg_covered = query_once('neg_covered(S2)', module_name=self.module_name)['S2']
        
        if not neg_covered:
            return self.empty_neg_covered

        return frozen_bits_from_indices(self.num_neg, neg_covered)

    def has_redundant_literal(self, prog):
        return any(rule_has_redundant_literal(rule, module_name=self.module_name) for rule in prog)

    @contextmanager
    def using(self, prog):

        str_prog = [':- style_check(-singleton)']

        if self.settings.recursion_enabled:
            prog = order_prog(prog)

        current_clauses = set()
        for rule in prog:
            head, _body = rule
            x = format_rule(order_rule(rule, self.settings))[:-1]
            # x = parse_rule_for_recursion(rule)
            str_prog.append(x)
            current_clauses.add((head.predicate, len(head.arguments)))

        if self.settings.pi_enabled:
            for p, a in current_clauses:
                str_prog.append(f':- dynamic {p}/{a}')

        str_prog = '.\n'.join(str_prog) +'.'
        consult(self.prog_file, str_prog, module=self.module_name)
        yield
        for predicate, arity in current_clauses:
            args = ','.join(['_'] * arity)
            query_once(f"retractall({predicate}({args}))", module_name=self.module_name)

    def reduce_inconsistent(self, program):
        if len(program) < 3:
            return program
        for rule in program:
            subprog = [r for r in program if r != rule]
            if not prog_is_recursive(subprog):
                continue
            with self.using(subprog):
                if self.test_prog_inconsistent(subprog):
                    return self.reduce_inconsistent(subprog)
        return program


    # def find_redundant_rules(self, prog):
    #     base = []
    #     step = []
    #     for rule in prog:
    #         if rule_is_recursive(rule):
    #             step.append(rule)
    #         else:
    #             base.append(rule)
    #     if len(base) > 1 and self.has_redundant_rule(base):
    #         return self.find_redundant_rule_(base)
    #     if len(step) > 1 and self.has_redundant_rule(step):
    #         return self.find_redundant_rule_(step)
    #     return None

    def find_pointless_relations(self):
        settings = self.settings
        keep = set()
        pointless = set()
        missing = set()

        for p, pa in settings.body_preds:
            try:
                if not query_once(f'current_predicate({p}/{pa})', module_name=self.module_name)['truth']:
                    pointless.add((p, pa))
                    missing.add(p)
            except Exception as Err:
                print(f"Error in find_pointless_relations: {Err}")
                return pointless

        preds = [(p, pa) for p, pa in settings.body_preds if p not in missing]

        for (p, pa), (q, qa) in combinations(preds, 2):
            if pa != qa:
                continue
            if settings.body_types and settings.body_types[p] != settings.body_types[q]:
                continue

            a, b = (p, pa), (q, qa)
            if a in pointless and b in pointless:
                continue

            arg_str = ','.join(f'_V{i}' for i in range(pa))
            query = f'({p}({arg_str}), \\+ {q}({arg_str})) ; ({q}({arg_str}), \\+ {p}({arg_str}))'
            try:
                if query_once(query, module_name=self.module_name)['truth']:
                    continue
            except Exception as Err:
                print('ERROR detecting pointless relations', Err)
                return pointless

            if a in keep and b in keep:
                raise ValueError(f'Both {a} and {b} are in keep — invariant violated')
            if a not in pointless and b not in pointless:
                if a in keep:
                    pointless.add(b)
                elif b in keep:
                    pointless.add(a)
                else:
                    keep.add(a)
                    pointless.add(b)
            elif a in pointless or b in pointless:
                if a not in keep:
                    pointless.add(a)
                if b not in keep:
                    pointless.add(b)

        return pointless
