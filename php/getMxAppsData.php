<?php

include "database.php";
ini_set('display_errors','off');
ini_set('date.timezone', 'America/Mexico_City');
ini_set('display_errors', '1');
error_reporting(E_ALL ^ E_NOTICE);

$db = new MxApps();
// echo "<pre>";
// print_r($_SERVER);

if (isset($_GET['carrier']) && $_GET['carrier'] !== ''){

	getData();

}


function getData()
{
	// Toma el valor maximo de la base de datos y lo devuelve como ID
	global $db;

	$query = <<<QUERY
	SELECT
  *
FROM medicion_alps 
WHERE carrier = '%carrier%'
QUERY;

	$query = str_replace('%carrier%', $_GET['carrier'], $query);
	$db->query($query);
	echo $db->json();
}
