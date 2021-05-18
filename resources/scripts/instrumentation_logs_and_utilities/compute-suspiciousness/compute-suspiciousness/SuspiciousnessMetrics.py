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

    def tarantula(passed: int, failed: int,
                  total_passed: int, total_failed: int) -> float:
        """ Returns the tarantula metric. """
        return 1 - ((float(passed) / float(total_passed)) /
                    ((float(passed) / float(total_passed)) +
                      (float(failed) / float(total_failed))))

    def ochiai(passed: int, failed: int,
               total_passed: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return float(failed) / math.sqrt(total_failed* (failed + passed))

    def op2(passed: int, failed: int,
               total_passed: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return failed - (float(passed) / (total_passed + 1))

    def barinel(passed: int, failed: int,
               total_passed: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return 1 - float(passed) / (passed + failed)

    def dstar(passed: int, failed: int,
               total_passed: int, total_failed: int) -> float:
        """ Returns the ochiai metric. """
        return (math.pow(failed, 2) / (passed + (total_failed - failed)))

    
