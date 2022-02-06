import 'dart:convert';

class Surveyor {
  String? uid;
  String firstName;
  String middleName;
  String lastName;
  String profession;
  String email;
  String mobileNumber;
  String address;
  String gender;
  String joiningDate;
  String district;
  String taluka;
  String village;
  String aadhaarNumber;
  int age;
  
  Surveyor({
    this.uid,
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.profession,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.gender,
    required this.joiningDate,
    required this.district,
    required this.taluka,
    required this.village,
    required this.aadhaarNumber,
    required this.age,
  });

  Surveyor copyWith({
    String? uid,
    String? firstName,
    String? middleName,
    String? lastName,
    String? profession,
    String? email,
    String? mobileNumber,
    String? address,
    String? gender,
    String? joiningDate,
    String? district,
    String? taluka,
    String? village,
    String? aadhaarNumber,
    int? age,
  }) {
    return Surveyor(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      profession: profession ?? this.profession,
      email: email ?? this.email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      address: address ?? this.address,
      gender: gender ?? this.gender,
      joiningDate: joiningDate ?? this.joiningDate,
      district: district ?? this.district,
      taluka: taluka ?? this.taluka,
      village: village ?? this.village,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      age: age ?? this.age,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'middleName': middleName,
      'lastName': lastName,
      'profession': profession,
      'email': email,
      'mobileNumber': mobileNumber,
      'address': address,
      'gender': gender,
      'joiningDate': joiningDate,
      'district': district,
      'taluka': taluka,
      'village': village,
      'aadhaarNumber': aadhaarNumber,
      'age': age,
    };
  }

  factory Surveyor.fromMap(Map<String, dynamic> map) {
    return Surveyor(
      uid: map['uid'],
      firstName: map['firstName'] ?? '',
      middleName: map['middleName'] ?? '',
      lastName: map['lastName'] ?? '',
      profession: map['profession'] ?? '',
      email: map['email'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      address: map['address'] ?? '',
      gender: map['gender'] ?? '',
      joiningDate: map['joiningDate'] ?? '',
      district: map['district'] ?? '',
      taluka: map['taluka'] ?? '',
      village: map['village'] ?? '',
      aadhaarNumber: map['aadhaarNumber'] ?? '',
      age: int.parse(map['age'].toString()),
    );
  }

  String toJson() => json.encode(toMap());

  factory Surveyor.fromJson(String source) =>
      Surveyor.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Surveyor(uid: $uid, firstName: $firstName, middleName: $middleName, lastName: $lastName, profession: $profession, email: $email, mobileNumber: $mobileNumber, address: $address, gender: $gender, joiningDate: $joiningDate, district: $district, taluka: $taluka, village: $village, aadhaarNumber: $aadhaarNumber, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Surveyor &&
        other.uid == uid &&
        other.firstName == firstName &&
        other.middleName == middleName &&
        other.lastName == lastName &&
        other.profession == profession &&
        other.email == email &&
        other.mobileNumber == mobileNumber &&
        other.address == address &&
        other.gender == gender &&
        other.joiningDate == joiningDate &&
        other.district == district &&
        other.taluka == taluka &&
        other.village == village &&
        other.aadhaarNumber == aadhaarNumber &&
        other.age == age;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        firstName.hashCode ^
        middleName.hashCode ^
        lastName.hashCode ^
        profession.hashCode ^
        email.hashCode ^
        mobileNumber.hashCode ^
        address.hashCode ^
        gender.hashCode ^
        joiningDate.hashCode ^
        district.hashCode ^
        taluka.hashCode ^
        village.hashCode ^
        aadhaarNumber.hashCode ^
        age.hashCode;
  }
}
