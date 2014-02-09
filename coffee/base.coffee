
data = []
NProgress.configure({ showSpinner: false })

class Carrier
  constructor: () ->
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
    if @carrier
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