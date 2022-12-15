<!DOCTYPE html>
<html lang="en">
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
    </head>
    <body>
        <div class="d-flex" id="wrapper">
                <?php include('navbar_template.php'); ?>
                <!-- Page content-->
                <div class="container col-md-8" >
                    <!-- Stack the columns on mobile by making one full-width and the other half-width -->
                    <div class="row" style="margin: 100; color: rgb(92, 90, 90);">
                      <div class="p-5">
                        <h2>Avisos</h2>
                        <div class="row">
                            <div class="p-2">
                            <input type="search" class="form-control rounded" placeholder="Escribir DNI de paciente" aria-label="Search" aria-describedby="search-addon" />
                            </div>
                            <div class="p-2">
                                <button type="button" class="btn btn-primary p-2" data-toggle="modal" data-target="#exampleModalCenter">Buscar</button>
                            </div>
                          </div>
                      </div>
                    </div>
                </div>  
        </div>
        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    </body>
</html>