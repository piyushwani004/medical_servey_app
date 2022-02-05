import 'dart:convert';

class VillageData {
  String No;
  String Taluka;
  String Village;
  
  VillageData({
    required this.No,
    required this.Taluka,
    required this.Village,
  });

  VillageData copyWith({
    String? No,
    String? Taluka,
    String? Village,
  }) {
    return VillageData(
      No: No ?? this.No,
      Taluka: Taluka ?? this.Taluka,
      Village: Village ?? this.Village,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'No': No,
      'Taluka': Taluka,
      'Village': Village,
    };
  }

  factory VillageData.fromMap(Map<String, dynamic> map) {
    return VillageData(
      No: map['No'] ?? '',
      Taluka: map['Taluka'] ?? '',
      Village: map['Village'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory VillageData.fromJson(String source) =>
      VillageData.fromMap(json.decode(source));

  @override
  String toString() =>
      'VillageData(No: $No, Taluka: $Taluka, Village: $Village)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is VillageData &&
        other.No == No &&
        other.Taluka == Taluka &&
        other.Village == Village;
  }

  @override
  int get hashCode => No.hashCode ^ Taluka.hashCode ^ Village.hashCode;
}
