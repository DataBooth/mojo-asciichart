# Changelog

All notable changes to mojo-asciichart will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-01-17

### Added
- Core `plot()` function for single series with automatic scaling
- `Config` struct for chart customization (height, min/max, offset, format)
- `Symbols` struct for type-safe box-drawing character access
- `Bounds` struct for min/max value pairs
- NaN value handling with gap symbols (╶ and ╴)
- Banker's rounding (IEEE 754) via `_round_half_to_even()`
- Helper functions for modular code:
  - `_find_extreme()` - Unified min/max finding
  - `_validate_series()` - Series validation
  - `_get_bounds()` - Bounds calculation with config overrides
  - `_create_grid()` - Grid initialization
  - `_draw_axis_and_labels()` - Axis rendering
  - `_plot_line_segment()` - Line segment rendering
- Comprehensive test suite (25 tests total):
  - `test_basic.mojo` (6 tests)
  - `test_python_interop.mojo` (6 tests)
  - `test_helpers.mojo` (13 tests for helper functions)
- Visual gallery with 13 chart examples
- Documentation:
  - README with API reference
  - BLOG_POST with implementation lessons
  - CREDITS with acknowledgements
  - GALLERY inspection guide
  - CODE_REVIEW with refactoring analysis
  - FORUM_ANNOUNCEMENT for community
  - FUTURE_GENERALIZATION with v1.1.0+ roadmap

### Fixed
- Pixel-perfect output matching with Python's asciichartpy
- Correct ZERO_AXIS symbol (┼ not ├)
- Proper label formatting with 2 decimal places
- Simplified label placement (always starts at position 0)

### Technical Details
- Uses `@fieldwise_init` (replaced deprecated `@value`)
- Proper mutability with `mut` parameters
- Ownership transfers with `^` operator
- Modern TestSuite with `fn` test functions
- Compatible with Mojo 25.7+

### Removed
- N/A (initial release)

---

## [1.1.0] - 2026-01-17

### Added
- 🎨 **ANSI Color Support** via Mojo stdlib `utils._ansi.Color`
  - `ChartColors` struct with `line`, `axis`, and `labels` color fields
  - 6 predefined color schemes:
    - `default()` - no colors (Color.NONE)
    - `blue()` - blue line, cyan axis/labels
    - `matrix()` - green terminal theme
    - `fire()` - red/yellow theme
    - `ocean()` - cyan/blue theme
    - `rainbow()` - multicolor (magenta/cyan/yellow)
  - Added `colors: Optional[ChartColors]` field to Config
  - Smart color wrapping: only adds ANSI codes when color != NONE
- New examples:
  - `examples/colors.mojo` - demonstrates all 6 color schemes
  - `examples/snoopy.mojo` - classic Snoopy sleeping on doghouse pattern
  - `examples/snowflake.mojo` - crystalline symmetry patterns (with colors)
- New tests:
  - `test_colors.mojo` (4 tests) - validates color functionality
  - Total test suite: 29 tests (6 basic + 4 colors + 13 helpers + 6 interop)
- GitHub Actions workflow for automated `.mojopkg` builds on releases
- 📊 **Performance Benchmarking** via BenchSuite integration
  - `benchmarks/bench_plotting.mojo` - 6 Mojo-only benchmarks
  - `benchmarks/bench_python_comparison.mojo` - Mojo vs Python comparison
  - Results: Mojo is 1.4-4.3x faster than Python asciichartpy
  - Auto-generated markdown and CSV reports
- New examples:
  - `examples/australia.mojo` - Australian coastline with ocean theme
- Pixi tasks: `example-colors`, `example-australia`, `bench-plotting`, `bench-python-comparison`

### Changed
- Moved `docs/planning/FUTURE_GENERALIZATION.md` → `ROADMAP.md`
- Updated ROADMAP with detailed ANSI color implementation notes
- Updated README with color scheme documentation
- Color-aware plotting functions:
  - `_plot_line_segment()` - wraps line symbols with color
  - `_draw_axis_and_labels()` - colors axis ticks and labels

### Technical Details
- Zero external dependencies (uses Mojo stdlib only)
- ANSI format: `\033[XXm` (color) + symbol + `\033[0m` (reset)
- Backward compatible: existing code works without modification
- Color.NONE provides empty string ("") for no-color mode

---

## [1.0.0] - 2026-01-17
- **Repository**: https://github.com/DataBooth/mojo-asciichart
- **Issues**: https://github.com/DataBooth/mojo-asciichart/issues
- **Original**: https://github.com/kroitor/asciichart (JavaScript & Python)

## Contributing
Contributions welcome! See README.md for guidelines.

## License
Apache 2.0 - See [LICENSE](LICENSE) for details.
