"""
Basic tests for mojo-asciichart.

Tests the core plot() functionality.
"""

from asciichart import plot
from testing import assert_equal, assert_true, TestSuite


fn test_plot_exists() raises:
    """Test that plot function exists and is callable."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(3.0)

    var result = plot(data)
    assert_true(len(result) > 0, "plot() should return non-empty string")


fn test_empty_data() raises:
    """Test plot with empty data."""
    var data = List[Float64]()

    var result = plot(data)
    assert_equal(result, "", "Empty data should return empty string")


fn test_horizontal_line() raises:
    """Test plot with all same values (horizontal line)."""
    var data = List[Float64]()
    for _ in range(5):
        data.append(5.0)

    var result = plot(data)
    assert_true(len(result) > 0, "Horizontal line should produce output")
    assert_true("─" in result, "Horizontal line should contain ─ symbol")


fn test_ascending_line() raises:
    """Test plot with ascending values."""
    var data = List[Float64]()
    for i in range(5):
        data.append(Float64(i))

    var result = plot(data)
    assert_true(len(result) > 0, "Ascending line should produce output")
    # Should contain corner symbols for ascending line
    assert_true(("╭" in result) or ("╯" in result), "Ascending line should contain corner symbols")


fn test_nan_handling() raises:
    """Test plot with NaN values."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(Float64("nan"))
    data.append(4.0)
    data.append(5.0)

    var result = plot(data)
    assert_true(len(result) > 0, "Data with NaN should still plot valid values")


fn test_all_nan() raises:
    """Test plot with all NaN values."""
    var data = List[Float64]()
    data.append(Float64("nan"))
    data.append(Float64("nan"))
    data.append(Float64("nan"))

    var result = plot(data)
    assert_equal(result, "", "All NaN data should return empty string")


def main():
    """Run all basic tests."""
    var suite = TestSuite()
    suite.test[test_plot_exists]()
    suite.test[test_empty_data]()
    suite.test[test_horizontal_line]()
    suite.test[test_ascending_line]()
    suite.test[test_nan_handling]()
    suite.test[test_all_nan]()
    suite^.run()
