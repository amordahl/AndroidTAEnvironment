import math
from typing import List, Set

class SuspiciousnessMetrics:
    """
    This class provides static methods to compute suspiciousness.
    """

    @staticmethod
    def get_registry() -> List[str]:
        """ Returns the functions registered in this class. """
        return [l for l in dir(SuspiciousnessMetrics) if
                (not l.startswith('__') and not l == 'get_registry')]

    def tarantula(successful: int, failed: int,
                  total_successful: int, total_failed: int) -> float:
        """ Returns the tarantula metric. """
        return 1 - ((float(successful) / float(total_successful)) /
                    ((float(successful) / float(total_successful)) +
                      (float(failed) / float(total_failed))))

    def ochiai(successful: int, failed: int,
               total_successful: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return float(failed) / math.sqrt(total_failed* (failed + successful))

    def op2(successful: int, failed: int,
               total_successful: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return failed - (float(successful) / (total_successful + 1))

    def barinel(successful: int, failed: int,
               total_successful: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return 1 - float(passed) / (passed + failed)

    def dstar(successful: int, failed: int,
               total_successful: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return (math.pow(failed, 2) / (successful + (total_failed - failed)))

    
