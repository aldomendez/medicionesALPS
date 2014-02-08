// Generated by CoffeeScript 1.7.1
var Addr, Carrier, addr, ca, data, loadNew, r;

data = [];

NProgress.configure({
  showSpinner: false
});

Carrier = (function() {
  function Carrier() {
    this.process = ["LR4TosaGen2 Lens Only", "LR4RosaGen2 Lens Only"];
  }

  Carrier.prototype.setCarrier = function(carrier) {
    this.carrier = carrier;
    this.setDefaults();
    this.pluckCarriers();
    this.pluckProcess();
    this.sort();
    r.set('carrier', this.carrier);
    return NProgress.done();
  };

  Carrier.prototype.setDefaults = function() {
    var carrier, defs, _i, _len, _ref, _results;
    defs = {
      MEAS_X: '',
      MEAS_Y: '',
      MEAS_T: ''
    };
    _ref = this.carrier;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      carrier = _ref[_i];
      _results.push(_.defaults(carrier, defs));
    }
    return _results;
  };

  Carrier.prototype.pluckCarriers = function() {
    var d;
    d = _.keys(_.groupBy(this.carrier, function(num) {
      return num.SYSTEM_ID;
    }));
    return r.set('involvedMachines', d);
  };

  Carrier.prototype.pluckProcess = function() {
    var d;
    d = _.keys(_.groupBy(this.carrier, function(num) {
      return num.PART_CODE_NAME;
    }));
    return r.set('process_performed', d);
  };

  Carrier.prototype.sort = function() {
    return this.carrier = _.sortBy(this.carrier, function(num) {
      return ("00" + num.CARRIER_SITE).slice(-2);
    });
  };

  Carrier.prototype.setStoredData = function(rawCapturedData) {
    this.rawCapturedData = rawCapturedData;
    if (rawCapturedData.length === 0) {
      return r.set('action', 'save');
    } else {
      return r.set('action', 'update');
    }
  };

  Carrier.prototype.consolidateData = function() {
    if (this.rawCapturedData.length !== 0) {
      return r.set('carrier', this.rawCapturedData);
    }
  };

  return Carrier;

})();

Addr = (function() {
  function Addr() {
    this.valid = false;
    this.patrn = /#\/carrier\/(\d{9})/;
    this.test();
  }

  Addr.prototype.test = function() {
    this.carrier = this.patrn.exec(window.location.hash);
    if (this.carrier[1] != null) {
      if (this.carrier[1].length === 9 && !isNaN(this.carrier[1])) {
        this.valid = true;
        return r.set('lookupCarrier', this.carrier[1]);
      }
    }
  };

  Addr.prototype.setbyCarrier = function(carrier) {
    return window.location.hash = "./#/carrier/" + carrier;
  };

  return Addr;

})();

r = new Ractive({
  el: '#output',
  template: "#template",
  data: {
    carrier: data,
    action: 'save',
    lookupCarrier: '',
    involvedMachines: [],
    process_performed: [],
    warns: 0,
    editing: false,
    isGood: function(val, axis) {
      var pass;
      pass = false;
      if (axis === 'X') {
        pass = (-.01 <= val && val <= .01);
      } else if (axis === 'Y') {
        pass = (-.03 <= val && val <= .03);
      } else if (axis === 'T') {
        pass = (-.018 <= val && val <= .18);
      } else if (axis === 'Z') {
        pass = (-.018 <= val && val <= .18);
      }
      if (pass) {
        return 'positive';
      } else {
        return 'warning';
      }
    }
  }
});

loadNew = function(newCarrier) {
  var MxApps, MxOptix;
  NProgress.start();
  MxOptix = $.getJSON('php/getMxOptixData.php', {
    carrier: newCarrier
  });
  MxOptix.done(function(data) {
    ca.setCarrier(data);
    NProgress.inc();
    return console.log("MxOptix");
  });
  MxOptix.fail(function(d) {
    return NProgress.done();
  });
  MxApps = $.getJSON('php/getMxAppsData.php', {
    carrier: newCarrier
  });
  MxApps.done(function(data) {
    ca.setStoredData(data);
    NProgress.inc();
    return console.log("MxApps");
  });
  MxApps.fail(function(d) {
    return NProgress.done();
  });
  return $.when(MxApps, MxOptix).done(function() {
    ca.consolidateData();
    NProgress.done();
    return console.log("When");
  });
};

r.on('saveData', function() {
  var saving;
  NProgress.start();
  saving = $.post('php/saveMeasures.php', {
    data: r.data.carrier,
    action: r.data.action
  });
  saving.done(function(data) {});
  return NProgress.done();
});

r.observe('lookupCarrier', function(carrier, oldvar) {
  if (carrier.toString().length === 9) {
    r.set('actualCarrier', carrier);
    return loadNew(carrier);
  } else {
    return r.set('actualCarrier', '');
  }
});

ca = new Carrier();

ca.setCarrier(data);

addr = new Addr();
