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


fn _min(series: List[Float64]) raises -> Float64:
    """Find minimum value in series, ignoring NaN."""
    var result: Optional[Float64] = None
    for i in range(len(series)):
        if _isnum(series[i]):
            if not result:
                result = series[i]
            elif series[i] < result.value():
                result = series[i]
    if not result:
        raise Error("No valid numbers in series")
    return result.value()


fn _max(series: List[Float64]) raises -> Float64:
    """Find maximum value in series, ignoring NaN."""
    var result: Optional[Float64] = None
    for i in range(len(series)):
        if _isnum(series[i]):
            if not result:
                result = series[i]
            elif series[i] > result.value():
                result = series[i]
    if not result:
        raise Error("No valid numbers in series")
    return result.value()


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
    # Handle empty series
    if len(series) == 0:
        return ""
    
    # Check if all values are NaN
    var has_valid = False
    for i in range(len(series)):
        if _isnum(series[i]):
            has_valid = True
            break
    if not has_valid:
        return ""
    
    # Calculate min/max
    var minimum: Float64
    var maximum: Float64
    
    if config.min_val:
        minimum = config.min_val.value()
    else:
        minimum = _min(series)
    
    if config.max_val:
        maximum = config.max_val.value()
    else:
        maximum = _max(series)
    
    if minimum > maximum:
        raise Error("The min value cannot exceed the max value.")
    
    # Box-drawing symbols
    var symbols = List[String]()
    symbols.append("┼")  # [0] zero-axis
    symbols.append("┤")  # [1] tick
    symbols.append("╶")  # [2] gap start
    symbols.append("╴")  # [3] gap end
    symbols.append("─")  # [4] horizontal
    symbols.append("╰")  # [5] corner down-right
    symbols.append("╭")  # [6] corner down-left
    symbols.append("╮")  # [7] corner up-right
    symbols.append("╯")  # [8] corner up-left
    symbols.append("│")  # [9] vertical
    
    # Calculate dimensions
    var interval = maximum - minimum
    # Offset needs to accommodate the label width (10 chars: 8 for number + 2 spaces)
    # Python uses offset=3 but that's just the default minimum, actual space needed is label width
    var label_width = 10  # Length of formatted label with 2 trailing spaces
    var offset = max(config.offset, label_width)  # Label + tick fits exactly
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
        # Round manually (add 0.5 and floor)
        if scaled_val >= 0:
            return Int(floor(scaled_val + 0.5)) - min2
        else:
            return Int(ceil(scaled_val - 0.5)) - min2
    
    # Create result grid
    var result = List[List[String]]()
    for _ in range(rows + 1):
        var row = List[String]()
        for _ in range(width):
            row.append(" ")
        result.append(row^)
    
    # Draw axis and labels
    for y in range(min2, max2 + 1):
        var row_idx = y - min2
        var label_value: Float64
        if rows > 0:
            label_value = maximum - ((Float64(y - min2) * interval) / Float64(rows))
        else:
            label_value = maximum
        
        # Format label to match Python: '{:8.2f} '
        # Format with 2 decimal places, right-aligned in 8 chars, plus trailing space
        var label = _format_label(label_value)
        
        # Place label - it should end right before the tick mark at offset-1
        # Label is 9 chars, so it starts at offset - 9 - 1 = offset - 10
        # But we want it to start at position 0 in Python's layout
        var label_start = offset - len(label) - 1
        for i in range(len(label)):
            if label_start + i >= 0 and label_start + i < width:
                result[row_idx][label_start + i] = String(label[i])
        
        # Place tick mark
        if y == 0:
            result[row_idx][offset - 1] = symbols[0]  # zero-axis
        else:
            result[row_idx][offset - 1] = symbols[1]  # tick
    
    # Plot first value
    var d0 = series[0]
    if _isnum(d0):
        result[rows - scaled(d0)][offset - 1] = symbols[0]
    
    # Plot the line
    for x in range(len(series) - 1):
        var v0 = series[x]
        var v1 = series[x + 1]
        
        # Handle NaN cases
        if isnan(v0) and isnan(v1):
            continue
        
        if isnan(v0) and _isnum(v1):
            result[rows - scaled(v1)][x + offset] = symbols[2]  # gap start
            continue
        
        if _isnum(v0) and isnan(v1):
            result[rows - scaled(v0)][x + offset] = symbols[3]  # gap end
            continue
        
        # Both values are valid numbers
        var y0 = scaled(v0)
        var y1 = scaled(v1)
        
        if y0 == y1:
            # Horizontal line
            result[rows - y0][x + offset] = symbols[4]
            continue
        
        # Diagonal line
        if y0 > y1:
            # Ascending (v1 is higher on screen)
            result[rows - y1][x + offset] = symbols[5]  # corner down-right
            result[rows - y0][x + offset] = symbols[7]  # corner up-right
        else:
            # Descending (v1 is lower on screen)
            result[rows - y1][x + offset] = symbols[6]  # corner down-left
            result[rows - y0][x + offset] = symbols[8]  # corner up-left
        
        # Fill vertical connector
        var start = min(y0, y1) + 1
        var end = max(y0, y1)
        for y in range(start, end):
            result[rows - y][x + offset] = symbols[9]  # vertical
    
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
