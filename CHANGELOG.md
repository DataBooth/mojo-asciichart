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

## [Unreleased]

### Planned for v1.1.0
- Multiple series support (overlay charts)
- ANSI color support
- Legend rendering
- Custom symbol themes

See [FUTURE_GENERALIZATION.md](docs/planning/FUTURE_GENERALIZATION.md) for detailed roadmap.

---

## Project Links
- **Repository**: https://github.com/DataBooth/mojo-asciichart
- **Issues**: https://github.com/DataBooth/mojo-asciichart/issues
- **Original**: https://github.com/kroitor/asciichart (JavaScript & Python)

## Contributing
Contributions welcome! See README.md for guidelines.

## License
Apache 2.0 - See [LICENSE](LICENSE) for details.
