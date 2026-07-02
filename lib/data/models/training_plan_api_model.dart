import 'package:fitness/domain/models/training_plan.dart';

/// Raw API model for a [TrainingPlan] with manual JSON (de)serialization.
class TrainingPlanApiModel {
  const TrainingPlanApiModel({
    required this.id,
    required this.name,
    required this.level,
    required this.weeks,
    required this.sessionsPerWeek,
    required this.focus,
    required this.accent,
    required this.progress,
    required this.description,
    required this.tags,
  });

  final String id;
  final String name;
  final String level;
  final int weeks;
  final int sessionsPerWeek;
  final String focus;
  final String accent;
  final double progress;
  final String description;
  final List<String> tags;

  factory TrainingPlanApiModel.fromJson(Map<String, dynamic> json) =>
      TrainingPlanApiModel(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        level: (json['level'] ?? '') as String,
        weeks: (json['weeks'] ?? 0) as int,
        sessionsPerWeek: (json['sessions_per_week'] ?? 0) as int,
        focus: (json['focus'] ?? '') as String,
        accent: (json['accent'] ?? 'fullBody') as String,
        progress: ((json['progress'] ?? 0) as num).toDouble(),
        description: (json['description'] ?? '') as String,
        tags: ((json['tags'] ?? const <dynamic>[]) as List<dynamic>)
            .map((e) => '$e')
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'level': level,
        'weeks': weeks,
        'sessions_per_week': sessionsPerWeek,
        'focus': focus,
        'accent': accent,
        'progress': progress,
        'description': description,
        'tags': tags,
      };

  TrainingPlan toDomain() => TrainingPlan(
        id: id,
        name: name,
        level: level,
        weeks: weeks,
        sessionsPerWeek: sessionsPerWeek,
        focus: focus,
        accent: accent,
        progress: progress,
        description: description,
        tags: tags,
      );
}
