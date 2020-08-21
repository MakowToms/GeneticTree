# import pyximport; pyximport.install() # this cannot compile something from numpy
from genetic.Initializer import Initializer
from genetic.Mutator import Mutator
from genetic.Crosser import Crosser
from genetic.Selector import Selector
from genetic.StopCondition import StopCondition
from tree import TreeContainer


class GeneticTree:
    """
    High level interface possible to use like scikit-learn class
    """

    def __init__(self):
        #TODO write all kwargs
        self.genetic_processor = GeneticProcessor()
        self.__can_predict__ = False

    def set_params(self):
        #TODO write all kwargs
        self.genetic_processor.set_params()

    def fit(self, X, y, check_input=True, **kwargs):
        self.__can_predict__ = False
        self.genetic_processor.set_params(**kwargs)
        if check_input:
            self.check_input(X, y)
        self.genetic_processor.prepare_new_training(X, y)
        self.genetic_processor.growth_trees()
        self.__prepare_to_predict__()

    def __prepare_to_predict__(self):
        self.genetic_processor.prepare_to_predict()
        self.__can_predict__ = True

    def predict(self):
        if not self.__can_predict__:
            #TODO write warning/exception
            return
        #TODO
        pass

    def check_input(self, X, y):
        #TODO write metainformation about X, y or check if provided are the same as metainformation
        #TODO check if X and y are proper type of Object and have the same number of observations
        pass


class GeneticProcessor:
    """
    Low level interface responsible for communication between all genetic classes
    """

    def __init__(self, **kwargs):
        self.initializer = Initializer(**kwargs)
        self.mutator = Mutator(**kwargs)
        self.crosser = Crosser(**kwargs)
        self.selector = Selector(**kwargs)
        self.stop_condition = StopCondition(**kwargs)
        self.tree_container = TreeContainer(5)

    def set_params(self, **kwargs):
        self.initializer.set_params(**kwargs)
        self.mutator.set_params(**kwargs)
        self.crosser.set_params(**kwargs)
        self.selector.set_params(**kwargs)
        self.stop_condition.set_params(**kwargs)

    def prepare_new_training(self, X, y):
        self.stop_condition.reset_private_variables()
        self.initializer.initialize(X, y)

    def growth_trees(self):
        while not self.stop_condition.stop():
            self.mutator.mutate()
            self.crosser.cross_population()
            self.selector.select()

    def prepare_to_predict(self):
        #TODO
        pass
