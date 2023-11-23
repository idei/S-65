import 'package:app_salud/services/departamento_service.dart';
import 'package:app_salud/services/genero_service.dart';
import 'package:app_salud/services/grupo_conviviente_service.dart';
import 'package:app_salud/services/medico_services.dart';
import 'package:app_salud/services/nivel_educativo_service.dart';
import 'package:app_salud/services/session_service.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_salud/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new UsuarioServices()),
        ChangeNotifierProvider(create: (_) => new MedicoServices()),
        ChangeNotifierProvider(create: (_) => new DepartamentoServices()),
        ChangeNotifierProvider(create: (_) => new GeneroServices()),
        ChangeNotifierProvider(create: (_) => new NivelEducativoService()),
        ChangeNotifierProvider(create: (_) => new GrupoConvivienteServices()),
        ChangeNotifierProvider(create: (_) => new AuthProvider()),
      ],
      child: WillPopScope(
        onWillPop: () async {
          return true; // Cambia esto según tu lógica.
        },
        child: MaterialApp(
          key: UniqueKey(),
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          supportedLocales: [
            const Locale('es', 'ES'),
          ],
          theme: ThemeData(
            primaryColor: Colors.blue,
            textTheme: TextTheme(
              headline1: TextStyle(
                color: Colors.white,
                fontFamily: 'NunitoR',
                fontSize: 16.0,
              ),
            ),
          ),
          debugShowCheckedModeBanner: false,
          initialRoute: '/splash',
          //initialRoute: '/screening_cerebral',
          routes: getApplicationRoutes(),
        ),
      ),
    );
  }
}
