"""
Sine wave example demonstrating mojo-asciichart with smooth curves.
"""

from asciichart import plot, Config
from math import sin, pi

fn main() raises:
    print("=== mojo-asciichart Sine Wave Example ===\n")
    
    # Generate sine wave data
    var data = List[Float64]()
    for i in range(120):
        var value = 15.0 * sin(Float64(i) * ((pi * 4) / 120.0))
        data.append(value)
    
    print("Sine wave (120 points, amplitude=15):\n")
    print(plot(data))
    
    print("\n\n=== With configured height ===\n")
    var config = Config()
    config.height = 6
    print(plot(data, config))
    
    print("\n=== Example Complete ===")
