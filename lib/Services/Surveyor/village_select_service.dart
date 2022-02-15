import 'package:medical_servey_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VillageSelectService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setSelectedVillage({
    required String passedVillage,
    required String passedTaluka,
    required String passedUID,
  }) async {
    String keyVillage = passedUID + SELECTEDVILLAGE;
    String keyTaluka = passedUID + SELECTEDVILLAGE;
    final SharedPreferences prefs = await _prefs;
    prefs.setString(keyVillage, passedVillage);
    prefs.setString(keyTaluka, passedTaluka);
  }

  Stream<String> getSelectedVillage({required String passedUID}) async* {
    String keyVillage = passedUID + SELECTEDVILLAGE;
    // Future<String> _selectedVillage = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString(key) ?? "NA";
    // });
    final SharedPreferences prefs = await _prefs;
    String _selectedVillage = prefs.getString(keyVillage) ?? "Select";
    print("_selectedVillage::: $_selectedVillage");
    yield _selectedVillage;
  }

  Future<Map<String, String>> getSelectedVillageString(
      {required String passedUID}) async {
    Map<String, String> map = {};
    String keyVillage = passedUID + SELECTEDVILLAGE;
    String keyTaluka = passedUID + SELECTEDVILLAGE;

    final SharedPreferences prefs = await _prefs;

    String _selectedVillage = prefs.getString(keyVillage) ?? "";
    String _selectedTaluka = prefs.getString(keyTaluka) ?? "";
    print(
        "_selected Village and Taluka String: $_selectedVillage   $_selectedTaluka");

    map['$SELECTEDVILLAGE'] = _selectedVillage;
    map['$SELECTEDTALUKA'] = _selectedTaluka;

    return map;
  }
}
