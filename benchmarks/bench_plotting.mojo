"""
Benchmarks for mojo-asciichart plotting performance.

Tests performance of plot() with various data sizes and configurations.
"""

# Import benchsuite from libs
# Note: Run with mojo -I libs/benchsuite/src

from benchsuite import BenchReport
from asciichart import plot, Config, ChartColors

fn plot_small_series():
    """Benchmark plotting 10 data points."""
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i))
    try:
        _ = plot(data)
    except:
        pass

fn plot_medium_series():
    """Benchmark plotting 100 data points."""
    var data = List[Float64]()
    for i in range(100):
        data.append(Float64(i * i))
    try:
        _ = plot(data)
    except:
        pass

fn plot_large_series():
    """Benchmark plotting 1000 data points."""
    var data = List[Float64]()
    for i in range(1000):
        data.append(Float64(i) * 0.1)
    try:
        _ = plot(data)
    except:
        pass

fn plot_with_config():
    """Benchmark plotting with custom config."""
    var data = List[Float64]()
    for i in range(100):
        data.append(Float64(i))
    
    var config = Config()
    config.height = 20
    try:
        _ = plot(data, config)
    except:
        pass

fn plot_with_colors():
    """Benchmark plotting with ANSI colors."""
    var data = List[Float64]()
    for i in range(100):
        data.append(Float64(i))
    
    var config = Config()
    config.colors = ChartColors.matrix()
    try:
        _ = plot(data, config)
    except:
        pass

fn plot_sine_wave():
    """Benchmark plotting realistic sine wave."""
    from math import sin, pi
    
    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(Float64(i) * ((pi * 4.0) / 120.0)))
    try:
        _ = plot(data)
    except:
        pass

def main():
    print("\n🔥 mojo-asciichart Performance Benchmarks 🔥\n")
    
    var report = BenchReport()
    
    # Run benchmarks with adaptive iteration counts
    report.benchmark[plot_small_series]("plot_10_points")
    report.benchmark[plot_medium_series]("plot_100_points")
    report.benchmark[plot_large_series]("plot_1000_points")
    report.benchmark[plot_with_config]("plot_with_config")
    report.benchmark[plot_with_colors]("plot_with_colors")
    report.benchmark[plot_sine_wave]("plot_sine_wave_120pts")
    
    print("\n✅ Benchmarks complete!\n")
