# mojo-asciichart Roadmap 🗺️

Visual roadmap for mojo-asciichart development, showing completed milestones and planned features.

---

## Release Timeline

```
v1.0.0  ═══════════════════════════════════════════════════════════ ✅ 2026-01-17
  │      • Core plot() function
  │      • Pixel-perfect Python compatibility
  │      • 25 tests, helper functions
  │      • Banker's rounding
  │
v1.1.0  ═══════════════════════════════════════════════════════════ ✅ 2026-01-17
  │      • 🎨 ANSI color support (6 themes)
  │      • ChartColors struct
  │      • Fun examples (Snoopy, Snowflake, Australia)
  │      • 29 tests, benchmarking
  │      • CI/CD (.mojopkg builds)
  │
v1.2.0  ═══════════════════════════════════════════════════════════ 🚧 Q1 2026
  │      • Multiple series support
  │      • Legend rendering
  │      • Custom symbol themes
  │      • Performance optimizations
  │
v2.0.0  ═══════════════════════════════════════════════════════════ 📋 Q2 2026
         • Bar charts & histograms
         • Statistical overlays
         • Export formats (SVG, PNG)
         • Pluggable formatters
```

---

## Feature Status

### ✅ Completed (v1.0.0 - v1.1.0)

#### Core Functionality
- [x] Single series line charts
- [x] Automatic scaling and bounds detection
- [x] NaN handling with gap symbols
- [x] Configurable height, min/max, offset
- [x] Banker's rounding (IEEE 754)
- [x] UTF-8 box-drawing characters

#### Visual Enhancements
- [x] 🎨 ANSI color support
- [x] 6 predefined color schemes (blue, matrix, fire, ocean, rainbow, default)
- [x] ChartColors struct

#### Developer Experience
- [x] 29 comprehensive tests
- [x] Python interop validation
- [x] Modular architecture (helper functions)
- [x] GitHub Actions CI/CD
- [x] Automated .mojopkg builds
- [x] Benchmarking with BenchSuite

#### Examples
- [x] Simple & sine wave examples
- [x] Gallery (13 chart types)
- [x] Snoopy pattern
- [x] Snowflake patterns
- [x] Australia coastline

---

## 🚧 In Progress (v1.2.0)

### High Priority

#### Multiple Series Support
**Goal**: Overlay multiple data series on the same chart

```mojo
fn plot_multi(series: List[List[Float64]], config: MultiConfig) raises -> String

var temps_sydney = [18.0, 22.0, 25.0, 28.0, 30.0]
var temps_melbourne = [12.0, 15.0, 18.0, 22.0, 24.0]
var series = List[List[Float64]]()
series.append(temps_sydney)
series.append(temps_melbourne)

var config = MultiConfig()
config.colors = [ChartColors.fire(), ChartColors.ocean()]
print(plot_multi(series, config))
```

**Implementation**:
- Reuse `_plot_line_segment()` for each series
- Handle overlapping points (z-order)
- Per-series colors and symbols
- Unified axis and bounds

**Estimated Effort**: 1-2 weeks

---

#### Legend Support
**Goal**: Identify multiple series with labels

```mojo
struct SeriesLabel:
    var name: String
    var color: Color
    var symbol: String

fn plot_with_legend(
    series: List[List[Float64]],
    labels: List[SeriesLabel]
) raises -> String
```

**Implementation**:
- Render legend below or beside chart
- Auto-generate labels if not provided
- Use same colors/symbols as chart

**Estimated Effort**: 3-5 days

---

#### Custom Axis Labels (X-axis)
**Goal**: Allow custom labels on the x-axis (currently implicit indices)

```mojo
struct Config:
    var x_labels: Optional[List[String]]  # Custom x-axis labels
    var x_label_interval: Int             # Show every Nth label

var config = Config()
config.x_labels = ["00:00", "04:00", "08:00", "12:00", "16:00", "20:00"]
config.x_label_interval = 1
print(plot(data, config))

# Output:
#    20.54  ┤───╯ ╰──╯
#           └─────────────────────────────────
#           00:00  04:00  08:00  12:00  16:00
```

**Benefits**:
- Time series with timestamps
- Categorical x-axis (days, months, categories)
- Better context for data
- Currently x-axis is implicit (0, 1, 2, ..., n)

