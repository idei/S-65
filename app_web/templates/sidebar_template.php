<?php
$nombre=$_SESSION['nombre'];
$apellido=$_SESSION['apellido'];

?>
<!-- Main Sidebar Container -->
<aside class="main-sidebar main-sidebar-custom sidebar-dark-primary elevation-4">
  <!-- Brand Logo -->
  <a href="home.php" class="brand-link">
    <img src="dist/img/logoChico.png" alt="Logo" class="brand-image img-circle elevation-3"
      style="opacity: .8">
    <span class="brand-text font-weight-light">Agenda Salud</span>
  </a>

  <!-- Sidebar -->
  <div class="sidebar">
    <!-- Sidebar user (optional) -->
    <div class="user-panel mt-3 pb-3 mb-3 d-flex">
      <div class="image">
        <img src="dist/img/user2-160x160.jpg" class="img-circle elevation-2" alt="User Image">
      </div>
      <div class="info">
        <a href="#" class="d-block">Dr. <?php echo $nombre." ".$apellido ?></a>
      </div>
    </div>

    <!-- SidebarSearch Form -->
    <div class="form-inline">
      <div class="input-group" data-widget="sidebar-search">
        <input class="form-control form-control-sidebar" type="search" placeholder="Buscar" aria-label="Search">
        <div class="input-group-append">
          <button class="btn btn-sidebar">
            <i class="fas fa-search fa-fw"></i>
          </button>
        </div>
      </div>
    </div>

    <!-- Sidebar Menu -->
    <nav class="mt-2">
      <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
    
        <li class="nav-item">
          <a href="home.php" class="nav-link">
            <i class="nav-icon  fas fa-solid fa-house"></i>
            <p>
              Inicio
            </p>
          </a>
        </li>

        <li class="nav-item">
          <a href="avisos.php" class="nav-link">
            <i class="nav-icon fas fa-regular fa-calendar-plus"></i>
            <p>
              Avisos Generales
              <!-- <span class="right badge badge-danger">New</span> -->
            </p>
          </a>
        </li>

        <li class="nav-item">
          <a href="chequeos_enviados.php" class="nav-link">
            <i class="nav-icon fas fa-square-check"></i>
            <p>
              Chequeos
              <!-- <span class="right badge badge-danger">New</span> -->
            </p>
          </a>
        </li>

        <li class="nav-item">
          <a href="pacientes_buscador.php" class="nav-link">
            <i class="nav-icon fas fa-square-check"></i>
            <p>
              Buscar Pacientes
              <!-- <span class="right badge badge-danger">New</span> -->
            </p>
          </a>
        </li>

      </ul>

    </nav>
    <!-- /.sidebar-menu -->
  </div>
  <!-- /.sidebar -->

  <div class="sidebar-custom">
    <!-- <a href="#" class="btn btn-link" id="buttonfix2"><i class="fas fa-cog"></i></a>
    <a href="#" class="btn btn-secondary hide-on-collapse pos-right"  id="buttonfix1" >Ayuda</a> -->
  </div>
  <!-- /.sidebar-custom -->
</aside>
