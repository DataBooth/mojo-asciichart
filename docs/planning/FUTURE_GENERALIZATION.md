# Future Generalization Opportunities

This document outlines potential enhancements for v1.1.0 and beyond, based on the refactored v1.0.0 codebase.

## Overview

The current refactored architecture provides a solid foundation for future enhancements. All refactorings from CODE_REVIEW.md have been implemented:

✅ **Completed Refactorings (v1.0.0)**:
1. Extracted `_round_half_to_even()` for banker's rounding
2. Created `Symbols` struct for type-safe symbol access
3. Extracted `_find_extreme()` to unify min/max logic
4. Created validation functions (`_validate_series`, `_get_bounds`)
5. Extracted `_create_grid()` for grid initialization  
6. Extracted `_draw_axis_and_labels()` for axis rendering
7. Extracted `_plot_line_segment()` for line rendering

## Planned Enhancements for v1.1.0+

### 1. Multiple Series Support (High Priority)

**Current State**: Single series only

**Proposed API**:
```mojo
fn plot(series: List[List[Float64]]) raises -> String:
    """Plot multiple data series on the same chart."""

fn plot(series: List[List[Float64]], config: MultiSeriesConfig) raises -> String:
    """Plot with per-series configuration."""

struct MultiSeriesConfig:
    var height: Optional[Int]
    var symbols_list: List[Symbols]  # Different symbols per series
    var colors: List[String]  # ANSI color codes
```

**Implementation Notes**:
- Reuse existing `_plot_line_segment()` for each series
- Overlay series in the same grid
- Handle overlapping points (last-drawn wins, or blend)
- Extend `Symbols` to support per-series customization

**Benefits**:
- Compare multiple datasets visually
- Matches original asciichart/asciichartpy capability
- Enables advanced visualizations

---

### 2. Custom Symbol Sets (Medium Priority)

**Current State**: Fixed symbol set in `Symbols` struct

**Proposed API**:
```mojo
struct SymbolTheme:
    """Predefined symbol themes for different styles."""
    fn default() -> Symbols
    fn minimal() -> Symbols  # Use only |-+
    fn block() -> Symbols    # Use block chars ▗▖▄█
    fn dots() -> Symbols     # Use dot chars ⋅•●

struct Config:
    var symbols: Optional[Symbols]  # Custom symbol override
```

**Implementation Notes**:
- Add theme factory functions
- Allow complete symbol customization
- Document symbol requirements (10 distinct chars)

**Benefits**:
- Different visual styles
- Terminal compatibility (fallback to ASCII)
- Accessibility options

---

### 3. ANSI Color Support (Medium Priority)

**Current State**: Monochrome output

**Proposed API**:
```mojo
struct Colors:
    """ANSI color codes for chart elements."""
    var axis: String
    var line: String  
    var labels: String

struct Config:
    var colors: Optional[Colors]

# Predefined colors
fn Colors.blue() -> Colors
fn Colors.green() -> Colors  
fn Colors.rainbow() -> Colors  # Cycle through colors
```

**Implementation Notes**:
- Wrap symbols in ANSI escape codes
- Support 16-color and 256-color modes
- Add `--no-color` flag for plain output
- Helper function to detect color support

**Benefits**:
- More visually appealing output
- Multiple series with distinct colors
- Highlight important data points

---

### 4. Pluggable Label Formatters (Low Priority)

**Current State**: Fixed `{:8.2f}` format

**Proposed API**:
```mojo
trait LabelFormatter:
    fn format(self, value: Float64) -> String

struct ScientificFormatter(LabelFormatter):
    fn format(self, value: Float64) -> String:
        # e.g. "1.23e+05"

struct IntegerFormatter(LabelFormatter):
    fn format(self, value: Float64) -> String:
        # e.g. "   12345"

struct Config:
    var formatter: Optional[LabelFormatter]
```

**Implementation Notes**:
- Define `LabelFormatter` trait
- Create common formatter implementations
- Update `_draw_axis_and_labels()` to use formatter
- Ensure label width consistency

**Benefits**:
- Scientific notation for large/small values
- Integer-only labels when appropriate
- Custom formatting (e.g., currency, percentages)

---

### 5. Bar Charts and Histograms (Future)

**Current State**: Line charts only

**Proposed API**:
```mojo
fn bar_chart(data: List[Float64], labels: List[String]) raises -> String:
    """Vertical bar chart."""

fn histogram(data: List[Float64], bins: Int) raises -> String:
    """Frequency distribution histogram."""
```

**Implementation Notes**:
- Reuse grid infrastructure
- New rendering functions for bars
- Horizontal vs vertical orientation
- Stacked bar charts

**Benefits**:
- Complementary visualization types
- Frequency analysis
- Categorical data display

---

### 6. Horizontal Charts (Low Priority)

**Current State**: Vertical Y-axis only

**Proposed API**:
```mojo
struct Config:
    var orientation: ChartOrientation  # VERTICAL or HORIZONTAL

enum ChartOrientation:
    VERTICAL
    HORIZONTAL
```

**Implementation Notes**:
- Transpose grid operations
- Swap X/Y axis logic
- Update label placement

**Benefits**:
- Better for time-series with labels
- Accommodates narrow terminals
- Different visual emphasis

