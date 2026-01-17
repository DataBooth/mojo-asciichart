"""
Tests for helper functions in mojo-asciichart.

Tests the refactored utility functions for correctness.
"""

from asciichart import _round_half_to_even, _find_extreme, _validate_series, _isnum
from testing import assert_equal, assert_true, assert_false, TestSuite


fn test_round_half_to_even_basic() raises:
    """Test banker's rounding with basic cases."""
    # Less than 0.5 - round down
    assert_equal(_round_half_to_even(1.3), 1)
    assert_equal(_round_half_to_even(2.4), 2)

    # Greater than 0.5 - round up
    assert_equal(_round_half_to_even(1.6), 2)
    assert_equal(_round_half_to_even(2.7), 3)

    # Exact integers
    assert_equal(_round_half_to_even(5.0), 5)
    assert_equal(_round_half_to_even(10.0), 10)


fn test_round_half_to_even_halves() raises:
    """Test banker's rounding with .5 values (round to even)."""
    # Round down to even
    assert_equal(_round_half_to_even(0.5), 0, "0.5 should round to 0 (even)")
    assert_equal(_round_half_to_even(2.5), 2, "2.5 should round to 2 (even)")
    assert_equal(_round_half_to_even(4.5), 4, "4.5 should round to 4 (even)")
    assert_equal(_round_half_to_even(12.5), 12, "12.5 should round to 12 (even)")
    assert_equal(_round_half_to_even(20.5), 20, "20.5 should round to 20 (even)")

    # Round up to even
    assert_equal(_round_half_to_even(1.5), 2, "1.5 should round to 2 (even)")
    assert_equal(_round_half_to_even(3.5), 4, "3.5 should round to 4 (even)")
    assert_equal(_round_half_to_even(13.5), 14, "13.5 should round to 14 (even)")
    assert_equal(_round_half_to_even(21.5), 22, "21.5 should round to 22 (even)")


fn test_round_half_to_even_negatives() raises:
    """Test banker's rounding with negative values."""
    assert_equal(_round_half_to_even(-1.3), -1)
    assert_equal(_round_half_to_even(-1.6), -2)
    assert_equal(_round_half_to_even(-0.5), 0, "-0.5 should round to 0 (even)")
    assert_equal(_round_half_to_even(-1.5), -2, "-1.5 should round to -2 (even)")


fn test_find_extreme_min() raises:
    """Test finding minimum value."""
    var data = List[Float64](5.0, 2.0, 8.0, 1.0, 9.0)
    assert_equal(_find_extreme(data, False), 1.0, "Should find minimum")


fn test_find_extreme_max() raises:
    """Test finding maximum value."""
    var data = List[Float64](5.0, 2.0, 8.0, 1.0, 9.0)
    assert_equal(_find_extreme(data, True), 9.0, "Should find maximum")


fn test_find_extreme_with_nan() raises:
    """Test finding min/max with NaN values."""
    var data = List[Float64](5.0, Float64("nan"), 2.0, 8.0, Float64("nan"), 1.0)
    assert_equal(_find_extreme(data, False), 1.0, "Should find min ignoring NaN")
    assert_equal(_find_extreme(data, True), 8.0, "Should find max ignoring NaN")


fn test_find_extreme_single_value() raises:
    """Test finding min/max with single value."""
    var data = List[Float64](42.0)
    assert_equal(_find_extreme(data, False), 42.0)
    assert_equal(_find_extreme(data, True), 42.0)


fn test_find_extreme_all_nan_raises() raises:
    """Test that all-NaN series raises error."""
    var data = List[Float64](Float64("nan"), Float64("nan"))
    var error_raised = False
    try:
        _ = _find_extreme(data, False)
    except:
        error_raised = True
    assert_true(error_raised, "Should raise error for all-NaN series")


fn test_validate_series_valid() raises:
    """Test series validation with valid data."""
    var data = List[Float64](1.0, 2.0, 3.0)
    assert_true(_validate_series(data), "Should validate series with numbers")


fn test_validate_series_mixed() raises:
    """Test series validation with mixed NaN and valid."""
    var data = List[Float64](Float64("nan"), 2.0, Float64("nan"))
    assert_true(_validate_series(data), "Should validate if any valid number")


fn test_validate_series_all_nan() raises:
    """Test series validation with all NaN."""
    var data = List[Float64](Float64("nan"), Float64("nan"))
    assert_false(_validate_series(data), "Should reject all-NaN series")


fn test_validate_series_empty() raises:
    """Test series validation with empty series."""
    var data = List[Float64]()
    assert_false(_validate_series(data), "Should reject empty series")


fn test_isnum() raises:
    """Test _isnum helper function."""
    assert_true(_isnum(5.0), "Regular number should be valid")
    assert_true(_isnum(0.0), "Zero should be valid")
    assert_true(_isnum(-3.14), "Negative should be valid")
    assert_false(_isnum(Float64("nan")), "NaN should be invalid")


def main():
    """Run all helper function tests."""
    var suite = TestSuite()
    suite.test[test_round_half_to_even_basic]()
    suite.test[test_round_half_to_even_halves]()
    suite.test[test_round_half_to_even_negatives]()
    suite.test[test_find_extreme_min]()
    suite.test[test_find_extreme_max]()
    suite.test[test_find_extreme_with_nan]()
    suite.test[test_find_extreme_single_value]()
    suite.test[test_find_extreme_all_nan_raises]()
    suite.test[test_validate_series_valid]()
    suite.test[test_validate_series_mixed]()
    suite.test[test_validate_series_all_nan]()
    suite.test[test_validate_series_empty]()
    suite.test[test_isnum]()
    suite^.run()
