<?php
session_start();
$email_doctor= $_SESSION['email'] ;
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
    <link href="../css/styles.css" rel="stylesheet" />
    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
    

</head>

<body onload="read_avisos()">
    <div class="d-flex" id="wrapper">
        <?php include('navbar_template.php'); ?>
        <!-- Page content-->
        <div class="container">
            <!-- Stack the columns on mobile by making one full-width and the other half-width -->
            <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
                <div class="p-5">
                    <h2>Avisos</h2>
                    <button class="btn-danger float-right">Crear Anuncio Grupal</button>
                    <button class="btn-primary float-right" onclick="$('#nuevoAvisoModal').modal('show')">Crear Anuncio Individual</button>
                    <br></br>
                    <table class="table">
                        <thead>
                            <tr>
                                <th scope="col"></th>
                                <th scope="col">Descripción</th>
                                <th scope="col">URL Imagen</th>
                                <th scope="col">Fecha de Creación</th>
                                <th scope="col">Fecha Límite</th>
                                <th scope="col">Acción</th>
                            </tr>
                        </thead>
                        <tbody id="tabla">

                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="avisoModal" tabindex="-1" role="dialog" aria-labelledby="avisoModalTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="exampleModalLongTitle">Aviso</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div id="modal1" class="modal-body">

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">OK</button>
                    <!--<a href="datos.html" class="btn btn-primary active" role="button" aria-pressed="true">Aceptar</a> -->
                </div>
            </div>
        </div>
    </div>


     <!-- Modal Nuevo Anuncio-->
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
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="nuevo_anuncio()">OK</button>
                    <!--<a href="datos.html" class="btn btn-primary active" role="button" aria-pressed="true">Aceptar</a> -->
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>

    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
</body>


<script>

    function nuevo_anuncio(){
        //$('#nuevoAvisoModal').modal('show'); // abrir

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

                if (response['request'] == 'Success') {
                    tabla.innerHTML = ``;
                    read_avisos();
    
                } else {
                    console.log(response['request']);
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
    
                if (response['request'] == 'Success') {
    
                        modal1.innerHTML += `
                        <p> Descripcion: ` + response['aviso']['descripcion'] + ` </p>
                        <p> Fecha Creación: ` + response['aviso']['fecha_creacion'] + ` </p>
                        <p> Fecha Límite: ` + response['aviso']['fecha_limite'] + ` </p>
                        `;
    
                } else {
                    console.log(response['request']);
                }
                
    
            }
        });
    
    
    
    }
    
    
    function read_avisos() {
    
        const tabla = document.querySelector('#tabla');
        
        var parametros = {
            email: "<?php echo $email_doctor ?>",
        };
    
        $.ajax({
            data: JSON.stringify(parametros),
            url: '../php/read_avisos.php',
            type: 'POST',
            dataType: "JSON",
    
            success: function(response) {
    
                if (response['request'] == 'Success') {
    
                    response['avisos'].forEach(element => {
    
                        tabla.innerHTML += `
                <tr>
                <th scope="row"></th>
                <td>${element['descripcion'].slice(0,30)}</td>
                <td>${element['url_imagen']}</td>
                <td>${element['fecha_creacion']}</td>
                <td>${element['fecha_limite']}</td>
                <td><button onclick="ver_mas('${element['id']}')" id="ver_mas" type="button" class="btn-primary btn-sm" >Ver Más</button>
                <button type="button" class="btn-danger btn-sm">Eliminar</button>
                </td>
                </tr>
                `;
                    });
                } else {
                    console.log(response['request']);
                }
    
            }
        });
    }
    
</script>

</html>