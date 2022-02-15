import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';

class PdfModel {
  final List<Patient>? patientLst;
  final List<Surveyor>? surveyorLst;
  final Map<String, double>? reportLst;
  
  PdfModel({
    this.patientLst,
    this.surveyorLst,
    this.reportLst,
  });

  PdfModel copyWith({
    List<Patient>? patientLst,
    List<Surveyor>? surveyorLst,
    Map<String, double>? reportLst,
  }) {
    return PdfModel(
      patientLst: patientLst ?? this.patientLst,
      surveyorLst: surveyorLst ?? this.surveyorLst,
      reportLst: reportLst ?? this.reportLst,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientLst': patientLst?.map((x) => x.toMap()).toList(),
      'surveyorLst': surveyorLst?.map((x) => x.toMap()).toList(),
      'reportLst': reportLst,
    };
  }

  factory PdfModel.fromMap(Map<String, dynamic> map) {
    return PdfModel(
      patientLst: map['patientLst'] != null
          ? List<Patient>.from(
              map['patientLst']?.map((x) => Patient.fromMap(x)))
          : null,
      surveyorLst: map['surveyorLst'] != null
          ? List<Surveyor>.from(
              map['surveyorLst']?.map((x) => Surveyor.fromMap(x)))
          : null,
      reportLst: Map<String, double>.from(map['reportLst']),
    );
  }

  String toJson() => json.encode(toMap());

  factory PdfModel.fromJson(String source) =>
      PdfModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PdfModel(patientLst: $patientLst, surveyorLst: $surveyorLst, reportLst: $reportLst)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PdfModel &&
        listEquals(other.patientLst, patientLst) &&
        listEquals(other.surveyorLst, surveyorLst) &&
        mapEquals(other.reportLst, reportLst);
  }

  @override
  int get hashCode =>
      patientLst.hashCode ^ surveyorLst.hashCode ^ reportLst.hashCode;
}
