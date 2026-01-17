"""
mojo-asciichart: Nice-looking lightweight console ASCII line charts for Mojo

A native Mojo port of asciichartpy (Python) and asciichart (JavaScript) by Igor Kroitor.

Example:
    ```mojo
    from asciichart import plot
    from math import sin, pi
    
    fn main() raises:
        var data = List[Float64]()
        for i in range(120):
            data.append(15.0 * sin(i * ((pi * 4) / 120)))
        print(plot(data))
    ```

License:
    Apache 2.0 - See LICENSE file for details
    
Acknowledgements:
    - Igor Kroitor: Original asciichart (JS) and asciichartpy (Python)
    - See CREDITS.md for detailed acknowledgements
"""

from math import floor, ceil, isnan


@fieldwise_init
struct Symbols(Copyable, Movable):
    """Box-drawing characters for chart rendering."""
    var ZERO_AXIS: String
    var TICK: String
    var GAP_START: String
    var GAP_END: String
    var HORIZONTAL: String
    var CORNER_DOWN_RIGHT: String
    var CORNER_DOWN_LEFT: String
    var CORNER_UP_RIGHT: String
    var CORNER_UP_LEFT: String
    var VERTICAL: String
    
    fn __init__(out self):
        """Create default box-drawing symbols."""
        self.ZERO_AXIS = "┼"
        self.TICK = "┤"
        self.GAP_START = "╶"
        self.GAP_END = "╴"
        self.HORIZONTAL = "─"
        self.CORNER_DOWN_RIGHT = "╰"
        self.CORNER_DOWN_LEFT = "╭"
        self.CORNER_UP_RIGHT = "╮"
        self.CORNER_UP_LEFT = "╯"
        self.VERTICAL = "│"


@fieldwise_init
struct Config(Copyable, Movable):
    """Configuration options for ASCII chart generation."""
    var height: Optional[Int]
    var min_val: Optional[Float64]
    var max_val: Optional[Float64]
    var offset: Int
    var format_str: String
    
    fn __init__(out self):
        """Create default configuration."""
        self.height = None
        self.min_val = None
        self.max_val = None
        self.offset = 3
        self.format_str = "{:8.2f} "


fn _isnum(n: Float64) -> Bool:
    """Check if value is a valid number (not NaN)."""
    return not isnan(n)


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


fn _find_extreme(series: List[Float64], find_max: Bool) raises -> Float64:
    """Find min or max value in series, ignoring NaN.
    
    Args:
        series: List of Float64 values
        find_max: If True, find maximum; if False, find minimum
    
    Returns:
        The minimum or maximum value
    
    Raises:
        Error if no valid numbers found in series
    """
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
    """Find minimum value in series, ignoring NaN."""
    return _find_extreme(series, False)


fn _max(series: List[Float64]) raises -> Float64:
    """Find maximum value in series, ignoring NaN."""
    return _find_extreme(series, True)


fn _validate_series(series: List[Float64]) -> Bool:
    """Check if series has at least one valid (non-NaN) value."""
    for i in range(len(series)):
        if _isnum(series[i]):
            return True
    return False


struct Bounds:
    """Min/max bounds for chart data."""
    var minimum: Float64
    var maximum: Float64
    
    fn __init__(out self, minimum: Float64, maximum: Float64):
        self.minimum = minimum
        self.maximum = maximum


fn _get_bounds(series: List[Float64], config: Config) raises -> Bounds:
    """Get min/max bounds from config or calculate from series.
    
    Args:
        series: List of Float64 values
        config: Configuration with optional min/max overrides
    
    Returns:
        Bounds with minimum and maximum values
    
    Raises:
        Error if minimum exceeds maximum
    """
    var minimum = config.min_val.value() if config.min_val else _min(series)
    var maximum = config.max_val.value() if config.max_val else _max(series)
    
    if minimum > maximum:
        raise Error("The min value cannot exceed the max value.")
    
    return Bounds(minimum, maximum)


fn _format_label(value: Float64) -> String:
    """Format label to match Python's '{:8.2f} ' format.
    
    Returns a string with 2 decimal places, right-aligned in 8 characters,
    plus a trailing space (total 9 chars).
    """
    # Convert to string with 2 decimal places
    var int_part = Int(value)
    var frac_part = value - Float64(int_part)
    
    # Handle negative values
    var is_negative = value < 0
    if is_negative:
        int_part = -int_part
        frac_part = -frac_part
    
    # Get fractional part as integer (multiply by 100)
    var frac_int = Int(frac_part * 100.0 + 0.5)  # Round
    
    # Build the string: "X.YZ"
    var result = String(int_part) + "."
    
    # Pad fractional part to 2 digits
    if frac_int < 10:
        result += "0"
    result += String(frac_int)
    
    # Add negative sign if needed
    if is_negative:
        result = "-" + result
    
    # Right-align in 8 characters
    while len(result) < 8:
        result = " " + result
    
    # Add trailing spaces (2 spaces to match Python's format)
    result += "  "
    
    return result


fn _create_grid(rows: Int, width: Int) -> List[List[String]]:
    """Create empty character grid for rendering.
    
    Args:
        rows: Number of rows in the grid
        width: Number of columns in the grid
    
    Returns:
        2D grid filled with spaces
    """
    var result = List[List[String]]()
    for _ in range(rows + 1):
        var row = List[String]()
        for _ in range(width):
            row.append(" ")
        result.append(row^)
    return result^


