import 'dart:convert';

class DiseaseReportModel {
  String diseaseName;
  double diseasePercentage;
  
  DiseaseReportModel({
    required this.diseaseName,
    required this.diseasePercentage,
  });

  DiseaseReportModel copyWith({
    String? diseaseName,
    double? diseasePercentage,
  }) {
    return DiseaseReportModel(
      diseaseName: diseaseName ?? this.diseaseName,
      diseasePercentage: diseasePercentage ?? this.diseasePercentage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diseaseName': diseaseName,
      'diseasePercentage': diseasePercentage,
    };
  }

  factory DiseaseReportModel.fromMap(Map<String, dynamic> map) {
    return DiseaseReportModel(
      diseaseName: map['diseaseName'] ?? '',
      diseasePercentage: map['diseasePercentage']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory DiseaseReportModel.fromJson(String source) =>
      DiseaseReportModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'DiseaseReportModel(diseaseName: $diseaseName, diseasePercentage: $diseasePercentage)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiseaseReportModel &&
        other.diseaseName == diseaseName &&
        other.diseasePercentage == diseasePercentage;
  }

  @override
  int get hashCode => diseaseName.hashCode ^ diseasePercentage.hashCode;
}