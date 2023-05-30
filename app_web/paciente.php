<?php
include (__DIR__."/env.php");

session_start();

if (isset($_POST['id_paciente'])) {
$id_paciente = $_POST["id_paciente"];
}

$id_medico = $_SESSION["id_medico"];

$rutaRaiz = Env::$_URL_API;

?>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>S-65 | Médico</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet"
    href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <!-- <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css"> -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">

  <!-- overlayScrollbars -->
  <link rel="stylesheet" href="plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/adminlte.min.css">
</head>
<style>
  .modal-lg {
    max-width: 80%;
  }
</style>

<body class="hold-transition sidebar-mini layout-fixed" onload="leerInformacionPaciente()">
  <div class="wrapper">

    <?php include('./templates/navbar_template.php'); ?>

    <?php include('./templates/sidebar_template.php'); ?>

    <div class="content-wrapper">
</br>
      <!-- Content Header (Page header) -->
      <?php
      $titulo = "";
     // include('./templates/content_header.php');
      ?>

      <!-- Main content -->
      <section class="content" >
        <!-- <div class="d-flex" id="wrapper"> -->
        <!-- Page content-->
        <div class="callout callout-info">
          <div class="row">
            <div id="content_paciente" class="col-6">
              <h4>Datos de Paciente</h4>
              <div id="nombre"></div>
              <div id="dni"></div>
              <div id="contacto"></div>
              <div id="depto"></div>
              </br>
              <h4>Últimos Datos Clínicos</h4>
              <div id="peso"></div>
              <div id="presionA"></div>
              <div id="presionB"></div>
              <div id="pulso"></div>
              <div id="circun"></div>
              <div id="alcohol"></div>
              <div id="fuma"></div>
              <div id="mari"></div>
              <div id="otras"></div>
            </div>
            <div class="col-6 text-center">

              <div class="col align-self-center">
                <button type="button" onclick="antecedentesP()" class="btn btn-block btn-info btn-flat text-uppercase"
                  data-toggle="modal" data-target="#modalMedico">Antecedentes Médicos</button>
              </div>
              <br>
              <div class="col align-self-center">
                <button type="button" onclick="antecedentesF()" class="btn btn-block btn-info btn-flat text-uppercase"
                  data-toggle="modal" data-target="#modalFamiliar">Antecedentes Familiares</button>
              </div>
              <br>
              <div class="col align-self-center">
                  <button onclick="read_nombre_chequeos();" class="btn btn-block btn-info btn-flat text-uppercase"
                  data-toggle="modal" data-target="#nuevochequeoModal">Enviar Chequeo</button>
              </div>
              <br>
              <div class="col align-self-center">
                <button class="btn btn-block btn-info btn-flat text-uppercase"
                  onclick="$('#nuevoAvisoModal').modal('show')">Enviar Aviso</button>
              </div>
              <br>
              <div class="col align-self-center">
                <button class="btn btn-block btn-info btn-flat text-uppercase" type="button" data-toggle="modal"
                  onclick="datos_historicos_clinicos()" data-target="#clinicoHistorico">Datos clinicos
                  historicos</button>
              </div>

              <br>
              <div class="col align-self-center">
                <button class="btn btn-block btn-info btn-flat text-uppercase" type="button" data-toggle="modal"
                  onclick="read_medicamentos_paciente()" data-target="#planfarmacologico">Plan Farmacológico</button>
              </div>

            </div>
          </div>
          </br>
          <div class="row">
            <h4>Chequeos del Paciente</h4>
            <table class="table table-striped">
              <thead>
                <tr>
                  <th scope="col"></th>
                  <th scope="col">Tipo de Chequeo</th>
                  <th scope="col">Fecha de Envío</th>
                  <th scope="col">Fecha Límite</th>
                  <th scope="col">Estado</th>
                  <th scope="col"></th>
                </tr>
              </thead>
              <tbody id="tabla">
              </tbody>
            </table>
          </div>
          <hr>
          <div class="container" style="margin: 30px;">

            <div class="modal fade" id="modalMedico" tabindex="-1" role="dialog"
              aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Antecedentes Médicos</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <div id="resultado_personales"></div>
                    <div id="retraso"></div>
                    <div id="desorden"></div>
                    <div id="deficit"></div>
                    <div id="lesiones_cabeza"></div>
                    <div id="lesiones_espalda"></div>
                    <div id="infecciones"></div>
                    <div id="toxinas"></div>
                    <div id="acv"></div>
                    <div id="demencia"></div>
                    <div id="parkinson"></div>
                    <div id="epilepsia"></div>
                    <div id="esclerosis"></div>
                    <div id="huntington"></div>
                    <div id="depresion"></div>
                    <div id="trastorno"></div>
                    <div id="esquizofrenia"></div>
                    <div id="enfermedad_desorden"></div>
                    <div id="intoxicaciones"></div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Aceptar</button>
                  </div>
                </div>
              </div>
            </div>
            <div class="modal fade" id="modalFamiliar" tabindex="-1" role="dialog"
              aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
              <div class="modal-dialog modal-dialog-centered" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Antecedentes Familiares</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                      <span aria-hidden="true">&times;</span>
                    </button>
                  </div>
                  <div class="modal-body">
                    <div id="resultado_familiares"></div>
                    <div id="retraso"></div>
                    <div id="desorden"></div>
                    <div id="deficit"></div>
                    <div id="lesiones_cabeza"></div>
                    <div id="lesiones_espalda"></div>
                    <div id="infecciones"></div>
                    <div id="toxinas"></div>
                    <div id="acv"></div>
                    <div id="demencia"></div>
                    <div id="parkinson"></div>
                    <div id="epilepsia"></div>
                    <div id="esclerosis"></div>
                    <div id="huntington"></div>
                    <div id="depresion"></div>
                    <div id="trastorno"></div>
                    <div id="esquizofrenia"></div>
                    <div id="enfermedad_desorden"></div>
                    <div id="intoxicaciones"></div>
                    <div id="cancer"></div>
                    <div id="cirujia"></div>
                    <div id="trasplante"></div>
                    <div id="hipotiroidismo"></div>
                    <div id="cardiologico"></div>
                    <div id="diabetes"></div>
                    <div id="hipertension"></div>
                    <div id="colesterol"></div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Aceptar</button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <br>


      </section>
      <!-- /.content -->

    </div>
    <!-- Control Sidebar -->
    <aside class="control-sidebar control-sidebar-dark">
      <!-- Control sidebar content goes here -->
    </aside>
    <!-- /.control-sidebar -->
  </div>

  <?php include('./templates/footer_template.php'); ?>

  <script>
    function leerInformacionPaciente() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      leerChequeosPacientes();
      var settings = {
        "url": rootRaiz + "/datos_personales",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };

      $('#content_paciente').html('<div class="loading"><img src="dist/img/loading.gif" alt="loading" /><br/>Un momento, por favor...</div>');

      $.ajax(settings).done(function (response) {
            if (response['status'] == "Success") {
          $('#content_paciente').fadeIn(4000).html('<h4>Datos de Paciente</h4><div id="nombre"></div><div id="dni"></div><div id="contacto"></div> <div id="depto"></div> </br> <h4>Últimos Datos Clínicos</h4> <div id="peso"></div> <div id="presionA"></div> <div id="presionB"></div> <div id="pulso"></div> <div id="circun"></div> <div id="alcohol"></div> <div id="fuma"></div> <div id="mari"></div> <div id="otras"></div> </div>');

          var response = response['data'];
          var nombre = "Nombre y Apellido: " + response['nombre'] + " " + response['apellido']
          var dni = "DNI: " + response['dni']
          var contacto = "Contacto: " + response['contacto']
          $("#nombre").html(nombre);
          $('#dni').html(dni)
          $('#contacto').html(contacto);
          $('#depto').html(depto)
          var peso = "Peso: " + response['peso']
          var presionA = "Presión alta: " + response['presion_alta']
          var presionB = "Presión baja: " + response['presion_baja']
          var pulso = "Pulso: " + response['pulso']
          var circun = "Circunferencia de la cintura: " + response['circunferencia_cintura']
          var fuma = "Fuma: " + response['fuma_tabaco']
          var marihuana = "Consume Marihuana: " + response['consume_marihuana']
          var alcohol = "Consume Alcohol: " + response['consume_alcohol']
          var otras = "Otras drogas: " + response['otras_drogas']
          $("#peso").html(peso);
          $('#presionA').html(presionA)
          $('#presionB').html(presionB)
          $('#pulso').html(pulso);
          $('#circun').html(circun)
          $('#fuma').html(fuma)
          $('#mari').html(marihuana)
          $('#alcohol').html(alcohol)
          $('#otras').html(otras)

        } else {
          if (response['status'] == "Vacio") {

            $("#nombre").html('No hay datos personales registrados');
          }
        }
      });

    }

    function leerChequeosPacientes() {
      var estado;
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      var settings = {
        "url": rootRaiz + "/chequeos_medico_paciente",
        "method": "POST",
        "data": JSON.stringify({
          "id_medico": "<?php echo $id_medico; ?>",
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };

      $.ajax(settings).done(function (response) {

        if (response['status'] == "Success") {
          response['data'].forEach(element => {
            console.log(element['nombre_estado']);
            if (element['nombre_estado'] == "Respondido") {
              estado = '';
            } else {
              if (element['nombre_estado'] == "Enviado") {
                estado = 'disabled';
              }
            }
            tabla.innerHTML += `<tr>
                <th scope="row"></th>
                <td>${element['nombre']}</td>
                <td>${element['fecha_creacion']}</td>
                <td>${element['fecha_limite']}</td>
                <td>${element['nombre_estado']}</td>
                <td><button class="btn btn-sm btn-primary ${estado} " onclick="ver_mas_chequeo('${element['id']}','${element['nombre']}','${element['resultado']}')"><i class="fa-solid fa-file-lines"></i></button>
              
                </td>
                </tr>
                `;
          });
        } else {
          if (response['status'] == "Vacio") {

            tabla.innerHTML = `<tr>
                <th scope="row"></th>
                <td>Sin</td>
                <td>chequeos</td>
                <td>cargados</td>
                <td></td>
                <td></button>
                </td>
                </tr>
                `;

          }
        }
      });

    }

    function ver_mas_chequeo(id_chequeo, nombre_estado, resultado) {
      if (nombre_estado == "Enviado") {
        console.log(nombre_estado);

      } else {
        if (nombre_estado = "Respondido") {
          console.log(nombre_estado);
          $('#modal_resultado_chequeo').modal('show'); // abrir
          modal_resultado.innerHTML = `
          <p style="color:red;">${resultado}</p>`;

        }
      }
    }

    function antecedentesP() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      var settings = {
        "url": rootRaiz + "/antecedentes_personales",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };
      $.ajax(settings).done(function (response) {
        if (response['status'] == "Success") {
          var response = response['data'];

          $("#retraso").html(response['retraso']);
          $('#deficit').html(response['deficit']);
          $('#desorden').html(response['desorden']);
          $('#lesiones_cabeza').html(response['lesiones_cabeza']);
          $('#lesiones_espalda').html(response['lesiones_espalda']);
          $('#infecciones').html(response['infecciones']);
          $('#toxinas').html(response['toxinas']);
          $('#acv').html(response['acv']);
          $('#demencia').html(response['demencia']);
          $('#parkinson').html(response['parkinson']);
          $('#epilepsia').html(response['epilepsia']);
          $('#esclerosis').html(response['esclerosis']);
          $('#huntington').html(response['huntington']);
          $('#depresion').html(response['depresion']);
          $('#trastorno').html(response['trastorno']);
          $('#esquizofrenia').html(response['esquizofrenia']);
          $('#enfermedad_desorden').html(response['enfermedad_desorden']);
          $('#intoxicaciones').html(response['intoxicaciones']);
        } else {
          if (response['status'] == "Vacio") {
            $("#resultado_personales").html('Sin antecedentes personales registrados');
          }
        }

      });
    }

    function antecedentesF() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      var settings = {
        "url": rootRaiz + "/antecedentes_familiares",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };
      $.ajax(settings).done(function (response) {
        console.log(response['status']);
        if (response['status'] == "Success") {
          var response = response['data'];

          $("#retraso").html(response['retraso']);
          $('#deficit').html(response['deficit']);
          $('#desorden').html(response['desorden']);
          $('#lesiones_cabeza').html(response['lesiones_cabeza']);
          $('#lesiones_espalda').html(response['lesiones_espalda']);
          $('#infecciones').html(response['infecciones']);
          $('#toxinas').html(response['toxinas']);
          $('#acv').html(response['acv']);
          $('#demencia').html(response['demencia']);
          $('#parkinson').html(response['parkinson']);
          $('#epilepsia').html(response['epilepsia']);
          $('#esclerosis').html(response['esclerosis']);
          $('#huntington').html(response['huntington']);
          $('#depresion').html(response['depresion']);
          $('#trastorno').html(response['trastorno']);
          $('#esquizofrenia').html(response['esquizofrenia']);
          $('#enfermedad_desorden').html(response['enfermedad_desorden']);
          $('#intoxicaciones').html(response['intoxicaciones']);
          $('#cancer').html(response['cancer']);
          $('#cirujia').html(response['cirujia']);
          $('#trasplante').html(response['trasplante']);
          $('#hipotiroidismo').html(response['hipotiroidismo']);
          $('#cardiologico').html(response['cardiologico']);
          $('#diabetes').html(response['diabetes']);
          $('#hipertension').html(response['hipertension']);
          $('#colesterol').html(response['colesterol']);

        } else {
          if (response['status'] == "Vacio") {
            $("#resultado_familiares").html('Sin antecedentes familiares registrados');
          }
        }
      });
    }

    function nuevo_anuncio() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";
      var id_paciente = "<?php echo $id_paciente; ?>";
      var id_medico = "<?php echo $_SESSION["id_medico"]; ?>";

      console.log(id_paciente + " " +id_medico);

      var parametros = {
        descripcion: document.getElementById("descripcion_anuncio_individual").value,
        fecha_limite: document.getElementById("fecha_limite").value,
        id_medico: id_medico.toString(),
        id_paciente: id_paciente.toString(),
        criterio: "4"
      };

      $.ajax({
        data: JSON.stringify(parametros),
        url: rootRaiz + '/create_avisos',
        type: 'POST',
        dataType: "JSON",

        success: function (response) {

          if (response['status'] == 'Success') {
            tabla.innerHTML = ``;
            showalert("Aviso creado","alert-primary");
            
          } else {
            showalert("Error","alert-danger");
            console.log(response['status']);
          }


        }
      });
    }

    function datos_historicos_clinicos() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      var estado;

      var settings = {
        "url": rootRaiz + "/datos_clinicos",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };


      $.ajax(settings).success(function (response) {
        if (response['status'] == "Success") {
          response['data'].forEach(element => {
            consume_alcohol = consumos(element['consume_alcohol']);
            consume_marihuana = consumos(element['consume_marihuana']);
            otras_drogas = consumos(element['otras_drogas']);
            fuma_tabaco = consumos(element['fuma_tabaco']);
            tablaClinicos.innerHTML += `<tr>
                <td>${element['fecha_alta']}</td>
                <td>${element['presion_alta']}</td>
                <td>${element['presion_baja']}</td>
                <td>${element['pulso']}</td>
                <td>${element['peso']}</td>
                <td>${element['circunferencia_cintura']}</td>
                <td>${element['talla']}</td>
                <td>${consume_alcohol}</td>
                <td>${consume_marihuana}</td>
                <td>${otras_drogas}</td>
                <td>${fuma_tabaco}</td>
                </tr>
                `;
          });
        } else {
          if (response['status'] == "Vacio") {

            tablaClinicos.innerHTML = `<tr>
                <td>Sin</td>
                <td>datos</td>
                <td>clínicos</td>
                <td>históricos</td>
                <td>cargados</td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                </tr>
                `;

          }
        }
      });
    }

    function read_medicamentos_paciente() {
      var rootRaiz = "<?php echo $rutaRaiz; ?>";

      var estado;

      var settings = {
        "url": rootRaiz + "/read_medicamentos",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };
      $.ajax(settings).done(function (response) {
        if (response['status'] == "Success") {
          tablaMedicamentos.innerHTML = ``;
          // console.log(response['data']);
          response['data'].forEach(element => {
            tablaMedicamentos.innerHTML += `<tr>
                <td>${element['nombre_comercial']}</td>
                <td>${element['forma_farmaceutica']}</td>
                <td>${element['presentacion']}</td>
                <td>${element['dosis_frecuencia']}</td>
                <td>${element['fecha_alta']}</td>
                </tr>
                `;
          });
        } else {
          if (response['status'] == "Vacio") {

            tablaClinicos.innerHTML = `<tr>
                <td>Sin</td>
                <td>datos</td>
                <td>clínicos</td>
                <td>históricos</td>
                <td>cargados</td>
                </tr>
                `;

          }
        }
      });
    }


    function consumos(frecuencia){
      if (frecuencia == 902) {
                return consume = "A veces (una vez al mes)";
            } else if(frecuencia == 903){
              return consume = "Con frecuencia (una vez por semana)";
            } else {
              return consume = "Siempre (casi todos los días)";
            }
    }

    function read_nombre_chequeos() {
    var parametros = {};
    var rootRaiz = "<?php echo $rutaRaiz; ?>";

    $.ajax({
      data: JSON.stringify(parametros),
      url: rootRaiz + '/chequeos',
      type: 'POST',
      dataType: "JSON",

      success: function(response) {

        if (response['status'] == 'Success') {
          var response = response['data'];

          response['chequeos'][0].forEach(element => {
            select_chequeos.innerHTML += `
              <option value="${element["id"]}" title="${element["nombre"]}">${element["nombre"]}</option>
              `;
          });

        } else {
          modal_body.innerHTML = `<p style="color:red;">No se encuentra el paciente</p>`;
        }

      }
    });

  }


    function guardar_chequeo() {
    var rootRaiz = "<?php echo $rutaRaiz; ?>";

    var parametros = {
      tipo_chequeo: document.getElementById("select_chequeos").value,
      fecha_chequeo: document.getElementById("fecha1").value,
      id_paciente: "<?php echo $id_paciente; ?>",
      id_medico: "<?php echo $id_medico; ?>",
      descripcion: "Estimado paciente le envio para que complete el siguiente "+ document.getElementById("select_chequeos").title +":"
    };

    $.ajax({
      data: JSON.stringify(parametros),
      url: rootRaiz + '/crear_recordatorio_chequeo',
      type: 'POST',
      dataType: "JSON",

      success: function(response) {

        if (response['request'] == 'Success') {

          $('#modal_chequeo').modal('show'); // abrir

          titulo_modal.innerHTML = `Chequeo creado correctamente`;

        } else {
          titulo_modal.innerHTML = `<p style="color:red;">No se encuentra el paciente</p>`;
          //$("#mensaje").html("");
        }


      }
    });
  }

    

  </script>
  <!-- jQuery -->
  <script src="plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- overlayScrollbars -->
  <script src="plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
  <!-- AdminLTE App -->
  <script src="dist/js/adminlte.min.js"></script>
  <script src="dist/js/alert-msg.js"></script>

