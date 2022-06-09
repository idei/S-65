<?php
header('Content-Type: application/json; charset=utf8');

/*$db_name = "id16812177_app65mas";
$db_server = "localhost";
$db_user = "id16812177_admin";
$db_pass = "Mas65-2021bue";
*/
//-------------- LOCAL -----------------------

$db_name = "dbs65";
$db_server = "127.0.0.1";
$db_user = "root";

$db_pass = "";


$db = new PDO("mysql:host={$db_server};dbname={$db_name};charset=utf8", $db_user, $db_pass);

$db->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
$db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
?>