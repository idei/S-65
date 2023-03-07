<?php
header('Content-Type: application/json; charset=utf8');

//require('../flight/Flight.php');
include ('../flight/Flight.php');

//Base de datos de Hosting UNSJ
$db_name = "s65";
$db_server = "localhost";
$db_user = "user_s65";
$db_pass = "A8smFW7#";
//$certificado = 'https://190.124.224.143/php/certificado.pem';

//-------------- LOCAL -----------------------

//  $db_name = "dbs65";
//  $db_server = "localhost";
//  $db_user = "root";
//  $db_pass = "";
 //$certificado = 'C:/xampp/htdocs/S-65/app_movil/lib/php/certificado.pem';

Flight::register('db','PDO',array('mysql:host='.$db_server.';dbname='. $db_name .';charset=utf8', $db_user, $db_pass));


?>