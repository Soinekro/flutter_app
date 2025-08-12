import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/functions/encrypt.dart' as encrypt;

class AuthService {
  final String baseUrl =
      dotenv.env['API_URL'] != null ? '${dotenv.env['API_URL']!}/account/' : '';
  final String cKey = dotenv.env['C_KEY'] ?? '';
  final String cVec = dotenv.env['C_VEC'] ?? '';

  Future<bool> login(String username, String password) async {
    // Cifrar la contraseña
    String encryptedPassword = encrypt.encrypt(password);
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}Login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'UsrName': username,
          'UsrPassword': encryptedPassword,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Login response: $data");
        final prefs = await SharedPreferences.getInstance();
        final keepKeys = [
          "recordateFilters",
          "processInitial",
          "notFireWorks",
          "animate5Years",
          "filterDoll"
        ];
        Map<String, String> preserved = {};
        for (var key in keepKeys) {
          if (prefs.containsKey(key)) {
            preserved[key] = prefs.getString(key)!;
          }
        }
        await prefs.clear();
        for (var key in preserved.keys) {
          await prefs.setString(key, preserved[key]!);
        }

        await prefs.setString("token", data['token']);
        await prefs.setString("UsrID", data['user']['UsrID'].toString());
        await prefs.setString("UsrName", data['user']['UsrName']);
        await prefs.setBool("isIdle", false);
        int tokenRefresh = (data['tokenRefresh'] ?? 10) as int;
        await prefs.setInt("TimeToken", tokenRefresh * 60000 - 60000);
        await prefs.setInt("TimeTokenCount", tokenRefresh * 60000 - 60000);
        final value =data['user']['UsrPasswordChange'] == 0;
        print('changepassword: $value');
        // Devuelve true si no requiere cambio de contraseña, false si requiere
        return data['user']['UsrPasswordChange'] == 0;
      } else {
        return false;
      }
    } catch (e) {
      print("Error de conexión: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final usrName = prefs.getString("UsrName");
      print("Cerrando sesión de $usrName");
      final token = prefs.getString("token") ?? "";

      // Borra primero los datos locales
      await prefs.remove("token");
      await prefs.remove("UsrName");
      await prefs.remove("UsrID");
      await prefs.remove("isIdle");
      // ...otros datos si es necesario

      // Luego intenta avisar al backend (esto puede fallar, pero ya limpiaste local)
      if (usrName != null && usrName.isNotEmpty) {
        await http.post(
          Uri.parse('${baseUrl}Logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'UsrID': int.tryParse(prefs.getString("UsrID") ?? '0') ?? 0,
            'UsrName': usrName,
          }),
        );
      }
    } catch (e) {
      print("Error al cerrar sesión: $e");
      // Puedes mostrar un mensaje de error si quieres
    }
  }

  Future<void> initialize(int usrID) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}ApplicationUserInitialize/$usrID'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString("token") ?? ""}',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setString("UsrEmail", data['UsrEmail'] ?? '');
        await prefs.setString("UsrFullName", data['UsrFullName'] ?? '');
        await prefs.setString("CompanyName", data['CompanyName'] ?? '');
        await prefs.setString("CompanyLogo", data['CompanyLogo'] ?? '');
        await prefs.setString("UsrPhoto", data['UsrPhoto'] ?? '');
        await prefs.setInt("UsrType", data['UsrType'] ?? 0);
        await prefs.setInt("CompanyID", data['CompanyID'] ?? 0);
        await prefs.setInt("ProfileID", data['ProfileID'] ?? 0);
        await prefs.setString("ProfileName", data['ProfileName'] ?? '');
      } else {
        print("Error al inicializar: ${response.statusCode}");
      }
    } catch (e) {
      print("Error de conexión: $e");
    }
  }
}
