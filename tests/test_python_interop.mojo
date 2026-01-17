"""
Test mojo-asciichart compatibility with asciichartpy using Python interop.

This demonstrates Mojo's Python interoperability by calling asciichartpy
directly from Mojo and comparing outputs.
"""

from asciichart import plot, Config
from python import Python
from testing import assert_equal


def test_simple_comparison():
    """Compare simple linear data with Python asciichartpy."""
    print("\n=== Test: Simple Linear Comparison ===")
    
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
    print("Mojo output:")
    print(mojo_output)
    print("\nPython output:")
    print(py_output)
    
    if mojo_output == py_output:
        print("✅ MATCH: Outputs are identical!")
    else:
        print("❌ MISMATCH: Outputs differ")
        print("\nDifference found - checking line by line:")
        var mojo_lines = mojo_output.split("\n")
        var py_lines = py_output.split("\n")
        for i in range(min(len(mojo_lines), len(py_lines))):
            if mojo_lines[i] != py_lines[i]:
                print("Line", i, "differs:")
                print("  Mojo:", repr(mojo_lines[i]))
                print("  Py:  ", repr(py_lines[i]))
    
    assert_equal(mojo_output, py_output, "Outputs should match exactly")


def test_sine_wave_comparison():
    """Compare sine wave with Python asciichartpy."""
    print("\n=== Test: Sine Wave Comparison ===")
    
    from math import sin, pi
    
    # Create sine wave data in Mojo
    var mojo_data = List[Float64]()
    for i in range(30):
        mojo_data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 30.0)))
    
    # Generate chart with Mojo
    var mojo_output = plot(mojo_data)
    
    # Import Python modules
    var asciichartpy = Python.import_module("asciichartpy")
    
    # Create equivalent data in Python (using __import__ in eval context)
    var py_math = Python.import_module("math")
    var py_data = Python.evaluate(
        "[10.0 * __import__('math').sin(i * ((2.0 * __import__('math').pi) / 30.0)) for i in range(30)]"
    )
    
    # Generate chart with Python
    var py_output = String(asciichartpy.plot(py_data))
    
    print("Chart dimensions:")
    print("  Mojo lines:", len(mojo_output.split("\n")))
    print("  Python lines:", len(py_output.split("\n")))
    
    if mojo_output == py_output:
        print("✅ MATCH: Sine wave outputs are identical!")
    else:
        print("❌ MISMATCH: Outputs differ")
    
    assert_equal(mojo_output, py_output, "Sine wave outputs should match")


def test_with_height_config():
    """Compare charts with height configuration."""
    print("\n=== Test: Height Configuration Comparison ===")
    
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
    var py_math = Python.import_module("math")
    var py_data = Python.evaluate(
        "[10.0 * __import__('math').sin(i * ((2.0 * __import__('math').pi) / 30.0)) for i in range(30)]"
    )
    
    # Generate with Python (height=6)
    var py_config = Python.dict()
    py_config["height"] = 6
    var py_output = String(asciichartpy.plot(py_data, py_config))
    
    print("Configured height: 6")
    print("Mojo chart height:", len(mojo_output.split("\n")))
    print("Python chart height:", len(py_output.split("\n")))
    
    if mojo_output == py_output:
        print("✅ MATCH: Configured outputs are identical!")
    else:
        print("❌ MISMATCH: Outputs differ")
    
    assert_equal(mojo_output, py_output, "Configured outputs should match")


def test_flat_line_comparison():
    """Compare flat line (constant value) with Python."""
    print("\n=== Test: Flat Line Comparison ===")
    
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
    
    print("Mojo flat line:")
    print(mojo_output)
    
    if mojo_output == py_output:
        print("✅ MATCH: Flat line outputs are identical!")
    else:
        print("❌ MISMATCH")
    
    assert_equal(mojo_output, py_output, "Flat line outputs should match")


