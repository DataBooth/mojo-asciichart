"""
Gallery of ASCII chart examples demonstrating mojo-asciichart capabilities.

This file showcases various chart types and configurations for visual verification.
"""

from asciichart import plot, Config
from math import sin, cos, pi, sqrt

fn print_separator():
    print("\n" + "=" * 80 + "\n")


fn example_linear() raises:
    """Simple linear progression."""
    print("LINEAR PROGRESSION (y = x)")
    print("Simple ascending line\n")

    var data = List[Float64]()
    for i in range(20):
        data.append(Float64(i))

    print(plot(data))


fn example_quadratic() raises:
    """Quadratic growth."""
    print("QUADRATIC GROWTH (y = x²)")
    print("Accelerating curve\n")

    var data = List[Float64]()
    for i in range(15):
        data.append(Float64(i * i))

    print(plot(data))


fn example_sine_wave() raises:
    """Smooth sine wave matching original asciichart README."""
    print("SINE WAVE (matching original asciichart README example)")
    print("120 points, 4 complete cycles: 15 * sin(i * π * 4 / 120)\n")

    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(Float64(i) * ((pi * 4.0) / 120.0)))

    print(plot(data))


fn example_cosine_wave() raises:
    """Cosine wave matching README height rescaling example."""
    print("COSINE WAVE WITH HEIGHT RESCALING")
    print("120 points, rescaled to height=6: 15 * cos(i * π * 8 / 120)\n")

    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * cos(Float64(i) * ((pi * 8.0) / 120.0)))

    var config = Config()
    config.height = 6
    print(plot(data, config))


fn example_damped_oscillation() raises:
    """Decaying oscillation."""
    print("DAMPED OSCILLATION")
    print("Sine wave with exponential decay\n")

    var data = List[Float64]()
    for i in range(80):
        var t = Float64(i) / 10.0
        var amplitude = 15.0 * (1.0 / (1.0 + t * 0.3))
        data.append(amplitude * sin(t * 2.0))

    print(plot(data))


fn example_step_function() raises:
    """Step function."""
    print("STEP FUNCTION")
    print("Discrete jumps between levels\n")

    var data = List[Float64]()
    for i in range(60):
        var step = Float64(i / 10)
        data.append(step * 5.0)

    print(plot(data))


fn example_random_walk() raises:
    """Simulated random walk."""
    print("RANDOM WALK (simulated)")
    print("Cumulative random steps\n")

    var data = List[Float64]()
    var value = 50.0
    data.append(value)

    # Pseudo-random walk using simple hash-like function
    for i in range(1, 60):
        var random_val = Float64((i * 1103515245 + 12345) % 100) / 100.0
        var step = (random_val - 0.5) * 5.0
        value += step
        data.append(value)

    print(plot(data))


fn example_sawtooth() raises:
    """Sawtooth wave."""
    print("SAWTOOTH WAVE")
    print("Linear rise with sudden drops\n")

    var data = List[Float64]()
    for i in range(60):
        var phase = Float64(i % 15)
        data.append(phase * 2.0)

    print(plot(data))


fn example_square_root() raises:
    """Square root function."""
    print("SQUARE ROOT (y = √x)")
    print("Decelerating growth\n")

    var data = List[Float64]()
    for i in range(30):
        data.append(sqrt(Float64(i)) * 5.0)

    print(plot(data))


fn example_with_config() raises:
    """Same data with different heights."""
    print("SINE WAVE WITH DIFFERENT HEIGHTS")
    print("Demonstrating Config height parameter\n")

    var data = List[Float64]()
    for i in range(60):
        data.append(15.0 * sin(Float64(i) * ((2.0 * pi) / 60.0)))

    print("Default height (auto):")
    print(plot(data))

    print("\n\nCompressed height=8:")
    var config = Config()
    config.height = 8
    print(plot(data, config))

    print("\n\nVery compressed height=4:")
    var config2 = Config()
    config2.height = 4
    print(plot(data, config2))


fn example_flat_line() raises:
    """Constant value."""
    print("FLAT LINE (constant value)")
    print("All values equal\n")

    var data = List[Float64]()
    for i in range(40):
        data.append(10.0)

    print(plot(data))


fn example_spike() raises:
    """Sharp spike."""
    print("SPIKE")
    print("Sharp peak in data\n")

    var data = List[Float64]()
    for i in range(40):
        if i == 20:
            data.append(50.0)
        else:
            data.append(5.0)

    print(plot(data))


fn main() raises:
    print("\n" + "=" * 80)
    print("MOJO-ASCIICHART GALLERY".center(80))
    print("Visual verification of chart rendering".center(80))
    print("=" * 80 + "\n")

    example_linear()
    print_separator()

    example_quadratic()
    print_separator()

    example_sine_wave()
    print_separator()

    example_cosine_wave()
    print_separator()

    example_damped_oscillation()
    print_separator()

    example_step_function()
    print_separator()

    example_random_walk()
    print_separator()

    example_sawtooth()
    print_separator()

    example_square_root()
    print_separator()

    example_flat_line()
    print_separator()

    example_spike()
    print_separator()

    example_with_config()

    print("\n" + "=" * 80)
    print("END OF GALLERY".center(80))
    print("=" * 80 + "\n")
