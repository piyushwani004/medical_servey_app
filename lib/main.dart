import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Admin/add_diseases.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddDiseases(),
    );
  }
}
