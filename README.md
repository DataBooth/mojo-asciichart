# mojo-asciichart 🔥

**Nice-looking lightweight console ASCII line charts ╭┈╯ for Mojo**

> **Status:** ✅ **Production Ready** - Pixel-perfect Python compatibility achieved

## Overview

`mojo-asciichart` is a native Mojo port of the popular `asciichartpy` Python library, which itself is a port of the original JavaScript `asciichart` by Igor Kroitor. Generate beautiful ASCII line charts in your terminal with no dependencies, combining Python-like ergonomics with C++-level performance.

```mojo
from asciichart import plot
from math import sin, pi

fn main() raises:
    # Generate sample data
    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(i * ((pi * 4) / 120)))
    
    # Plot it!
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

## Motivation

This project ports `asciichartpy` to Mojo to provide:
- ✅ Native Mojo implementation with no Python dependencies
- ✅ High-performance charting for data-intensive applications
- ✅ API compatibility with `asciichartpy` where practical
- ✅ Python interop testing for validation

See **[CREDITS.md](CREDITS.md)** for detailed acknowledgements to the original `asciichart` (JavaScript) and `asciichartpy` (Python) projects by Igor Kroitor.

## Features

### Current (v1.0.0) ✅
- ✅ Basic `plot()` function for single series
- ✅ Configurable height via `Config` struct
- ✅ Automatic min/max detection and scaling
- ✅ NaN value handling (gaps in data)
- ✅ UTF-8 box-drawing characters for smooth curves
- ✅ Python interop tests for compatibility validation
- ✅ Pixel-perfect output matching `asciichartpy`
- ✅ Banker's rounding (IEEE 754) for correct value placement
- ✅ Comprehensive test suite (12 tests: 6 basic + 6 Python interop)
- ✅ Visual gallery with 13 chart examples

### Future (v1.1.0+)
- [ ] Multiple data series support (overlay charts)
- [ ] Custom symbols and ANSI colours
- [ ] Axis labels and legends
- [ ] Performance optimisations and benchmarks
- [ ] Bar charts and histograms

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

### API Reference

**Core Function:**
```mojo
fn plot(series: List[Float64]) raises -> String
fn plot(series: List[Float64], config: Config) raises -> String
```

**Configuration:**
```mojo
struct Config:
    var height: Optional[Int]     # Chart height in rows
    var min_val: Optional[Float64]  # Force minimum value
    var max_val: Optional[Float64]  # Force maximum value
    var offset: Int                 # Left margin (default: 3)
    var format_str: String          # Label format (default: 8.2f)
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
pixi run example-simple
```

## Documentation

- [CREDITS.md](CREDITS.md) - Acknowledgements and project history
- [docs/planning/](docs/planning/) - Development roadmap and design docs (coming soon)

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
