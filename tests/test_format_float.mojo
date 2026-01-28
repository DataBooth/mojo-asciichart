from testing import assert_equal
from asciichart import format_float


fn test_basic_formatting() raises:
    """Test basic float formatting with width and precision."""
    # 8.2f format (8 chars wide, 2 decimal places)
    assert_equal(format_float(12.34, 8, 2), "   12.34")
    assert_equal(format_float(1.5, 8, 2), "    1.50")
    assert_equal(format_float(123.456, 8, 2), "  123.46")


fn test_different_widths() raises:
    """Test formatting with different width values."""
    assert_equal(format_float(12.34, 5, 2), "12.34")
    assert_equal(format_float(12.34, 10, 2), "     12.34")
    assert_equal(format_float(12.34, 15, 2), "          12.34")


fn test_different_precisions() raises:
    """Test formatting with different precision values."""
    assert_equal(format_float(12.3456, 8, 0), "      12")
    assert_equal(format_float(12.3456, 8, 1), "    12.3")
    assert_equal(format_float(12.3456, 8, 2), "   12.35")
    assert_equal(format_float(12.3456, 8, 3), "  12.346")
    assert_equal(format_float(12.3456, 8, 4), " 12.3456")


fn test_negative_values() raises:
    """Test formatting negative float values."""
    assert_equal(format_float(-12.34, 8, 2), "  -12.34")
    assert_equal(format_float(-1.5, 8, 2), "   -1.50")
    assert_equal(format_float(-123.456, 8, 2), " -123.46")


fn test_zero_values() raises:
    """Test formatting zero values."""
    assert_equal(format_float(0.0, 8, 2), "    0.00")
    assert_equal(format_float(-0.0, 8, 2), "    0.00")
    assert_equal(format_float(0.0, 5, 1), "  0.0")


fn test_rounding() raises:
    """Test proper rounding behavior."""
    # Round half up
    assert_equal(format_float(12.345, 8, 2), "   12.35")
    assert_equal(format_float(12.344, 8, 2), "   12.34")

    # Rounding overflow: 0.999 with precision=2 should become 1.00
    assert_equal(format_float(0.999, 8, 2), "    1.00")
    assert_equal(format_float(9.996, 8, 2), "   10.00")


fn test_edge_cases() raises:
    """Test edge cases and special values."""
    # Very small numbers
    assert_equal(format_float(0.001, 8, 2), "    0.00")
    assert_equal(format_float(0.005, 8, 2), "    0.01")

    # Large numbers
    assert_equal(format_float(12345.67, 10, 2), "  12345.67")

    # Negative precision defaults to 0
    assert_equal(format_float(12.34, 8, -1), "      12")


fn test_minimal_width() raises:
    """Test that width accommodates the value even if smaller than needed."""
    # Width smaller than value - should still show full value
    assert_equal(format_float(12345.67, 5, 2), "12345.67")


fn test_zero_precision() raises:
    """Test formatting with zero decimal places."""
    assert_equal(format_float(12.9, 5, 0), "   13")
    assert_equal(format_float(12.1, 5, 0), "   12")
    assert_equal(format_float(-5.6, 5, 0), "   -6")


fn main() raises:
    test_basic_formatting()
    test_different_widths()
    test_different_precisions()
    test_negative_values()
    test_zero_values()
    test_rounding()
    test_edge_cases()
    test_minimal_width()
    test_zero_precision()

    print("All format_float tests passed! ✓")
