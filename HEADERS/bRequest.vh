`ifndef bRequest_VH
`define bRequest_VH
    //Standard Requests
    `define GET_STATUS 8'h00;
    `define CLEAR_FEATURE 8'h01;
    `define SET_FEATURE 8'h03;
    `define SET_ADDRESS 8'h05;
    `define GET_DESCRIPTOR 8'h06;
    `define SET_DESCRIPTOR 8'h07;
    `define GET_CONFIGURATION 8'h008;
    `define SET_CONFIGURATION 8'h009;
    `define GET_INTERFACE 8'h0A;
    `define SET_INTERFACE 8'h0B;
    `define SYNCH_FRAME 8'h0C;
    //Class Requests for MSC
    `define BULK_ONLY_RESET 8'hFF;
    `define GET_MAX_LUN 8'hFE;

`endif
