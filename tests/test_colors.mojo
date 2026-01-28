"""
Tests for color functionality in ASCII charts.

Verifies ANSI color code injection and color scheme factories.
"""

from asciichart import plot, Config, ChartColors
from testing import assert_true, assert_false, TestSuite


fn test_colors_in_output() raises:
    """Test that ANSI color codes appear in output when colors are enabled."""
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i))

    # Test with colors
    var config = Config()
    config.colors = ChartColors.blue()
    var output = plot(data, config)

    # Should contain ANSI escape codes
    assert_true("\033[" in output, "Output should contain ANSI escape codes")


fn test_no_colors_by_default() raises:
    """Test that output has no ANSI codes when colors are not configured."""
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i))

    # Test without colors
    var output = plot(data)

    # Should NOT contain ANSI escape codes
    assert_false("\033[" in output, "Default output should not contain ANSI escape codes")


fn test_color_scheme_factories() raises:
    """Test that all color scheme factories work."""
    _ = ChartColors.default()
    _ = ChartColors.blue()
    _ = ChartColors.matrix()
    _ = ChartColors.fire()
    _ = ChartColors.ocean()
    _ = ChartColors.rainbow()

    # If we get here, all factories worked
    assert_true(True, "All color scheme factories should work")


fn test_colors_with_config() raises:
    """Test that colors work when set via Config."""
    var data = List[Float64]()
    for i in range(5):
        data.append(Float64(i * 2))

    var config = Config()
    config.height = 5
    config.colors = ChartColors.matrix()

    var output = plot(data, config)

    # Should contain ANSI codes and be non-empty
    assert_true(len(output) > 0, "Output should not be empty")
    assert_true("\033[" in output, "Output should contain ANSI escape codes")


def main():
    """Run all color tests."""
    var suite = TestSuite()
    suite.test[test_colors_in_output]()
    suite.test[test_no_colors_by_default]()
    suite.test[test_color_scheme_factories]()
    suite.test[test_colors_with_config]()
    suite^.run()
