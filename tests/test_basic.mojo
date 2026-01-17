"""
Basic tests for mojo-asciichart.

Tests the core plot() functionality.
"""

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
    
    # TODO: Define expected behaviour for empty data
    var result = plot(data)
    print("✓ test_empty_data passed")

fn main() raises:
    print("=== Running Basic Tests ===\n")
    
    test_plot_exists()
    test_empty_data()
    
    print("\n=== All Basic Tests Passed ===")
