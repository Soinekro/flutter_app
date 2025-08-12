import 'package:shared_preferences/shared_preferences.dart';


Future<String?> getSavedUsername() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('UsrName');
}