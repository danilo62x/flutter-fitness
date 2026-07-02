import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A smooth line chart drawn with [CustomPaint]: gradient area fill, a rounded
/// line and dots at every reading. Values are auto-scaled to their own range.
class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.values,
    required this.color,
    this.height = 150,
    this.showDots = true,
  });

  final List<double> values;
  final Color color;
  final double height;
  final bool showDots;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _LineChartPainter(
          values: values,
          color: color,
          gridColor: scheme.outlineVariant.withValues(alpha: 0.5),
          haloColor: scheme.surface,
          showDots: showDots,
        ),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.values,
    required this.color,
    required this.gridColor,
    required this.haloColor,
    required this.showDots,
  });

  final List<double> values;
  final Color color;
  final Color gridColor;
  final Color haloColor;
  final bool showDots;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final range = (maxV - minV).abs() < 1e-6 ? 1.0 : (maxV - minV);

    const topPad = 14.0;
    const bottomPad = 14.0;
    final chartH = size.height - topPad - bottomPad;

    double xFor(int i) => values.length == 1
        ? size.width / 2
        : i / (values.length - 1) * size.width;
    double yFor(double v) => topPad + chartH * (1 - (v - minV) / range);

    // Horizontal grid lines.
    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (var g = 0; g <= 2; g++) {
      final y = topPad + chartH * g / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final points = <Offset>[
      for (var i = 0; i < values.length; i++) Offset(xFor(i), yFor(values[i])),
    ];

    // Smooth line path.
    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final midX = (p0.dx + p1.dx) / 2;
      linePath.cubicTo(midX, p0.dy, midX, p1.dy, p1.dx, p1.dy);
    }

    // Gradient area fill under the line.
    final fillPath = Path.from(linePath)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: <Color>[
          color.withValues(alpha: 0.30),
          color.withValues(alpha: 0.02),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    // The line itself.
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color;
    canvas.drawPath(linePath, linePaint);

    if (showDots) {
      final dotPaint = Paint()..color = color;
      final haloPaint = Paint()..color = haloColor;
      for (var i = 0; i < points.length; i++) {
        final isLast = i == points.length - 1;
        if (isLast) {
          canvas.drawCircle(points[i], 6, haloPaint);
          canvas.drawCircle(points[i], 4.5, dotPaint);
        } else {
          canvas.drawCircle(points[i], 2.6, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(_LineChartPainter oldDelegate) =>
      oldDelegate.values != values || oldDelegate.color != color;
}

/// A large circular timer ring with a two-tone sweep gradient, used by the
/// exercise player. The center holds an arbitrary [child] (time + label).
class TimerRing extends StatelessWidget {
  const TimerRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 232,
    this.stroke = 16,
    this.color,
  });

  final double progress;
  final Widget child;
  final double size;
  final double stroke;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final ringColor = color ?? scheme.primary;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TimerRingPainter(
          progress: progress.clamp(0.0, 1.0),
          color: ringColor,
          endColor: scheme.tertiary,
          track: ringColor.withValues(alpha: 0.14),
          stroke: stroke,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  _TimerRingPainter({
    required this.progress,
    required this.color,
    required this.endColor,
    required this.track,
    required this.stroke,
  });

  final double progress;
  final Color color;
  final Color endColor;
  final Color track;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) - stroke) / 2;
    const start = -math.pi / 2;

    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    canvas.drawCircle(center, radius, trackPaint);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: 0,
        endAngle: 2 * math.pi,
        transform: const GradientRotation(-math.pi / 2),
        colors: <Color>[color, endColor],
      ).createShader(rect);
    canvas.drawArc(rect, start, 2 * math.pi * progress, false, arcPaint);
  }

  @override
  bool shouldRepaint(_TimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.color != color;
}

/// A labelled horizontal macronutrient bar.
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.label,
    required this.value,
    required this.goal,
    required this.unit,
    required this.color,
  });

  final String label;
  final int value;
  final int goal;
  final String unit;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final ratio = goal == 0 ? 0.0 : (value / goal).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: scheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Text(
              '$value / $goal $unit',
              style: textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 9,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
