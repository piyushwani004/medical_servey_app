import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String TRUST_NAME = "Trust Name";
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const kPrimaryColor = Color(0xFFFE4350);

const defaultPadding = 16.0;

const DEF_SEC_FB = '123456789!@#&*()';

final CollectionReference collectionDisease =
    FirebaseFirestore.instance.collection('Diseases');

final CollectionReference collectionPatient =
    FirebaseFirestore.instance.collection('Patient');

final CollectionReference collectionSurveyor =
    FirebaseFirestore.instance.collection('Surveyor');
