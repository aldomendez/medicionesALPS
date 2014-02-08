
# data = [{"SYSTEM_ID":"CYBOND54","SERIAL_NUM":"148356722","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"887.599","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"1","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.282847","LENS_POS_X":"-.00153946","LENS_POS_Y":"-.025","LENS_POS_Z":"-.0141219","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND54","SERIAL_NUM":"148356734","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"820.721","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"2","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".181191","LENS_POS_X":"-.00267133","LENS_POS_Y":"-.023272","LENS_POS_Z":"-.0176601","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356756","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"181.242","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"3","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".166271","LENS_POS_X":"-.00862634","LENS_POS_Y":"-.00456786","LENS_POS_Z":".00712115","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356776","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"273.002","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"4","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.251392","LENS_POS_X":"-.00658179","LENS_POS_Y":".0140623","LENS_POS_Z":".00737387","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356872","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"160.525","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"5","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".313612","LENS_POS_X":".00166923","LENS_POS_Y":"-.00460117","LENS_POS_Z":"-.00712198","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356954","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"177.014","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"6","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".0693534","LENS_POS_X":".00132641","LENS_POS_Y":"-.00345512","LENS_POS_Z":".00165659","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356974","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"187.061","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"7","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.211841","LENS_POS_X":"-.00305705","LENS_POS_Y":"-.000645101","LENS_POS_Z":"-.00418466","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148357014","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"246.341","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"8","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".242568","LENS_POS_X":".0102794","LENS_POS_Y":".00232163","LENS_POS_Z":"-.0157432","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148367422","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"259.866","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"9","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.148882","LENS_POS_X":"-.016564","LENS_POS_Y":".0242185","LENS_POS_Z":".00858981","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148366948","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"160.852","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"10","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".27152","LENS_POS_X":"-.00233357","LENS_POS_Y":"-.00474426","LENS_POS_Z":"-.00156206","PART_NUM":"001055423"}]
data = []
# Hide loading spinner
NProgress.configure({ showSpinner: false })

class Carrier
  constructor: () ->
    @process=["LR4TosaGen2 Lens Only","LR4RosaGen2 Lens Only"]
  setCarrier:(@carrier)->
    @setDefaults()
    @pluckCarriers()
    @pluckProcess()
    @sort()
    r.set('carrier',@carrier)
    NProgress.done()
  setDefaults:()->
    defs = {MEAS_X:'',MEAS_Y:'',MEAS_T:''}
    _.defaults( carrier,defs )  for carrier in @carrier
  pluckCarriers:->
    d = _.keys _.groupBy( @carrier, (num) -> num.SYSTEM_ID )
    r.set('involvedMachines',d)
  pluckProcess:->
    d = _.keys _.groupBy( @carrier, (num) -> num.PART_CODE_NAME )
    r.set('process_performed',d)
  sort:()->
    @carrier = _.sortBy @carrier, (num) -> ("00"+num.CARRIER_SITE).slice(-2)
  setStoredData:(@rawCapturedData)->
    if rawCapturedData.length == 0
      r.set 'action', 'save'
    else
      r.set 'action', 'update'
  consolidateData:()->
    if @rawCapturedData.length != 0
      r.set 'carrier', @rawCapturedData


class Addr
  constructor: () ->
    @valid = false
    @patrn = /#\/carrier\/(\d{9})/
    @test()
  test:()->
    @carrier = (@patrn.exec window.location.hash)
    if @carrier[1]?
      if @carrier[1].length == 9 and !isNaN(@carrier[1])
        @valid = true
        r.set('lookupCarrier',@carrier[1])
  setbyCarrier:(carrier)->
    window.location.hash = "./#/carrier/#{carrier}"

# var srvr = new Cenny({url:'./server/cenny.php'})

r = new Ractive {
  el: '#output',
  template: "#template",
  data: { 
    carrier:data,
    action:'save', # can be save|update
    lookupCarrier:'',
    involvedMachines:[],
    process_performed:[],
    warns:0,
    editing:false,
    isGood:(val,axis) ->
      pass = false
      if axis is 'X'
        pass = -.01 <= val <= .01
      else if axis is  'Y'
        pass = -.03 <= val <= .03
      else if axis is 'T'
        pass = -.018 <= val <= .18
      else if axis is 'Z'
        pass = -.018 <= val <= .18
      
      return if pass then 'positive' else 'warning'
    }
  }


loadNew = (newCarrier) ->
  NProgress.start()
  
  MxOptix = $.getJSON 'php/getMxOptixData.php', {carrier:newCarrier}
  MxOptix.done (data)->
    ca.setCarrier(data)
    NProgress.inc()
    console.log "MxOptix"
  MxOptix.fail (d) ->
    NProgress.done()

  MxApps = $.getJSON 'php/getMxAppsData.php', {carrier:newCarrier}
  MxApps.done (data)->
    ca.setStoredData(data)
    NProgress.inc()
    console.log "MxApps"
  MxApps.fail (d) ->
    NProgress.done()

  # Pruebas de como se usa $.when
  # http://jsfiddle.net/cg9J3/
  $.when(MxApps,MxOptix).done ()-> 
    ca.consolidateData()
    NProgress.done()
    console.log "When"

r.on 'saveData', ()->
  NProgress.start()
  saving = $.post 'php/saveMeasures.php', {data:r.data.carrier,action:r.data.action}
  saving.done (data)->
  NProgress.done()


r.observe 'lookupCarrier',(carrier, oldvar) ->
  if (carrier.toString().length == 9)
    r.set('actualCarrier',carrier)
    # addr.setbyCarrier(carrier)
    loadNew(carrier)
  else
    r.set('actualCarrier','')

ca = new Carrier()
ca.setCarrier(data)
addr = new Addr()