"""
ML Model Serving Latency Monitoring Example

Demonstrates monitoring prediction latencies in a production ML serving scenario.
This is a realistic use case where ASCII charts provide quick visual feedback
without requiring a GUI or external monitoring tool.

Use Case:
- You're serving an ML model via API
- Want to monitor prediction latency trends
- Need quick visual feedback in logs/terminal
- ASCII chart is perfect for this!
"""

from asciichart import plot, Config, ChartColors
from random import random_float64
from math import sin, pi

fn simulate_prediction_latency(request_num: Int, total_requests: Int) -> Float64:
    """
    Simulate realistic ML prediction latency with various real-world patterns:
    - Base latency around 10-20ms
    - Random spikes (outliers) representing cold starts or cache misses
    - Gradual increase over time (memory pressure)
    - Periodic spikes (garbage collection)
    """
    var base_latency = 15.0  # Base prediction time in milliseconds

    # Gradual memory pressure increase
    var memory_pressure = Float64(request_num) / Float64(total_requests) * 5.0

    # Random noise
    var noise = (random_float64() - 0.5) * 3.0

    # Periodic GC spikes every ~50 requests
    var gc_cycle = sin(Float64(request_num) * pi / 25.0)
    var gc_spike = 0.0
    if gc_cycle > 0.9:
        gc_spike = 20.0 + random_float64() * 10.0

    # Random outliers (cold starts, cache misses)
    var outlier = 0.0
    if random_float64() > 0.95:  # 5% chance of outlier
        outlier = 30.0 + random_float64() * 40.0

    return base_latency + memory_pressure + noise + gc_spike + outlier


fn main() raises:
    print("\n🚀 ML MODEL SERVING - LATENCY MONITORING 🚀\n")
    print("Scenario: Production API serving predictions")
    print("Monitoring: Last 100 requests (real-time latency in milliseconds)")
    print("Note: X-axis represents request sequence (0→100), Y-axis shows latency (ms)\n")

    # Simulate 100 prediction requests
    var latencies = List[Float64]()
    var total_requests = 100

    for i in range(total_requests):
        var latency = simulate_prediction_latency(i, total_requests)
        latencies.append(latency)

    # Create config with fire colors (hot = red/yellow, appropriate for latency!)
    var config = Config()
    config.height = 12
    config.colors = ChartColors.fire()

    print("=" * 60)
    print(plot(latencies, config))
    print("=" * 60)

    # Calculate and display statistics
    var total = 0.0
    var min_latency = latencies[0]
    var max_latency = latencies[0]

    for i in range(len(latencies)):
        var lat = latencies[i]
        total += lat
        if lat < min_latency:
            min_latency = lat
        if lat > max_latency:
            max_latency = lat

    var mean_latency = total / Float64(len(latencies))

    # Calculate P95 (approximate - sort and get 95th percentile)
    var sorted_lats = List[Float64]()
    for i in range(len(latencies)):
        sorted_lats.append(latencies[i])

    # Simple bubble sort for P95 calculation
    for i in range(len(sorted_lats)):
        for j in range(len(sorted_lats) - 1 - i):
            if sorted_lats[j] > sorted_lats[j + 1]:
                var temp = sorted_lats[j]
                sorted_lats[j] = sorted_lats[j + 1]
                sorted_lats[j + 1] = temp

    var p95_index = Int(Float64(len(sorted_lats)) * 0.95)
    var p95_latency = sorted_lats[p95_index]

    print("\n📊 LATENCY STATISTICS:")
    print("  Requests:     " + String(total_requests))
    print("  Mean:         " + String(Float64(Int(mean_latency * 100.0)) / 100.0) + " ms")
    print("  Min:          " + String(Float64(Int(min_latency * 100.0)) / 100.0) + " ms")
    print("  Max:          " + String(Float64(Int(max_latency * 100.0)) / 100.0) + " ms")
    print("  P95:          " + String(Float64(Int(p95_latency * 100.0)) / 100.0) + " ms")

    print("\n💡 INSIGHTS:")
    if max_latency > 60.0:
        print("  ⚠️  High latency spikes detected (>60ms)")
        print("     → Check for cold starts or cache misses")
    if mean_latency > 25.0:
        print("  ⚠️  Mean latency elevated (>25ms)")
        print("     → Consider scaling up or optimizing model")
    if p95_latency < 30.0:
        print("  ✅ P95 latency is healthy (<30ms)")
        print("     → Most users getting fast responses")
    else:
        print("  ⚠️  P95 latency needs attention (>30ms)")

    print("\n🔍 USE CASE:")
    print("  This pattern is useful for:")
    print("  • SSH'd into production server")
    print("  • Quick health check in CI/CD logs")
    print("  • Monitoring script output")
    print("  • Alerting system visualization")
    print("  • Local development testing\n")
