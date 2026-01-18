# Building mojo-asciichart 🔥: Porting Python to Mojo

*Posted 2026-01-17 · ~600 words · Tags: Mojo, Python Porting, Performance, ASCII Visualisation*

## Executive Summary

I ported Python's `asciichartpy` (215 lines) to Mojo, achieving pixel-perfect compatibility while delivering 1.4-4.3x performance improvements. The Mojo implementation (513 lines) is larger due to explicit type handling and missing standard library features, but demonstrates that high-fidelity Python ports are achievable in Mojo.

**Key outcomes:**
- ✅ Pixel-perfect output matching Python
- ⚡ 1.4-4.3x faster than Python
- 🎨 Added ANSI colour support (6 themes)
- 📊 Production-ready in ~7 hours initial development

## Why This Matters

ASCII charts solve real problems in constrained environments: SSH sessions, CI/CD logs, embedded systems, and terminal monitoring. No GUI required—just fast, lightweight visualisation.

## Code Comparison: Python vs Mojo

| Metric | Python | Mojo | Notes |
|--------|--------|------|-------|
| **Lines of code** | 215 | 513 | 2.4x larger |
| **Core logic** | ~180 | ~400 | Similar complexity |
| **Type declarations** | Minimal | Explicit | Mojo requires types everywhere |
| **String formatting** | `f"{x:8.2f}"` | Custom function | Mojo lacks format strings |
| **Dependencies** | stdlib only | stdlib only | Both self-contained |
| **Performance** | Baseline | 1.4-4.3x faster | Verified benchmarks |

**Why is Mojo larger?**

1. **Missing string formatting**: Python's `f"{value:8.2f}"` became ~20 lines of manual formatting in Mojo
2. **Explicit type handling**: Every variable needs type declaration (`var data: List[Float64]`)
3. **Ownership semantics**: Must manage memory explicitly (`var`, `owned`, `borrowed`)
4. **No default arguments yet**: More function overloads needed
5. **Verbose struct initialisation**: `@fieldwise_init` boilerplate

## Key Mojo Limitations Encountered

### 1. String Formatting (Biggest Gap)

**Python:**
```python
label = f"{value:8.2f}  "  # One line
```

**Mojo:**
```mojo
fn _format_label(value: Float64) -> String:
    var int_part = Int(value)
    var frac_part = value - Float64(int_part)
    var frac_int = Int(frac_part * 100.0 + 0.5)
    var result = String(int_part) + "."
    if frac_int < 10:
        result += "0"
    result += String(frac_int)
    while len(result) < 8:
        result = " " + result
    return result + "  "
```

**Impact**: ~15-20 lines of manual formatting replaces Python's format strings. This will improve as Mojo's stdlib matures.

### 2. No List Comprehensions

**Python:**
```python
data = [x * x for x in range(10)]
```

**Mojo:**
```mojo
var data = List[Float64]()
for i in range(10):
    data.append(Float64(i * i))
```

Not a blocker, but more verbose.

### 3. Explicit Memory Management

**Python:** Automatic
**Mojo:** Must choose `var`, `let`, `owned`, `borrowed`, `inout`

This adds lines but provides control for performance optimisation.

## What Worked Brilliantly

### UTF-8 Support
Mojo handled box-drawing characters (`┼├┤╭╮╯╰│─`) perfectly—no special encoding needed. Better than C/C++!

### Python Interop Testing
Used Python's `asciichartpy` directly in tests to verify pixel-perfect compatibility. Six interop tests caught subtle rounding differences.

### Banker's Rounding
Python uses IEEE 754 round-half-to-even. Simple `floor(x + 0.5)` failed—had to implement proper banker's rounding for exact compatibility.

## Performance Results

Benchmarked on M1 Mac, Mojo 0.25.7.0:

| Data Points | Mojo | Python | Speedup |
|-------------|------|--------|---------|
| 10          | 7.4 µs | 31.8 µs | **4.3x** |
| 100         | 107 µs | 262 µs | **2.4x** |
| 1000        | 4.6 ms | 6.5 ms | **1.4x** |

Python measurements via Mojo interop (includes overhead).

## Development Velocity

- **Initial port**: 2 hours (core plotting)
- **Python compatibility**: 2.5 hours (formatting, rounding)
- **Testing**: 1.5 hours (29 tests total)
- **Colours & benchmarks**: 3 hours (v1.1.0 features)

**Total**: ~10 hours to production-ready library with colours and benchmarks.

## Lessons for Future Ports

1. **Expect 2-3x code size**: Missing stdlib features require manual implementation
2. **Budget time for string handling**: Format strings are a significant gap
3. **Python interop is gold**: Use it for validation tests
4. **Visual testing matters**: Automated tests missed spacing issues
5. **Banker's rounding is real**: Match Python's IEEE 754 behaviour exactly

## What's Next (v1.2.0)

- Multi-series support (overlay multiple lines)
- Custom x-axis labels
- Performance optimisation (target < 1ms for 100 points)
- Legend rendering

## Conclusion

Porting Python to Mojo is practical today, despite missing features. The 2.4x code bloat is acceptable for the performance gains (1.4-4.3x), and as Mojo's stdlib matures, this gap will close.

The hardest part wasn't the algorithm—it was reimplementing Python's string formatting. Once that's in Mojo's stdlib, ports will be significantly easier.

**Would I do it again?** Absolutely. The performance improvements are real, and pixel-perfect compatibility proves Mojo is ready for production library work.

---

**Try it:**
```bash
git clone https://github.com/databooth/mojo-asciichart
cd mojo-asciichart
pixi install
pixi run example-ml-serving  # See ML latency monitoring example
```

**Project Links:**
- [GitHub](https://github.com/databooth/mojo-asciichart)
- [Original Python](https://pypi.org/project/asciichartpy/)
- [DataBooth](https://www.databooth.com.au/posts/mojo/)

**Licence**: Apache 2.0
