import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const String TRUST_NAME = "Trust Name";
const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const kPrimaryColor = Color(0xFFFE4350);

const scafoldbBackgroundColor = Color.fromRGBO(234, 242, 255, 1.0);

const blueshGradientOne = Color(0xFF2C90C4);
const blueshGradientTwo = Color(0xFF31CCB0);

const iconColor = Color.fromARGB(255, 0, 0, 0);

const defaultPadding = 16.0;

const DEF_SEC_FB = '123456789!@#&*()';

const SELECTEDVILLAGE = 'SelectedVillage';

final CollectionReference collectionDisease =
    FirebaseFirestore.instance.collection('Diseases');

final CollectionReference collectionPatient =
    FirebaseFirestore.instance.collection('Patient');

final CollectionReference collectionSurveyor =
    FirebaseFirestore.instance.collection('Surveyor');
