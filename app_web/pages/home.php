<?php
include '../env.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>

    <title>Document</title>
</head>
<body onload="read_datos_personales()">
    <p>HOME</p>

</body>

<script>
    function read_datos_personales()
    {
      var base_dir = "<?php echo $BASE_DIR ?>";


      var parametros = 
      {
        //"email" : document.getElementById("email").value,
        email : "prueba@gmail.com",
      };


      $.ajax({
        data: JSON.stringify(parametros),
        //url: '../php/user_read_datos_personales.php',
        //url: '../php/user_read_datosclinicos.php',
        //url: '../php/user_read_antc_personales.php',
        //url: '../php/user_read_antc_familiares.php',
        //url: '../php/read_avisos.php',
        //base_dir +
        url:  '../php/recordatorios',
        type: 'POST',
        dataType:"JSON",
    
        success: function(response)
        { 
            
            if (response['request']=='Success') {
                response['recordatorios'].forEach(element => {
                console.log(element['descripcion']);
            });
            }else{
                console.log(response['request']);
            }
            

            // if(response['request']=='Success'){   
            //     //console.log(response['request']);
            //     //alert(response['nombre'])
            // }else{
            //     console.log(response['request']);
            //     $('#error').html(response);
            // }

        }
      });
}
</script>
</html>
