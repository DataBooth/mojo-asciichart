"""
Australia coastline - ASCII chart approximating Australian coast shape.

Demonstrates using asciichart for creative visualisations beyond typical data plots.
The chart roughly follows the southern coastline of Australia from west to east.
"""

from asciichart import plot, Config, ChartColors

fn main() raises:
    print("\n🇦🇺 AUSTRALIA COASTLINE 🇦🇺\n")
    print("Approximate southern coastline (West to East)")
    print("Perth → Adelaide → Melbourne → Sydney → Brisbane\n")
    
    # Create data representing southern Australian coastline
    # Simplified elevation profile from west to east
    var data = List[Float64]()
    
    # Perth/Western Australia coast (relatively flat)
    for _ in range(15):
        data.append(2.0)
    
    # Great Australian Bight (lower, curved bay)
    for i in range(20):
        var t = Float64(i) / 20.0
        data.append(2.0 - 3.0 * (t * (1.0 - t)))  # Parabolic dip
    
    # Nullarbor Plain to Adelaide (flat, low)
    for _ in range(15):
        data.append(0.5)
    
    # Adelaide region (slight rise)
    for i in range(10):
        var t = Float64(i) / 10.0
        data.append(0.5 + t * 2.0)
    
    # Melbourne/Victoria coast (varied, Bass Strait)
    for i in range(25):
        var t = Float64(i) / 25.0
        # Some variation for Victorian coast
        data.append(2.5 + 1.5 * (t * t - t))
    
    # Bass Strait to Sydney (NSW coast - rising)
    for i in range(20):
        var t = Float64(i) / 20.0
        data.append(2.0 + t * 4.0)
    
    # Sydney region (higher, Great Dividing Range influence)
    for _ in range(12):
        data.append(6.0)
    
    # Brisbane/Queensland (gradually rising to subtropical)
    for i in range(15):
        var t = Float64(i) / 15.0
        data.append(6.0 + t * 3.0)
    
    # Plot with ocean colours
    var config = Config()
    config.height = 15
    config.colors = ChartColors.ocean()
    
    print(plot(data, config))
    
    print("\n📍 Approximate locations:")
    print("   Left:  Perth (WA)")
    print("   Dip:   Great Australian Bight")
    print("   Low:   Nullarbor Plain")
    print("   Mid:   Adelaide → Melbourne")
    print("   Rise:  NSW Coast")
    print("   High:  Brisbane (QLD)")
    print("\n🏖️  'Where the bloody hell are you?' 🏖️\n")
