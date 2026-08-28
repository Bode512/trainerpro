class ExerciseSet {
  final String name;
  final double weight;
  final double reps;
  final String note;
  final String time;
  final DateTime date;

  // Nuevos campos para ajuste de peso
  final String? adjustment; // 'subir', 'bajar', 'mantener'
  final double? nextWeight; // Peso sugerido para la próxima

  ExerciseSet({
    required this.name,
    required this.weight,
    required this.reps,
    required this.note,
    required this.time,
    required this.date,
    this.adjustment,
    this.nextWeight,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'weight': weight,
    'reps': reps,
    'note': note,
    'time': time,
    'date': date.toIso8601String(),
    'adjustment': adjustment,
    'nextWeight': nextWeight,
  };

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => ExerciseSet(
    name: json['name'],
    weight: (json['weight'] as num).toDouble(),
    reps: (json['reps'] as num).toDouble(),
    note: json['note'] ?? '',
    time: json['time'],
    date: DateTime.parse(json['date']),
    adjustment: json['adjustment'],
    nextWeight: json['nextWeight'] != null
        ? (json['nextWeight'] as num).toDouble()
        : null,
  );

  ExerciseSet copyWith({
    double? weight,
    double? reps,
    String? note,
    String? adjustment,
    double? nextWeight,
  }) {
    return ExerciseSet(
      name: name,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      note: note ?? this.note,
      time: time,
      date: date,
      adjustment: adjustment ?? this.adjustment,
      nextWeight: nextWeight ?? this.nextWeight,
    );
  }

  // Métrica de progreso: 1 kg = 2 reps (Score efectivo)
  double get effectiveScore => weight + (reps / 2);
}
