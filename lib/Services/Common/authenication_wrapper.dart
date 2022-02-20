import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Common/auth_service.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/pages/Admin/main/main_screen.dart';
import 'package:medical_servey_app/pages/Surveyor/surveyor_home.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatefulWidget {
  final String adminEmail;
  AuthenticationWrapper({required this.adminEmail, Key? key}) : super(key: key);

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  @override
  Widget build(BuildContext context) {
    User? firebaseUser = context.watch<User?>();
    print("${firebaseUser?.email} userEmail");
    if (firebaseUser != null) {
      if (firebaseUser.email == widget.adminEmail) {
        return AdminHome();
      } else {
        print("AuthenticationWrapper surveyor else 25");
        return StreamBuilder<Response>(
            stream: context
                .read<FirebaseAuthService>()
                .checkValidAccount(email: firebaseUser.email!),
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.isSuccessful) {
                  return SurveyorHomePage();
                } else {
                  context.read<FirebaseAuthService>().deleteUser();
                  return LoginPage();
                }
              } else {
                return Container();
              }
            });
      }
    } else {
      return LoginPage();
    }
  }
}
