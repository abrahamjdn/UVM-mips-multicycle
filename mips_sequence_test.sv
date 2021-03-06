//-------------------------------------------------------------------------
//						mips_sequence_test -
//-------------------------------------------------------------------------
class mips_sequence_test extends mips_model_base_test;

  `uvm_component_utils(mips_sequence_test)
  
  //---------------------------------------
  // sequence instance 
  //--------------------------------------- 
  mips_random_sequence seq;

  //---------------------------------------
  // constructor
  //---------------------------------------
  function new(string name = "mips_sequence_test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new

  //---------------------------------------
  // build_phase
  //---------------------------------------
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create the sequence
    seq = mips_random_sequence::type_id::create("seq");
  endfunction : build_phase
  
  //---------------------------------------
  // run_phase - starting the test
  //---------------------------------------
  task run_phase(uvm_phase phase);
    
    phase.raise_objection(this);
    seq.start(env.mips_agnt.sequencer);
    phase.drop_objection(this);
    
    //set a drain-time for the environment if desired
    phase.phase_done.set_drain_time(this, 10);
  endtask : run_phase
  
endclass : mips_sequence_test