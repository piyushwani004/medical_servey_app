import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';

class PdfModel {
  final List<Patient>? patientLst;
  final List<Surveyor>? surveyorLst;
  PdfModel({
    this.patientLst,
    this.surveyorLst,
  });

  PdfModel copyWith({
    List<Patient>? patientLst,
    List<Surveyor>? surveyorLst,
  }) {
    return PdfModel(
      patientLst: patientLst ?? this.patientLst,
      surveyorLst: surveyorLst ?? this.surveyorLst,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'patientLst': patientLst!.map((x) => x.toMap()).toList(),
      'surveyorLst': surveyorLst!.map((x) => x.toMap()).toList(),
    };
  }

  factory PdfModel.fromMap(Map<String, dynamic> map) {
    return PdfModel(
      patientLst:
          List<Patient>.from(map['patientLst']?.map((x) => Patient.fromMap(x))),
      surveyorLst: List<Surveyor>.from(
          map['surveyorLst']?.map((x) => Surveyor.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory PdfModel.fromJson(String source) =>
      PdfModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PdfModel(patientLst: $patientLst, surveyorLst: $surveyorLst)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PdfModel &&
        listEquals(other.patientLst, patientLst) &&
        listEquals(other.surveyorLst, surveyorLst);
  }

  @override
  int get hashCode => patientLst.hashCode ^ surveyorLst.hashCode;
}
