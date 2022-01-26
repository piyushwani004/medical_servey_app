import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Surveyor/surveyor_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const firebaseConfig = FirebaseOptions(
      apiKey: "AIzaSyAuX_K_41nxsW4R-zuTJXqurNY4qdIuBQc",
      authDomain: "medicalsurvey-171ca.firebaseapp.com",
      projectId: "medicalsurvey-171ca",
      storageBucket: "medicalsurvey-171ca.appspot.com",
      messagingSenderId: "566586934466",
      appId: "1:566586934466:web:48fab48e87e92718b5e75b",
      measurementId: "G-HDG71K05K2");

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: firebaseConfig,
    );
  } else {
    await Firebase.initializeApp();
  }
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
