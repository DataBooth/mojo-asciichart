# Gallery Visual Inspection Guide

The gallery example (`examples/gallery.mojo`) provides comprehensive visual verification of mojo-asciichart rendering.

## Running the Gallery

```bash
pixi run example-gallery
```

Or save to a file for easier inspection:

```bash
pixi run example-gallery > gallery_output.txt
```

## Chart Types Included

### 1. **Linear Progression** (y = x)
- **What to check:** Smooth diagonal line from bottom-left to top-right
- **Expected:** Uses ╭ and ╯ corner characters, ╰ and ╮ for direction changes

### 2. **Quadratic Growth** (y = x²)
- **What to check:** Accelerating curve that gets steeper
- **Expected:** Mostly vertical (│) lines on the right side, corners on the left

### 3. **Sine Wave**
- **What to check:** Smooth oscillating wave
- **Expected:** Symmetrical peaks and troughs, smooth curves using corner characters

### 4. **Cosine Wave**
- **What to check:** Phase-shifted sine (starts at peak)
- **Expected:** Similar to sine but starting high instead of middle

### 5. **Damped Oscillation**
- **What to check:** Oscillation that decays over time
- **Expected:** Amplitude decreases from left to right, waves get smaller

### 6. **Step Function**
- **What to check:** Discrete jumps between levels
- **Expected:** Horizontal lines (─) with sudden vertical jumps

### 7. **Random Walk**
- **What to check:** Irregular wandering path
- **Expected:** Mix of ascending/descending segments, no clear pattern

### 8. **Sawtooth Wave**
- **What to check:** Repeating ramp pattern
- **Expected:** Diagonal rises followed by sharp drops

### 9. **Square Root** (y = √x)
- **What to check:** Curve that levels off
- **Expected:** Steep at left, gradually flattening to the right

### 10. **Flat Line**
- **What to check:** Completely horizontal line
- **Expected:** All horizontal dashes (─) on same row

### 11. **Spike**
- **What to check:** Sharp peak in otherwise flat data
- **Expected:** Tall vertical line in the middle with corners

### 12. **Config Demo** (Height Parameter)
- **What to check:** Same sine wave at different heights
- **Expected:** Three versions getting progressively more compressed

## What to Look For

### ✅ Good Signs
- **Smooth curves:** No jagged edges where curves should be smooth
- **Proper corners:** ╭ ╮ ╯ ╰ characters used at direction changes
- **Aligned characters:** Box-drawing characters line up properly
- **Readable labels:** Y-axis labels visible on the left (currently simplified)
- **Appropriate scaling:** Charts fill the vertical space reasonably

### ⚠️ Potential Issues to Check
- **Broken lines:** Gaps where lines should be continuous
- **Misaligned characters:** Box-drawing symbols don't connect properly
- **Incorrect corners:** Wrong corner character for the direction
- **Label overlap:** Labels colliding with chart lines
- **Extreme scaling:** Data compressed too much or spread too wide

## Comparing with Python

To verify compatibility with asciichartpy, you can compare specific examples:

```python
# Python
import asciichartpy
import math

data = [15 * math.sin(i * ((math.pi * 4) / 120)) for i in range(120)]
print(asciichartpy.plot(data))
```

```mojo
# Mojo (from examples/sine.mojo)
pixi run example-sine
```

The output should be visually identical (box-drawing characters may render differently based on terminal font).

## Known Limitations

Current version (v0.1.0):
- Y-axis labels are simplified (no decimal formatting yet)
- Only single series supported
- No colour support
- Labels may not align perfectly for very large/small numbers

These will be addressed in future versions.

## Quick Test

A minimal working test:

```mojo
from asciichart import plot

fn main() raises:
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i))
    print(plot(data))
```

Should produce a simple ascending diagonal line.
