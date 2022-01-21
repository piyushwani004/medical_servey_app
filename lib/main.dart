import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Admin/new_surveyor_form.dart';
import 'package:medical_servey_app/pages/auth/login.dart';

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
      home: NewSurveyorForm(),
    );
  }
}
