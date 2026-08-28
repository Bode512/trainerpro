import 'exercise_set.dart';

class TrainingSession {
  final String id;
  String type;
  final List<ExerciseSet> exercises;
  final DateTime date;

  TrainingSession({
    required this.id,
    required this.type,
    required this.exercises,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'date': date.toIso8601String(),
  };

  factory TrainingSession.fromJson(Map<String, dynamic> json) =>
      TrainingSession(
        id: json['id'],
        type: json['type'],
        exercises: (json['exercises'] as List)
            .map((e) => ExerciseSet.fromJson(e))
            .toList(),
        date: DateTime.parse(json['date']),
      );
  TrainingSession copyWith({
    String? id,
    String? type,
    List<ExerciseSet>? exercises,
    DateTime? date,
  }) {
    return TrainingSession(
      id: id ?? this.id,
      type: type ?? this.type,
      exercises: exercises ?? this.exercises,
      date: date ?? this.date,
    );
  }
}
