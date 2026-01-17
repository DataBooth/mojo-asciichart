"""
Simple example demonstrating mojo-asciichart usage.

This example will create a basic line chart when the plot() function is implemented.
"""

from asciichart import plot

fn main() raises:
    print("=== mojo-asciichart Simple Example ===\n")

    # Create simple linear data
    var data = List[Float64]()
    for i in range(10):
        data.append(Float64(i * i))

    print("\nChart:")
    print(plot(data))

    print("\n=== Example Complete ===")
