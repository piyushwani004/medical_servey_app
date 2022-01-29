import 'dart:convert';

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
  List diseases;
  int age;
  
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
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'],
      firstName: map['firstName'],
      middleName: map['middleName'],
      lastName: map['lastName'],
      profession: map['profession'],
      email: map['email'],
      mobileNumber: map['mobileNumber'],
      address: map['address'],
      gender: map['gender'],
      date: map['date'],
      diseases: List.from(map['diseases']),
      age: map['age'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Patient.fromJson(String source) => Patient.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Patien(id: $id, firstName: $firstName, middleName: $middleName, lastName: $lastName, profession: $profession, email: $email, mobileNumber: $mobileNumber, address: $address, gender: $gender, date: $date, diseases: $diseases, age: $age)';
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
        other.age == age;
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
        age.hashCode;
  }
}