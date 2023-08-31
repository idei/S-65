import 'package:app_salud/pages/home_pag.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simula un tiempo de espera (por ejemplo, carga de recursos)
    Future.delayed(Duration(seconds: 5), () {
      _navigateToHome(); // Navegar a la página de inicio
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomePage()), // Reemplazar con tu página de inicio
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Image.asset('assets/logo1.png'),
              height: 110.0,
            ),
            SpinKitCircle(
              // Indicador de carga
              color: Colors.blue, // Color del indicador
              size: 50.0, // Tamaño del indicador
            ),
            SizedBox(height: 10.0),
            // Text(
            //   "Cargando...",
            //   style: TextStyle(fontSize: 10),
            // )
          ],
        ),
      ),
    );
  }
}
