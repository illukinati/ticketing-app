class Date {
  final DateTime value;

  const Date._(this.value);

  factory Date.fromString(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return Date._(dateTime);
    } catch (e) {
      throw ArgumentError('Invalid date format: $dateString');
    }
  }

  factory Date.fromDateTime(DateTime dateTime) {
    return Date._(dateTime);
  }

  factory Date.now() {
    return Date._(DateTime.now());
  }

  String toDateString() {
    return '${value.year.toString().padLeft(4, '0')}-'
        '${value.month.toString().padLeft(2, '0')}-'
        '${value.day.toString().padLeft(2, '0')}';
  }

  String toIso8601String() {
    return value.toIso8601String();
  }

  DateTime toDateTime() {
    return value;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Date &&
          runtimeType == other.runtimeType &&
          value.year == other.value.year &&
          value.month == other.value.month &&
          value.day == other.value.day;

  @override
  int get hashCode => 
      value.year.hashCode ^ value.month.hashCode ^ value.day.hashCode;

  @override
  String toString() => toDateString();
}