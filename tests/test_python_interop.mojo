"""
Test mojo-asciichart compatibility with asciichartpy using Python interop.

This demonstrates Mojo's Python interoperability by calling asciichartpy
directly from Mojo and comparing outputs.
"""

from asciichart import plot, Config
from python import Python
from testing import assert_equal, TestSuite


fn test_simple_comparison() raises:
    """Compare simple linear data with Python asciichartpy."""
    # Create data in Mojo
    var mojo_data = List[Float64]()
    for i in range(5):
        mojo_data.append(Float64(i))

    # Generate chart with Mojo
    var mojo_output = plot(mojo_data)

    # Import Python's asciichartpy
    var asciichartpy = Python.import_module("asciichartpy")

    # Create equivalent Python list
    var py_data = Python.evaluate("[0.0, 1.0, 2.0, 3.0, 4.0]")

    # Generate chart with Python
    var py_output = String(asciichartpy.plot(py_data))

    # Compare
    assert_equal(mojo_output, py_output, "Outputs should match exactly")


fn test_sine_wave_comparison() raises:
    """Compare sine wave with Python asciichartpy."""
    from math import sin, pi

    # Create sine wave data in Mojo
    var mojo_data = List[Float64]()
    for i in range(30):
        mojo_data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 30.0)))

    # Generate chart with Mojo
    var mojo_output = plot(mojo_data)

    # Import Python modules
    var asciichartpy = Python.import_module("asciichartpy")
    var py_data = Python.evaluate(
        "[10.0 * __import__('math').sin(i * ((2.0 * __import__('math').pi) / 30.0)) for i in range(30)]"
    )

    # Generate chart with Python
    var py_output = String(asciichartpy.plot(py_data))

    assert_equal(mojo_output, py_output, "Sine wave outputs should match")


fn test_with_height_config() raises:
    """Compare charts with height configuration."""
    from math import sin, pi

    # Create data
    var mojo_data = List[Float64]()
    for i in range(30):
        mojo_data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 30.0)))

    # Generate with Mojo (height=6)
    var mojo_config = Config()
    mojo_config.height = 6
    var mojo_output = plot(mojo_data, mojo_config)

    # Import Python
    var asciichartpy = Python.import_module("asciichartpy")
    var py_data = Python.evaluate(
        "[10.0 * __import__('math').sin(i * ((2.0 * __import__('math').pi) / 30.0)) for i in range(30)]"
    )

    # Generate with Python (height=6)
    var py_config = Python.dict()
    py_config["height"] = 6
    var py_output = String(asciichartpy.plot(py_data, py_config))

    assert_equal(mojo_output, py_output, "Configured outputs should match")


fn test_flat_line_comparison() raises:
    """Compare flat line (constant value) with Python."""
    # Create constant data
    var mojo_data = List[Float64]()
    for _ in range(10):
        mojo_data.append(5.0)

    # Generate with Mojo
    var mojo_output = plot(mojo_data)

    # Python
    var asciichartpy = Python.import_module("asciichartpy")
    var py_data = Python.evaluate("[5.0] * 10")
    var py_output = String(asciichartpy.plot(py_data))

    assert_equal(mojo_output, py_output, "Flat line outputs should match")


fn test_data_from_python_list() raises:
    """Test using data loaded from Python directly."""
    # Load data from Python (simulating reading from file or API)
    var py_data = Python.evaluate("[i * i for i in range(10)]")

    # Convert Python list to Mojo List
    var mojo_data = List[Float64]()
    for i in range(len(py_data)):
        mojo_data.append(Float64(py_data[i]))

    # Generate chart with Mojo
    var mojo_output = plot(mojo_data)

    # Compare with Python's direct plot
    var asciichartpy = Python.import_module("asciichartpy")
    var py_output = String(asciichartpy.plot(py_data))

    assert_equal(mojo_output, py_output, "Should work with Python data sources")


fn test_csv_data_comparison() raises:
    """Test with CSV-like data (demonstrating practical use case)."""
    # Simulate CSV data as a Python string
    var csv_data = Python.evaluate("""
[12.5, 15.3, 14.8, 18.2, 22.1, 25.4, 23.8, 20.5, 17.2, 14.9]
""")

    # Convert to Mojo
    var mojo_data = List[Float64]()
    for i in range(len(csv_data)):
        mojo_data.append(Float64(csv_data[i]))

    # Plot with Mojo
    var mojo_output = plot(mojo_data)

    # Plot with Python
    var asciichartpy = Python.import_module("asciichartpy")
    var py_output = String(asciichartpy.plot(csv_data))

    assert_equal(mojo_output, py_output, "CSV data outputs should match")


def main():
    """Run all Python interop tests."""
    var suite = TestSuite()
    suite.test[test_simple_comparison]()
    suite.test[test_sine_wave_comparison]()
    suite.test[test_with_height_config]()
    suite.test[test_flat_line_comparison]()
    suite.test[test_data_from_python_list]()
    suite.test[test_csv_data_comparison]()
    suite^.run()
