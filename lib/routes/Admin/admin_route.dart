import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Admin/admin_home.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:page_transition/page_transition.dart';

const routeLogin = '/login';
const routeAdminHome = '/adminHome';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeLogin:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginPage());
      case routeAdminHome:
        //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AdminHomePage());
      default:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginPage());
    }
  }
}
