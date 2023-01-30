<?php
//session_start();
$email = "doc@gmail.com";
?>

<!DOCTYPE html>
<html lang="es">

<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
  <meta name="description" content="" />
  <meta name="author" content="" />
  <title>Home</title>
  <!-- Favicon-->
  <link rel="icon" type="image/x-icon" href="../assets/logo1.png" />
  <!-- Core theme CSS (includes Bootstrap)-->
  <!-- CSS only -->
  <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  <link href="../css/styles.css" rel="stylesheet" />
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />

</head>

<body onload="read_pacientes()">
  <div class="d-flex" id="wrapper">
    <?php include('navbar_template.php'); ?>
    <!-- Page content-->
    <div class="container ">
      <!-- Stack the columns on mobile by making one full-width and the other half-width -->
      <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
        <div class="p-5">
          <h2>Mis pacientes</h2>
          <div class="row">
            <div class="col-8">
              <form method="POST">
                <input id="buscar" type="search" class="form-control rounded" placeholder="Dni / Apellido / Nombre" onkeyup="doSearch()" />

              </form>
              <div id="mensaje"></div>
            </div>
          </div>
        </div>


      </div>

      <!-- tabla   -->
      <table class="table table-hover">
        <thead>
          <tr>
            <th scope="col"></th>
            <th scope="col">Dni</th>
            <th scope="col">Apellido</th>
            <th scope="col">Nombre</th>
            <th scope="col"></th>
          </tr>
        </thead>
        <tbody id="tabla">
        </tbody>
      </table>

    </div>
    <!-- Modal -->
    <div class="modal fade" id="modal_paciente" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="titulo_modal">Paciente buscado</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div class="modal-body">
            <div id="nombre" class=""> </div>
            </br>
            <div id="apellido"></div>
          </div>
          <div class="modal-footer">
            <button onclick="mensaje.innerHTML = ``;" type="button" class="btn btn-secondary" data-dismiss="modal">Cancelar</button>
            <a href="paciente.php" class="btn btn-primary active" role="button" aria-pressed="true">Ver Datos</a>
          </div>

        </div>
      </div>
    </div>
  </div>
  <script>
    function buscar() {

      var parametros = {
        dni: document.getElementById("dni").value
      };

      $.ajax({
        data: JSON.stringify(parametros),
        url: '../php/buscar_paciente.php',
        type: 'POST',
        dataType: "JSON",

        success: function(response) {

          if (response['request'] == 'Success') {

            $('#modal_paciente').modal('show'); // abrir

            var nombre = "Nombre: " + response["paciente"]['nombre']
            var apellido = "Apellido: " + response["paciente"]['apellido']
            $("#nombre").html(nombre);
            $("#apellido").html(apellido);
            // window.location.replace("datos.php");
          } else {
            mensaje.innerHTML = `<p style="color:red;">No se encuentra el paciente</p>`;
            //alert_info("No se encuentra el paciente");
          }


        }
      });


    }

    function read_pacientes() {

      const tabla = document.querySelector('#tabla');

      var url_imagen = "";

      var parametros = {
        dni: "<?php echo "444444" ?>",
      };

      $.ajax({
        data: JSON.stringify(parametros),
        url: 'http://localhost/S-65/api/v1/pacientes',
        type: 'POST',
        dataType: "JSON",

        success: function(response) {
          console.log(response);
          if (response['status'] == 'Success') {

            response['data'].forEach(element => {

              tabla.innerHTML += `
        <tr>
        <th scope="row"></th>
        <td>${element['dni']}</td>
        <td>${element['apellido']}</td>
        <td>${element['nombre']}</td>
        <td>
        <form action="paciente.php" method="post">
        <button onclick="ver_mas('${element['id']}')" id="ver_mas" type="submit" class="btn-primary btn-sm" ><i class="fa fa-chevron-right" aria-hidden="true"></i></button>
        </form>
        </td>
        </tr>
        `;
            });
          } else {
            console.log(response['status']);
            if (response['status'] == 'Vacio') {
              tabla.innerHTML += ``;
            }
          }

        }
      });
    }

    function ver_mas(id) {

      $('#avisoModal').modal('show'); // abrir

      var parametros = {
        id: id,
      };

      $.ajax({
        data: JSON.stringify(parametros),
        url: '../php/read_aviso.php',
        type: 'POST',
        dataType: "JSON",

        success: function(response) {

          if (response['status'] == 'Success') {

            modal1.innerHTML += `
                <p> Descripcion: ` + response['aviso']['descripcion'] + ` </p>
                <p> Fecha Creación: ` + response['aviso']['fecha_creacion'] + ` </p>
                <p> Fecha Límite: ` + response['aviso']['fecha_limite'] + ` </p>
                `;

          } else {
            console.log(response['status']);
          }


        }
      });
    }

    function doSearch(){

      const tableReg = document.getElementById('tabla');

      const searchText = document.getElementById('buscar').value.toLowerCase();

      let total = 0;

      // Recorremos todas las filas con contenido de la tabla

      for (let i = 1; i < tableReg.rows.length; i++) {

        // Si el td tiene la clase "noSearch" no se busca en su cntenido

        if (tableReg.rows[i].classList.contains("noSearch")) {

          continue;

        }


        let found = false;

        const cellsOfRow = tableReg.rows[i].getElementsByTagName('td');

        // Recorremos todas las celdas

        for (let j = 0; j < cellsOfRow.length && !found; j++) {

          const compareWith = cellsOfRow[j].innerHTML.toLowerCase();

          // Buscamos el texto en el contenido de la celda

          if (searchText.length == 0 || compareWith.indexOf(searchText) > -1) {

            found = true;

            total++;

          }

        }

        if (found) {

          tableReg.rows[i].style.display = '';

        } else {

          // si no ha encontrado ninguna coincidencia, esconde la

          // fila de la tabla

          tableReg.rows[i].style.display = 'none';

        }

      }

      // mostramos las coincidencias

      const lastTR = tableReg.rows[tableReg.rows.length - 1];

      const td = lastTR.querySelector("td");

      lastTR.classList.remove("hide", "red");

      if (searchText == "") {

        lastTR.classList.add("hide");

      } else if (total) {

        td.innerHTML = "Se ha encontrado " + total + " coincidencia" + ((total > 1) ? "s" : "");

      } else {

        lastTR.classList.add("red");

        td.innerHTML = "No se han encontrado coincidencias";

      }

    }
  </script>
  <script src="../js/alerts_msg.js"></script>
  <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
</body>

</html>