"""
Snoopy plot - ASCII chart resembling Snoopy sleeping on his doghouse.

This is a classic ASCII art pattern that appears in many charting libraries.
The curve creates a shape similar to Snoopy lying on top of his doghouse.

Based on the traditional "Snoopy calendar" pattern popularised in the 1960s.
"""

from asciichart import plot
from math import sin, cos, pi, sqrt

fn main() raises:
    print("\n🐕 SNOOPY SLEEPING ON HIS DOGHOUSE 🐕\n")

    # Create Snoopy-shaped data
    # This approximates the classic shape using mathematical functions
    var data = List[Float64]()

    # Doghouse base (flat)
    for _ in range(15):
        data.append(2.0)

    # Doghouse roof (slight rise)
    for i in range(10):
        var t = Float64(i) / 10.0
        data.append(2.0 + t * 2.0)

    # Snoopy's body (curved back)
    for i in range(30):
        var t = Float64(i) / 30.0
        var curve = 4.0 + 6.0 * sin(pi * t)
        data.append(curve)

    # Snoopy's head/nose (bump)
    for i in range(15):
        var t = Float64(i) / 15.0
        var nose = 8.0 + 3.0 * sin(pi * t) - t * 2.0
        data.append(nose)

    # Tail end (drop off)
    for i in range(15):
        var t = Float64(i) / 15.0
        data.append(6.0 - t * 4.0)

    # Doghouse base continuation
    for _ in range(15):
        data.append(2.0)

    print(plot(data))

    print("\n💤 'Happiness is a warm puppy' - Charles M. Schulz\n")