def test_data_from_python_list():
    """Test using data loaded from Python directly."""
    print("\n=== Test: Using Python Data Source ===")
    
    # Load data from Python (simulating reading from file or API)
    var py = Python.import_module("builtins")
    var py_data = Python.evaluate("[i * i for i in range(10)]")
    
    # Convert Python list to Mojo List
    var mojo_data = List[Float64]()
    for i in range(len(py_data)):
        mojo_data.append(Float64(py_data[i]))
    
    print("Data loaded from Python:", end=" ")
    for i in range(min(5, len(mojo_data))):
        print(mojo_data[i], end=" ")
    print("...")
    
    # Generate chart with Mojo
    var mojo_output = plot(mojo_data)
    
    # Compare with Python's direct plot
    var asciichartpy = Python.import_module("asciichartpy")
    var py_output = String(asciichartpy.plot(py_data))
    
    print("\nMojo chart from Python data:")
    print(mojo_output)
    
    if mojo_output == py_output:
        print("\n✅ MATCH: Can use Python data sources seamlessly!")
    else:
        print("\n❌ MISMATCH")
    
    assert_equal(mojo_output, py_output, "Should work with Python data sources")


def test_csv_data_comparison():
    """Test with CSV-like data (demonstrating practical use case)."""
    print("\n=== Test: CSV Data Comparison ===")
    
    # Simulate CSV data as a Python string
    var csv_data = Python.evaluate("""
[12.5, 15.3, 14.8, 18.2, 22.1, 25.4, 23.8, 20.5, 17.2, 14.9]
""")
    
    # Convert to Mojo
    var mojo_data = List[Float64]()
    for i in range(len(csv_data)):
        mojo_data.append(Float64(csv_data[i]))
    
    print("Simulated CSV data (10 temperature readings)")
    
    # Plot with Mojo
    var mojo_output = plot(mojo_data)
    
    # Plot with Python
    var asciichartpy = Python.import_module("asciichartpy")
    var py_output = String(asciichartpy.plot(csv_data))
    
    print("Mojo chart:")
    print(mojo_output)
    
    if mojo_output == py_output:
        print("\n✅ MATCH: CSV data handling is identical!")
    else:
        print("\n❌ MISMATCH")
    
    assert_equal(mojo_output, py_output, "CSV data outputs should match")


def main():
    """Run all Python interop comparison tests."""
    print("\n" + "="*70)
    print("MOJO-ASCIICHART PYTHON INTEROP TESTS")
    print("Demonstrating Mojo's Python interoperability")
    print("="*70)
    
    var passed = 0
    var failed = 0
    
    # Test 1: Simple comparison
    try:
        test_simple_comparison()
        passed += 1
        print("\n✅ test_simple_comparison PASSED")
    except e:
        failed += 1
        print("\n❌ test_simple_comparison FAILED:", e)
    
    # Test 2: Sine wave
    try:
        test_sine_wave_comparison()
        passed += 1
        print("\n✅ test_sine_wave_comparison PASSED")
    except e:
        failed += 1
        print("\n❌ test_sine_wave_comparison FAILED:", e)
    
    # Test 3: Height config
    try:
        test_with_height_config()
        passed += 1
        print("\n✅ test_with_height_config PASSED")
    except e:
        failed += 1
        print("\n❌ test_with_height_config FAILED:", e)
    
    # Test 4: Flat line
    try:
        test_flat_line_comparison()
        passed += 1
        print("\n✅ test_flat_line_comparison PASSED")
    except e:
        failed += 1
        print("\n❌ test_flat_line_comparison FAILED:", e)
    
    # Test 5: Python data source
    try:
        test_data_from_python_list()
        passed += 1
        print("\n✅ test_data_from_python_list PASSED")
    except e:
        failed += 1
        print("\n❌ test_data_from_python_list FAILED:", e)
    
    # Test 6: CSV data
    try:
        test_csv_data_comparison()
        passed += 1
        print("\n✅ test_csv_data_comparison PASSED")
    except e:
        failed += 1
        print("\n❌ test_csv_data_comparison FAILED:", e)
    
    # Summary
    print("\n" + "="*70)
    print("SUMMARY")
    print("="*70)
    print("Tests passed:", passed)
    print("Tests failed:", failed)
    
    if failed == 0:
        print("\n🎉 All Python interop tests passed!")
        print("\nKey demonstration:")
        print("- Mojo can seamlessly call Python libraries")
        print("- Data can flow between Mojo and Python")
        print("- Output is pixel-perfect identical")
        print("- Real-world use cases (CSV data) work perfectly")
    else:
        print("\n⚠️ Some tests failed")
        raise Error("Test failures detected")
