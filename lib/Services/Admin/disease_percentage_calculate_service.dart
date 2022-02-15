import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';

class DiseasePercentageCalculateService {
  AdminFirebaseService adminFirebaseService = AdminFirebaseService();

  Future<Map<String, double>> calculatePercentageOfAllDisease() async {
    Map<String, double> freqDisease = {};
    Map<String, double> perDisease = {};
    int totalPatients;
    List<Patient> patients = await adminFirebaseService.getPatients();
    //getting count of total patients
    totalPatients = patients.length;
    //calculating freq
    for (Patient pat in patients) {
      for (String dis in pat.diseases) {
        //if freq has disease name increase its count
        if ((freqDisease.keys.toList()).contains(dis)) {
          freqDisease[dis] = (freqDisease[dis]! + 1);
        } else {
          ////if freq don't have disease name init its count to 1
          freqDisease[dis] = 1;
        }
      }
      // listOfDisease.addAll(pat.diseases);
    }
    print("$freqDisease --freqDisease");

    //calculating percentage
    for (String dis in freqDisease.keys) {
      perDisease[dis] = (freqDisease[dis]! / totalPatients) * 100;
    }
    print("$perDisease --perDisease");
    return perDisease;
  }
}
