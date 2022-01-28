import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/routes/routes.dart';
import 'package:provider/provider.dart';

import 'Services/Admin/admin_firebase_service.dart';
import 'Services/Common/MenuController.dart';
import 'Services/Common/auth_service.dart';
import 'Services/Common/authenication_wrapper.dart';

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
  AdminFirebaseService _adminFirebaseService = AdminFirebaseService();
  String adminEmail = await _adminFirebaseService.getAdminEmail();
  runApp(MyApp(adminEmail));
}

class MyApp extends StatefulWidget {
  final String adminEmail;
  MyApp(this.adminEmail);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medical Survey',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: Routes.generateRoute,
      home: MultiProvider(providers: [
        Provider<FirebaseAuthService>(
            create: (_) => FirebaseAuthService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) =>
              context.read<FirebaseAuthService>().authStateChanges,
          initialData: null,
        ),
      ], child: AuthenticationWrapper(adminEmail: widget.adminEmail,)),
    );
  }
}
