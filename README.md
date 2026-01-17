# mojo-asciichart 🔥

**Nice-looking lightweight console ASCII line charts ╭┈╯ for Mojo**

> **Status:** ✅ **Production Ready** - Pixel-perfect Python compatibility achieved

## Overview

`mojo-asciichart` is a native Mojo port of the popular `asciichartpy` Python library, which itself is a port of the original JavaScript `asciichart` by Igor Kroitor. Generate beautiful ASCII line charts in your terminal with no dependencies, combining Python-like ergonomics with C++-level performance.

```mojo
from asciichart import plot

fn main() raises:
    # Simple data
    var data = List[Float64]()
    for i in range(8):
        data.append(Float64(i * i))
    
    print(plot(data))
```

**Output:**
```
   49.00  ┤      ╭
   42.00  ┤     ╭╯
   36.00  ┤    ╭╯
   30.00  ┤   ╭╯
   25.00  ┤  ╭╯
   20.00  ┤ ╭╯
   16.00  ┤╭╯
    9.00  ├╯
    4.00  ┼╯
    1.00  ┼
    0.00  ┼
```

## Practical Use Case: ML Serving Latency Monitoring

ASCII charts are perfect for quick visual feedback in production environments. Here's a realistic example monitoring ML model prediction latencies:

```mojo
# examples/ml_serving.mojo - Monitor API latency in real-time
from asciichart import plot, Config, ChartColors

fn main() raises:
    var latencies = collect_api_latencies()  # Last 100 requests
    
    var config = Config()
    config.height = 12
    config.colors = ChartColors.fire()  # Red/yellow for 'hot' data
    
    print(plot(latencies, config))
    print_stats(latencies)  # Mean, P95, etc.
```

**Output (shortened for display):**
```
   65.2  ┤  ╭╮    ╭╮
   52.1  ┤  ││    ││  ╭╮
   39.0  ┤ ╭╯│    ││  │╰╮
   26.0  ┤ │ │  ╭╮││  │ │ ╭╮
   13.0  ┼─╯ ╰──╯╰╯╰──╯ ╰─╯╰──

📊 Stats: Mean=25.3ms | P95=63.7ms | Max=101.9ms
⚠️  Action: High latency spikes detected
```
_Note: Actual output is wider (100 data points). This is shortened for markdown display only._

**Perfect for:**
- 🔌 SSH'd into production servers
- 📦 CI/CD pipeline monitoring
- 📝 Quick health checks in logs
- 🛠️ Local development testing

_Run `pixi run example-ml-serving` to see full width chart with colors!_

## Motivation

This project ports `asciichartpy` to Mojo to provide:
- ✅ Native Mojo implementation with no Python dependencies
- ✅ High-performance charting for data-intensive applications
- ✅ API compatibility with `asciichartpy` where practical
- ✅ Python interop testing for validation

See **[CREDITS.md](CREDITS.md)** for detailed acknowledgements to the original `asciichart` (JavaScript) and `asciichartpy` (Python) projects by Igor Kroitor.

## Features

### Current (v1.1.0) ✅
- ✅ Basic `plot()` function for single series
- ✅ Configurable height via `Config` struct
- ✅ Automatic min/max detection and scaling
- ✅ NaN value handling (gaps in data)
- ✅ UTF-8 box-drawing characters for smooth curves
- ✅ 🎨 **ANSI color support** (6 predefined themes)
- ✅ Python interop tests for compatibility validation
- ✅ Pixel-perfect output matching `asciichartpy`
- ✅ Banker's rounding (IEEE 754) for correct value placement
- ✅ Comprehensive test suite (29 tests: 6 basic + 4 colors + 13 helpers + 6 interop)
- ✅ Performance benchmarks (1.4-4.3x faster than Python)
- ✅ Visual gallery with fun examples (Snoopy, snowflakes, Australia)

### Future (v1.2.0+)
- [ ] Multiple data series support (overlay charts)
- [ ] Custom x-axis labels (currently implicit indices 0→9)
- [ ] Legend rendering for multi-series
- [ ] Custom symbol themes
- [ ] Performance optimisations (target < 1ms for 100 points)
- [ ] Bar charts and histograms

See **[ROADMAP.md](ROADMAP.md)** for detailed feature plans.

## Installation

### Development Setup
```bash
# Clone repository
git clone https://github.com/databooth/mojo-asciichart
cd mojo-asciichart

# Install dependencies with pixi
pixi install

# Run tests (when available)
pixi run test-all

# Run example
pixi run example-simple
```

### Usage in Your Project

**Current installation options:**
- **Git submodule**: Add as a submodule and import from `src/asciichart`
- **Direct copy**: Copy `src/asciichart/` into your project
- **Future**: pixi package (via modular-community channel), compiled `.mojopkg`

## Usage

### Quick Start

```mojo
from asciichart import plot

fn main() raises:
    # Simple data
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i * i))
    
    print(plot(data))
```

### Configuration Options

```mojo
from asciichart import plot, Config

fn main() raises:
    var data = List[Float64]()
    # ... populate data ...
    
    # Configure chart appearance
    var config = Config()
    config.height = 10
    config.offset = 3
    
    print(plot(data, config))
```

