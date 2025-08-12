import 'package:app_prueba/views/home_view.dart';
import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(); // Carga las variables de entorno
   runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginView(),
    routes: {
      '/home': (context) => HomeView(),
      '/login': (context) => LoginView(), 
    },
  ));
}