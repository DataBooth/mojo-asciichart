#!/usr/bin/env python3
"""
Compare mojo-asciichart output with asciichartpy (Python reference implementation).

This script generates charts using both implementations and compares the output
to verify compatibility.
"""

import math
import sys
import subprocess
import tempfile
import os

try:
    import asciichartpy
except ImportError:
    print("ERROR: asciichartpy not installed")
    print("Install with: pip install asciichartpy")
    sys.exit(1)


def generate_mojo_output(test_name, data_expr, config_params=""):
    """Generate chart output using Mojo implementation."""
    
    # Create a temporary Mojo script
    mojo_script = f"""
from asciichart import plot, Config

fn main() raises:
    var data = List[Float64]()
    {data_expr}
    
    {f'''
    var config = Config()
    {config_params}
    print(plot(data, config))
    ''' if config_params else 'print(plot(data))'}
"""
    
    with tempfile.NamedTemporaryFile(mode='w', suffix='.mojo', delete=False) as f:
        f.write(mojo_script)
        temp_file = f.name
    
    try:
        result = subprocess.run(
            ['mojo', '-I', 'src', temp_file],
            capture_output=True,
            text=True,
            cwd='/Users/mjboothaus/code/github/databooth/mojo-asciichart'
        )
        return result.stdout.strip(), result.stderr
    finally:
        os.unlink(temp_file)


def test_simple_linear():
    """Test simple linear data [0, 1, 2, 3, 4]"""
    print("\n" + "="*70)
    print("TEST: Simple Linear Data")
    print("="*70)
    
    # Python
    py_data = [0.0, 1.0, 2.0, 3.0, 4.0]
    py_output = asciichartpy.plot(py_data)
    
    # Mojo
    mojo_data_expr = """
    for i in range(5):
        data.append(Float64(i))
    """
    mojo_output, stderr = generate_mojo_output("simple_linear", mojo_data_expr)
    
    if stderr:
        print(f"Mojo stderr: {stderr}")
    
    print("\nPython output:")
    print(py_output)
    print("\nMojo output:")
    print(mojo_output)
    
    # Compare
    if py_output == mojo_output:
        print("\n✅ MATCH: Outputs are identical")
        return True
    else:
        print("\n❌ MISMATCH: Outputs differ")
        print("\nDifferences:")
        py_lines = py_output.split('\n')
        mojo_lines = mojo_output.split('\n')
        for i, (py_line, mojo_line) in enumerate(zip(py_lines, mojo_lines)):
            if py_line != mojo_line:
                print(f"Line {i}:")
                print(f"  Python: {repr(py_line)}")
                print(f"  Mojo:   {repr(mojo_line)}")
        return False


def test_sine_wave():
    """Test sine wave"""
    print("\n" + "="*70)
    print("TEST: Sine Wave")
    print("="*70)
    
    # Python
    py_data = [10.0 * math.sin(i * ((2.0 * math.pi) / 30.0)) for i in range(30)]
    py_output = asciichartpy.plot(py_data)
    
    # Mojo
    mojo_data_expr = """
    from math import sin, pi
    for i in range(30):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 30.0)))
    """
    mojo_output, stderr = generate_mojo_output("sine_wave", mojo_data_expr)
    
    if stderr:
        print(f"Mojo stderr: {stderr}")
    
    print("\nPython output:")
    print(py_output)
    print("\nMojo output:")
    print(mojo_output)
    
    # Compare
    if py_output == mojo_output:
        print("\n✅ MATCH: Outputs are identical")
        return True
    else:
        print("\n❌ MISMATCH: Outputs differ")
        return False


def test_with_height():
    """Test with configured height"""
    print("\n" + "="*70)
    print("TEST: With Height Configuration")
    print("="*70)
    
    # Python
    py_data = [10.0 * math.sin(i * ((2.0 * math.pi) / 30.0)) for i in range(30)]
    py_output = asciichartpy.plot(py_data, {'height': 6})
    
    # Mojo
    mojo_data_expr = """
    from math import sin, pi
    for i in range(30):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 30.0)))
    """
    mojo_config = "config.height = 6"
    mojo_output, stderr = generate_mojo_output("sine_height", mojo_data_expr, mojo_config)
    
    if stderr:
        print(f"Mojo stderr: {stderr}")
    
    print("\nPython output:")
    print(py_output)
    print("\nMojo output:")
    print(mojo_output)
    
    # Compare
    if py_output == mojo_output:
        print("\n✅ MATCH: Outputs are identical")
        return True
    else:
        print("\n❌ MISMATCH: Outputs differ")
        return False


def test_flat_line():
    """Test flat line (all same values)"""
    print("\n" + "="*70)
    print("TEST: Flat Line")
    print("="*70)
    
    # Python
    py_data = [5.0] * 10
    py_output = asciichartpy.plot(py_data)
    
    # Mojo
    mojo_data_expr = """
    for i in range(10):
        data.append(5.0)
    """
    mojo_output, stderr = generate_mojo_output("flat_line", mojo_data_expr)
    
    if stderr:
        print(f"Mojo stderr: {stderr}")
    
    print("\nPython output:")
    print(py_output)
    print("\nMojo output:")
    print(mojo_output)
    
    # Compare
    if py_output == mojo_output:
        print("\n✅ MATCH: Outputs are identical")
        return True
    else:
        print("\n❌ MISMATCH: Outputs differ")
        return False


def main():
    print("\n" + "="*70)
    print("MOJO-ASCIICHART vs ASCIICHARTPY COMPARISON")
    print("Testing output compatibility with Python reference implementation")
    print("="*70)
    
    results = []
    
    # Run tests
    results.append(("Simple Linear", test_simple_linear()))
    results.append(("Sine Wave", test_sine_wave()))
    results.append(("With Height Config", test_with_height()))
    results.append(("Flat Line", test_flat_line()))
    
    # Summary
    print("\n" + "="*70)
    print("SUMMARY")
    print("="*70)
    
    passed = sum(1 for _, result in results if result)
    total = len(results)
    
    for name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status}: {name}")
    
    print(f"\nTotal: {passed}/{total} tests passed")
    
    if passed == total:
        print("\n🎉 All tests passed! Output is identical to asciichartpy.")
        return 0
    else:
        print(f"\n⚠️  {total - passed} test(s) failed. Output differs from asciichartpy.")
        return 1


if __name__ == '__main__':
    sys.exit(main())
