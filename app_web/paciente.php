<?php
session_start();

if (isset($_POST['id_paciente'])) {
$id_paciente = $_POST["id_paciente"];
}
?>
<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>S-65 | Médico</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <!-- <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css"> -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.1/css/all.min.css">

  <!-- overlayScrollbars -->
  <link rel="stylesheet" href="plugins/overlayScrollbars/css/OverlayScrollbars.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/adminlte.min.css">
</head>
<style>
  .modal-lg { max-width: 80%; }
</style>
<body class="hold-transition sidebar-mini layout-fixed" onload="buscar()">
  <div class="wrapper">

    <?php include('./templates/navbar_template.php'); ?>

    <?php include('./templates/sidebar_template.php'); ?>

    <div class="content-wrapper">
      <!-- Content Header (Page header) -->
      <?php
      $titulo = "";
      include('./templates/content_header.php');
      ?>

      <!-- Main content -->
      <section class="content">
        <!-- <div class="d-flex" id="wrapper"> -->
        <!-- Page content-->

        <div class="callout callout-info">
          <div class="row">
            <div class="col-6">
              <h4>Datos de Paciente</h4>
              <div id="nombre"></div>
              <div id="dni"></div>
              <div id="contacto"></div>
              <div id="depto"></div>
              </br>
              <h4>Datos Clínicos</h4>
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
                <button type="button" onclick="antecedentesP()" class="btn btn-block btn-info btn-flat text-uppercase" data-toggle="modal" data-target="#modalMedico">Antecedentes Médicos</button>
              </div>
              <br>
              <div class="col align-self-center">
                <button type="button" onclick="antecedentesF()" class="btn btn-block btn-info btn-flat text-uppercase" data-toggle="modal" data-target="#modalFamiliar">Antecedentes Familiares</button>
              </div>
              <br>
              <div class="col align-self-center">
                <form action="chequeos.php" method="post">
                <input name="id_paciente" type="hidden" value="<?php echo $id_paciente; ?>"></input>
                <button href="chequeos.php" class="btn btn-block btn-info btn-flat text-uppercase" type="submit">Enviar Chequeo</button>
                </form>
              </div>
              <br>
              <div class="col align-self-center">
                <button class="btn btn-block btn-info btn-flat text-uppercase" onclick="$('#nuevoAvisoModal').modal('show')">Enviar Aviso</button>
              </div>
              <br>
              <div class="col align-self-center">
                <button class="btn btn-block btn-info btn-flat text-uppercase" type="button"  data-toggle="modal" onclick="datos_historicos_clinicos()"  data-target="#clinicoHistorico">Datos clinicos historicos</button>
              </div>

            </div>
          </div>

          <hr>
          <div class="container" style="margin: 30px;">

            <div class="modal fade" id="modalMedico" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
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
            <div class="modal fade" id="modalFamiliar" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
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
    function buscar() {
      chequeos_paciente();
      var settings = {
        "url": "http://localhost/S-65/api/v1/datos_personales",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };

      $.ajax(settings).done(function(response) {

        if (response['status'] == "Success") {
          var response = response['data'];
          console.log(response);
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

    function chequeos_paciente() {
      console.log("entre");
      var estado;

      var settings = {
        "url": "http://localhost/S-65/api/v1/chequeos_medico_paciente",
        "method": "POST",
        "data": JSON.stringify({
          "email": "<?php echo $_SESSION['email']; ?>",
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };

      $.ajax(settings).done(function(response) {
        
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
            tabla.innerHTML = `<tr>
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
          //read_avisos();
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

      var settings = {
        "url": "http://localhost/S-65/api/v1/antecedentes_personales",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };
      $.ajax(settings).done(function(response) {
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
      var settings = {
        "url": "http://localhost/S-65/api/v1/antecedentes_familiares",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };
      $.ajax(settings).done(function(response) {
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

var parametros = {
    descripcion: document.getElementById("descripcion_anuncio_individual").value,
    fecha_limite: document.getElementById("fecha_limite").value,
    email_medico: 'doc@gmail.com',
    email_paciente: 'prueba@gmail.com'
};

$.ajax({
    data: JSON.stringify(parametros),
    url: '../php/create_aviso.php',
    type: 'POST',
    dataType: "JSON",

    success: function(response) {

        if (response['status'] == 'Success') {
            tabla.innerHTML = ``;
            read_avisos();
            alert_success("Aviso creado");

        } else {
            alert_danger("Error");
            console.log(response['status']);
        }


    }
});
}

function datos_historicos_clinicos(){
  console.log("entre datos clinicos");
      var estado;

      var settings = {
        "url": "http://localhost/S-65/api/v1/datos_clinicos",
        "method": "POST",
        "data": JSON.stringify({
          "id_paciente": "<?php echo $id_paciente; ?>",
        }),
      };
      $.ajax(settings).done(function(response) {
        if (response['status'] == "Success") {
          response['data'].forEach(element => {
            console.log(count(element))
            switch (element['consume_alcohol']) {
                case 902:
                    consume_alcohol = "A veces (una vez al mes)";
                    break;
                case 903:
                    consume_alcohol = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    consume_alcohol = "Siempre (casi todos los días)";
                    break;
            }
            switch (element["consume_marihuana"]) {
                case 902:
                    $consume_marihuana = "A veces (una vez al mes)";
                    break;
                case 903:
                    $consume_marihuana = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $consume_marihuana = "Siempre (casi todos los días)";
                    break;
            }
            switch (element["otras_drogas"]) {
                case 902:
                    $otras_drogas = "A veces (una vez al mes)";
                    break;
                case 903:
                    $otras_drogas = "Con frecuencia (una vez por semana)";
                    break;
                case 904:
                    $otras_drogas = "Siempre (casi todos los días)";
                    break;
            }
            switch (element["fuma_tabaco"]) {
                case 902:
                    $fuma_tabaco = "A veces (una vez al mes)";
                    console.log($fuma_tabaco);
                    break;
                case 903:
                    $fuma_tabaco = "Con frecuencia (una vez por semana)";
                    console.log($fuma_tabaco);
                    break;
                case 904:
                    $fuma_tabaco = "Siempre (casi todos los días)";
                    console.log($fuma_tabaco);
                    break;
            }
            tablaClinicos.innerHTML = `<tr>
                <td>${element['fecha_alta']}</td>
                <td>${element['presion_alta']}</td>
                <td>${element['presion_baja']}</td>
                <td>${element['pulso']}</td>
                <td>${element['peso']}</td>
                <td>${element['circunferencia_cintura']}</td>
                <td>${element['talla']}</td>
                <td>${element['consume_alcohol']}</td>
                <td>${element['consume_marihuana']}</td>
                <td>${element['otras_drogas']}</td>
                <td>${element['fuma_tabaco']}</td>
                </tr>
                `;
          });
          //read_avisos();
        } else {
          if (response['status'] == "Vacio") {
          
            tablaClinicos.innerHTML = `<tr>
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
  </script>
  <!-- jQuery -->
  <script src="plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- overlayScrollbars -->
  <script src="plugins/overlayScrollbars/js/jquery.overlayScrollbars.min.js"></script>
  <!-- AdminLTE App -->
  <script src="dist/js/adminlte.min.js"></script>

</body>

<!-- Modal Nuevo Anuncio Individual-->
<div class="modal fade" id="nuevoAvisoModal" tabindex="-1" role="dialog" aria-labelledby="nuevoAvisoModalTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Nuevo Anuncio</h5>
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


<!-- Modal Ver Resultado Chequeo-->
<div class="modal fade" id="modal_resultado_chequeo" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
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
<div class="modal fade bd-example-modal-lg" id="clinicoHistorico" tabindex="-1" role="dialog" aria-labelledby="clinicoHistoricoTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLongTitle">Datos clinicos historicos</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div id="modal_nuevo_anuncio" class="modal-body">
      <div class="table-responsive">
      <table class="table table-striped">
          <thead>
            <tr>
              <th scope="col">Fecha</th>
              <th scope="col">Presión alta</th>
              <th scope="col">Presión baja</th>
              <th scope="col">Pulso</th>
              <th scope="col">Peso</th>
              <th scope="col">Circunferencia de cintura</th>
              <th scope="col">Talla</th>
              <th scope="col">Consume alcohol</th>
              <th scope="col">Consume marihuana</th>
              <th scope="col">Otras drogas</th>
              <th scope="col">Fuma tabaco</th>
            </tr>
          </thead>
          <tbody id="tablaClinicos">

          </tbody>
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

</html>