---

###  7. Legend Support (Medium Priority)

**Current State**: No series identification

**Proposed API**:
```mojo
struct SeriesLabel:
    var name: String
    var symbol: Symbols
    var color: Optional[String]

fn plot_with_legend(
    series: List[List[Float64]],
    labels: List[SeriesLabel]
) raises -> String:
    """Plot with legend showing series names."""
```

**Implementation Notes**:
- Render legend below or beside chart
- Use same symbols/colors as in chart
- Auto-generate labels if not provided

**Benefits**:
- Identify multiple series
- Professional appearance
- Self-documenting charts

---

### 8. Statistical Overlays (Future)

**Current State**: Raw data only

**Proposed API**:
```mojo
struct StatOverlays:
    var show_mean: Bool
    var show_median: Bool  
    var show_std_dev: Bool
    var show_trend_line: Bool

struct Config:
    var overlays: Optional[StatOverlays]
```

**Implementation Notes**:
- Calculate statistics from data
- Render as horizontal/diagonal lines
- Use different symbols for overlays
- Annotate with values

**Benefits**:
- Quick statistical insights
- Trend analysis
- Data quality assessment

---

## Architecture Considerations

### Extension Points

The refactored codebase provides clean extension points:

1. **Rendering Pipeline**:
   ```
   Create Grid → Draw Axis → Plot Data → Overlay Stats → Apply Colors → Format Output
   ```

2. **Pluggable Components**:
   - `Symbols`: Already struct-based
   - `LabelFormatter`: Add trait
   - `ColorScheme`: Add struct
   - `Renderer`: Extract interface

3. **Data Processing**:
   - `_validate_series()`: Extend for multiple series
   - `_get_bounds()`: Support global or per-series bounds
   - `_find_extreme()`: Already generalized

### Backward Compatibility

**Commitment**: Maintain v1.0 API forever

```mojo
// v1.0 API - always works
fn plot(series: List[Float64]) raises -> String

// v1.1+ API - opt-in features
fn plot(series: List[Float64], config: Config) raises -> String
fn plot_multi(series: List[List[Float64]], config: MultiConfig) raises -> String
```

**Strategy**:
- Never break existing `plot()` signatures
- Add new functions for new features
- Use Optional for new Config fields
- Semantic versioning: major.minor.patch

---

## Performance Optimization Opportunities

### 1. Pre-allocated Grids

**Current**: Create grid on every call

**Optimization**:
```mojo
struct ChartRenderer:
    var grid_pool: List[List[List[String]]]  # Reusable grids
    
    fn plot_with_cache(series: List[Float64]) -> String:
        var grid = self.grid_pool.pop()  # Reuse
        # ... render ...
        self.grid_pool.append(grid^)  # Return to pool
```

### 2. Parallel Rendering

**Current**: Sequential row rendering

**Optimization**:
```mojo
@parameter
fn parallel_plot(series: List[Float64]) -> String:
    # Use @parallelize for row rendering
    # Each row independent after bounds calculated
```

### 3. String Builder Optimization

**Current**: String concatenation

**Optimization**:
```mojo
fn plot_optimized() -> String:
    var builder = StringBuilder()
    for row in result:
        builder.append_line(row)
    return builder^.render()
```

---

## Testing Strategy for Future Features

### 1. Feature Flags

Enable incremental development:
```mojo
fn plot(series: List[Float64], config: Config) raises -> String:
    if config.enable_experimental_features:
        return _plot_v2(series, config)
    return _plot_v1(series, config)
```

### 2. Compatibility Tests

Ensure v1.0 behavior unchanged:
```mojo
fn test_v1_compat_after_refactor():
    # Run all v1.0 tests
    # Ensure identical output
```

### 3. Benchmark Suite

Track performance impact:
```mojo
fn benchmark_plot():
    var data = generate_large_series(10000)
    measure_time(lambda: plot(data))
```

---

## Priority Roadmap

### v1.1.0 (Q2 2026)
- [x] Refactor codebase (DONE in v1.0.0)
- [ ] Multiple series support
- [ ] ANSI colors  
- [ ] Legend support

### v1.2.0 (Q3 2026)
- [ ] Custom symbol themes
- [ ] Bar charts
- [ ] Horizontal orientation

### v1.3.0 (Q4 2026)
- [ ] Pluggable formatters
- [ ] Statistical overlays
- [ ] Performance optimizations

### v2.0.0 (2027)
- [ ] Major architecture overhaul if needed
- [ ] Break compatibility only if necessary

---

## Community Input

We welcome feedback on these generalization opportunities!

**Discussion Topics**:
1. Which features are most valuable to you?
2. Are there use cases we haven't considered?
3. Performance vs features trade-offs

**Contributing**:
- File issues for feature requests
- Submit PRs for implementations
- Share your use cases

---

## Conclusion

The v1.0.0 refactoring provides a solid foundation for future enhancements. The modular architecture enables incremental feature additions without breaking existing code.

**Next Steps**:
1. Gather community feedback
2. Prioritize v1.1.0 features
3. Create detailed design docs for top priorities
4. Implement with comprehensive tests

See **CODE_REVIEW.md** for implementation patterns and **FORUM_ANNOUNCEMENT.md** for current features.
