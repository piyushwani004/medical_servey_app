import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Patient {
  String id;
  String firstName;
  String middleName;
  String lastName;
  String profession;
  String email;
  String mobileNumber;
  String address;
  String gender;
  String date;
  List diseases = [];
  int age;
  String surveyorUID;
  String? otherDisease;
  String village;
  String taluka;
  Timestamp timestamp;
  bool isMember;
  String aadhaarNumber;
  Patient({
    required this.id,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profession,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.gender,
    required this.date,
    required this.diseases,
    required this.age,
    required this.surveyorUID,
    this.otherDisease,
    required this.village,
    required this.taluka,
    required this.timestamp,
    required this.isMember,
    required this.aadhaarNumber,
  });

  Patient copyWith({
    String? id,
    String? firstName,
    String? middleName,
    String? lastName,
    String? profession,
    String? email,
    String? mobileNumber,
    String? address,
    String? gender,
    String? date,
    List? diseases,
    int? age,
    String? surveyorUID,
    String? otherDisease,
    String? village,
    String? taluka,
    Timestamp? timestamp,
    bool? isMember,
    String? aadhaarNumber,
  }) {
    return Patient(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      profession: profession ?? this.profession,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      date: date ?? this.date,
      diseases: diseases ?? this.diseases,
      age: age ?? this.age,
      surveyorUID: surveyorUID ?? this.surveyorUID,
      otherDisease: otherDisease ?? this.otherDisease,
      village: village ?? this.village,
      taluka: taluka ?? this.taluka,
      timestamp: timestamp ?? this.timestamp,
      isMember: isMember ?? this.isMember,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'profession': profession,
      'email': email,
      'mobileNumber': mobileNumber,
      'address': address,
      'gender': gender,
      'date': date,
      'diseases': diseases,
      'age': age,
      'surveyorUID': surveyorUID,
      'otherDisease': otherDisease,
      'village': village,
      'taluka': taluka,
      'timestamp': timestamp,
      'isMember': isMember,
      'aadhaarNumber': aadhaarNumber,
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? '',
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      profession: map['profession'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      date: map['date'] ?? '',
      diseases: List<String>.from(map['diseases']),
      age: int.parse(map['age'].toString()),
      surveyorUID: map['surveyorUID'] ?? '',
      otherDisease: map['otherDisease'],
      village: map['village'] ?? '',
      taluka: map['taluka'] ?? '',
      timestamp: map['timestamp'],
      isMember: map['isMember'] ?? false,
      aadhaarNumber: map['aadhaarNumber'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) =>
      Patient.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Patient(id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, profession: $profession, email: $email, mobileNumber: $mobileNumber, address: $address, gender: $gender, date: $date, diseases: $diseases, age: $age, surveyorUID: $surveyorUID, otherDisease: $otherDisease, village: $village, taluka: $taluka, timestamp: $timestamp, isMember: $isMember, aadhaarNumber: $aadhaarNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Patient &&
        other.id == id &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.profession == profession &&
        other.email == email &&
        other.mobileNumber == mobileNumber &&
        other.address == address &&
        other.gender == gender &&
        other.date == date &&
        listEquals(other.diseases, diseases) &&
        other.age == age &&
        other.surveyorUID == surveyorUID &&
        other.otherDisease == otherDisease &&
        other.village == village &&
        other.taluka == taluka &&
        other.timestamp == timestamp &&
        other.isMember == isMember &&
        other.aadhaarNumber == aadhaarNumber;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        profession.hashCode ^
        email.hashCode ^
        mobileNumber.hashCode ^
        address.hashCode ^
        gender.hashCode ^
        date.hashCode ^
        diseases.hashCode ^
        age.hashCode ^
        surveyorUID.hashCode ^
        otherDisease.hashCode ^
        village.hashCode ^
        taluka.hashCode ^
        timestamp.hashCode ^
        isMember.hashCode ^
        aadhaarNumber.hashCode;
  }
}
