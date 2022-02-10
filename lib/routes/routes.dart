import 'package:flutter/material.dart';
import 'package:medical_servey_app/main.dart';
import 'package:medical_servey_app/pages/Admin/add_diseases.dart';
import 'package:medical_servey_app/pages/Admin/generate_report.dart';
import 'package:medical_servey_app/pages/Admin/main/main_screen.dart';
import 'package:medical_servey_app/pages/Admin/patient_admin_update.dart';
import 'package:medical_servey_app/pages/Admin/surveyor_update.dart';
import 'package:medical_servey_app/pages/Admin/new_surveyor_form.dart';
import 'package:medical_servey_app/pages/Surveyor/SurveyorProfile.dart';
import 'package:medical_servey_app/pages/Surveyor/add_patient.dart';
import 'package:medical_servey_app/pages/Surveyor/patient_List.dart';
import 'package:medical_servey_app/pages/Surveyor/surveyor_home.dart';
import 'package:medical_servey_app/pages/auth/login.dart';
import 'package:page_transition/page_transition.dart';

const routeStart = '/';
const routeLogin = '/login';
const routeAdminHome = '/adminHome';
const routeAdminAddSurveyor = '/adminAddSurveyor';
const routeHome = '/home';
const routeAddDiseases = '/AddDisease';
const routeSurveyorListForUpdate = '/SurveyorListForUpdate';
const routeGenerateReport = '/GenerateReport';

const routeAddPatient = '/AddPatient';
const routeUpdatePatient = '/UpdatePatient';
const routeSurveyorProfile = '/SurveyorProfile';
const routeAdminUpdatePatient = '/AdminUpdatePatient';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      //admin
      case routeLogin:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: MyApp());
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
            type: PageTransitionType.rightToLeft,
            child: SurveyorListForUpdate());
      case routeAddDiseases:
        //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: AddDiseases());
      case routeAdminUpdatePatient:
        //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft,
            child: PatientUpdateAdminForUpdate());
      case routeGenerateReport:
        //Map mapData = settings.arguments;
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: GenerateReport());

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
      case routeSurveyorProfile:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: SurveyorProfie());
      default:
        return PageTransition(
            type: PageTransitionType.rightToLeft, child: LoginPage());
    }
  }
}
