import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Admin/admin_home.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:provider/provider.dart';
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    return firebaseUser!=null? const AdminHomePage(): LoginPage();
  }
}
