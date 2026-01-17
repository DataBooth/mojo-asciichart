# Release Notes

Comprehensive release notes for all versions of mojo-asciichart.

---

## v1.1.0 - 2026-01-17 🎨

**ASCII line charts for Mojo with ANSI color support!**

### What's New

#### 🎨 ANSI Color Support
Chart visualisation just got more colourful! Now supports 6 predefined color schemes using Mojo's stdlib `utils._ansi.Color`:

```mojo
from asciichart import plot, Config, ChartColors

var config = Config()
config.colors = ChartColors.ocean()  # Cyan/blue theme
print(plot(data, config))
```

**Available themes:**
- `default()` - No colours (backward compatible)
- `blue()` - Blue line, cyan axis/labels
- `matrix()` - Classic green terminal
- `fire()` - Red/yellow heat
- `ocean()` - Cyan/blue aquatic
- `rainbow()` - Multicolour fun

#### ✨ New Examples
- `colors.mojo` - Demonstrates all 6 color schemes
- `snoopy.mojo` - Classic "Snoopy sleeping on doghouse" pattern
- `snowflake.mojo` - Crystalline symmetry with colours

#### 🧪 Expanded Test Suite
Now 29 tests (up from 25):
- 6 basic tests ✅
- 4 colour tests ✅ (NEW)
- 13 helper tests ✅
- 6 Python interop tests ✅

#### 🤖 CI/CD
- Automated `.mojopkg` builds on GitHub releases
- Package artifact attached to releases

### Installation

**From source:**
```bash
git clone https://github.com/databooth/mojo-asciichart
cd mojo-asciichart
pixi install
```

**As git submodule:**
```bash
git submodule add https://github.com/databooth/mojo-asciichart libs/asciichart
```

**Using .mojopkg:**
Download `asciichart.mojopkg` from [releases](https://github.com/databooth/mojo-asciichart/releases) and use with `mojo -I path/to/asciichart.mojopkg`

### Quick Start

```mojo
from asciichart import plot, ChartColors, Config
from math import sin, pi

fn main() raises:
    # Generate data
    var data = List[Float64]()
    for i in range(60):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 60.0)))
    
    # Plot with colours!
    var config = Config()
    config.colors = ChartColors.matrix()
    print(plot(data, config))
```

### Breaking Changes

None - fully backward compatible! 🎉

### Technical Details

- Zero external dependencies (uses Mojo stdlib only)
- ANSI format: `\033[XXm` + symbol + `\033[0m`
- Smart colour wrapping: no escape codes when `Color.NONE`
- Compatible with Mojo 25.7+

### What's Next?

See [ROADMAP.md](ROADMAP.md) for v1.2.0+ plans:
- Multiple series support
- Custom symbol themes
- Legends and labels
- Performance optimisations

---

## v1.0.0 - 2026-01-17 🚀

**Initial production release - Pixel-perfect Python compatibility!**

### Features

#### Core Functionality
- `plot()` function for single series with automatic scaling
- `Config` struct for chart customisation (height, min/max, offset, format)
- `Symbols` struct for type-safe box-drawing character access
- `Bounds` struct for min/max value pairs
- NaN value handling with gap symbols (╶ and ╴)

#### Advanced Features
- Banker's rounding (IEEE 754) via `_round_half_to_even()`
- Pixel-perfect output matching Python's asciichartpy
- Proper label formatting with 2 decimal places
- Automatic min/max detection and scaling

#### Helper Functions (Modular Architecture)
- `_find_extreme()` - Unified min/max finding
- `_validate_series()` - Series validation
- `_get_bounds()` - Bounds calculation with config overrides
- `_create_grid()` - Grid initialisation
- `_draw_axis_and_labels()` - Axis rendering
- `_plot_line_segment()` - Line segment rendering

#### Test Suite
Comprehensive test suite (25 tests total):
- `test_basic.mojo` (6 tests)
- `test_python_interop.mojo` (6 tests)
- `test_helpers.mojo` (13 tests for helper functions)

#### Examples
- Visual gallery with 13 chart examples
- Simple line example
- Sine wave example

#### Documentation
- README with API reference
- BLOG_POST with implementation lessons learned
- CREDITS with acknowledgements
- GALLERY inspection guide
- CODE_REVIEW with refactoring analysis
- FORUM_ANNOUNCEMENT for community
- ROADMAP (moved from FUTURE_GENERALIZATION.md)

### Fixed

- Correct ZERO_AXIS symbol (┼ not ├)
- Simplified label placement (always starts at position 0)

### Technical Details

- Uses `@fieldwise_init` (replaced deprecated `@value`)
- Proper mutability with `mut` parameters
- Ownership transfers with `^` operator
- Modern TestSuite with `fn` test functions
- Compatible with Mojo 25.7+

### Acknowledgements

This project is built on the excellent work of:
- **[Igor Kroitor](https://github.com/kroitor)** - Creator of asciichart (JavaScript) and asciichartpy (Python)
- **Modular Team** - For creating the Mojo programming language

---

## Package Compatibility

⚠️ **Important**: The `.mojopkg` files are compiled with specific Mojo versions as noted in each release. They may not work with different Mojo versions. For maximum compatibility, use source installation (git submodule or direct copy).

## Links

- 📦 [Repository](https://github.com/databooth/mojo-asciichart)
- 📖 [Documentation](https://github.com/databooth/mojo-asciichart#readme)
- 🗺️ [Roadmap](https://github.com/databooth/mojo-asciichart/blob/main/ROADMAP.md)
- 📝 [Changelog](https://github.com/databooth/mojo-asciichart/blob/main/CHANGELOG.md)
- 🐛 [Issues](https://github.com/databooth/mojo-asciichart/issues)
- 🔖 [Releases](https://github.com/databooth/mojo-asciichart/releases)

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.
