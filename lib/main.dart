import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Surveyor/surveyor_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      home: SurveyorHomePage(),
    );
  }
}
