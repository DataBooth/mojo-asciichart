"""
Color schemes demonstration - Shows all available color themes.

Demonstrates the ANSI color support using Mojo stdlib's utils._ansi.Color.
"""

from asciichart import plot, Config, ChartColors
from math import sin, pi

fn main() raises:
    print("\n🎨 MOJO-ASCIICHART COLOR SCHEMES 🎨\n")
    
    # Create sample sine wave data
    var data = List[Float64]()
    for i in range(60):
        data.append(10.0 * sin(Float64(i) * ((2.0 * pi) / 60.0)))
    
    # Default (no colors)
    print("DEFAULT (no colors):")
    var config1 = Config()
    config1.height = 8
    print(plot(data, config1))
    
    print("\n" + "─" * 60 + "\n")
    
    # Blue theme
    print("BLUE THEME:")
    var config2 = Config()
    config2.height = 8
    config2.colors = ChartColors.blue()
    print(plot(data, config2))
    
    print("\n" + "─" * 60 + "\n")
    
    # Matrix/terminal theme
    print("MATRIX THEME (green terminal):")
    var config3 = Config()
    config3.height = 8
    config3.colors = ChartColors.matrix()
    print(plot(data, config3))
    
    print("\n" + "─" * 60 + "\n")
    
    # Fire theme
    print("FIRE THEME (red/yellow):")
    var config4 = Config()
    config4.height = 8
    config4.colors = ChartColors.fire()
    print(plot(data, config4))
    
    print("\n" + "─" * 60 + "\n")
    
    # Ocean theme
    print("OCEAN THEME (cyan/blue):")
    var config5 = Config()
    config5.height = 8
    config5.colors = ChartColors.ocean()
    print(plot(data, config5))
    
    print("\n" + "─" * 60 + "\n")
    
    # Rainbow theme
    print("RAINBOW THEME (multicolor):")
    var config6 = Config()
    config6.height = 8
    config6.colors = ChartColors.rainbow()
    print(plot(data, config6))
    
    print("\n" + "─" * 60 + "\n")
    
    print("\n✨ All color schemes use Mojo stdlib's utils._ansi.Color ✨\n")
