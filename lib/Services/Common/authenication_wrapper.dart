import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/pages/Admin/main/main_screen.dart';
import 'package:medical_servey_app/pages/Surveyor/surveyor_home.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  AdminFirebaseService _adminFirebaseService = AdminFirebaseService();
  String? adminEmail;
  @override
  void initState() {
    _adminFirebaseService.getAdminEmail().then((value) {
      adminEmail = value;
      print("Email $value");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if(firebaseUser != null){
      if(firebaseUser.email == adminEmail){
        return AdminHome();
      }else{
        return SurveyorHomePage();
      }
    }else{
      return LoginPage();
    }
  }
}
