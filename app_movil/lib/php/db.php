<?php
header('Content-Type: application/json; charset=utf8');

$db_name = "id16812178_app65";
$db_server = "db4free.net:3306";
$db_user = "id16812177_s65";
$db_pass = "Mas65-2021bue";


// $db_name = "db65";
// $db_server = "nyf1yu6o7nm9.us-east-4.psdb.cloud"; 
// $db_user = "l3gzjnv19ns9";
// $db_pass = "pscale_pw_dhpOBO91y_pCNkEjOmkC_Nr4rwsaY5aXkwbetNn3q64";

//-------------- LOCAL -----------------------

// $db_name = "dbs65";
// $db_server = "127.0.0.1";
// $db_user = "root";

// $db_pass = "";

$options = array(
    PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8',
	PDO::MYSQL_ATTR_SSL_CA => 'C:/xampp/htdocs/S-65/app_movil/lib/php/certificado.pem',
	PDO::MYSQL_ATTR_SSL_VERIFY_SERVER_CERT => false,
);

$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass, $options);

$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
$db->setAttribute(PDO::MYSQL_ATTR_SSL_CERT,true);

?>