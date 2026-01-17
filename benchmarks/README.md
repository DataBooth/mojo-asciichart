# mojo-asciichart Benchmarks

Performance benchmarks for mojo-asciichart using [BenchSuite](https://github.com/DataBooth/mojo-benchsuite).

## Running Benchmarks

```bash
# Run all benchmarks and generate reports
pixi run bench-plotting

# Reports are auto-saved to benchmarks/reports/ with timestamps
```

## Current Results

**Environment**: Mojo 0.25.7.0 (e5af2b2f) | macOS 14.6.0 | Apple M1 (8 cores)

| Benchmark | Mean | Min | Max | Iterations | Total Time* |
|-----------|------|-----|-----|------------|-------------|
| plot_10_points | 10.7 µs | 9.99 µs | 100 µs | 180,000 | ~1.9s |
| plot_100_points | **19.6 ms** | 18.9 ms | 20.6 ms | 80 | ~1.6s |
| plot_1000_points | 953 µs | 916 µs | 1.21 ms | 2,000 | ~1.9s |
| plot_with_config | 48.9 µs | 46.9 µs | 156 µs | 40,000 | ~2.0s |
| plot_with_colors | 199 µs | 193 µs | 625 µs | 10,000 | ~2.0s |
| plot_sine_wave_120pts | 79.6 µs | 75.9 µs | 308 µs | 20,000 | ~1.6s |

*Total Time = Mean × Iterations (approximate benchmark duration)

### Key Insights

- ⚠️ **100-point plotting is slow** (19.6ms) - **target < 1ms for v1.2.0**
- ✅ Small charts (10 points) are very fast (10.7µs)
- ✅ Large charts (1000 points) are acceptable (953µs)
- ✅ Colors add minimal overhead (199µs vs 80µs baseline ~2.5x)
- ✅ Realistic use case (120pt sine) is fast (79.6µs)

### Performance Priorities for v1.2.0

1. **Optimize 100-point case** - Currently 245x slower than expected
2. Investigate string concatenation overhead
3. Profile `_plot_line_segment()` hot path
4. Consider pre-allocated grid pool
5. Benchmark string builder vs concatenation

## Report Format

Benchmarks auto-generate timestamped reports in `benchmarks/reports/`:

- **Markdown**: `asciichart_bench_YYYYMMDD_HHMMSS.md`
- **CSV**: `asciichart_bench_YYYYMMDD_HHMMSS.csv`

The latest report contains all benchmark results (cumulative as each benchmark runs).

## Known Issues

### 1. Mojo Version Hardcoded in BenchSuite

**Issue**: BenchSuite reports `Mojo 0.26.1+` but actual version is `0.25.7.0`

**Cause**: `EnvironmentInfo.__init__()` in benchsuite.mojo has:
```mojo
self.mojo_version = "0.26.1+"  # Hardcoded
```

**Workaround**: Manually note actual version from `pixi run mojo-version`

**Status**: Issue tracked at [mojo-benchsuite#XX](https://github.com/DataBooth/mojo-benchsuite/issues) (to be filed)

**Fix Needed in BenchSuite**:
```mojo
# Proposed fix - get from command output
from subprocess import run
var result = run(["mojo", "--version"])
var version_line = str(result.stdout).strip()
self.mojo_version = version_line.split()[1]  # Extract version
```

### 2. Total Runtime Not in Markdown Table

**Issue**: Markdown reports don't include total runtime column

**Calculation**: Total Runtime ≈ Mean Time × Iterations

**Status**: Feature request for BenchSuite

**Proposed Addition to `to_markdown()`**:
```mojo
md += "| Benchmark | Mean | Min | Max | Iterations | Total (s) |\n"
md += "|-----------|------|-----|-----|------------|-----------|
\n"

for i in range(len(self.results)):
    var r = self.results[i].copy()
    var total_secs = (r.mean_time_ns * Float64(r.iterations)) / 1_000_000_000.0
    md += "| " + r.name + " | " + format_time(r.mean_time_ns) + " | "
    md += format_time(r.min_time_ns) + " | " + format_time(r.max_time_ns)
    md += " | " + String(r.iterations) + " | " + String(total_secs) + " |\n"
```

### 3. Multiple Reports Generated

**Behaviour**: One report saved after each benchmark completes

**Cause**: `auto_save=True` triggers `save_report()` after every `benchmark[]()` call

**Result**: 6 timestamped reports (1, 2, 3, 4, 5, 6 benchmarks each)

**Workaround**: Use latest report (has all results)

**Better Approach**: Save once at end:
```mojo
var report = BenchReport(auto_print=True, auto_save=False)  # Disable auto-save
report.benchmark[func1](...)
report.benchmark[func2](...)
# ... all benchmarks ...
try:
    report.save_report("benchmarks/reports", "asciichart_bench")  # Manual save once
except:
    print("Warning: Failed to save report")
```

## Benchmark Definitions

See `bench_plotting.mojo` for implementation details.

### plot_10_points
Minimal chart with 10 sequential integers. Tests baseline overhead.

### plot_100_points
Medium chart with 100 quadratic values. **Performance bottleneck identified.**

### plot_1000_points
Large chart with 1000 linear values. Tests scalability.

### plot_with_config
100 points with custom config (height=20). Tests config overhead.

### plot_with_colors
100 points with matrix color theme. Tests ANSI color overhead.

### plot_sine_wave_120pts
Realistic use case: 120-point sine wave. Tests typical workload.

## Contributing

Found a performance issue? Want to help optimize?

1. Run benchmarks: `pixi run bench-plotting`
2. Profile hot paths (consider stdlib `benchmark` module)
3. Submit PR with optimization
4. Include before/after benchmark results

See [ROADMAP.md](../ROADMAP.md) for performance targets.

---

**Last Updated**: 2026-01-17  
**Mojo Version**: 0.25.7.0 (e5af2b2f)  
**Platform**: Apple M1, macOS 14.6.0
