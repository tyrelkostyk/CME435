module port_fsm (clk, 
  reset, 
  write_enb, 
  ffee, 
  hold, 
  data_status, 
  data_in, 
  data_out, 
  mem0, 
  mem1, 
  mem2, 
  mem3, 
  addr); 

input clk; 
input reset; 
input [7:0] mem0; 
input [7:0] mem1; 
input [7:0] mem2; 
input [7:0] mem3; 
output[3:0] write_enb; 
input ffee; 
input hold; 
input data_status; 
input[7:0] data_in; 
output[7:0] data_out; 
output [7:0] addr; 
reg [7:0] data_out; 
reg [7:0] addr; 
reg [3:0] write_enb_r; 
reg fsm_write_enb; 
reg [3:0] state_r; 
reg [3:0] state; 
reg [7:0] parity; 
reg [7:0] parity_delayed; 
reg sus_data_in,error; 

parameter ADDR_WAIT = 4'b0000; 
parameter DATA_LOAD = 4'b0001; 
parameter PARITY_LOAD = 4'b0010; 
parameter HOLD_STATE = 4'b0011; 
parameter BUSY_STATE = 4'b0100; 

always@(negedge reset) 
begin 
  error = 1'b0; 
  data_out = 8'b0000_0000; 
  addr = 8'b00000000; 
  write_enb_r = 3'b000; 
  fsm_write_enb = 1'b0; 
  state_r = 4'b0000; 
  state = 4'b0000; 
  parity = 8'b0000_0000; 
  parity_delayed = 8'b0000_0000; 
  sus_data_in = 1'b0; 
end 

assign busy = sus_data_in; 
always @(data_status) begin : addr_mux 
  if (data_status == 1'b1) begin 
    case (data_in) 
    mem0 : begin 
      write_enb_r[0] = 1'b1; 
      write_enb_r[1] = 1'b0; 
      write_enb_r[2] = 1'b0; 
      write_enb_r[3] = 1'b0; 
    end 
    mem1 : begin 
      write_enb_r[0] = 1'b0; 
      write_enb_r[1] = 1'b1; 
      write_enb_r[2] = 1'b0; 
      write_enb_r[3] = 1'b0; 
    end 
    mem2 : begin 
      write_enb_r[0] = 1'b0; 
      write_enb_r[1] = 1'b0; 
      write_enb_r[2] = 1'b1; 
      write_enb_r[3] = 1'b0; 
    end 
    mem3 : begin 
      write_enb_r[0] = 1'b0; 
      write_enb_r[1] = 1'b0; 
      write_enb_r[2] = 1'b0; 
      write_enb_r[3] = 1'b1; 
    end 
    default :write_enb_r = 3'b000; 
    endcase 
// $display(" data_inii %d ,mem0 %d ,mem1 %d ,mem2 %d mem3",data_in,mem0,mem1,mem2,mem3); 
  end //if 
end //addr_mux; 

always @(posedge clk) begin : fsm_state 
  state_r <= state; 
end //fsm_state; 

always @(state_r or data_status or ffee or hold or data_in) 
begin : fsm_core 
  state = state_r; //Default state assignment 
  case (state_r) 
  ADDR_WAIT : begin 
    if ((data_status == 1'b1) && ((mem0 == data_in)||(mem1 == data_in)||(mem3 == data_in) ||(mem2 == data_in))) 
	begin 
      if (ffee == 1'b1) begin 
        state = DATA_LOAD; 
      end 
      else begin 
        state = BUSY_STATE; 
      end //if 
    end //if; 
    sus_data_in = !ffee; 
    if ((data_status == 1'b1) && ((mem0 == data_in)||(mem1 == data_in)||(mem3 == data_in) ||(mem2 == data_in)) && (ffee == 1'b1)) 
    begin 
      addr = data_in; 
      data_out = data_in; 
      fsm_write_enb = 1'b1; 
    end 
    else begin 
      fsm_write_enb = 1'b0; 
    end //if 
  end // of case ADDR_WAIT 
  PARITY_LOAD : begin 
    state = ADDR_WAIT; 
    data_out = data_in; 
    fsm_write_enb = 1'b0; 
  end // of case PARITY_LOAD 
  DATA_LOAD : begin 
    if ((data_status == 1'b1) && (hold == 1'b0)) begin 
      state = DATA_LOAD; 
    end 
    else if ((data_status == 1'b0) && (hold == 1'b0)) begin 
      state = PARITY_LOAD; 
    end 
    else begin 
      state = HOLD_STATE; 
    end //if 
    sus_data_in = 1'b0; 
    if ((data_status == 1'b1) && (hold == 1'b0)) begin 
      data_out = data_in; 
      fsm_write_enb = 1'b1; 
    end 
    else if ((data_status == 1'b0) && (hold == 1'b0)) begin 
      data_out = data_in; 
      fsm_write_enb = 1'b1; 
    end 
    else begin 
      fsm_write_enb = 1'b0; 
    end //if 
  end //end of case DATA_LOAD 
  HOLD_STATE : begin 
    if (hold == 1'b1) begin 
      state = HOLD_STATE; 
    end 
    else if ((hold == 1'b0) && (data_status == 1'b0)) begin 
      state = PARITY_LOAD; 
    end 
    else begin 
      state = DATA_LOAD; 
    end //if 
    if (hold == 1'b1) begin 
      sus_data_in = 1'b1; 
      fsm_write_enb = 1'b0; 
    end 
    else begin 
      fsm_write_enb = 1'b1; 
      data_out = data_in; 
    end //if 
  end //end of case HOLD_STATE 
  BUSY_STATE : begin 
    if (ffee == 1'b0) begin 
      state = BUSY_STATE; 
    end 
    else begin 
      state = DATA_LOAD; 
    end //if 
    if (ffee == 1'b0) begin 
      sus_data_in = 1'b1; 
    end 
    else begin 
      addr = data_in; // hans 
      data_out = data_in; 
      fsm_write_enb = 1'b1; 
    end //if 
  end //end of case BUSY_STATE 
  endcase 
end //fsm_core 

assign write_enb[0] = write_enb_r[0] & fsm_write_enb; 
assign write_enb[1] = write_enb_r[1] & fsm_write_enb; 
assign write_enb[2] = write_enb_r[2] & fsm_write_enb; 
assign write_enb[3] = write_enb_r[3] & fsm_write_enb; 

endmodule //port_fsm 