**Implementation**:
- Render labels below chart
- Auto-spacing based on chart width
- Optional rotation for long labels
- Smart label skipping for dense data

**Estimated Effort**: 1 week

---

### Medium Priority

#### Custom Symbol Themes
**Goal**: Different visual styles for charts

```mojo
struct SymbolTheme:
    @staticmethod
    fn default() -> Symbols
    fn minimal() -> Symbols   # Only |-+
    fn block() -> Symbols     # Block chars ▗▖▄█
    fn dots() -> Symbols      # Dot chars ⋅•●
    fn ascii() -> Symbols     # Pure ASCII (no UTF-8)

struct Config:
    var symbols: Optional[Symbols]
```

**Benefits**:
- Terminal compatibility
- Accessibility options
- Different aesthetic styles

**Estimated Effort**: 1 week

---

#### Performance Optimizations
**Goal**: Faster chart generation for large datasets

**Targets**:
- 1000 points: < 500µs (current: ~950µs)
- 10000 points: < 5ms
- Colored charts: minimal overhead (<10%)

**Strategies**:
- Pre-allocated grid pools
- String builder optimization
- Parallel row rendering (future)
- Benchmark-driven optimization

**Estimated Effort**: 2-3 weeks

---

## 📋 Planned (v2.0.0+)

### Chart Types

#### Bar Charts & Histograms
```mojo
fn bar_chart(data: List[Float64], labels: List[String]) raises -> String
fn histogram(data: List[Float64], bins: Int) raises -> String
```

**Use Cases**:
- Frequency distributions
- Categorical data
- Stacked comparisons

---

#### Statistical Overlays
```mojo
struct StatOverlays:
    var show_mean: Bool
    var show_median: Bool
    var show_std_dev: Bool
    var show_trend_line: Bool
```

**Use Cases**:
- Quick statistical insights
- Trend analysis
- Data quality assessment

---

### Export Formats

#### Image Export
```mojo
fn plot_to_svg(series: List[Float64], config: Config) raises -> String
fn plot_to_png(series: List[Float64], config: Config, path: String) raises
```

**Implementation**:
- SVG: Direct conversion from ASCII
- PNG: Via external rendering (Python PIL or similar)

---

### Advanced Features

#### Pluggable Label Formatters
```mojo
trait LabelFormatter:
    fn format(self, value: Float64) -> String

struct ScientificFormatter(LabelFormatter)
struct CurrencyFormatter(LabelFormatter)
struct PercentageFormatter(LabelFormatter)
```

---

#### Horizontal Charts
```mojo
struct Config:
    var orientation: ChartOrientation  # VERTICAL or HORIZONTAL

enum ChartOrientation:
    VERTICAL
    HORIZONTAL
```

---

## Contributing

Want to help implement a feature? Check the issues tagged with:
- `good-first-issue` - Easy wins for new contributors
- `help-wanted` - Features we'd love help with
- `enhancement` - Feature requests

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Benchmarks

Current performance (v1.1.0, M1 Mac):

| Operation | Mean Time | Notes |
|-----------|-----------|-------|
| 10 points | 10.9 µs | Very small chart |
| 100 points | 19.7 ms | **Needs optimization** |
| 1000 points | 953 µs | Acceptable |
| With colors | 201 µs | Minimal overhead |
| Sine wave (120pts) | 80.0 µs | Realistic use case |

**Target for v1.2.0**: Reduce 100-point plotting to < 1ms

---

## Backward Compatibility Promise

**API Stability**: The core `plot()` API will remain stable across all v1.x releases.

```mojo
// This will ALWAYS work
fn plot(series: List[Float64]) raises -> String
fn plot(series: List[Float64], config: Config) raises -> String
```

New features will be additive (new functions, new config fields) - never breaking.

---

## Links

- [Issues](https://github.com/DataBooth/mojo-asciichart/issues)
- [Discussions](https://github.com/DataBooth/mojo-asciichart/discussions)
- [CHANGELOG](CHANGELOG.md)
- [RELEASE_NOTES](RELEASE_NOTES.md)

---

**Last Updated**: 2026-01-17  
**Status**: Active Development 🔥
