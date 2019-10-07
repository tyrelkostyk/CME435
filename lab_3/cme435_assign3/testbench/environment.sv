class environment;

//virtual interface
virtual intf vif;

//constructor
function new( virtual intf vif );
  //get the interface from test
  this.vif = vif;

endfunction

endclass
