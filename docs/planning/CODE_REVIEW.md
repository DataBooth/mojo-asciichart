# Code Review: src/asciichart/__init__.mojo

## Executive Summary

The code is production-ready with excellent quality. Key strengths:
- ✅ Clear structure and documentation
- ✅ Pixel-perfect Python compatibility
- ✅ Proper error handling
- ✅ Good use of Mojo idioms

**Recommendation**: Minor refactoring opportunities for clarity and maintainability.

---

## Detailed Analysis

### 1. **Helper Functions: _min() and _max()**

**Current State**: Duplicate logic with only comparison operator differing

```mojo
fn _min(series: List[Float64]) raises -> Float64:
    var result: Optional[Float64] = None
    for i in range(len(series)):
        if _isnum(series[i]):
            if not result:
                result = series[i]
            elif series[i] < result.value():  # Only difference
                result = series[i]
    if not result:
        raise Error("No valid numbers in series")
    return result.value()
```

**Refactoring Opportunity**: Extract to single generic function

```mojo
fn _find_extreme(series: List[Float64], find_max: Bool) raises -> Float64:
    """Find min or max value in series, ignoring NaN."""
    var result: Optional[Float64] = None
    for i in range(len(series)):
        if _isnum(series[i]):
            if not result:
                result = series[i]
            else:
                var current = result.value()
                if find_max and series[i] > current:
                    result = series[i]
                elif not find_max and series[i] < current:
                    result = series[i]
    if not result:
        raise Error("No valid numbers in series")
    return result.value()

fn _min(series: List[Float64]) raises -> Float64:
    return _find_extreme(series, False)

fn _max(series: List[Float64]) raises -> Float64:
    return _find_extreme(series, True)
```

**Benefits**: 
- Reduces code duplication (DRY principle)
- Single point of maintenance for min/max logic
- **Trade-off**: Slightly more complex, but more maintainable

---

### 2. **Banker's Rounding: Extract to Separate Function**

**Current State**: Embedded in `scaled()` function (lines 219-239)

**Refactoring Opportunity**: Extract for reusability and testing

```mojo
fn _round_half_to_even(value: Float64) -> Int:
    """Implement banker's rounding (IEEE 754): round half to even.
    
    This matches Python's round() behavior where .5 values round to 
    the nearest even integer.
    
    Examples:
        12.5 -> 12 (round down to even)
        13.5 -> 14 (round up to even)
        20.5 -> 20 (round down to even)
        21.5 -> 22 (round up to even)
    """
    var floored = floor(value)
    var diff = value - floored
    
    if diff < 0.5:
        return Int(floored)
    elif diff > 0.5:
        return Int(floored) + 1
    else:
        # Exactly 0.5: round to even
        var floor_int = Int(floored)
        return floor_int if floor_int % 2 == 0 else floor_int + 1

fn scaled(y: Float64) -> Int:
    var scaled_val = clamp(y) * ratio
    return _round_half_to_even(scaled_val) - min2
```

**Benefits**:
- Can be unit tested independently
- Reusable in other contexts
- Clear documentation of IEEE 754 behavior
- Separates rounding logic from scaling logic

---

### 3. **Symbol Constants: Use Struct or Enum**

**Current State**: Dynamic list creation (lines 174-185)

```mojo
var symbols = List[String]()
symbols.append("┼")  # [0] zero-axis
symbols.append("┤")  # [1] tick
# ...
```

**Refactoring Opportunity**: Static struct for better type safety

```mojo
@value
struct Symbols:
    """Box-drawing characters for chart rendering."""
    alias ZERO_AXIS = "┼"
    alias TICK = "┤"
    alias GAP_START = "╶"
    alias GAP_END = "╴"
    alias HORIZONTAL = "─"
    alias CORNER_DOWN_RIGHT = "╰"
    alias CORNER_DOWN_LEFT = "╭"
    alias CORNER_UP_RIGHT = "╮"
    alias CORNER_UP_LEFT = "╯"
    alias VERTICAL = "│"
```

**Usage in plot()**:
```mojo
result[row_idx][offset - 1] = Symbols.TICK
result[rows - y0][x + offset] = Symbols.HORIZONTAL
```

**Benefits**:
- No runtime list allocation
- Better IDE autocomplete
- Named constants improve readability
- Type-safe symbol access
- **Trade-off**: More verbose, but clearer intent

---

### 4. **Validation Logic: Extract Function**

**Current State**: Scattered validation (lines 145-155, 161-172)

**Refactoring Opportunity**:

```mojo
fn _validate_series(series: List[Float64]) -> Bool:
    """Check if series has at least one valid (non-NaN) value."""
    for i in range(len(series)):
        if _isnum(series[i]):
            return True
    return False

fn _get_bounds(series: List[Float64], config: Config) raises -> (Float64, Float64):
    """Get min/max bounds from config or calculate from series."""
    var minimum = config.min_val.value() if config.min_val else _min(series)
    var maximum = config.max_val.value() if config.max_val else _max(series)
    
    if minimum > maximum:
        raise Error("The min value cannot exceed the max value.")
    
    return (minimum, maximum)
```

