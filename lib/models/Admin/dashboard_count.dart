import 'dart:convert';

class DashboardCount {
  int count;
  String name;

  DashboardCount({
    required this.count,
    required this.name,
  });

  DashboardCount copyWith({
    int? count,
    String? name,
  }) {
    return DashboardCount(
      count: count ?? this.count,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'count': count,
      'name': name,
    };
  }

  factory DashboardCount.fromMap(Map<String, dynamic> map) {
    return DashboardCount(
      count: map['count']?.toInt() ?? 0,
      name: map['name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DashboardCount.fromJson(String source) =>
      DashboardCount.fromMap(json.decode(source));

  @override
  String toString() => 'DashboardCount(count: $count, name: $name)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DashboardCount &&
        other.count == count &&
        other.name == name;
  }

  @override
  int get hashCode => count.hashCode ^ name.hashCode;
}
