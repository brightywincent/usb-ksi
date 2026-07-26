`ifndef CONFIGURATION_DESCRIPTOR_VH
`define CONFIGURATION_DESCRIPTOR_VH
    //Fields in order lsb-msb
    `define bLength 8'h09 //Always 9 bytes. config descriptor length
    `define bDescriptorType 8'h02 //always 2. Because, descriptor no.2 is config descriptor
    `define wTotalLength 16'h0020  //Size of the entire configuration block, not just the config descriptor
    `define bNumInterfaces 8'h01  //No. of interfaces. Tells host no. of interface descriptors that'll follow
    `define bConfigurationValue 8'h01  //Must match the configuration from the config manager
    `define iConfiguration 8'h00  //Index for configuration string. If no config string, 8'h00.
    `define bmAttributes 8'h80  //Made up of 8 separate bits 
                           // bit-7: Always 1, USB requires this
                           // bit-6: self powered - 1, bus powered - 0
                           // bit-5: remote wakeup - 1, no - 0
                           // bit-[4-0]: Always reserved - 00000 
    `define bMaxPower 8'h32  //Max current consumption measured in units of 2mA
`endif
