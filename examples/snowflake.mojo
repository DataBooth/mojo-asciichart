"""
Snowflake plot - Creates a symmetric crystalline pattern.

Demonstrates creating visually interesting patterns using mathematical
functions to approximate the hexagonal symmetry of snowflakes.
"""

from asciichart import plot, Config, ChartColors
from math import sin, cos, pi

fn main() raises:
    print("\n❄️  SNOWFLAKE PATTERN ❄️\n")
    
    # Create snowflake-like pattern with 6-fold symmetry
    var data = List[Float64]()
    
    var points = 120
    var cycles = 6  # Hexagonal symmetry
    
    for i in range(points):
        var t = Float64(i) / Float64(points)
        var angle = t * 2.0 * pi * Float64(cycles)
        
        # Main oscillation with modulation
        var main_wave = sin(angle)
        
        # Add harmonics for complexity
        var harmonic1 = 0.3 * sin(angle * 2.0)
        var harmonic2 = 0.15 * sin(angle * 3.0)
        
        # Envelope to create crystal edges
        var envelope = 1.0 - abs(2.0 * t - 1.0)  # Triangle wave
        
        var value = 10.0 * (main_wave + harmonic1 + harmonic2) * envelope
        data.append(value)
    
    var config = Config()
    config.height = 15
    config.colors = ChartColors.fire()  # Cyan/blue for icy crystals
    print(plot(data, config))
    
    print("\n❄️  'No two snowflakes are alike' ❄️\n")
    
    # Second pattern: More geometric
    print("\n❄️  GEOMETRIC CRYSTAL ❄️\n")
    
    var data2 = List[Float64]()
    for i in range(90):
        var t = Float64(i) / 90.0
        var angle = t * 2.0 * pi * 3.0  # 3-fold pattern
        
        # Square wave approximation for sharp edges
        var value: Float64
        var sine_val = sin(angle)
        if sine_val > 0.5:
            value = 8.0
        elif sine_val < -0.5:
            value = -8.0
        else:
            value = 0.0
        
        # Add modulation
        value *= (1.0 - 0.3 * abs(2.0 * t - 1.0))
        data2.append(value)
    
    var config2 = Config()
    config2.height = 12
    config2.colors = ChartColors.blue()  # Blue geometric pattern
    print(plot(data2, config2))
    
    print("\n❄️  Crystalline mathematics ❄️\n")
