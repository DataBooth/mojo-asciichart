from asciichart import plot

fn main() raises:
    # Basic smoke test: generate a simple chart and ensure it is non-empty.
    var data = [0.0, 1.0, 0.0, -1.0, 0.0]
    var chart = plot(data)

    if len(chart) == 0:
        raise Error("Plot output was empty for non-empty data")

    print("ok")
