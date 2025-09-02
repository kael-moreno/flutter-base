/// Counter entity representing the business object
class Counter {
  final int value;
  final DateTime lastUpdated;

  const Counter({
    required this.value,
    required this.lastUpdated,
  });

  Counter copyWith({
    int? value,
    DateTime? lastUpdated,
  }) {
    return Counter(
      value: value ?? this.value,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() => 'Counter(value: $value, lastUpdated: $lastUpdated)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Counter &&
        other.value == value &&
        other.lastUpdated == lastUpdated;
  }

  @override
  int get hashCode => value.hashCode ^ lastUpdated.hashCode;
}
