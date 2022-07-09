//-------------------------------------------------------------------------
//						mips_driver - 
//-------------------------------------------------------------------------

`define DRIV_IF vif.DRIVER.driver_cb

class mips_driver extends uvm_driver #(mips_seq_item);
  
  //--------------------------------------- 
  // Virtual Interface
  //--------------------------------------- 
  virtual mips_if vif;
  `uvm_component_utils(mips_driver)
  
  //--------------------------------------- 
  // Constructor
  //--------------------------------------- 
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new  
  
  //--------------------------------------- 
  // build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mips_if)::get(this, "", "vif", vif))
       `uvm_fatal("NO_VIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase  
  
  
  
  //---------------------------------------  
  // run phase
  //---------------------------------------  
  virtual task run_phase(uvm_phase phase);
    begin
      @(posedge vif.clk);
      vif.valid<=1;
       vif.extInst = 32'b0;
      wait (!vif.rst);
      vif.valid<=1;
    end
    forever begin
      seq_item_port.get_next_item(req);
      drive();
      seq_item_port.item_done();
    end
  endtask : run_phase  
  
  
 //---------------------------------------
  // drive - transaction level to signal level
  // drives the value's from seq_item to interface signals
  //---------------------------------------
  virtual task drive();
   wait (vif.valid==1);
    wait(vif.current_state==0);
    vif.extInst <= req.extInst; 
    @(posedge vif.clk);  

  endtask : drive
endclass : mips_driver  