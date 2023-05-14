const String tableTransactions = 'transactions';

class HabitFields {
  static final List<String> values = [
    id,
    title,
    amount,
    date,
    amount,
    date,
    type,
    account,
    category,
    iconCode,
    categoryType
  ];
  static const String id = '_id';
  static const String title = 'title';
  static const String amount = 'amount';
  static const String date = 'date';
  static const String type = 'type';
  static const String account = 'account';
  static const String category = 'category';
  static const String iconCode = 'iconCode';
  static const String categoryType = 'categoryType';
}

class HabitEntry {
  final int? id;
  final String title;
  final double amount;
  final DateTime date;
  final String type;
  final String account;
  final String category;
  final int iconCode;
  final String categoryType;

  HabitEntry(
      {this.id,
      required this.title,
      required this.amount,
      required this.date,
      required this.type,
      required this.account,
      required this.category,
      required this.iconCode,
      required this.categoryType});

  Map<String, Object?> toJson() {
    return {
      HabitFields.id: id,
      HabitFields.title: title,
      HabitFields.amount: amount,
      HabitFields.date: date.toIso8601String(),
      HabitFields.type: type,
      HabitFields.account: account,
      HabitFields.category: category,
      HabitFields.iconCode: iconCode,
      HabitFields.categoryType: categoryType,
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
        title: title ?? this.title,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        type: type ?? this.type,
        account: account ?? this.account,
        category: category ?? this.category,
        iconCode: iconCode ?? this.iconCode,
        categoryType: categoryType ?? this.categoryType,
      );

  static HabitEntry fromJson(Map<String, dynamic> json) => HabitEntry(
        id: json[HabitFields.id] as int,
        title: json[HabitFields.title] as String,
        amount: json[HabitFields.amount] as double,
        date: DateTime.parse(json[HabitFields.date] as String),
        type: json[HabitFields.type] as String,
        account: json[HabitFields.account] as String,
        category: json[HabitFields.category] as String,
        iconCode: json[HabitFields.iconCode] as int,
        categoryType: json[HabitFields.categoryType] as String,
      );
}