**Benefits**:
- Cleaner `plot()` function
- Testable validation logic
- Single responsibility principle

---

### 5. **Grid Creation: Extract to Function**

**Current State**: Inline grid initialization (lines 242-247)

**Refactoring Opportunity**:

```mojo
fn _create_grid(rows: Int, width: Int) -> List[List[String]]:
    """Create empty character grid for rendering."""
    var result = List[List[String]]()
    for _ in range(rows + 1):
        var row = List[String]()
        for _ in range(width):
            row.append(" ")
        result.append(row^)
    return result
```

**Benefits**:
- Clearer intent in main `plot()` function
- Could be optimized separately
- Easier to test edge cases

---

### 6. **Label Rendering: Extract Loop**

**Current State**: Lines 249-274 handle axis drawing

**Refactoring Opportunity**:

```mojo
fn _draw_axis_and_labels(
    result: List[List[String]],
    min2: Int,
    max2: Int,
    offset: Int,
    rows: Int,
    maximum: Float64,
    interval: Float64,
    width: Int
) -> None:
    """Draw Y-axis labels and tick marks."""
    for y in range(min2, max2 + 1):
        var row_idx = y - min2
        var label_value = maximum - ((Float64(y - min2) * interval) / Float64(rows)) if rows > 0 else maximum
        var label = _format_label(label_value)
        
        # Place label
        for i in range(len(label)):
            if i < width:
                result[row_idx][i] = String(label[i])
        
        # Place tick
        result[row_idx][offset - 1] = Symbols.ZERO_AXIS if y == 0 else Symbols.TICK
```

---

### 7. **Plot Line Logic: Extract Function**

**Current State**: Lines 282-321 handle line rendering

**Refactoring Opportunity**:

```mojo
fn _plot_line_segment(
    result: List[List[String]],
    x: Int,
    y0: Int, 
    y1: Int,
    rows: Int,
    offset: Int
) -> None:
    """Plot a single line segment between two points."""
    if y0 == y1:
        result[rows - y0][x + offset] = Symbols.HORIZONTAL
        return
    
    # Draw corners
    if y0 > y1:  # Ascending
        result[rows - y1][x + offset] = Symbols.CORNER_DOWN_RIGHT
        result[rows - y0][x + offset] = Symbols.CORNER_UP_RIGHT
    else:  # Descending
        result[rows - y1][x + offset] = Symbols.CORNER_DOWN_LEFT
        result[rows - y0][x + offset] = Symbols.CORNER_UP_LEFT
    
    # Fill vertical connector
    for y in range(min(y0, y1) + 1, max(y0, y1)):
        result[rows - y][x + offset] = Symbols.VERTICAL
```

---

## Generalization Opportunities

### 1. **Support Multiple Series** (Future Enhancement)

Current API is single-series only. Consider:

```mojo
fn plot(series: List[List[Float64]]) raises -> String:
    """Plot multiple data series on same chart."""
    # Could overlay multiple lines with different symbols/colors
```

### 2. **Pluggable Symbol Sets**

Allow custom symbols for different chart styles:

```mojo
struct Config:
    var symbols: Optional[Symbols]  # Custom symbol set
```

### 3. **Formatter Functions**

Make label formatting configurable:

```mojo
alias LabelFormatter = fn(Float64) -> String

struct Config:
    var label_formatter: Optional[LabelFormatter]
```

---

## Priority Recommendations

### High Priority (Do Now)
1. ✅ **Extract banker's rounding** - Improves testability
2. ✅ **Use Symbols struct** - Better type safety and readability

### Medium Priority (Consider)
3. **Extract _find_extreme()** - Reduces duplication
4. **Extract validation functions** - Cleaner plot() function

### Low Priority (Future)
5. **Extract rendering functions** - Only if adding more features
6. **Support multiple series** - Separate v1.1.0 feature

---

## Testing Recommendations

If refactoring is applied:

1. Add unit tests for `_round_half_to_even()`:
   - Test 0.5, 1.5, 2.5, etc.
   - Test negative values
   - Test edge cases

2. Add tests for `_find_extreme()`:
   - All NaN
   - Mixed NaN and valid
   - Single value

3. Ensure all existing tests pass after refactoring

---

## Conclusion

The code is **production-ready as-is**. Suggested refactorings are:
- **Optional**: Won't impact functionality
- **Beneficial**: Improve maintainability and testability
- **Safe**: Can be done incrementally with test coverage

**Recommendation**: Apply High Priority refactorings (#1, #2) now, defer others until adding new features.
