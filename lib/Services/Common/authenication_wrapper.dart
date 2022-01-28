import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/pages/Admin/main/main_screen.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  AdminFirebaseService _adminFirebaseService = AdminFirebaseService();
  @override
  void initState() {
    _adminFirebaseService.getAdminEmail().then((value) {
      print("Email $value");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    return firebaseUser != null ? AdminHome() : LoginPage();
  }
}
