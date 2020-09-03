from tree.tree cimport Tree
from tree._utils cimport Stack

import numpy as np
cimport numpy as np

ctypedef np.npy_float64 DOUBLE_t         # Type of y
ctypedef np.npy_intp SIZE_t              # Type for indices and counters

cdef struct CrossoverPoint:
    SIZE_t new_parent_id
    bint is_left

cdef class TreeCrosser:
    cpdef Tree cross_trees(self, Tree first_parent, Tree second_parent)

    cdef _add_tree_nodes(self, Tree master, SIZE_t crossover_point,
                         Tree slave, bint is_first, CrossoverPoint* result)
    cdef void _register_node_in_stack(self, Tree master,
                                      SIZE_t new_parent_id, SIZE_t old_self_id,
                                      bint is_left, Stack stack) nogil

    cdef SIZE_t _get_random_node(self, Tree tree)
    cdef Tree _initialize_new_tree(self, Tree previous_tree)

