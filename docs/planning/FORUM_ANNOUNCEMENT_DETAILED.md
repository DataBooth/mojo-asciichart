# mojo-asciichart v1.1.0 - ASCII Line Charts with Colors! 🎨

I've released **mojo-asciichart v1.1.0**, a native Mojo port of asciichartpy with:
- 🎨 ANSI color support (6 themes!)
- ⚡ Verified performance gains (1.4-4.3x faster than Python)
- 🚀 Realistic ML serving monitoring example
- 🔥 Zero dependencies (stdlib only)
- 📊 Comprehensive benchmarking with BenchSuite

## What it does

Generate beautiful ASCII line charts in your terminal:
- UTF-8 box-drawing characters for smooth curves
- Automatic scaling and height adjustment
- NaN handling (gaps in data)
- Configurable min/max bounds
- IEEE 754 banker's rounding for accuracy
- 12 tests ensuring Python compatibility

## Installation

```bash
git clone https://github.com/DataBooth/mojo-asciichart.git
cd mojo-asciichart
pixi install
pixi run mojo -I src examples/gallery.mojo
```

Coming soon to the `modular-community` channel.

## Usage

```mojo
from asciichart import plot
from math import sin, pi

fn main() raises:
    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(i * ((pi * 4) / 120)))
    print(plot(data))
```

**Output:**
```
    15.00  ┼╮╭┼───────╮╭┼───────╮╭┼
    10.71  ┤╰╯        ╰╯        ╰╯ 
     6.43  ┤                       
     2.14  ┤                       
    -2.14  ┤                       
    -6.43  ┤                       
   -10.71  ┤╭╮        ╭╮        ╭╮ 
   -15.00  ┼╯╰────────╯╰────────╯╰─
```

### With Configuration

```mojo
from asciichart import plot, Config

fn main() raises:
    var data = List[Float64]()
    for i in range(30):
        data.append(15.0 * cos(i * ((pi * 8) / 120)))
    
    var config = Config()
    config.height = 6
    print(plot(data, config))
```

## What's New in v1.1.0

- 🎨 **ANSI Color Support** - 6 predefined themes (blue, matrix, fire, ocean, rainbow)
- 📊 **Performance Benchmarking** - Integrated with BenchSuite, verified 1.4-4.3x faster than Python
- 🚀 **ML Serving Example** - Realistic production latency monitoring (`examples/ml_serving.mojo`)
- 🇦🇺 **Fun Examples** - Snoopy, Snowflake, Australia coastline
- 🤖 **CI/CD** - Automated `.mojopkg` builds on releases
- 📝 **29 Tests** - Expanded from 25 (4 new color tests)

### Color Example

```mojo
from asciichart import plot, Config, ChartColors

fn main() raises:
    var data = List[Float64]()
    for i in range(60):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 60.0)))
    
    var config = Config()
    config.colors = ChartColors.matrix()  # Green terminal theme!
    print(plot(data, config))
```

## Performance

**Benchmarked on M1 Mac with Mojo 0.25.7.0**:

### Native Mojo Performance

| Data Points | Mean Time | Status |
|-------------|-----------|--------|
| 10 points   | 7.4 µs    | ⚡ Very fast |
| 100 points  | 107 µs    | ✅ Production ready |
| 1000 points | 4.6 ms    | ⚠️ Needs optimisation |

### Mojo vs Python (asciichartpy)

| Data Points | Mojo | Python | Speedup |
|-------------|------|--------|----------|
| 10 points   | 7.4 µs | 31.8 µs | **4.3x faster** |
| 100 points  | 107 µs | 262 µs | **2.4x faster** |
| 1000 points | 4.6 ms | 6.5 ms | **1.4x faster** |

*Note: Python measurements include Python interop overhead when called from Mojo.*

Colors add minimal overhead (~2.5x vs baseline, still < 200µs for 100 points).

**Python Compatibility**: Verified pixel-perfect output matching against asciichartpy with 6 interop tests.

## Practical Example: ML Serving Latency Monitoring

Check out `examples/ml_serving.mojo` for a realistic production scenario:
- Monitor ML model prediction latencies
- Visualize 100 requests with statistics (Mean, P95, Max)
- Actionable insights based on thresholds
- Perfect for SSH sessions, CI/CD logs, or quick health checks

```mojo
var latencies = collect_api_latencies()  # Last 100 requests
var config = Config()
config.colors = ChartColors.fire()  # Red/yellow for 'hot' data
print(plot(latencies, config))
```

**Output shows**: Latency spikes, GC patterns, outliers - all in your terminal!

## Use Cases

- 🚀 **ML/API monitoring** - Production latency tracking
- 📊 **CI/CD pipelines** - Build time trends, test results
- 🔌 **SSH sessions** - Quick health checks on remote servers
- 📝 **Log analysis** - Visualize metrics without GUI
- 🛠️ **Development** - Fast feedback during prototyping
- 📉 **Embedded systems** - Resource-constrained environments

## Links

- [GitHub Repository](https://github.com/DataBooth/mojo-asciichart)
- [Documentation](https://github.com/DataBooth/mojo-asciichart/blob/main/README.md)
- [Blog Post: Building mojo-asciichart](https://github.com/DataBooth/mojo-asciichart/blob/main/docs/BLOG_POST.md)
- License: Apache 2.0

## Roadmap

Completed in v1.1.0:
- ✅ ANSI color support (6 themes)
- ✅ Performance benchmarks
- ✅ Comprehensive documentation
- ✅ GitHub CI/CD

Planned for v1.2.0+:
- Multiple data series support (overlay charts)
- Legend rendering
- Custom symbols and line styles
- Performance optimizations (target < 1ms for 100 points)
- Bar charts and histograms

## Acknowledgements

This project is a Mojo port of:
- **[asciichart](https://github.com/kroitor/asciichart)** (JavaScript) - Original by Igor Kroitor
- **[asciichartpy](https://github.com/kroitor/asciichart)** (Python) - Python port by Igor Kroitor

Sponsored by [DataBooth](https://www.databooth.com.au/posts/mojo), building high-performance data and AI services with Mojo.

---

## Personal Note 🏖️

This marks the end of my intensive "Month of Mojo" self-learning journey! I've built three Mojo projects:
- [mojo-toml](https://github.com/DataBooth/mojo-toml) - TOML parser
- [mojo-dotenv](https://github.com/DataBooth/mojo-dotenv) - Environment variable loader
- [mojo-asciichart](https://github.com/DataBooth/mojo-asciichart) - ASCII charts (this one!)

Learned the language from scratch, contributed to the ecosystem, and had a blast doing it.

Now it's time for some well-earned Australian summer beach time! 🇦🇺☀️🌊

The repos will continue to be maintained, and I'll be back with fresh energy and ideas. Feel free to open issues, contribute, or just explore the code.

**Feedback and contributions welcome!** 🔥
