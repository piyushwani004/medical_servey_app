import 'package:medical_servey_app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VillageSelectService {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<void> setSelectedVillage({required String passedVillage}) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setString(SELECTEDVILLAGE, passedVillage);
  }

  Future<String> getSelectedVillage() {
    Future<String> _selectedVillage = _prefs.then((SharedPreferences prefs) {
      return prefs.getString(SELECTEDVILLAGE) ?? "";
    });
    return _selectedVillage;
  }
}
