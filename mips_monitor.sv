//-------------------------------------------------------------------------
//						mips_monitor - 
//-------------------------------------------------------------------------

class mips_monitor extends uvm_monitor;

  //---------------------------------------
  // Virtual Interface
  //---------------------------------------
  virtual mips_if vif;

  //---------------------------------------
  // analysis port, to send the transaction to scoreboard
  //---------------------------------------
  uvm_analysis_port #(mips_seq_item) item_collected_port;
  
 // The following property holds the transaction information currently
  // begin captured (by the collect_address_phase and data_phase methods).
  //---------------------------------------
  mips_seq_item trans_collected;

  `uvm_component_utils(mips_monitor)

  //---------------------------------------
  // new - constructor
  //---------------------------------------
  function new (string name, uvm_component parent);
    super.new(name, parent);
    trans_collected = new();
    item_collected_port = new("item_collected_port", this);
  endfunction : new
  
 //---------------------------------------
  // build_phase - getting the interface handle
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mips_if)::get(this, "", "vif", vif))
       `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
  endfunction: build_phase  
  
 //---------------------------------------
  // run_phase - convert the signal level activity to transaction level.
  // i.e, sample the values on interface signal ans assigns to transaction class fields
  //---------------------------------------
  virtual task run_phase(uvm_phase phase);
    forever begin
      wait(vif.valid==1);
      wait(vif.current_state==0);
      @(posedge vif.clk);
     //  wait(vif.monitor_cb.extInst);
      trans_collected.extInst=vif.extInst;
       case (trans_collected.extInst[31:26])
         0:wait(vif.current_state==7);
         2:wait(vif.current_state==10);
         4:wait(vif.current_state==8);
         5:wait(vif.current_state==9);
         35:wait(vif.current_state==4);
         43:wait(vif.current_state==5);
       default: $display("ERROR OPCODE");
       endcase
	   @(negedge vif.clk);
      trans_collected.regmem_data=vif.regmem_data;             trans_collected.pc_current=vif.pc_current;        
      trans_collected.pc_next=vif.pc_next; 
      trans_collected.regf1=vif.regf1;
      trans_collected.regf2=vif.regf2;
      trans_collected.datamem_data=vif.datamem_data;

      
     item_collected_port.write(trans_collected);
     trans_collected.display("[Monitor]");
    end
  endtask : run_phase

endclass : mips_monitor