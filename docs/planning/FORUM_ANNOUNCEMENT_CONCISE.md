# mojo-asciichart v1.1.0 🔥

**ASCII line charts for Mojo with colors and proven performance gains**

```mojo
from asciichart import plot, ChartColors, Config

var latencies = collect_api_latencies()  # Monitor ML serving
var config = Config()
config.colors = ChartColors.fire()
print(plot(latencies, config))
```

**Output:**
```
  101.90  ├              ╭╮
   74.78  ├    ╭╮        ││               ││
   47.66  ├   │ │  ╭─╮  ╭╯╰╮              ││        ││
   20.54  ┤───╯ ╰──╯       ╰──────────────╯╰─────╯╰─╯╰──╯╰──╯

📊 Mean=25.3ms | P95=63.7ms | Max=101.9ms
```

## v1.1.0 Highlights

- 🎨 **6 color themes** (matrix, fire, ocean, blue, rainbow, default)
- ⚡ **1.4-4.3x faster** than Python asciichartpy
- 🚀 **ML serving example** - realistic production monitoring
- 📊 **Benchmarked** with BenchSuite (auto-generated reports)
- ✅ **29 tests** - pixel-perfect Python compatibility
- 🤖 **CI/CD** - automated `.mojopkg` builds

## Quick Start

```bash
git clone https://github.com/DataBooth/mojo-asciichart.git
cd mojo-asciichart
pixi install
pixi run example-ml-serving  # See realistic use case!
```

## Links

- 📦 [GitHub](https://github.com/DataBooth/mojo-asciichart) (Apache 2.0)
- 📝 [Detailed Announcement](https://github.com/DataBooth/mojo-asciichart/blob/main/docs/planning/FORUM_ANNOUNCEMENT_DETAILED.md)
- 📖 [Blog: Building mojo-asciichart](https://github.com/DataBooth/mojo-asciichart/blob/main/docs/BLOG_POST.md)

## Personal Note 🏖️

This wraps up my intensive "Month of Mojo" learning journey! Built 3 projects, learned the language, contributed to the ecosystem. Now off to enjoy the Australian summer at the beach! 🇦🇺☀️🌊

Repos remain maintained - issues and contributions welcome!

---

**[DataBooth](https://www.databooth.com.au/posts/mojo)** - High-performance data & AI services with Mojo
