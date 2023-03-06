<?php

include __DIR__ . '/db.php';
include __DIR__ . '/functions.php';

// *** Rutas Sitio Web Doctor
Flight::route('/', 'index' );

// Login Doctor  ----------------------------------------------------------
Flight::route('POST /login', 'login_doctor');


// Read Pacientes  ----------------------------------------------------------
Flight::route('POST /pacientes', 'read_pacientes');

// Read Antecedentes Familiares
Flight::route('POST /antecedentes_familiares', 'read_antecedentes_familiares');

// Read Antecedentes Personales
Flight::route('POST /antecedentes_personales', 'read_antecedentes_personales');

// Read Datos Clinicos
Flight::route('POST /datos_clinicos', 'read_datos_clinicos');

// Read Datos Personales
Flight::route('POST /datos_personales', 'read_datos_personales');

// Read Chequeos
Flight::route('POST /chequeos', 'read_tipos_chequeos');

// Read Chequeos Medico Paciente
Flight::route('POST /chequeos_medico_paciente', 'chequeos_medico_paciente');

// Read Todos los Chequeos del medico
Flight::route('POST /chequeos_medico', 'get_chequeos');

// Read Departamentos o Generos
Flight::route('POST /deptos_generos', 'read_deptos_generos');

// Read Avisos
Flight::route('POST /avisos', 'read_avisos');

// Read Avisos por criterios
Flight::route('POST /avisos_criterios', 'get_criterios');

// Read un solo Aviso
Flight::route('POST /aviso', 'read_aviso');

// Read Recordatorios del paciente
Flight::route('POST /recordatorios', 'read_recordatorios');

// Read Recordatorios relacionados con el medico
Flight::route('POST /recordatorios_medicos', 'read_recordatorios_medico');


// *** Rutas App Movil Paciente

// Login Paciente  ----------------------------------------------------------
Flight::route('POST /login_paciente', 'login_paciente');

// Read Antecedentes Personales Paciente
Flight::route('POST /antecedentes_personales_paciente', 'antecedentes_personales_paciente');

// Read Antecedentes Familiares Paciente
Flight::route('POST /antecedentes_familiares_paciente', 'antecedentes_familiares_paciente');

// Read Respuestas Datos Clinicos
Flight::route('POST /respuesta_datos_clinicos', 'respuesta_datos_clinicos');

// Read Medicamentos
Flight::route('POST /medicamentos','medicamentos_paciente');

// Read Medicamentos Vademecum
Flight::route('POST /medicamentos_vademecum','medicamentos_paciente_vademecum');

// Save Dosis de Medicamento
Flight::route('POST /save_dosis_frecuencia','save_dosis_frecuencia');

// Delete Medicamento de lista
Flight::route('POST /delete_medicamento','delete_medicamento');

// Save Medicamento de lista
Flight::route('POST /save_medicamento','save_medicamento');

// Read Avisos Pacientes
 Flight::route('POST /avisos_paciente','avisos_paciente');

 // Update Aviso
 Flight::route('POST /update_estado_aviso','update_estado_aviso');

 // Update Recordatorio Personal
 Flight::route('POST /update_recordatorio_personal','update_recordatorio_personal');

  // New Recordatorio Personal
  Flight::route('POST /new_recordatorio_personal','new_recordatorio_personal');
 
 
// Read Tipo de Screening
Flight::route('POST /read_tipo_screening','read_tipo_screening');

// Respuesta Screening Fisico
Flight::route('POST /respuesta_screening_fisico','respuesta_screening_fisico');

// Respuesta Screening Animo
Flight::route('POST /respuesta_screening_animo','respuesta_screening_animo');

// Respuesta Screening CDR
Flight::route('POST /respuesta_screening_cdr','respuesta_screening_cdr');

// Save Screening CDR
Flight::route('POST /tipo_respuesta_conductual','tipo_respuesta_conductual');

// Save Screening Nutricional
Flight::route('POST /respuesta_screening_nutricional','respuesta_screening_nutricional');

// Read tipo de respuesta quejas
Flight::route('POST /tipo_respuesta_quejas','tipo_respuesta_quejas');

// Read tipo de respuesta CDR
Flight::route('POST /tipo_respuesta_cdr','tipo_respuesta_cdr');

// Register User
Flight::route('POST /user_register','user_register');

// Read All Screenings
Flight::route('POST /screenings','screenings');

// read_code_screening
Flight::route('POST /read_code_screening','read_code_screening');

// Read Screenings
Flight::route('POST /read_screenings','read_screenings');

// Read Antecedentes Familiares
Flight::route('POST /user_read_antc_familiares','user_read_antc_familiares');

// Save Antecedentes Familiares
Flight::route('POST /save_antec_familiares','save_antec_familiares');

// Read Antecedentes Personales
Flight::route('POST /user_read_antc_personales','user_read_antc_personales');

// Save Antecedentes Personales
Flight::route('POST /save_antec_personales','save_antec_personales');

// Save Antecedentes Personales
Flight::route('POST /save_datos_clinicos','save_datos_clinicos');

// Save Antecedentes Personales
Flight::route('POST /save_datos_personales','save_datos_personales');

// Read Respuestas
Flight::route('POST /respuesta','respuesta');

// Read Respuestas
Flight::route('POST /read_list_medicos','read_list_medicos');

// Consult Preference
Flight::route('POST /consult_preference','consult_preference');

// Generate Vinculation
Flight::route('POST /generate_vinculation','generate_vinculation');

// Read Medico
Flight::route('POST /read_medico','read_medico');

// Modificar Email
Flight::route('POST /modificar_email','modificar_email');

// Modificar Pass
Flight::route('POST /modificar_pass','modificar_pass');

// Recuperar Pass
Flight::route('POST /recuperar_pass','recuperar_pass');


// --------------------------------------------------------------------------

Flight::start();
