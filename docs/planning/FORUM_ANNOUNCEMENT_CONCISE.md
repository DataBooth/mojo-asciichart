# mojo-asciichart v1.0.0 - ASCII Line Charts

I've released **mojo-asciichart**, a native Mojo port of asciichartpy with pixel-perfect Python compatibility and zero dependencies.

## What it does

Generate beautiful ASCII line charts in your terminal:
- UTF-8 box-drawing characters for smooth curves
- Automatic scaling and height adjustment
- NaN handling (gaps in data)
- Configurable min/max bounds
- IEEE 754 banker's rounding for accuracy
- 12 tests ensuring Python compatibility

## Installation

```bash
git clone https://github.com/DataBooth/mojo-asciichart.git
cd mojo-asciichart
pixi install
pixi run mojo -I src examples/gallery.mojo
```

Coming soon to the `modular-community` channel.

## Usage

```mojo
from asciichart import plot
from math import sin, pi

fn main() raises:
    var data = List[Float64]()
    for i in range(120):
        data.append(15.0 * sin(i * ((pi * 4) / 120)))
    print(plot(data))
```

**Output:**
```
    15.00  ┼╮╭┼───────╮╭┼───────╮╭┼
    10.71  ┤╰╯        ╰╯        ╰╯ 
     6.43  ┤                       
     2.14  ┤                       
    -2.14  ┤                       
    -6.43  ┤                       
   -10.71  ┤╭╮        ╭╮        ╭╮ 
   -15.00  ┼╯╰────────╯╰────────╯╰─
```

### With Configuration

```mojo
from asciichart import plot, Config

fn main() raises:
    var data = List[Float64]()
    for i in range(30):
        data.append(15.0 * cos(i * ((pi * 8) / 120)))
    
    var config = Config()
    config.height = 6
    print(plot(data, config))
```

## What's in v1.0.0

- ✅ Core `plot()` function with automatic scaling
- ✅ `Config` struct for height, min/max, offset customization
- ✅ NaN value handling (shows gaps)
- ✅ Banker's rounding (IEEE 754) for pixel-perfect Python compatibility
- ✅ Modern TestSuite with 12 tests (6 basic + 6 Python interop)
- ✅ Comprehensive visual gallery (13 chart examples)
- ✅ ~7 hours from idea to production-ready library

**Python Compatibility**: Verified pixel-perfect output matching against asciichartpy.

## Use Cases

- Terminal-based monitoring dashboards
- CI/CD pipeline output visualization
- SSH sessions to remote servers
- Log file analysis
- Embedded systems without GUI
- Quick data exploration

## Links

- [GitHub Repository](https://github.com/DataBooth/mojo-asciichart)
- [Documentation](https://github.com/DataBooth/mojo-asciichart/blob/main/README.md)
- [Blog Post: Building mojo-asciichart](https://github.com/DataBooth/mojo-asciichart/blob/main/docs/BLOG_POST.md)
- License: Apache 2.0

## Roadmap

Planned features for v1.1.0+:
- Multiple data series support (overlay charts)
- ANSI color support for colored lines
- Custom symbols and line styles
- Performance benchmarks vs Python
- Bar charts and histograms

## Acknowledgements

This project is a Mojo port of:
- **[asciichart](https://github.com/kroitor/asciichart)** (JavaScript) - Original by Igor Kroitor
- **[asciichartpy](https://github.com/kroitor/asciichart)** (Python) - Python port by Igor Kroitor

Sponsored by [DataBooth](https://www.databooth.com.au/posts/mojo), building high-performance data and AI services with Mojo.

Feedback and contributions welcome! 🔥
