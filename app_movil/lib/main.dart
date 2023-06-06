import 'package:app_salud/services/medico_services.dart';
import 'package:app_salud/services/usuario_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_salud/routes/routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => new UsuarioServices()),
        ChangeNotifierProvider(create: (_) => new MedicoServices()),
      ],
      child: MaterialApp(
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
        initialRoute: '/',
        routes: getApplicationRoutes(),
      ),
    );
  }
}
