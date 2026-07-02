import 'package:fitness/domain/models/exercise.dart';
import 'package:fitness/domain/models/workout.dart';

/// Raw API model for an [Exercise] with manual JSON (de)serialization.
class ExerciseApiModel {
  const ExerciseApiModel({
    required this.id,
    required this.name,
    required this.muscle,
    required this.sets,
    required this.reps,
    required this.restSec,
    required this.note,
  });

  final String id;
  final String name;
  final String muscle;
  final int sets;
  final String reps;
  final int restSec;
  final String note;

  factory ExerciseApiModel.fromJson(Map<String, dynamic> json) =>
      ExerciseApiModel(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        muscle: (json['muscle'] ?? 'fullBody') as String,
        sets: (json['sets'] ?? 0) as int,
        reps: '${json['reps'] ?? ''}',
        restSec: (json['rest_sec'] ?? 0) as int,
        note: (json['note'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'muscle': muscle,
        'sets': sets,
        'reps': reps,
        'rest_sec': restSec,
        'note': note,
      };

  Exercise toDomain() => Exercise(
        id: id,
        name: name,
        muscle: muscle,
        sets: sets,
        reps: reps,
        restSec: restSec,
        note: note,
      );
}

/// Raw API model for a [Workout] with manual JSON (de)serialization.
class WorkoutApiModel {
  const WorkoutApiModel({
    required this.id,
    required this.name,
    required this.durationMin,
    required this.level,
    required this.category,
    required this.focus,
    required this.calories,
    required this.description,
    required this.exercises,
  });

  final String id;
  final String name;
  final int durationMin;
  final String level;
  final String category;
  final String focus;
  final int calories;
  final String description;
  final List<ExerciseApiModel> exercises;

  factory WorkoutApiModel.fromJson(Map<String, dynamic> json) => WorkoutApiModel(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? json['title'] ?? '') as String,
        durationMin: (json['duration_min'] ?? json['duration'] ?? 0) as int,
        level: (json['level'] ?? '') as String,
        category: (json['category'] ?? 'fullBody') as String,
        focus: (json['focus'] ?? '') as String,
        calories: (json['calories'] ?? 0) as int,
        description: (json['description'] ?? '') as String,
        exercises: ((json['exercises'] ?? const <dynamic>[]) as List<dynamic>)
            .map((e) => ExerciseApiModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'duration_min': durationMin,
        'level': level,
        'category': category,
        'focus': focus,
        'calories': calories,
        'description': description,
        'exercises': exercises.map((e) => e.toJson()).toList(),
      };

  /// Transform the transport model into the clean domain model.
  Workout toDomain() => Workout(
        id: id,
        name: name,
        durationMin: durationMin,
        level: level,
        category: category,
        focus: focus,
        calories: calories,
        description: description,
        exercises: exercises.map((e) => e.toDomain()).toList(),
      );
}