</body>

<!-- Modal Nuevo Anuncio Individual-->
<div class="modal fade" id="nuevoAvisoModal" tabindex="-1" role="dialog" aria-labelledby="nuevoAvisoModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Nuevo Anuncio <abbr title="Envia un aviso con indicaciones específicas al paciente para que complete hasta una fecha limite"><i class="fa-sharp fa-solid fa-circle-info"></i></abbr></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="modal_nuevo_anuncio" class="modal-body">
        <form action="" method="post">
          <div class="form-group">
            <label for="descripcion-text" class="col-form-label">Descripción:</label>
            <textarea class="form-control" id="descripcion_anuncio_individual"></textarea>
          </div>
          <div class="form-group">
            <label for="fecha-text" class="col-form-label">Fecha Límite:</label>
            <input type="date" name="" id="fecha_limite">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="nuevo_anuncio()">Enviar</button>
        <!--<a href="datos.html" class="btn btn-primary active" role="button" aria-pressed="true">Aceptar</a> -->
      </div>
    </div>
  </div>
</div>

<!-- Modal Nuevo Chequeo-->
<div class="modal fade" id="nuevochequeoModal" tabindex="-1" role="dialog" aria-labelledby="nuevochequeoModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Envio de Chequeo <abbr title="Envia un determinado chequeo al paciente para que complete hasta una fecha limite"><i class="fa-sharp fa-solid fa-circle-info"></i></abbr></h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="modal_nuevo_anuncio" class="modal-body">
      <form>
            <div class="card-body">
              <div class="form-group">
                <label>Chequeos </label>
                <select id="select_chequeos" class="form-control" aria-label="Default select example">

                </select>
              </div>
              <div class="form-group mb-4">
                <div class="form-group">
                  <label for="">Elegir Fecha</label>
                  <input type="date" placeholder="Elegir Fecha" class="form-control" id="fecha1">

                </div>
              </div>
            </div>
            
          </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" data-dismiss="modal" onclick="guardar_chequeo()">Enviar Chequeo</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal Ver Resultado Chequeo-->
