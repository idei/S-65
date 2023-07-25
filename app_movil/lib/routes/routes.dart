import 'package:app_salud/pages/ajustes.dart';
import 'package:app_salud/pages/ant_familiares.dart';
import 'package:app_salud/pages/ant_personales.dart';
import 'package:app_salud/pages/avisos.dart';
import 'package:app_salud/pages/datosCli_page.dart';
import 'package:app_salud/pages/form_antecedentes_familiar.dart';
import 'package:app_salud/pages/form_antecedentes_personal.dart';
import 'package:app_salud/pages/form_datos_clinicos.dart';
import 'package:app_salud/pages/form_datos_generales.dart';
import 'package:app_salud/pages/historial_clinico.dart';
import 'package:app_salud/pages/home_pag.dart';
import 'package:app_salud/pages/ibupiracejem.dart';
import 'package:app_salud/pages/login_page.dart';
import 'package:app_salud/pages/medicamento_add.dart';
import 'package:app_salud/pages/medicamentos.dart';
import 'package:app_salud/pages/medico_perfil.dart';
import 'package:app_salud/pages/menu.dart';
import 'package:app_salud/pages/menuPrueba.dart';
import 'package:app_salud/pages/menu_chequeo.dart';
import 'package:app_salud/pages/new_recordatorio_personal.dart';
import 'package:app_salud/pages/recordatorios.dart';
import 'package:app_salud/pages/recuperar_contras.dart';
import 'package:app_salud/pages/register_page.dart';
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
import 'package:app_salud/pages/ver_aviso_general.dart';
import 'package:app_salud/pages/screening_new.dart';
import 'package:app_salud/pages/list_medicos.dart';
import 'package:app_salud/pages/screening_diabetes.dart';
import 'package:app_salud/pages/screening_encro.dart';
import 'package:flutter/material.dart';

Map<String, WidgetBuilder> getApplicationRoutes() {
  return <String, WidgetBuilder>{
    '/': (context) => HomePage(),
    'ingresar': (context) => LoginPage(),
    'registrar': (context) => RegisterPage(),
    //'/menu': (context) => MenuPrueba(),
    '/menu': (context) => MenuPage(),
    '/form_datos_generales': (context) => FormDatosGenerales(),
    '/form_datos_clinicos': (context) => FormDatosClinicos(),
    '/historial_clinico': (context) => HistorialClinico(),
    '/form_antecedentes_personales': (context) => FormAntecedentesPersonales(),
    '/antecedentes_personales': (context) => AntecedentesPerPage(),
    '/antecedentes_familiares': (context) => AntecedentesFamiliarPage(),
    '/form_antecedentes_familiares': (context) => FormAntecedentesFamiliares(),
    '/datoscli': (context) => DatosClinicos(),
    '/medicamentos': (context) => MedicamentoPage(),
    '/medicamentosAdd': (context) => MedicamentoAddPage(),
    '/ajustes': (context) => AjustesPage(),
    '/ibupirac': (context) => IbupiracPage(),
    '/recuperar': (context) => RecuperarPage(),
    '/recordatorio': (context) => RecordatorioPage(),
    '/avisos': (context) => Avisos(),
    '/ver_aviso_general': (context) => VerAvisoGeneral(),
    '/screening': (context) => ScreeningPage(),
    '/screening_new': (context) => NewScreening(),
    '/ver_screening': (context) => VerScreening(),
    '/screening_queja_cognitiva': (context) => ScreeningBPage(),
    '/screening_conductual': (context) => ScreeningConductualPage(),
    '/screening_fisico': (context) => FormScreeningSintomas(),
    '/ver_recordatorio_screening': (context) => VerRecordatorio(),
    '/ver_recordatorio_personal': (context) => VerRecordatorioPersonal(),
    '/screening_animo': (context) => FormScreeningAnimo(),
    '/screening_nutricional': (context) => ScreeningNutricional(),
    '/screening_cdr': (context) => ScreeningCDR(),
    '/new_recordatorio_personal': (context) => RecordatorioPersonal(),
    '/menu_chequeo': (context) => MenuChequeoPage(),
    '/list_medicos': (context) => ListMedicos(),
    '/screening_diabetes': (context) => ScreeningDiabetes(),
    '/screening_encro': (context) => ScreeningEnfCronicas(),
    '/medico_perfil': (context) => MedicoPerfil(),
  };
}
