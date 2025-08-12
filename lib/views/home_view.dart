import 'package:app_prueba/services/auth_service.dart';
import 'package:flutter/material.dart';
import '../utils/functions/general.dart';
import '../models/menu_option.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  String? _username;
  String companyName = "SUNSHINE EXPORT";
  int notificationCount = 3;
  List<MenuOption> menuOptions = []; // Llénalo desde tu servicio
  int currentSliderIndex = 0;
  bool showNotificationDialog = false;
  bool showConfigDialog = false;

  @override
  void initState() {
    super.initState();
    getSavedUsername().then((username) {
      setState(() {
        _username = username;
      });
    });
    // menuOptions = await MenuService.getMenu();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SunExpert Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () async {
              try {
                await AuthService().logout();
                if (!mounted) return;
                Navigator.pushReplacementNamed(context, '/login');
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al cerrar sesión: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          _username != null
              ? '¡Hola, $_username! Bienvenido a la app base'
              : 'Bienvenido a la app base',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
