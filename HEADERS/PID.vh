`ifndef PID_VH
`define PID_VH

//PID TYPEs
`define PID_SPECIAL 2'b00
`define PID_TOKEN 2'b01
`define PID_HANDSHAKE 2'b10
`define PID_DATA 2'b11

//TOKEN PIDs
`define PID_OUT 8'b1110_0001
`define PID_SOF 8'b1010_0101
`define PID_IN 8'b0110_1001
`define PID_SETUP 8'b0010_1101

//DATA PIDs
`define PID_DATA0 8'b1100_0011
`define PID_DATA2 8'b1000_0111
`define PID_DATA1 8'b0100_1011
`define PID_MDATA 8'b0000_1111

//HANDSHAKE PIDs
`define PID_ACK 8'b1101_0010
`define PID_NYET 8'b1001_0110
`define PID_NAK 8'b0101_1010
`define PID_STALL 8'b0001_1110

//SPECIAL
`define PID_PING 8'b1011_0100
`define PID_SPLIT 8'b0111_1000
`define PID_PRE 8'b0011_1100

`define PID_INVALID 8'b0000_0000

`endif
