const String tableTransactions = 'transactions';

class HabitFields {
  static final List<String> values = [
    id,
    habitName,
    activation,
    date,
    type,
  ];
  static const String id = '_id';
  static const String habitName = 'habitName';
  static const String activation = 'activation';
  static const String date = 'date';
  static const String type = 'type';
}

class HabitEntry {
  final int? id;
  final String habitName;
  final double activation;
  final DateTime date;
  final String type;

  HabitEntry({
    this.id,
    required this.habitName,
    required this.activation,
    required this.date,
    required this.type,
  });

  Map<String, Object?> toJson() {
    return {
      HabitFields.id: id,
      HabitFields.habitName: habitName,
      HabitFields.activation: activation,
      HabitFields.date: date.toIso8601String(),
      HabitFields.type: type,
    };
  }

  HabitEntry copy({
    int? id,
    String? title,
    double? amount,
    DateTime? date,
    String? type,
    String? account,
    String? category,
    int? iconCode,
    String? categoryType,
  }) =>
      HabitEntry(
        id: id ?? this.id,
        habitName: title ?? this.habitName,
        activation: amount ?? this.activation,
        date: date ?? this.date,
        type: type ?? this.type,
      );

  static HabitEntry fromJson(Map<String, dynamic> json) => HabitEntry(
        id: json[HabitFields.id] as int,
        habitName: json[HabitFields.habitName] as String,
        activation: json[HabitFields.activation] as double,
        date: DateTime.parse(json[HabitFields.date] as String),
        type: json[HabitFields.type] as String,
      );
}