fn _draw_axis_and_labels(
    mut result: List[List[String]],
    min2: Int,
    max2: Int,
    offset: Int,
    rows: Int,
    maximum: Float64,
    interval: Float64,
    width: Int,
    symbols: Symbols
) -> None:
    """Draw Y-axis labels and tick marks.
    
    Args:
        result: Grid to draw into (modified in-place)
        min2: Scaled minimum value
        max2: Scaled maximum value
        offset: Left margin offset
        rows: Number of rows
        maximum: Maximum data value
        interval: Data range (max - min)
        width: Grid width
        symbols: Symbol set for rendering
    """
    for y in range(min2, max2 + 1):
        var row_idx = y - min2
        var label_value = maximum - ((Float64(y - min2) * interval) / Float64(rows)) if rows > 0 else maximum
        var label = _format_label(label_value)
        
        # Place label
        for i in range(len(label)):
            if i < width:
                result[row_idx][i] = String(label[i])
        
        # Place tick
        result[row_idx][offset - 1] = symbols.ZERO_AXIS if y == 0 else symbols.TICK


fn _plot_line_segment(
    mut result: List[List[String]],
    x: Int,
    y0: Int,
    y1: Int,
    rows: Int,
    offset: Int,
    symbols: Symbols
) -> None:
    """Plot a single line segment between two points.
    
    Args:
        result: Grid to draw into (modified in-place)
        x: X coordinate
        y0: Scaled Y coordinate of first point
        y1: Scaled Y coordinate of second point
        rows: Number of rows
        offset: Left margin offset
        symbols: Symbol set for rendering
    """
    if y0 == y1:
        result[rows - y0][x + offset] = symbols.HORIZONTAL
        return
    
    # Draw corners
    if y0 > y1:  # Ascending
        result[rows - y1][x + offset] = symbols.CORNER_DOWN_RIGHT
        result[rows - y0][x + offset] = symbols.CORNER_UP_RIGHT
    else:  # Descending
        result[rows - y1][x + offset] = symbols.CORNER_DOWN_LEFT
        result[rows - y0][x + offset] = symbols.CORNER_UP_LEFT
    
    # Fill vertical connector
    for y in range(min(y0, y1) + 1, max(y0, y1)):
        result[rows - y][x + offset] = symbols.VERTICAL


fn plot(series: List[Float64]) raises -> String:
    """Generate an ASCII line chart with default configuration."""
    return plot(series, Config())


fn plot(series: List[Float64], config: Config) raises -> String:
    """
    Generate an ASCII line chart from a list of Float64 values.
    
    Args:
        series: List of Float64 values to plot
        cfg: Optional configuration for chart appearance
    
    Returns:
        String containing the ASCII chart
    
    Example:
        ```mojo
        var data = List[Float64]()
        for i in range(10):
            data.append(Float64(i))
        print(plot(data))
        ```
    """
    # Handle empty series or all-NaN series
    if len(series) == 0 or not _validate_series(series):
        return ""
    
    # Get min/max bounds
    var bounds = _get_bounds(series, config)
    var minimum = bounds.minimum
    var maximum = bounds.maximum
    
    # Create symbols for rendering
    var symbols = Symbols()
    
    # Calculate dimensions
    var interval = maximum - minimum
    # Offset needs to accommodate the label width (10 chars: 8 for number + 2 spaces)
    # plus 1 for the tick mark itself
    var label_width = 10  # Length of formatted label with 2 trailing spaces  
    var offset = max(config.offset, label_width + 1)  # Label (0-9) + tick (10) + data starts at 11
    var height: Float64
    if config.height:
        height = Float64(config.height.value())
    else:
        height = interval
    
    var ratio: Float64
    if interval > 0:
        ratio = height / interval
    else:
        ratio = 1.0
    
    var min2 = Int(floor(minimum * ratio))
    var max2 = Int(ceil(maximum * ratio))
    var rows = max2 - min2
    var width = len(series) + offset
    
    # Helper functions for scaling
    fn clamp(n: Float64) -> Float64:
        if n < minimum:
            return minimum
        elif n > maximum:
            return maximum
        else:
            return n
    
    fn scaled(y: Float64) -> Int:
        var scaled_val = clamp(y) * ratio
        return _round_half_to_even(scaled_val) - min2
    
    # Create result grid
    var result = _create_grid(rows, width)
    
    # Draw axis and labels
    _draw_axis_and_labels(result, min2, max2, offset, rows, maximum, interval, width, symbols)
    
    # Plot first value
    var d0 = series[0]
    if _isnum(d0):
        result[rows - scaled(d0)][offset - 1] = symbols.ZERO_AXIS
    
    # Plot the line
    for x in range(len(series) - 1):
        var v0 = series[x]
        var v1 = series[x + 1]
        
        # Handle NaN cases
        if isnan(v0) and isnan(v1):
            continue
        
        if isnan(v0) and _isnum(v1):
            result[rows - scaled(v1)][x + offset] = symbols.GAP_START
            continue
        
        if _isnum(v0) and isnan(v1):
            result[rows - scaled(v0)][x + offset] = symbols.GAP_END
            continue
        
        # Both values are valid numbers - use helper function
        var y0 = scaled(v0)
        var y1 = scaled(v1)
        _plot_line_segment(result, x, y0, y1, rows, offset, symbols)
    
    # Join result into string
    var output = String("")
    for i in range(len(result)):
        var line = String("")
        for j in range(len(result[i])):
            line += result[i][j]
        # Right-strip the line
        var stripped = line.rstrip()
        output += stripped
        if i < len(result) - 1:
            output += "\n"
    
    return output
