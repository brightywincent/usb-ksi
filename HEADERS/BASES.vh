`ifndef BASES_VH
`define BASES_VH
    
    //Base addresses of the descriptors in the descriptor_rom.v module
    `define DEVICE_BASE 8'h00;  //length = 8'h12
    `define CONFIGURATION_BASE 8'h12;  //length = 8'h09
    `define INTERFACE_BASE 8'h1B;  //length = 8'h09
    `define EP1OUT_BASE 8'h24;  //length = 8'h07
    `define EP1IN_BASE 8'h2B;  //length = 8'h07
    `define STRING0_BASE 8'h32;  //length = 8'h04
    `define STRING1_BASE 8'h36;  //length = 8'h10
    `define STRING2_BASE 8'h46;  //length = 8'h10
    `define STRING3_BASE 8'h56;  //length = 8'h0E

    `define DEVICE_LENGTH 8'h12;
    `define CONFIGURATION_LENGTH 8'h20;
    `define INTERFACE_LENGTH 8'h09;
    `define EP1OUT_LENGTH 8'h07;
    `define EP1IN_LENGTH 8'h07;
    `define STRING0_LENGTH 8'h04;
    `define STRING1_LENGTH 8'h10;
    `define STRING2_LENGTH 8'h10;
    `define STRING3_LENGTH 8'h0E;

`endif
