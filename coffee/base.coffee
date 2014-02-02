
data = [{"SYSTEM_ID":"CYBOND54","SERIAL_NUM":"148356722","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"887.599","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"1","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.282847","LENS_POS_X":"-.00153946","LENS_POS_Y":"-.025","LENS_POS_Z":"-.0141219","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND54","SERIAL_NUM":"148356734","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"820.721","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"2","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".181191","LENS_POS_X":"-.00267133","LENS_POS_Y":"-.023272","LENS_POS_Z":"-.0176601","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356756","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"181.242","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"3","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".166271","LENS_POS_X":"-.00862634","LENS_POS_Y":"-.00456786","LENS_POS_Z":".00712115","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356776","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"273.002","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"4","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.251392","LENS_POS_X":"-.00658179","LENS_POS_Y":".0140623","LENS_POS_Z":".00737387","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356872","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"160.525","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"5","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".313612","LENS_POS_X":".00166923","LENS_POS_Y":"-.00460117","LENS_POS_Z":"-.00712198","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356954","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"177.014","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"6","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".0693534","LENS_POS_X":".00132641","LENS_POS_Y":"-.00345512","LENS_POS_Z":".00165659","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148356974","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"187.061","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"7","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.211841","LENS_POS_X":"-.00305705","LENS_POS_Y":"-.000645101","LENS_POS_Z":"-.00418466","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148357014","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"246.341","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"8","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".242568","LENS_POS_X":".0102794","LENS_POS_Y":".00232163","LENS_POS_Z":"-.0157432","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148367422","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"259.866","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"9","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":"-.148882","LENS_POS_X":"-.016564","LENS_POS_Y":".0242185","LENS_POS_Z":".00858981","PART_NUM":"001055423"},{"SYSTEM_ID":"CYBOND46","SERIAL_NUM":"148366948","PASS_FAIL":"P","PROCESS_DATE":"28-JAN-14","STEP_NAME":"LR4 GLASS LENS ATTACH","CYCLE_TIME":"160.852","CARRIER_SERIAL_NUM":"148391000","CARRIER_SITE":"10","PART_CODE_NAME":"LR4TosaGen2 Lens Only","LENS_POS_T":".27152","LENS_POS_X":"-.00233357","LENS_POS_Y":"-.00474426","LENS_POS_Z":"-.00156206","PART_NUM":"001055423"}]

class Carrier
  constructor: () ->
  setCarrier:(@carrier)->
    @setDefaults()
    @pluckCarriers()
    @sort()
    r.set('carrier',@carrier)
  setDefaults:()->
    defs = {limits:{x:{min:0,max:.005},y:{min:0,max:.005},t:{min:0,max:.005}}}
    _.defaults( carrier,defs )  for carrier in @carrier
  pluckCarriers:->
    d = _.keys _.groupBy( @carrier, (num) -> num.SYSTEM_ID )
    r.set('involvedMachines',d)
  sort:()->
    @carrier = _.sortBy(@carrier, (num) -> ("00"+num.CARRIER_SITE).slice(-2))

class Addr
  constructor: () ->
    @patrn = /#\/carrier\/(\d{9})/
    @test()
  test:()->
    @carrier = (@patrn.exec window.location.hash)
    if @carrier[1]?
      if @carrier.length == 9 and !isNaN(@carrier)
        @valid = true
        r.set('lookupCarrier',@carrier)

# var srvr = new Cenny({url:'./server/cenny.php'})

r = new Ractive {
  el: '#output',
  template: "#template",
  data: { 
    carrier:data,
    lookupCarrier:'',
    involvedMachines:[],
    warns:0,
    editing:false,
    isGood:(val,axis) ->
      pass = false
      if axis is 'X'
        pass = -.01 <= val <= .31
      else if axis is  'Y'
        pass = .003 <= val <= .02
      else if axis is 'T'
        pass = .18 <= val <= .26
      
      return if pass then 'positive' else 'warning'
    }
  }
ca = new Carrier()
ca.setCarrier(data)

loadNew = (newCarrier) ->
  NProgress.start()
  
  loader = $.getJSON('php/getData.php', {carrier:newCarrier})

  loader.done (data)->
    ca.setCarrier(data)
    NProgress.done()

  loader.fail (d) ->
    NProgress.done()


r.observe 'lookupCarrier',(newval, oldvar) ->
  if (newval.toString().length == 9)
    console.log(newval)
    r.set('actualCarrier',newval)
    loadNew(newval)
  else
    r.set('actualCarrier','')

# addr = new Addr()



