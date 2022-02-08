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

  Future<String> getSelectedVillage({required String passedUID}) {
    String key = passedUID + SELECTEDVILLAGE;
    Future<String> _selectedVillage = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(key) ?? "Not Found";
    });
    return _selectedVillage;
  }
}
