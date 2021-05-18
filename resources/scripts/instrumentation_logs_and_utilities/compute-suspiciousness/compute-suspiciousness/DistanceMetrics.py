"""
This class contains static methods to compute suspiciousness rankings.
"""

from typing import List, Dict, Set, Callable
from Levenshtein import distance
import logging

class DistanceMetrics:
    """ All of the methods in this class should take two sets and return
    an distance metric, normalized between 0 and 1 inclusive, where 1.0 means maximally
    unequal, and 0.0 means exactly equal."""

    @staticmethod
    def get_registry() -> List[str]:
        """ Returns the list of distance metrics. The intent is for this to be
        called by argparse so we can present an accurate list of choices."""
        l = [f for f in dir(DistanceMetrics) if not f.startswith('__')]
        l.remove('get_registry')
        return l
        
    @staticmethod
    def basic_distance(o1: Set[str], o2: Set[str]) -> float:
        return 0.0 if o1 == o2 else 1.0

    @staticmethod
    def wei_distance(o1: Set[str],
                     o2: Set[str],
                     which_is_buggy: int = 0,
                     distance: Callable = basic_distance.__func__) -> float:
        """ Assuming A is the buggy configuration, return [if the data structure 
        is accessed in A's execution ? 1 : 0] * [if the data structure is different
        between the two executions ? 1 : 0].

        Accepts which_is_buggy, which indicates which set is 
        from the buggy configuration. By default, this is assumed to be o1.

        Also accepts a function as distance. By default, this uses 
        DistanceMetrics.basic_distance."""
        if which_is_buggy not in [0,1]:
            raise RuntimeError(f'which_is_buggy (value={which_is_buggy}) must be '
                               '0 or 1, indicating whether o1 or o2 is from the buggy '
                               'configuration, respectively.')

        os = [o1, o2]
        return (len(os[which_is_buggy]) > 0) * distance(o1, o2)

    @staticmethod
    def size_distance(o1: Set[str], o2: Set[str]) -> float:
        """ Only take into account whether the sizes of the two sets are the same. """
        return 0.0 if len(o1) == len(o2) else 1.0

    @staticmethod
    def levenshtein_distance(o1: Set[str], o2: Set[str]) -> float:
        """Compute the levenshtein distance between each string in the set.
        Normalized by dividing by the maximum levenshtein distance (the levenshtein
        distance is bounded by the length of the longer string)."""
        total_levenshtein_so_far = 0
        maximum_levenshtein = 0

        o1_copy = list(o1)
        o2_copy = list(o2)
        larger_set, smaller_set = (o2_copy, o1_copy) if len(o2) > len(o1) else (o1_copy, o2_copy)
        
        for elem in sorted(larger_set, key=lambda x: len(x), reverse=True):
            if elem in smaller_set:
                larger_set.remove(elem)
                smaller_set.remove(elem)
                maximum_levenshtein += len(elem)
            else:
                if len(smaller_set) > 0:
                    scores = [(b, distance(elem, b)) for b in smaller_set]
                    # get element that had the smallest distance from elem
                    best_partner = sorted(scores, key=lambda x: x[1])[0]
                    total_levenshtein_so_far += best_partner[1]
                    maximum_levenshtein += max(len(elem), len(best_partner[0]))
                    smaller_set.remove(best_partner[0])
                else:
                    total_levenshtein_so_far += len(elem)
                    maximum_levenshtein += len(elem)
                larger_set.remove(elem)


        try:
            return float(total_levenshtein_so_far)/maximum_levenshtein
        except ZeroDivisionError:
            if not (len(larger_set) == 0 and len(smaller_set) == 0):
                raise RuntimeError(f'maximum_levenshtein distance was 0, and both sets were not empty. o1: {o1}, o2: {o2}')
            else:
                return 0

    @staticmethod
    def jacard_distance(o1: Set[str], o2: Set[str]) -> float:
        if o1 == o2:
            return 0.0
        try:
            return 1.0 - float(len(o1.intersection(o2))) / len(o1.union(o2))
        except ZeroDivisionError:
            # o1.union(o2) was 0, which means that one of them was an empty set.
            # not both, else we would have returned 0, so we will say they are maximally
            # unequal (1.0).
            return 1.0
    
    
                


    
        

    
        
        
        
        
