`ifndef DEVICE_DESCRIPTOR_VH
`define DEVICE_DESCRIPTOR_VH
    
    // Fields in order lsb-msb
    bLength 8'h12
    bDescriptorType 8'h01
    bcdUSB 16'h0200
    bDeviceClass 8'h00  //Doesn't mean no class. Means look inside INTERFACE DESCRIPTOR 
    bDeviceSubClass 8'h00
    bDeviceProtocol 8'h00  //Defined per interface
    bMaxPacketSize0 8'h40  //Max packet size of EP0
    idVendor 16'h1234 //Defined by USB-IF. Often use dummy values
    idProduct 16'h0001  //Chosen by manufacturer
    bcdDevice 16'h0100  //Version of the device
    iManufacturer 8'h01  //Index of manufacturer string descriptor 
    iProduct 8'h02  //
    iSerialNumber 8'h03 
    bNumConfigurations 8'h01 //Number of configurations

`endif
