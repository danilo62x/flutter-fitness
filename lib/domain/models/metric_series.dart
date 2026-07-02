/// A time series for one progress metric (weight, calories, distance…).
///
/// [values] are raw readings; the chart normalizes them against their own
/// min/max. [points] holds the x-axis labels aligned with [values].
class MetricSeries {
  const MetricSeries({
    required this.id,
    required this.label,
    required this.unit,
    required this.values,
    required this.points,
    required this.current,
    required this.delta,
    required this.accent,
  });

  final String id;
  final String label;
  final String unit;
  final List<double> values;
  final List<String> points;

  /// Latest reading, shown as the headline value.
  final double current;

  /// Change versus the first reading (can be negative).
  final double delta;

  /// UI-agnostic accent tag mapped to a color by the view.
  final String accent;
}
