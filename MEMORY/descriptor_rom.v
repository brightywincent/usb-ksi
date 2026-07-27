`include "DEVICE_DESCRIPTOR.vh"
`include "CONFIGURATION_DESCRIPTOR.vh"
module descriptor_rom(
    input wire [7:0]dr_rd_addr_i,
    output wire [7:0]dr_rd_byte_o,
    output wire dr_byte_valid_o
);
    
    always @(*)begin
        case(dr_rd_addr_i)
            //Device Descriptor
            8'h00 : dr_rd_byte_o = 8'h12  //bLength
            8'h01 : dr_rd_byte_o = 8'h01  //bDescriptorType
            8'h02 : dr_rd_byte_o = 16'h0200 //bcdUSB
            8'h04 : dr_rd_byte_o = 8'h00  //bDeviceClass
            8'h05 : dr_rd_byte_o = 8'h00  //bDeviceSubClass
            8'h06 : dr_rd_byte_o = 8'h00  //bDeviceProtocol
            8'h07 : dr_rd_byte_o = 8'h04  //bMaxPacketSize0
            8'h08 : dr_rd_byte_o = 16'h1234  //idVendor
            8'h0A : dr_rd_byte_o = 16'h0001  //idProduct
            8'h0C : dr_rd_byte_o = 16'h0100  //bcdDevice
            8'h0E : dr_rd_byte_o = 8'h01  //iManufacturer
            8'h0F : dr_rd_byte_o = 8'h02 //iProduct
            8'h10 : dr_rd_byte_o = 8'h03 //iSerialNumber
            8'h11 : dr_rd_byte_o = 8'h01 //bNumConfigurations
            
            //Configuration Descriptor
            8'h12 : dr_rd_byte_o =   //bLength
            8'h13 : dr_rd_byte_o =   //bDescriptorType
            8'h14 : dr_rd_byte_o =   //wTotalLength
            8'h16 : dr_rd_byte_o =   //bNumInterfaces
            8'h17 : dr_rd_byte_o =   //bConfigurationValue
            8'h18 : dr_rd_byte_o =   //iConfiguration
            8'h19 : dr_rd_byte_o =   //bmAttributes
            8'h1A : dr_rd_byte_o =   //bMaxPower

            //Interface Descriptor
            8'h1B : dr_rd_byte_o =   //bLength
            8'h1C : dr_rd_byte_o =   //bDescriptorType
            8'h1D : dr_rd_byte_o =   //bInterfaceNumber
            8'h1E : dr_rd_byte_o =   //bAlternateSetting
            8'h1F : dr_rd_byte_o =   //bNumEndpoints
            8'h20 : dr_rd_byte_o =   //bInterfaceClass
            8'h21 : dr_rd_byte_o =   //bInterfaceSubClass
            8'h22 : dr_rd_byte_o =   //bInterfaceProtocol
            8'h23 : dr_rd_byte_o =   //iInterface
            
            //Endpoint Descriptor
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
            8'h24 : dr_rd_byte_o =   //
        endcase
    end

endmodule
