<?php
if (isset($_SESSION['email'])) {

    $email = $_SESSION['email'];
} else {
    session_start();
    $email = $_SESSION['email'];
}

?>

<!-- Sidebar-->
<div class="border-end bg-white" id="sidebar-wrapper">
    <div class="sidebar-heading border-bottom bg-light"><img class="img-fluid" width="150" heigth="100" src="../assets/logo1.png" alt="Chania" height="100%"></div>
    <div class="list-group list-group-flush">
        <div><i class="fa-solid fa-skating fa-fw"></i><a class="list-group-item list-group-item-action list-group-item-light p-3" href="inicio.php">Inicio</a></div>

        <a class="list-group-item list-group-item-action list-group-item-light p-3" href="avisos.php">Avisos Generales</a>
        <a class="list-group-item list-group-item-action list-group-item-light p-3" href="chequeos_list.php">Chequeos</a>

    </div>
</div>
<!-- Page content wrapper-->
<div id="page-content-wrapper">
    <!-- Top navigation-->
    <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
        <div class="container-fluid">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mt-2 mt-lg-0">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><i class="fa fa-bell-o" aria-hidden="true"></i></a>
                    </li>

                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-haspopup="true" aria-expanded="false"><?php echo $email ?></a>
                        <div class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <a class="dropdown-item" href="#!">Cerrar Sesión</a>
                        </div>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    <div id="alert_component" class="alert" role="alert" style="display: none">
        <div id="alert-msg"></div>
    </div>

    <nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="/s-65/app_web/pages/inicio.php">Home</a></li>
    <li class="breadcrumb-item active" aria-current="page">Library</li>
  </ol>
   </nav>