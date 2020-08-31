# code copied from https://github.com/scikit-learn/scikit-learn/blob/fd237278e895b42abe8d8d09105cbb82dc2cbba7/sklearn/tree/_tree.pxd
# notes above this file:

# Authors: Gilles Louppe <g.louppe@gmail.com>
#          Peter Prettenhofer <peter.prettenhofer@gmail.com>
#          Brian Holt <bdholt1@gmail.com>
#          Joel Nothman <joel.nothman@gmail.com>
#          Arnaud Joly <arnaud.v.joly@gmail.com>
#          Jacob Schreiber <jmschreiber91@gmail.com>
#          Nelson Liu <nelson@nelsonliu.me>
#
# License: BSD 3 clause

# See _tree.pyx for details.

import numpy as np
cimport numpy as np

ctypedef np.npy_float64 DOUBLE_t         # Type of y, sample_weight
ctypedef np.npy_intp SIZE_t              # Type for indices and counters

cdef struct Node:
    # Base storage structure for the nodes in a Tree object
    SIZE_t left_child                    # id of the left child of the node
    SIZE_t right_child                   # id of the right child of the node
    SIZE_t parent                        # id of the parent of the node
    SIZE_t feature                       # Feature used for splitting the node
    DOUBLE_t threshold                   # Threshold value at the node
    SIZE_t depth                         # the size of path from root to node


cdef class Tree:
    # The Tree object is a binary tree structure.

    # Input/Output layout
    cdef public SIZE_t n_features        # Number of features in X
    cdef SIZE_t* n_classes               # Number of classes in y[:, k]
    cdef public SIZE_t n_outputs         # Number of outputs in y
    cdef public SIZE_t max_n_classes     # max(n_classes)

    # Inner structures: values are stored separately from node structure,
    # since size is determined at runtime.
    cdef public SIZE_t max_depth         # Max depth of the tree
    cdef public SIZE_t node_count        # Counter for node IDs
    cdef public SIZE_t capacity          # Capacity of tree, in terms of nodes
    cdef Node* nodes                     # Array of nodes
    cdef double* value                   # (capacity, n_outputs, max_n_classes) array of values
    cdef SIZE_t value_stride             # = n_outputs * max_n_classes

    # Methods
    cdef SIZE_t _add_node(self, SIZE_t parent, bint is_left, bint is_leaf,
                          SIZE_t feature, double threshold, double impurity,
                          SIZE_t n_node_samples,
                          double weighted_n_samples) nogil except -1
    # cdef int _resize(self, SIZE_t capacity) nogil except -1
    cdef int _resize_c(self, SIZE_t capacity=*) nogil except -1

    cdef np.ndarray _get_value_ndarray(self)
    cdef np.ndarray _get_node_ndarray(self)

    # cpdef np.ndarray predict(self, object X)

    # cpdef np.ndarray apply(self, object X)
    # cdef np.ndarray _apply_dense(self, object X)
    # cdef np.ndarray _apply_sparse_csr(self, object X)

    # cpdef object decision_path(self, object X)
    # cdef object _decision_path_dense(self, object X)
    # cdef object _decision_path_sparse_csr(self, object X)

    # cpdef compute_feature_importances(self, normalize=*)

    cpdef test_function_with_args_core(self, char* name, long long size, int print_size)

    cpdef test_function_with_args(self, char* name, long long size, int print_size)

    cpdef time_test2(self, long long size)
    cpdef time_test(self, long long size)

    cpdef time_test_nogil(self, long long size)
    cdef void _time_test_nogil_(self, long long size) nogil


cdef class TreeContainer:
    # Class containing all trees
    
    cdef Tree[:] trees

    cpdef initial_function(self)

    cpdef function_to_test_nogil(self)
