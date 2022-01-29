import 'package:flutter/material.dart';
import 'package:medical_servey_app/pages/Admin/main/main_screen.dart';
import 'package:medical_servey_app/pages/Admin/main/surveyor_update.dart';
import 'package:medical_servey_app/pages/Admin/new_surveyor_form.dart';
import 'package:medical_servey_app/pages/Surveyor/add_patient.dart';
import 'package:medical_servey_app/pages/Surveyor/patient_List.dart';
import 'package:medical_servey_app/pages/Surveyor/surveyor_home.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:page_transition/page_transition.dart';

const routeLogin = '/login';
const routeAdminHome = '/adminHome';
const routeAdminAddSurveyor = '/adminAddSurveyor';
const routeHome = '/home';

const routeAddPatient = '/AddPatient';
const routeUpdatePatient = '/UpdatePatient';
const routeSurveyorListForUpdate = '/SurveyorListForUpdate';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      //admin
      case routeLogin:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginPage());
      case routeAdminHome:
        //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AdminHome());
      case routeAdminAddSurveyor:
      //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: NewSurveyorForm());
      case routeSurveyorListForUpdate:
      //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: SurveyorListForUpdate());


      //Surveyor
      case routeHome:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: SurveyorHomePage());
      case routeAddPatient:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddPatientForm());
      case routeUpdatePatient:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: PatientList());
      default:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginPage());
    }
  }



}
