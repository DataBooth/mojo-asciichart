"""
Basic tests for mojo-asciichart.

Tests the core plot() functionality.
"""

from asciichart import plot
from std.testing import assert_equal, assert_true, TestSuite


def test_plot_exists() raises:
    """Test that plot function exists and is callable."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(3.0)

    var result = plot(data)
    assert_true(result.byte_length() > 0, "plot() should return non-empty string")


def test_empty_data() raises:
    """Test plot with empty data."""
    var data = List[Float64]()

    var result = plot(data)
    assert_equal(result, "", "Empty data should return empty string")


def test_horizontal_line() raises:
    """Test plot with all same values (horizontal line)."""
    var data = List[Float64]()
    for _ in range(5):
        data.append(5.0)

    var result = plot(data)
    assert_true(result.byte_length() > 0, "Horizontal line should produce output")
    assert_true("─" in result, "Horizontal line should contain ─ symbol")


def test_ascending_line() raises:
    """Test plot with ascending values."""
    var data = List[Float64]()
    for i in range(5):
        data.append(Float64(i))

    var result = plot(data)
    assert_true(result.byte_length() > 0, "Ascending line should produce output")
    # Should contain corner symbols for ascending line
    assert_true(("╭" in result) or ("╯" in result), "Ascending line should contain corner symbols")


def test_nan_handling() raises:
    """Test plot with NaN values."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(Float64("nan"))
    data.append(4.0)
    data.append(5.0)

    var result = plot(data)
    assert_true(result.byte_length() > 0, "Data with NaN should still plot valid values")


def test_all_nan() raises:
    """Test plot with all NaN values."""
    var data = List[Float64]()
    data.append(Float64("nan"))
    data.append(Float64("nan"))
    data.append(Float64("nan"))

    var result = plot(data)
    assert_equal(result, "", "All NaN data should return empty string")


def main() raises:
    """Run all basic tests."""
    var suite = TestSuite()
    suite.test[test_plot_exists]()
    suite.test[test_empty_data]()
    suite.test[test_horizontal_line]()
    suite.test[test_ascending_line]()
    suite.test[test_nan_handling]()
    suite.test[test_all_nan]()
    suite^.run()