<div class="modal fade" id="modal_resultado_chequeo" tabindex="-1" role="dialog"
  aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="titulo_modal" align="center">Resultado del Chequeo</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="modal_resultado" class="modal-body">
      </div>
    </div>
  </div>
</div>

<!--Modal datos clinicos historicos-->
<div class="container">
  <div class="row justify-content-center">
    <div class="col-12">
      <div class="modal fade bd-example-modal-lg" id="clinicoHistorico" tabindex="-1" role="dialog"
        aria-labelledby="clinicoHistoricoTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLongTitle">Datos Históricos Clínicos</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div id="modal_nuevo_anuncio" class="modal-body">
              <div class="table-responsive-xl">
                <table class="table table-striped mb-0">
                  <thead>
                    <tr>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Fecha</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Presión alta</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Presión baja</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Pulso</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Peso</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Circunferencia de cintura</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Talla</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Consume alcohol</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Consume marihuana</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Otras drogas</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Fuma tabaco</th>
                    </tr>
                  </thead>
                  <tbody id="tablaClinicos"></tbody>
                </table>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Aceptar</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!--Modal de plan farmacologico-->
<div class="container">
  <div class="row justify-content-center">
    <div class="col-12">
      <div class="modal fade bd-example-modal-lg" id="planfarmacologico" tabindex="-1" role="dialog"
        aria-labelledby="planfarmacologicoTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h5 class="modal-title" id="exampleModalLongTitle">Plan Farmacologico</h5>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div id="modal_medicamentos" class="modal-body">
              <div class="table-responsive-xl">
                <table class="table table-striped mb-0">
                  <thead>
                    <tr>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Nombre Comercial</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Forma Farmaceutica</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Presentación</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Dosis o Frecuencia</th>
                      <th style="vertical-align: inherit;text-align: center;"scope="col">Fecha</th>
                    </tr>
                  </thead>
                  <tbody id="tablaMedicamentos"></tbody>
                </table>
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Aceptar</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>


</html>