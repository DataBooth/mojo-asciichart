"""
Basic tests for mojo-asciichart.

Tests the core plot() functionality.
"""

from asciichart import plot
from testing import assert_equal, assert_true


def test_plot_exists():
    """Test that plot function exists and is callable."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(3.0)
    
    var result = plot(data)
    assert_true(len(result) > 0, "plot() should return non-empty string")


def test_empty_data():
    """Test plot with empty data."""
    var data = List[Float64]()
    
    var result = plot(data)
    assert_equal(result, "", "Empty data should return empty string")


def test_horizontal_line():
    """Test plot with all same values (horizontal line)."""
    var data = List[Float64]()
    for _ in range(5):
        data.append(5.0)
    
    var result = plot(data)
    assert_true(len(result) > 0, "Horizontal line should produce output")
    assert_true("─" in result, "Horizontal line should contain ─ symbol")


def test_ascending_line():
    """Test plot with ascending values."""
    var data = List[Float64]()
    for i in range(5):
        data.append(Float64(i))
    
    var result = plot(data)
    assert_true(len(result) > 0, "Ascending line should produce output")
    # Should contain corner symbols for ascending line
    assert_true(("╭" in result) or ("╯" in result), "Ascending line should contain corner symbols")


def test_nan_handling():
    """Test plot with NaN values."""
    var data = List[Float64]()
    data.append(1.0)
    data.append(2.0)
    data.append(Float64("nan"))
    data.append(4.0)
    data.append(5.0)
    
    var result = plot(data)
    assert_true(len(result) > 0, "Data with NaN should still plot valid values")


def test_all_nan():
    """Test plot with all NaN values."""
    var data = List[Float64]()
    data.append(Float64("nan"))
    data.append(Float64("nan"))
    data.append(Float64("nan"))
    
    var result = plot(data)
    assert_equal(result, "", "All NaN data should return empty string")


def main():
    """Run all tests following Mojo testing conventions.
    
    Each test function follows the test_* naming pattern and uses
    assertions from the testing module. Tests pass if they don't raise
    an error, and fail if they do.
    """
    print("Running basic asciichart tests...\n")
    
    var passed = 0
    var failed = 0
    
    # Run each test and track results
    try:
        test_plot_exists()
        passed += 1
        print("✓ test_plot_exists")
    except e:
        failed += 1
        print("✗ test_plot_exists:", e)
    
    try:
        test_empty_data()
        passed += 1
        print("✓ test_empty_data")
    except e:
        failed += 1
        print("✗ test_empty_data:", e)
    
    try:
        test_horizontal_line()
        passed += 1
        print("✓ test_horizontal_line")
    except e:
        failed += 1
        print("✗ test_horizontal_line:", e)
    
    try:
        test_ascending_line()
        passed += 1
        print("✓ test_ascending_line")
    except e:
        failed += 1
        print("✗ test_ascending_line:", e)
    
    try:
        test_nan_handling()
        passed += 1
        print("✓ test_nan_handling")
    except e:
        failed += 1
        print("✗ test_nan_handling:", e)
    
    try:
        test_all_nan()
        passed += 1
        print("✓ test_all_nan")
    except e:
        failed += 1
        print("✗ test_all_nan:", e)
    
    # Summary
    print("\n" + "=" * 50)
    print("Tests passed:", passed)
    print("Tests failed:", failed)
    if failed > 0:
        print("FAILED")
        raise Error("Some tests failed")
    else:
        print("SUCCESS")
    print("\n=== All Basic Tests Passed ===")
