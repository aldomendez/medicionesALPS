<?php

include "database.php";
ini_set('display_errors','off');
ini_set('date.timezone', 'America/Mexico_City');
ini_set('display_errors', '1');
error_reporting(E_ALL ^ E_NOTICE);

$db = new MxOptix();
echo "<pre>";
// print_r($_POST);

if (isset($_POST['data']) && $_POST['data'] !== ''){
  foreach ($_POST['data'] as $key => $value) {
    echo $key . ': ' . $value['SERIAL_NUM'] . ' ' ;
  }

	// getData();

}

/*
 * Formato en el que se envian los datos al server
{
    "SYSTEM_ID": "CYBOND54",
    "SERIAL_NUM": "148356722",
    "PASS_FAIL": "P",
    "PROCESS_DATE": "28-JAN-14",
    "STEP_NAME": "LR4 GLASS LENS ATTACH",
    "CYCLE_TIME": "887.599",
    "CARRIER_SERIAL_NUM": "148391000",
    "CARRIER_SITE": "1",
    "PART_CODE_NAME": "LR4TosaGen2 Lens Only",
    "LENS_POS_T": "-.282847",
    "LENS_POS_X": "-.00153946",
    "LENS_POS_Y": "-.025",
    "LENS_POS_Z": "-.0141219",
    "PART_NUM": "001055423",
    "MEAS_X": "",
    "MEAS_Y": "",
    "MEAS_T": ""
}
*/

function getData()
{
	// Toma el valor maximo de la base de datos y lo devuelve como ID
	global $db;

	$query = <<<QUERY
	SELECT
  system_id,
  serial_num,
  pass_fail,
  process_date,
  step_name,
  cycle_time,
  carrier_serial_num,
  carrier_site,
  part_code_name,
  LENS_POS_T,
  LENS_POS_X,
  LENS_POS_Y,
  LENS_POS_Z,
  part_num
FROM lr4_shim_assembly 
WHERE carrier_serial_num = '%carrier%'
QUERY;

	$query = str_replace('%carrier%', $_GET['carrier'], $query);
	$db->query($query);
	echo $db->json();
}
