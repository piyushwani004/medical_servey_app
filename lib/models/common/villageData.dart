import 'dart:convert';

class VillageData {
  String no;
  String taluka;
  String village;

  VillageData({
    required this.no,
    required this.taluka,
    required this.village,
  });

  VillageData copyWith({
    String? no,
    String? taluka,
    String? village,
  }) {
    return VillageData(
      no: no ?? this.no,
      taluka: taluka ?? this.taluka,
      village: village ?? this.village,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'No': no,
      'Taluka': taluka,
      'Village': village,
    };
  }

  factory VillageData.fromMap(Map<String, dynamic> map) {
    return VillageData(
      no: map['No'].toString(),
      taluka: map['Taluka'] ?? '',
      village: map['Village'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VillageData.fromJson(String source) =>
      VillageData.fromMap(json.decode(source));

  @override
  String toString() =>
      'VillageData(no: $no, taluka: $taluka, village: $village)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VillageData &&
        other.no == no &&
        other.taluka == taluka &&
        other.village == village;
  }

  @override
  int get hashCode => no.hashCode ^ taluka.hashCode ^ village.hashCode;
}
