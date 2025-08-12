import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginView extends StatefulWidget {
  @override
  State<LoginView> createState() => _LoginViewState();
}
class _LoginViewState extends State<LoginView> {
  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  Future<void> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      // Ya hay sesión, redirige a home
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/home');
      });
    }
  }
  final _userController = TextEditingController();
  final _passController = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;
  String? _error;
  bool _showChangePassword = false;
  //Map<String, dynamic>? _user;

  final AuthService _authService = AuthService();

  Future<void> _login() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final username = _userController.text.trim();
    final password = _passController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _loading = false;
        _error = "Ingrese usuario y contraseña";
      });
      return;
    }

    bool loginOk = await _authService.login(username, password);

    setState(() {
      _loading = false;
      if (loginOk) {
        print("Login exitoso para $username");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _error = "Credenciales incorrectas o cambio de contraseña requerido";
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            width: 350,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      'SunExpert',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  "Ingrese sus Credenciales",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _userController,
                  decoration: InputDecoration(
                    labelText: "Nombre de Usuario",
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showPassword = !_showPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _login(),
                ),
                SizedBox(height: 16),
                if (_error != null)
                  Text(
                    _error!,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _login,
                    child: _loading
                        ? CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text("Iniciar Sesión"),
                  ),
                ),
                if (_showChangePassword)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      "Debes cambiar tu contraseña.",
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
