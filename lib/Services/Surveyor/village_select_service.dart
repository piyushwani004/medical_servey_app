import 'package:medical_servey_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VillageSelectService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setSelectedVillage(
      {required String passedVillage, required String passedUID}) async {
    String key = passedUID + SELECTEDVILLAGE;
    final SharedPreferences prefs = await _prefs;
    prefs.setString(key, passedVillage);
  }

  Stream<String> getSelectedVillage({required String passedUID}) async* {
    String key = passedUID + SELECTEDVILLAGE;
    // Future<String> _selectedVillage = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString(key) ?? "NA";
    // });
    final SharedPreferences prefs = await _prefs;
    String _selectedVillage = prefs.getString(key) ?? "Select";
    print("_selectedVillage::: $_selectedVillage");
    yield _selectedVillage;
  }

  Future<String> getSelectedVillageString({required String passedUID}) async {
    String key = passedUID + SELECTEDVILLAGE;
    // Future<String> _selectedVillage = _prefs.then((SharedPreferences prefs) {
    //   return prefs.getString(key) ?? "NA";
    // });
    final SharedPreferences prefs = await _prefs;
    String _selectedVillage = prefs.getString(key) ?? "";
    print("_selectedVillage String: $_selectedVillage");
    return _selectedVillage;
  }

  Future<void> setLoginDetails({
    required bool rememberMe,
    required String password,
    required String email,
  }) async {
    try {
      final SharedPreferences prefs = await _prefs;
      prefs.setBool(REMEMBER_ME, rememberMe);
      prefs.setString(EMAIL, email);
      prefs.setString(PASSWORD, password);
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, String>> getLoginDetails() async {
    Map<String, String> map = {};
    try {
      final SharedPreferences prefs = await _prefs;
      bool _getRememberMe = prefs.getBool(REMEMBER_ME) ?? false;
      String _getEmailID = prefs.getString(EMAIL) ?? "";
      String _getPassword = prefs.getString(PASSWORD) ?? "";
      map[REMEMBER_ME] = _getRememberMe.toString();
      map[EMAIL] = _getEmailID;
      map[PASSWORD] = _getPassword;
      print("getLoginDetails String: $map");
    } catch (e) {
      print(e);
    }
    return map;
  }
}
