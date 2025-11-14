import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/departamento_service.dart';
import 'services/genero_service.dart';
import 'services/grupo_conviviente_service.dart';
import 'services/medico_services.dart';
import 'services/nivel_educativo_service.dart';
import 'services/session_service.dart';
import 'services/usuario_services.dart';
import 'routes/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UsuarioServices()),
        ChangeNotifierProvider(create: (_) => MedicoServices()),
        ChangeNotifierProvider(create: (_) => DepartamentoServices()),
        ChangeNotifierProvider(create: (_) => GeneroServices()),
        ChangeNotifierProvider(create: (_) => NivelEducativoService()),
        ChangeNotifierProvider(create: (_) => GrupoConvivienteServices()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: WillPopScope(
        onWillPop: () async {
          // Aquí puedes añadir la lógica específica de tu aplicación.
          return Future.value(true);
        },
        child: MaterialApp(
          key: UniqueKey(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
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
          routes: getApplicationRoutes(),
        ),
      ),
    );
  }
}
