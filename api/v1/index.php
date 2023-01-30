<?php

include __DIR__ . '/db.php';
include __DIR__ . '/functions.php';


Flight::route('/', 'index' );

// Login Doctor  ----------------------------------------------------------
Flight::route('POST /login', 'login_doctor');

// Login Doctor  ----------------------------------------------------------
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

Flight::start();
