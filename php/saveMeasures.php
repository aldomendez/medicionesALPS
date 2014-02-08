<?php

include "database.php";
ini_set('display_errors','off');
ini_set('date.timezone', 'America/Mexico_City');
ini_set('display_errors', '1');
error_reporting(E_ALL ^ E_NOTICE);

$db = new MxApps();
// echo "<pre>";
// print_r($_POST);

if (isset($_POST['data']) && isset($_POST['action']) ){
  
  if ($_POST['action'] == 'save') {
    save_data();
  } elseif ( $_POST['action'] == 'update' ) {
    update_data();
  } else {
    echo "Command unknown";
  }
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

/*
CREATE Table medicion_alps (
  -- "Datos estandard" (todas las tablas los llevan)
  serial_num    varchar(12),
  process     varchar(12), --TOSA/ROSA
  measured_date date DEFAULT (sysdate),
  system_id   varchar(15),
  carrier     varchar(12),
  carrier_site  varchar(5),
  user_id     varchar(15),
  comments    varchar(500),
  passfail    varchar(1),
  -------------------------------------------------
  -- Datos de los shear test
  MEAS_X      number,
  MEAS_Y      number,
  MEAS_T      number
)

*/


function save_data()
{

  global $db;
  // Construye, los numeros de carrier que usaremos
  $values = array();
  foreach ($_POST['data'] as $key => $value) {
    array_push($values, array());
    array_push($values[$key], $value['SERIAL_NUM']);
    array_push($values[$key], $value['PART_CODE_NAME'] == 'LR4TosaGen2 Lens Only' ? 'TOSA' : 'ROSA');
    array_push($values[$key], $value['SYSTEM_ID']);
    array_push($values[$key], $value['CARRIER_SERIAL_NUM']);
    array_push($values[$key], $value['CARRIER_SITE']);
    array_push($values[$key], $value['PASS_FAIL']);
    array_push($values[$key], $value['MEAS_X']);
    array_push($values[$key], $value['MEAS_Y']);
    array_push($values[$key], $value['MEAS_T']);
  }

  $query = <<<QUERY
--------------------------------------------------------
insert into medicion_alps
(
  serial_num,process,system_id,carrier_serial_num,carrier_site,passfail,MEAS_X,MEAS_Y,MEAS_T
)
values(%values%)
QUERY;

  foreach ($values as $key => $value) {
    // print_r($value);
    $qry = str_replace('%values%', "'" . implode("','", $value) . "'", $query);
    echo $qry;
    $db->insert($qry);
    // echo $db->json();
  }
  
}

function update_data()
{

  global $db;

  foreach ($_POST['data'] as $key => $value) {
  
  $query = <<<QUERY

update medicion_alps
set
  MEAS_X = '%MEAS_X%'
  MEAS_Y = '%MEAS_Y%'
  MEAS_T = '%MEAS_T%'
where
  CARRIER_SERIAL_NUM = '%CARRIER_SERIAL_NUM%'
  and   CARRIER_SITE = '%CARRIER_SITE%'
QUERY;

    // print_r($value);
    $qry = str_replace('%MEAS_X%', $value['MEAS_X'], $query);
    $qry = str_replace('%MEAS_Y%', $value['MEAS_Y'], $query);
    $qry = str_replace('%MEAS_T%', $value['MEAS_T'], $query);
    $qry = str_replace('%CARRIER_SERIAL_NUM%', $value['CARRIER_SERIAL_NUM'], $query);
    $qry = str_replace('%CARRIER_SITE%', $value['CARRIER_SITE'], $query);
    echo $qry;
    // $db->insert($qry);
    // echo $db->json();
  
  }

}
