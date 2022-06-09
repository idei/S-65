import 'package:app_salud/pages/ajustes.dart';
import 'package:app_salud/pages/ant_familiares.dart';
import 'package:app_salud/pages/ant_personales.dart';
import 'package:app_salud/pages/avisos.dart';
import 'package:app_salud/pages/datosCli_page.dart';
import 'package:app_salud/pages/form_antecedentes_familiar.dart';
import 'package:app_salud/pages/form_antecedentes_pers.dart';
import 'package:app_salud/pages/form_datos_clinicos.dart';
import 'package:app_salud/pages/form_datos_generales.dart';
import 'package:app_salud/pages/historial_clinico.dart';
import 'package:app_salud/pages/home_pag.dart';
import 'package:app_salud/pages/ibupiracejem.dart';
import 'package:app_salud/pages/ingresar_pag.dart';
import 'package:app_salud/pages/medicamento_add.dart';
import 'package:app_salud/pages/medicamentos.dart';
import 'package:app_salud/pages/menu.dart';
import 'package:app_salud/pages/menu_chequeo.dart';
import 'package:app_salud/pages/new_recordatorio_personal.dart';
import 'package:app_salud/pages/recordatorios.dart';
import 'package:app_salud/pages/recuperar_contras.dart';
import 'package:app_salud/pages/registrar_pag.dart';
import 'package:app_salud/pages/screening.dart';
import 'package:app_salud/pages/ver_screening.dart';
import 'package:app_salud/pages/screening_animo.dart';
import 'package:app_salud/pages/screening_cdr.dart';
import 'package:app_salud/pages/screening_conductual.dart';
import 'package:app_salud/pages/screening_fisico.dart';
import 'package:app_salud/pages/screening_nutricional.dart';
import 'package:app_salud/pages/screening_queja_cognitiva.dart';
import 'package:app_salud/pages/ver_recordatorio_personal.dart';
import 'package:app_salud/pages/ver_recordatorio_screening.dart';
import 'package:app_salud/pages/avisos.dart';
import 'package:app_salud/pages/ver_aviso_general.dart';
import 'package:app_salud/pages/screening_new.dart';
import 'package:app_salud/pages/list_medicos.dart';
import 'package:app_salud/pages/screening_diabetes.dart';
import 'package:app_salud/pages/screening_encro.dart';
import 'package:app_salud/pages/menuPrueba.dart';
import 'package:flutter/material.dart';

import '../pages/menuPrueba.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => HomePage(),
    'ingresar': (BuildContext context) => IngresarPage(),
    'registrar': (BuildContext context) => RegistrarPage(),
    '/menu': (BuildContext context) => MenuPage(),
    '/form_datos_generales': (context) => Formprueba(),
    '/form_datos_clinicos': (context) => FormDatosClinicos(),
    '/historial_clinico': (context) => HistorialClinico(),
    '/form_antecedentes_personales': (context) => FormAntecedentesPersonales(),
    '/antecedentes_personales': (context) => AntecedentesPerPage(),
    '/antecedentes_familiares': (context) => AntecedentesFamPage(),
    '/form_antecedentes_familiares': (context) => FormAntecedentesFamiliares(),
    '/datoscli': (BuildContext context) => DatosCli(),
    '/medicamentos': (BuildContext context) => MedicamentoPage(),
    '/medicamentosAdd': (BuildContext context) => MedicamentoAddPage(),
    '/ajustes': (BuildContext context) => AjustesPage(),
    '/ibupirac': (BuildContext context) => IbupiracPage(),
    '/recuperar': (BuildContext context) => RecuperarPage(),
    '/recordatorio': (BuildContext context) => RecordatorioPage(),
    '/avisos': (BuildContext context) => Avisos(),
    '/ver_aviso_general': (BuildContext context) => VerAvisoGeneral(),
    '/screening': (BuildContext context) => ScreeningPage(),
    '/screening_new': (BuildContext context) => NewScreening(),
    '/ver_screening': (BuildContext context) => VerScreening(),
    '/screening_queja_cognitiva': (BuildContext context) => ScreeningBPage(),
    '/screening_conductual': (BuildContext context) =>
        ScreeningConductualPage(),
    '/screening_fisico': (BuildContext context) => FormScreeningSintomas(),
    '/ver_recordatorio_screening': (BuildContext context) => VerRecordatorio(),
    '/ver_recordatorio_personal': (BuildContext context) =>
        VerRecordatorioPersonal(),
    '/screening_animo': (BuildContext context) => FormScreeningAnimo(),
    '/screening_nutricional': (BuildContext context) =>
        FormScreeningNutricional(),
    '/screening_cdr': (BuildContext context) => ScreeningCDR(),
    '/new_recordatorio_personal': (BuildContext context) =>
        RecordatorioPersonal(),
    '/menu_chequeo': (BuildContext context) => MenuChequeoPage(),
    '/list_medicos': (BuildContext context) => ListMedicos(),
    '/screening_diabetes': (BuildContext context) => ScreeningDiabetes(),
    '/screening_encro': (BuildContext context) => ScreeningEnfCronicas(),
    '/menuPrueba': (BuildContext context) => menuPrueba(),
  };
}
