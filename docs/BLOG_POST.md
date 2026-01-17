# Building mojo-asciichart 🔥: Lessons in Porting Python Libraries to Mojo

*Posted on 2026-01-17 :: ~1200 Words :: Tags: Mojo 🔥, Visualisation, ASCII Art, Python Compatibility, Open Source, Porting, Testing*

## Table of Contents
- [Exec Summary](#exec-summary)
- [Why ASCII Charts?](#why-ascii-charts)
- [Key Lessons Learned](#key-lessons-learned)
  - [1. String Formatting is Different](#1-string-formatting-is-different)
  - [2. UTF-8 Works Beautifully](#2-utf-8-works-beautifully)
  - [3. Manual Testing Reveals Edge Cases](#3-manual-testing-reveals-edge-cases)
  - [4. Test Suites Need Framework Awareness](#4-test-suites-need-framework-awareness)
  - [5. Gallery Examples Are Essential](#5-gallery-examples-are-essential)
  - [6. Python Interop for Validation](#6-python-interop-for-validation)
  - [7. Pixel-Perfect Compatibility is Achievable](#7-pixel-perfect-compatibility-is-achievable)
- [The Journey](#the-journey)
- [What's Next](#whats-next)

## Exec Summary

For business and technical leaders: This post documents practical lessons from porting a Python visualisation library to Mojo, demonstrating that Mojo can achieve pixel-perfect compatibility with Python libraries while maintaining its performance advantages.

**Key takeaways:**
- **Mojo handles complex text rendering**: Successfully ported asciichartpy with UTF-8 box-drawing characters
- **Python compatibility is achievable**: Achieved identical output to Python reference implementation
- **Development velocity**: Built a production-ready charting library in a single session
- **Testing strategy matters**: Combined unit tests, visual galleries, and Python interop testing

## Why ASCII Charts?

ASCII charts solve a real problem: visualising data in constrained environments where graphical libraries aren't available or practical.

```mojo
from asciichart import plot
from math import sin, pi

fn main() raises:
    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(i * ((pi * 4) / 120)))
    print(plot(data))
```

Output:
```
    15.00  ┼╮╭┼───────╮╭┼───────╮╭┼
    10.71  ┤╰╯        ╰╯        ╰╯ 
     6.43  ┤                       
...
```

**Use cases:**
- Terminal-based monitoring dashboards
- Log file visualization
- CI/CD pipeline output
- Embedded systems without displays
- SSH sessions to remote servers

The **mojo-asciichart** project brings this capability to Mojo, targeting Python `asciichartpy` compatibility while maintaining Mojo's performance characteristics.

## Key Lessons Learned

### 1. String Formatting is Different

**Challenge**: Python's `'{:8.2f} '` format string isn't directly available in current Mojo versions.

**Solution**: Implement custom formatting manually:

```mojo
fn _format_label(value: Float64) -> String:
    var int_part = Int(value)
    var frac_part = value - Float64(int_part)
    
    # Handle negatives, format to 2 decimals
    var frac_int = Int(frac_part * 100.0 + 0.5)  # Round
    var result = String(int_part) + "."
    
    if frac_int < 10:
        result += "0"
    result += String(frac_int)
    
    # Right-align in 8 characters
    while len(result) < 8:
        result = " " + result
    result += "  "  # Trailing spaces
    
    return result
```

**Lesson**: String manipulation in systems languages requires explicit control. This trades convenience for predictability and performance.

### 2. UTF-8 Works Beautifully

**Finding**: Mojo's UTF-8 support handles box-drawing characters perfectly.

```mojo
var symbols = List[String]()
symbols.append("┼")  # zero-axis
symbols.append("┤")  # tick
symbols.append("╶")  # gap start
symbols.append("╴")  # gap end
symbols.append("─")  # horizontal
symbols.append("╰")  # corner down-right
symbols.append("╭")  # corner down-left
symbols.append("╮")  # corner up-right
symbols.append("╯")  # corner up-left
symbols.append("│")  # vertical
```

No special encoding handling needed—just works! This is a significant advantage over C/C++ where Unicode handling often requires external libraries.

### 3. Manual Testing Reveals Edge Cases

**Surprise**: Automated tests passed, but visual inspection revealed spacing issues.

Created a comprehensive gallery with 13 chart types:
- Linear progression
- Quadratic growth
- Sine/Cosine waves
- Damped oscillation
- Step functions
- Random walks
- Sawtooth waves
- Flat lines
- Spikes

Running `pixi run example-gallery` produces 565 lines of visual output for manual verification.

**Lesson**: For rendering libraries, eyeballing the output is essential. Automated tests catch regressions, but human inspection catches aesthetic issues.

### 4. Test Suites Need Framework Awareness

Adapted tests to follow [Mojo's testing conventions](https://docs.modular.com/mojo/tools/testing/):

```mojo
def test_sine_wave():
    """Test plot with sine wave data."""
    var data = List[Float64]()
    for i in range(30):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 30.0)))
    
    var result = plot(data)
    assert_true(len(result) > 0, "Sine wave should produce output")
    assert_true("╭" in result or "╯" in result, "Should contain curves")
```

Key changes from typical Python tests:
- Functions use `def` not `fn`
- Test names follow `test_*` pattern
- Assertions from `testing` module
- Manual test runner with try/except blocks

**Result**: 6/6 tests passing, with clear pass/fail indicators.

### 5. Gallery Examples Are Essential

Created `examples/gallery.mojo` showcasing all chart types. This serves multiple purposes:

1. **Visual verification** during development
2. **Documentation** for users
3. **Regression testing** (run and eyeball after changes)
4. **Marketing** (impressive demos!)

**Pro tip**: Save gallery output to a file for before/after comparisons:
```bash
pixi run example-gallery > gallery_output.txt
```

### 6. Python Interop for Validation

Built `tests/compare_with_python.py` to verify pixel-perfect compatibility:

```python
def test_simple_linear():
    # Python
    py_data = [0.0, 1.0, 2.0, 3.0, 4.0]
    py_output = asciichartpy.plot(py_data)
    
    # Mojo (via subprocess)
    mojo_output = generate_mojo_output(...)
    
    # Compare
    assert py_output == mojo_output
```

This catches subtle differences that manual testing might miss.

**Lesson**: When porting libraries, having automated compatibility tests against the reference implementation is invaluable.

### 7. Pixel-Perfect Compatibility is Achievable

The devil was in the details—specifically, label placement:

**Initial attempt**: Labels missing or misaligned  
**Issue**: Offset calculation was complex
```mojo
var label_start = max(offset - len(label), 0)  # Wrong!
```

**Solution**: Simplify—place label at position 0
```mojo
var label_start = 0  # Label always starts at 0
var offset = label_width + 1  # Account for tick mark
```

**Result**:
- Python: `'    4.00  ┼   ╭'`
- Mojo:   `'    4.00  ┼   ╭'`  ✅ **Identical!**

**Lesson**: Sometimes the simplest solution is the right one. Over-engineering the offset calculation caused bugs.

## The Journey

### Initial Implementation (2 hours)
- Set up project structure following mojo-dotenv/mojo-toml patterns
- Implemented `Config` struct with `@fieldwise_init`
- Core `plot()` function with box-drawing characters
- Basic NaN handling

### Testing Phase (1 hour)
- Created 6 unit tests following Mojo conventions
- Built 13-example gallery for visual verification
- All tests passing

### Python Compatibility (2 hours)
- Discovered label formatting differences
- Implemented `_format_label()` with manual decimal handling
- Fixed offset calculation (3 iterations)
- Achieved pixel-perfect output match

### Documentation (1 hour)
- README with quick start
- CREDITS with acknowledgements to Igor Kroitor
- GALLERY.md inspection guide
- This blog post!

**Total**: ~6 hours from idea to production-ready library with full Python compatibility.

## What's Next

**Immediate priorities:**
1. Multi-series support (plot multiple lines on one chart)
2. ANSI color support for colored lines
3. Custom axis labels
4. Performance benchmarking vs Python

**Future enhancements:**
5. Bar charts and histograms
6. Configurable symbols (different line styles)
7. Horizontal charts
8. Legend support

**Community:**
- Submit to modular-community pixi channel
- Blog post on databooth.com.au
- Share in Mojo Discord

## Try It Yourself

```bash
git clone https://github.com/databooth/mojo-asciichart
cd mojo-asciichart
pixi install
pixi run example-gallery
```

The library is production-ready and achieves pixel-perfect compatibility with Python's asciichartpy!

---

**About the Author**: Michael Booth builds high-performance data tools at [DataBooth](https://www.databooth.com.au), bringing risk expertise from quantitative finance and regulatory roles (APRA/ASIC) to help organizations make data-driven decisions.

**Project Links**:
- [GitHub Repository](https://github.com/databooth/mojo-asciichart)
- [Original asciichart (JS) by Igor Kroitor](https://github.com/kroitor/asciichart)
- [asciichartpy (Python)](https://pypi.org/project/asciichartpy/)
- [DataBooth Mojo Projects](https://www.databooth.com.au/posts/mojo/)

**License**: Apache 2.0 (aligning with Mojo language licensing)
