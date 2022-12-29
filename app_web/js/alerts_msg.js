function alert_success(mensaje){
    document.getElementById("alert_component").className = "alert alert-success";
    document.getElementById("alert_component").style.display = "block";
        document.getElementById('alert-msg').innerHTML = mensaje; // set message text
        window.setTimeout(function() {
          //document.getElementById("alert_component").style.display = "hidden";
          $(".alert").fadeOut(500, 0).slideUp(500, function(){
              $(this).remove(); 
          });
      }, 2000);

}

function alert_danger(mensaje){
    document.getElementById("alert_component").className = "alert alert-danger";
    document.getElementById("alert_component").style.display = "block";
        document.getElementById('alert-msg').innerHTML = mensaje; // set message text
        window.setTimeout(function() {
          //document.getElementById("alert_component").style.display = "hidden";
          $(".alert").fadeOut(500, 0).slideUp(500, function(){
              $(this).remove(); 
          });
      }, 2000);

}

function alert_info(mensaje){
    document.getElementById("alert_component").className = "alert alert-info";
    document.getElementById("alert_component").style.display = "block";
        document.getElementById('alert-msg').innerHTML = mensaje; // set message text
        window.setTimeout(function() {
          //document.getElementById("alert_component").style.display = "hidden";
          $(".alert").fadeOut(500, 0).slideUp(500, function(){
              $(this).remove(); 
          });
      }, 2000);

}

// document.getElementById("alert_component").style.display = "block";
// document.getElementById('alert-msg').innerHTML = "mensaje"; // set message text
// window.setTimeout(function() {
//   $(".alert").fadeOut(3000);
//   }, 3000);