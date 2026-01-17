# Credits & Acknowledgements

## Inspiration & Prior Art

### asciichart (JavaScript)
- **Repository**: https://github.com/kroitor/asciichart
- **Author**: Igor Kroitor
- **Role**: Original implementation and concept

The original `asciichart` library was created by Igor Kroitor in JavaScript for NodeJS and browsers. <cite index="1-1">Console ASCII line charts in pure Javascript (for NodeJS and browsers) with no dependencies.</cite> This pioneering work established the foundation for ASCII line charting across multiple programming languages.

### asciichartpy (Python)
- **Repository**: https://github.com/kroitor/asciichart (asciichartpy subdirectory)
- **PyPI**: https://pypi.org/project/asciichartpy/
- **Author**: Igor Kroitor
- **Role**: Python port and reference implementation

`asciichartpy` is the Python port of the original JavaScript library, also maintained by Igor Kroitor. `mojo-asciichart` is designed to be API-compatible with `asciichartpy` where practical, following the same function signatures and behaviour. We use `asciichartpy` as our reference implementation for testing and validation.

**Why a Mojo port?** Mojo combines Python-like ergonomics with C++-level performance, making it ideal for high-performance data visualisation whilst maintaining a familiar API. This port aims to provide native Mojo support without Python dependencies, enabling use in performance-critical applications.

## Other Language Ports

The asciichart concept has been successfully ported to many languages, demonstrating its universal utility:

- **Haskell**: [madnight/asciichart](https://github.com/madnight/asciichart)
- **Rust**: [rasciigraph](https://github.com/orhanbalci/rasciigraph) by orhanbalci
- **C++**: Multiple implementations available
- **Go**: Various community implementations
- **PHP**: [PHP-colored-ascii-linechart](https://github.com/noximo/PHP-colored-ascii-linechart) by noximo
- **C#**: [asciichart-sharp](https://github.com/samcarton/asciichart-sharp) by samcarton
- **R**: [asciichartr](https://github.com/blmayer/asciichartr) by blmayer
- **Lua**: lua-asciichart by wuyudi
- **Deno**: [chart](https://github.com/maximousblk/chart) by maximousblk

## Contributors

### Core Development
- **Michael Booth** ([@mjboothaus](https://github.com/mjboothaus)) - Initial Mojo implementation, testing, documentation

### AI Assistance
- **Warp AI Agent** - Code generation, testing assistance, documentation

## Technology Stack

### Mojo
- **Modular Team** - For creating the Mojo programming language
- **Version**: 25.7+ (stable)
- **Website**: https://www.modular.com/mojo

### Development Tools
- **pixi** - Package and environment management
- **asciichartpy** - Testing reference implementation
- **Python** - Interop testing and validation

## Testing Approach

Our testing methodology validates compatibility with `asciichartpy` using Python interop:

```mojo
from asciichart import plot
from python import Python

fn test() raises:
    # Test data
    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(i * ((PI * 4) / 120)))
    
    # Generate with Mojo
    var mojo_result = plot(data)
    
    # Validate against Python
    var py = Python.import_module("asciichartpy")
    var py_data = Python.evaluate("[15 * math.sin(i * ((math.pi * 4) / 120)) for i in range(120)]")
    var py_result = py.plot(py_data)
    
    # Compare results
    assert_equal(mojo_result, str(py_result))
```

This ensures behavioural compatibility beyond just API similarity.

## Community

Special thanks to:
- The Modular Discord community for Mojo support and feedback
- Igor Kroitor for creating and maintaining the original asciichart libraries
- Early mojo-asciichart testers and users

## Standing on the Shoulders of Giants

This project wouldn't exist without:
1. **asciichart (JavaScript)** establishing the concept and elegant API design
2. **asciichartpy** proving the value of ASCII charting in Python
3. **Modular** creating Mojo and enabling Python-level ergonomics with C++-level performance

We're grateful to build upon this foundation.

---

**Sponsorship**: This project is sponsored by **[DataBooth](https://www.databooth.com.au)** — Data analytics consulting for medium-sized businesses.

**How to Contribute**: See [CONTRIBUTING.md](CONTRIBUTING.md) (coming soon)

**Report Issues**: https://github.com/databooth/mojo-asciichart/issues
