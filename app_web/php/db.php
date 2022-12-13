<?php
//header('Content-Type: application/json; charset=utf8');

// Base de datos gratis de db4free
// $db_name = "id16812178_app65";
// $db_server = "db4free.net:3306";
// $db_user = "id16812177_s65";
// $db_pass = "Mas65-2021bue";
// //$certificado = 'http://192.168.100.143/S-65/app_movil/lib/php/certificado.pem';

// $certificado = 'https://alanalizador.000webhostapp.com/php/certificado.pem';

//Base de datos de Hosting UNSJ
//$db_name = "s65";
//$db_server = "localhost";
//$db_user = "user_s65";
//$db_pass = "A8smFW7#";
//$certificado = 'https://190.124.224.143/php/certificado.pem';

//-------------- LOCAL -----------------------

 $db_name = "dbs65";
 $db_server = "localhost";
 $db_user = "root";
 $db_pass = "";
 //$certificado = 'C:/xampp/htdocs/S-65/app_movil/lib/php/certificado.pem';

try {

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);

} catch (PDOException $error) {
	echo $error->getMessage();
}

?>