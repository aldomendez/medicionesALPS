<?php header('X-UA-Compatible: IE=edge,chrome=1') ?><!doctype html>
<html lang="en">
<head>
	<meta charset="UTF-8">
  <meta X-UA-Compatible: IE=edge,chrome=1>
	<title>Process Checks de Lente</title>
  <link rel="stylesheet" href="./semanticUi/css/semantic.min.css">
	<!-- <link rel="stylesheet" href="./btrp/css/bootstrap.min.css"> -->
	<link rel="stylesheet" href="./vendor/nprogress.css">
</head>
<body>

<div class="ui column page grid" id="output">
  <!-- Aqui se inserta el template -->
</div>

<script id="template" type="text/MaxTemplate">

<div class="column">
<div class="ui  menu {{barstate}}">
  <a class="item" href="../">
    <i class="home icon"></i> Avago Tech
  </a>
  <a class="active item">
    <i class="pencil icon"></i> Captura{{#lookupCarrier}}: {{/lookupCarrier}}{{lookupCarrier}} 
  </a>{{#actualCarrier}}
  <a class="item" href="./#/carrier/{{actualCarrier}}">
    <i class="attachment icon"></i>{{actualCarrier}} 
  </a>{{/actualCarrier}}
  <div class="right menu">
    <div class="item">
      <div class="ui icon input">
        <input type="text"  placeholder="Carrier de ALPS" value="{{lookupCarrier}}">
        <i class="search link icon"></i>
      </div>
    </div>
  </div>
</div>

<div class="ui segment">
  <p>Maquinas involucradas: {{#involvedMachines}}<span class="ui label"><i class="desktop icon"></i>{{.}}</span>{{/involvedMachines}}</p>
  <p>Procesos: {{#process_performed}}<span class="ui label"><i class="lab icon"></i>{{.}}</span>{{/process_performed}}</p>

</div>

<table class='ui table small celled segment'>
 
<thead>
 <tr>
    <th>#</th>
    <th>Serial</th>
    <th>Machine</th>
    <th>X</th>
    <th>Y</th>
    <th>T</th>
  </tr> 
</thead>

  {{#carrier}}
    <tr>
      <td class="{{passFlag(PASS_FAIL)}}">{{CARRIER_SITE}}</td>
      <td class="{{passFlag(PASS_FAIL)}}">{{SERIAL_NUM}}</td>
      <td>{{SYSTEM_ID}}</td>
			<td class="{{isGood(MEAS_X, 'X')}}"><div class="ui  mini input"><input type="text" value="{{MEAS_X}}"></div></td>
			<td class="{{isGood(MEAS_Y, 'Y')}}"><div class="ui  mini input"><input type="text" value="{{MEAS_Y}}"></div></td>
      <td class="{{isGood(MEAS_T, 'T')}}"><div class="ui  mini input"><input type="text" value="{{MEAS_T}}"></div></td>
    </tr>
  {{/carrier}}
  {{^carrier}}
  <tr><td colspan="6"><h3>Ingresa un carrier, en la casilla de arriba para comenzar</h3></td></tr>
  {{/carrier}}
  <tfoot>
    <tr>
      <th colspan="6">
        <div class="ui blue labaled icon button" on-click="saveData"><i class="save icon"></i> {{action === 'update' ? 'Actualizar':'Guardar'}} datos</div>
      </th>
    </tr>
  </tfoot>
</table>
</div>

</script>
<!-- <script src="vendor/jquery-2.1.0.min.js"></script> -->
<!-- <script src="vendor/underscore-1.5.2.min.js"></script> -->
<!-- <script src="vendor/nprogress.js"></script> -->
<!-- <script src="vendor/Ractive.min.js"></script> -->
<!-- <script src="cenny.js"></script> -->
<script src="js/dist.min.js"></script>
</body>
</html>