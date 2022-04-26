import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:medical_servey_app/models/surveyor/patient.dart';

class DiseaseReportModel {
  String diseaseName;
  double diseasePercentage;
  List<Patient> patientCount;
  DiseaseReportModel({
    required this.diseaseName,
    required this.diseasePercentage,
    required this.patientCount,
  });

  DiseaseReportModel copyWith({
    String? diseaseName,
    double? diseasePercentage,
    List<Patient>? patientCount,
  }) {
    return DiseaseReportModel(
      diseaseName: diseaseName ?? this.diseaseName,
      diseasePercentage: diseasePercentage ?? this.diseasePercentage,
      patientCount: patientCount ?? this.patientCount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'diseaseName': diseaseName,
      'diseasePercentage': diseasePercentage,
      'patientCount': patientCount.map((x) => x.toMap()).toList(),
    };
  }

  factory DiseaseReportModel.fromMap(Map<String, dynamic> map) {
    return DiseaseReportModel(
      diseaseName: map['diseaseName'] ?? '',
      diseasePercentage: map['diseasePercentage']?.toDouble() ?? 0.0,
      patientCount: List<Patient>.from(
          map['patientCount']?.map((x) => Patient.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory DiseaseReportModel.fromJson(String source) =>
      DiseaseReportModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'DiseaseReportModel(diseaseName: $diseaseName, diseasePercentage: $diseasePercentage, patientCount: $patientCount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DiseaseReportModel &&
        other.diseaseName == diseaseName &&
        other.diseasePercentage == diseasePercentage &&
        listEquals(other.patientCount, patientCount);
  }

  @override
  int get hashCode =>
      diseaseName.hashCode ^ diseasePercentage.hashCode ^ patientCount.hashCode;
}