### Using Colors

```mojo
from asciichart import plot, Config, ChartColors
from math import sin, pi

fn main() raises:
    var data = List[Float64]()
    for i in range(60):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 60.0)))
    
    # Apply color scheme
    var config = Config()
    config.colors = ChartColors.ocean()  # Cyan/blue theme
    
    print(plot(data, config))
```

**Available color schemes:**
- `ChartColors.default()` - No colors
- `ChartColors.blue()` - Blue line, cyan axis/labels
- `ChartColors.matrix()` - Green terminal theme
- `ChartColors.fire()` - Red/yellow theme
- `ChartColors.ocean()` - Cyan/blue theme
- `ChartColors.rainbow()` - Multicolor (magenta/cyan/yellow)

### API Reference

**Core Function:**
```mojo
fn plot(series: List[Float64]) raises -> String
fn plot(series: List[Float64], config: Config) raises -> String
```

**Configuration:**
```mojo
struct Config:
    var height: Optional[Int]          # Chart height in rows
    var min_val: Optional[Float64]     # Force minimum value
    var max_val: Optional[Float64]     # Force maximum value
    var offset: Int                    # Left margin (default: 3)
    var format_str: String             # Label format (default: 8.2f)
    var colors: Optional[ChartColors]  # Color scheme (default: None)

struct ChartColors:
    var line: Color    # Line/curve color
    var axis: Color    # Axis tick color
    var labels: Color  # Label text color
    
    @staticmethod
    fn default() -> ChartColors    # No colors
    fn blue() -> ChartColors       # Blue theme
    fn matrix() -> ChartColors     # Green terminal
    fn fire() -> ChartColors       # Red/yellow
    fn ocean() -> ChartColors      # Cyan/blue
    fn rainbow() -> ChartColors    # Multicolor
```

See [docs/BLOG_POST.md](docs/BLOG_POST.md) for detailed implementation notes.

## Project Structure

```
mojo-asciichart/
├── src/asciichart/     # Source code
├── tests/              # Tests
├── examples/           # Usage examples
├── docs/               # Documentation
│   └── planning/       # Project planning docs
├── LICENSE             # Apache 2.0
├── README.md           # This file
└── CREDITS.md          # Acknowledgements
```

## Development

### Prerequisites
- Mojo 25.7+ (via pixi)
- Python 3.10+ (for compatibility testing with asciichartpy)

### Running Tests

```bash
# Run basic tests
pixi run mojo -I src tests/test_basic.mojo

# Run Python interop tests
pixi run mojo -I src tests/test_python_interop.mojo

# Run visual gallery
pixi run mojo -I src examples/gallery.mojo
```

### Running Examples

```bash
# Basic examples
pixi run example-simple
pixi run example-sine

# Visual gallery
pixi run example-gallery

# Fun patterns
pixi run example-snoopy     # Classic Snoopy sleeping on doghouse
pixi run example-snowflake  # Crystalline symmetry patterns
```

## Documentation

- [RELEASE_NOTES.md](RELEASE_NOTES.md) - Comprehensive release notes for all versions
- [CHANGELOG.md](CHANGELOG.md) - Version history and release notes
- [ROADMAP.md](ROADMAP.md) - Future features and technical plans
- [CREDITS.md](CREDITS.md) - Acknowledgements and project history
- [docs/BLOG_POST.md](docs/BLOG_POST.md) - Implementation lessons learned
- [docs/planning/](docs/planning/) - Design docs and code reviews

## Contributing

Contributions welcome! This project is open source (Apache 2.0 License).

**How to contribute:**
1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Run `pixi run test-all` to ensure tests pass
5. Submit a pull request

## Related Projects

**Original Projects:**
- **[asciichart](https://github.com/kroitor/asciichart)** (JavaScript) - Original implementation by Igor Kroitor
- **[asciichartpy](https://github.com/kroitor/asciichart)** (Python) - Python port, our reference implementation

**Other Mojo Libraries:**
- **[mojo-dotenv](https://github.com/databooth/mojo-dotenv)** - Load environment variables from .env files
- **[mojo-toml](https://github.com/databooth/mojo-toml)** - TOML 1.0 parser and writer
- **[mojo-ini](https://github.com/databooth/mojo-ini)** - INI file parser

## Acknowledgements

This project is built on the excellent work of:
- **[Igor Kroitor](https://github.com/kroitor)** - Creator of asciichart (JavaScript) and asciichartpy (Python)
- **[DataBooth](https://www.databooth.com.au/posts/mojo)** - Project sponsor, building high-performance data and AI services with Mojo
- **Modular Team** - For creating the Mojo programming language

See **[CREDITS.md](CREDITS.md)** for detailed acknowledgements.

## License

Apache 2.0 License - See [LICENSE](LICENSE) for details.

This aligns with the Mojo language licensing and ensures maximum compatibility with the Mojo ecosystem.

## Links

- [GitHub Repository](https://github.com/databooth/mojo-asciichart)
- [Original asciichart (JS)](https://github.com/kroitor/asciichart)
- [asciichartpy (Python)](https://pypi.org/project/asciichartpy/)
- [Mojo Documentation](https://docs.modular.com/mojo/)
