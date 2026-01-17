"""
Python comparison benchmarks - Mojo vs Python asciichartpy.

Compares performance of native Mojo implementation against Python asciichartpy
library using Mojo's Python interop.
"""

from benchsuite import BenchReport
from asciichart import plot
from python import Python

fn bench_mojo_10_points():
    """Benchmark Mojo implementation with 10 points."""
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i) * 0.5)
    try:
        _ = plot(data)
    except:
        pass


fn bench_mojo_100_points():
    """Benchmark Mojo implementation with 100 points."""
    var data = List[Float64]()
    for i in range(100):
        data.append(Float64(i) * 0.5)
    try:
        _ = plot(data)
    except:
        pass


fn bench_mojo_1000_points():
    """Benchmark Mojo implementation with 1000 points."""
    var data = List[Float64]()
    for i in range(1000):
        data.append(Float64(i) * 0.5)
    try:
        _ = plot(data)
    except:
        pass


fn bench_python_10_points():
    """Benchmark Python asciichartpy with 10 points via interop."""
    try:
        var asciichartpy = Python.import_module("asciichartpy")
        var data_py = Python.evaluate("[]")
        for i in range(10):
            _ = data_py.append(Float64(i) * 0.5)
        _ = asciichartpy.plot(data_py)
    except:
        pass


fn bench_python_100_points():
    """Benchmark Python asciichartpy with 100 points via interop."""
    try:
        var asciichartpy = Python.import_module("asciichartpy")
        var data_py = Python.evaluate("[]")
        for i in range(100):
            _ = data_py.append(Float64(i) * 0.5)
        _ = asciichartpy.plot(data_py)
    except:
        pass


fn bench_python_1000_points():
    """Benchmark Python asciichartpy with 1000 points via interop."""
    try:
        var asciichartpy = Python.import_module("asciichartpy")
        var data_py = Python.evaluate("[]")
        for i in range(1000):
            _ = data_py.append(Float64(i) * 0.5)
        _ = asciichartpy.plot(data_py)
    except:
        pass


def main():
    print("\n⚔️  Mojo vs Python Performance Comparison ⚔️\n")
    print("Comparing native Mojo against Python asciichartpy (via interop)\n")
    
    # Create report with manual save (not auto-save to avoid multiple files)
    var report = BenchReport(auto_print=True, auto_save=False)
    
    # Benchmark Mojo implementation
    print("🔥 Benchmarking Mojo (native)...")
    report.benchmark[bench_mojo_10_points]("mojo_10_points", min_runtime_secs=0.5)
    report.benchmark[bench_mojo_100_points]("mojo_100_points", min_runtime_secs=0.5)
    report.benchmark[bench_mojo_1000_points]("mojo_1000_points", min_runtime_secs=0.5)
    
    # Benchmark Python via interop
    print("\n🐍 Benchmarking Python asciichartpy (via interop)...")
    report.benchmark[bench_python_10_points]("python_10_points", min_runtime_secs=0.5)
    report.benchmark[bench_python_100_points]("python_100_points", min_runtime_secs=0.5)
    report.benchmark[bench_python_1000_points]("python_1000_points", min_runtime_secs=0.5)
    
    # Save final report
    print("\n📊 Saving comparison report...")
    try:
        report.save_report("benchmarks/reports", "python_comparison")
        print("✅ Report saved to benchmarks/reports/\n")
    except:
        print("⚠️  Failed to save report\n")
    
    # Calculate speedups
    print("\n📈 Performance Analysis:")
    if len(report.results) >= 6:
        var mojo_10_ns = report.results[0].mean_time_ns
        var python_10_ns = report.results[3].mean_time_ns
        var speedup_10 = python_10_ns / mojo_10_ns
        
        var mojo_100_ns = report.results[1].mean_time_ns
        var python_100_ns = report.results[4].mean_time_ns
        var speedup_100 = python_100_ns / mojo_100_ns
        
        var mojo_1000_ns = report.results[2].mean_time_ns
        var python_1000_ns = report.results[5].mean_time_ns
        var speedup_1000 = python_1000_ns / mojo_1000_ns
        
        print("  10 points:   Mojo is " + String(Float64(Int(speedup_10 * 10.0)) / 10.0) + "x faster")
        print("  100 points:  Mojo is " + String(Float64(Int(speedup_100 * 10.0)) / 10.0) + "x faster")
        print("  1000 points: Mojo is " + String(Float64(Int(speedup_1000 * 10.0)) / 10.0) + "x faster")
    
    print("\nNote: Python benchmark includes Python interop overhead from Mojo.\n")
