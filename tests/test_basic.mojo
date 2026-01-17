"""
Basic tests for mojo-asciichart.

Tests the core plot() functionality.
"""

from math import isnan

from asciichart import plot
from testing import assert_equal, assert_true

fn test_plot_exists() raises:
    """Test that plot function exists and is callable."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(3.0)
    
    var result = plot(data)
    assert_true(len(result) > 0, "plot() should return non-empty string")
    print("✓ test_plot_exists passed")

fn test_empty_data() raises:
    """Test plot with empty data."""
    var data = List[Float64]()
    
    var result = plot(data)
    assert_equal(result, "", "Empty data should return empty string")
    print("✓ test_empty_data passed")


fn test_horizontal_line() raises:
    """Test plot with all same values (horizontal line)."""
    var data = List[Float64]()
    for _ in range(5):
        data.append(5.0)
    
    var result = plot(data)
    assert_true(len(result) > 0, "Horizontal line should produce output")
    assert_true("─" in result, "Horizontal line should contain ─ symbol")
    print("✓ test_horizontal_line passed")


fn test_ascending_line() raises:
    """Test plot with ascending values."""
    var data = List[Float64]()
    for i in range(5):
        data.append(Float64(i))
    
    var result = plot(data)
    assert_true(len(result) > 0, "Ascending line should produce output")
    # Should contain corner symbols for ascending line
    assert_true(("╭" in result) or ("╯" in result), "Ascending line should contain corner symbols")
    print("✓ test_ascending_line passed")


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
    print("✓ test_nan_handling passed")


fn test_all_nan() raises:
    """Test plot with all NaN values."""
    var data = List[Float64]()
    data.append(Float64("nan"))
    data.append(Float64("nan"))
    data.append(Float64("nan"))
    
    var result = plot(data)
    assert_equal(result, "", "All NaN data should return empty string")
    print("✓ test_all_nan passed")

fn main() raises:
    print("=== Running Basic Tests ===\n")
    
    test_plot_exists()
    test_empty_data()
    test_horizontal_line()
    test_ascending_line()
    test_nan_handling()
    test_all_nan()
    
    print("\n=== All Basic Tests Passed ===")
