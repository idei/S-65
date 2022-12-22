<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
        <meta name="description" content="" />
        <meta name="author" content="" />
        <title>Datos</title>
        <!-- Favicon-->
        <link rel="icon" type="image/x-icon" href="../assets/logo1.png" />
        <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
        <link href="../css/styles.css" rel="stylesheet" />
        <link href="../css/styleP.css" rel="stylesheet" />

    </head>
    <body onload="buscar()" >
        <div class="d-flex" id="wrapper">
                <?php include('navbar_template.php'); ?>
                <div class = "container" style= "margin:10px">
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
                <!--<button type="button" class="btn btn-outline-primary">Ver más</button>-->
                <div class="container" style="margin: 30px;">
                    <div class="row">
                        <div class="col-sm">
                        <button type="button" onclick="antecedentesP()" class="btn btn-primary text-uppercase" data-toggle="modal" data-target="#modalMedico">Antecedentes Médicos</button>
                        <button type="button" onclick="antecedentesF()"class="btn btn-primary text-uppercase" data-toggle="modal" data-target="#modalFamiliar">Antecedentes Familiares</button>
                    </div>
                </div>
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
                <!--<div class="container">
                    <div class="row">
                        <div class="col-sm">
                        <button type="button" class="btn btn-primary text-uppercase">Enviar un Aviso personal</button>
                        <button type="button" class="btn btn-primary text-uppercase">Enviar un chequeo</button>
                    </div>
                </div>-->
            </div>
            </div>
        </div>
        <script>
	function buscar()
    {
      var settings = {
      "url": "../php/user_read_datos_personales.php",
      "method": "POST",
      "data": JSON.stringify({
      "dni": 333333,
      }),
      };

      $.ajax(settings).done(function (response) {
  var nombre= "Nombre y Apellido: " +response['nombre'] + " " + response['apellido']
  var dni = "DNI: " + response['dni']
  var contacto = "Contacto: " + response['contacto']
  $("#nombre").html(nombre);
  $('#dni').html(dni)
  $('#contacto').html(contacto);
  $('#depto').html(depto)
  var peso= "Peso: " +response['peso'] 
  var presionA = "Presión alta: " + response['presion_alta']
  var presionB = "Presión baja: " + response['presion_baja']
  var pulso = "Pulso: " + response['pulso']
  var circun = "Circunferencia de la cintura: "+ response['circunferencia_cintura']
  var fuma = "Fuma: "+ response['fuma_tabaco']
  var marihuana = "Consume Marihuana:"+ response['consume_marihuana']
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
});

}
function antecedentesP(){
    var settings = {
      "url": "../php/user_read_antc_personales.php",
      "method": "POST",
      "data": JSON.stringify({
      "dni": 333333,
      }),
      };
      $.ajax(settings).done(function (response) {
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
      });
}
function antecedentesF(){
    var settings = {
      "url": "../php/user_read_antc_familiares.php",
      "method": "POST",
      "data": JSON.stringify({
      "dni": 333333,
      }),
      };
      $.ajax(settings).done(function (response) {
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
      });
}


</script>
<script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
    
</body>
</html>