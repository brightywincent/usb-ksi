module descriptor_rom(
    input wire [7:0]dr_rd_addr_i,
    output reg [7:0]dr_rd_byte_o
);
    
    always @(*)begin
        case(dr_rd_addr_i)
            //Device Descriptor
            8'h00 : dr_rd_byte_o = 8'h12;  //bLength
            8'h01 : dr_rd_byte_o = 8'h01;  //bDescriptorType
            8'h02 : dr_rd_byte_o = 8'h00;  //bcdUSB
            8'h03 : dr_rd_byte_o = 8'h02;
            8'h04 : dr_rd_byte_o = 8'h00;  //bDeviceClass
            8'h05 : dr_rd_byte_o = 8'h00;  //bDeviceSubClass
            8'h06 : dr_rd_byte_o = 8'h00;  //bDeviceProtocol
            8'h07 : dr_rd_byte_o = 8'h04;  //bMaxPacketSize0
            8'h08 : dr_rd_byte_o = 8'h34;  //idVendor
            8'h09 : dr_rd_byte_o = 8'h12;
            8'h0A : dr_rd_byte_o = 8'h01;  //idProduct
            8'h0B : dr_rd_byte_o = 8'h00;
            8'h0C : dr_rd_byte_o = 8'h00;  //bcdDevice
            8'h0D : dr_rd_byte_o = 8'h01;
            8'h0E : dr_rd_byte_o = 8'h01;  //iManufacturer
            8'h0F : dr_rd_byte_o = 8'h02;  //iProduct
            8'h10 : dr_rd_byte_o = 8'h03;  //iSerialNumber
            8'h11 : dr_rd_byte_o = 8'h01;  //bNumConfigurations
            
            //Configuration Descriptor
            8'h12 : dr_rd_byte_o = 8'h09;   //bLength
            8'h13 : dr_rd_byte_o = 8'h02;   //bDescriptorType
            8'h14 : dr_rd_byte_o = 8'h20;   //wTotalLength
            8'h15 : dr_rd_byte_o = 8'h00;
            8'h16 : dr_rd_byte_o = 8'h01;   //bNumInterfaces
            8'h17 : dr_rd_byte_o = 8'h01;   //bConfigurationValue
            8'h18 : dr_rd_byte_o = 8'h00;   //iConfiguration
            8'h19 : dr_rd_byte_o = 8'h80;   //bmAttributes
            8'h1A : dr_rd_byte_o = 8'h32;   //bMaxPower

            //Interface Descriptor
            8'h1B : dr_rd_byte_o = 8'h09;   //bLength
            8'h1C : dr_rd_byte_o = 8'h04;   //bDescriptorType
            8'h1D : dr_rd_byte_o = 8'h00;   //bInterfaceNumber
            8'h1E : dr_rd_byte_o = 8'h00;   //bAlternateSetting
            8'h1F : dr_rd_byte_o = 8'h02;   //bNumEndpoints
            8'h20 : dr_rd_byte_o = 8'h03;   //bInterfaceClass
            8'h21 : dr_rd_byte_o = 8'h01;   //bInterfaceSubClass
            8'h22 : dr_rd_byte_o = 8'h01;   //bInterfaceProtocol
            8'h23 : dr_rd_byte_o = 8'h00;   //iInterface
            
            //Endpoint EP1 OUT Descriptor
            8'h24 : dr_rd_byte_o = 8'h07;  // bLength
            8'h25 : dr_rd_byte_o = 8'h05;  // bDescriptorType (Endpoint)
            8'h26 : dr_rd_byte_o = 8'h01;  // bEndpointAddress (EP1 OUT)
            8'h27 : dr_rd_byte_o = 8'h02;  // bmAttributes (Bulk)
            8'h28 : dr_rd_byte_o = 8'h00;  // wMaxPacketSize (LSB)
            8'h29 : dr_rd_byte_o = 8'h02;  // wMaxPacketSize (MSB) = 512 Bytes
            8'h2A : dr_rd_byte_o = 8'h00;  // bInterval

            //Endpoint EP1 IN Descriptor
            8'h2B : dr_rd_byte_o = 8'h07;  // bLength
            8'h2C : dr_rd_byte_o = 8'h05;  // bDescriptorType (Endpoint)
            8'h2D : dr_rd_byte_o = 8'h81;  // bEndpointAddress (EP1 IN)
            8'h2E : dr_rd_byte_o = 8'h02;  // bmAttributes (Bulk)
            8'h2F : dr_rd_byte_o = 8'h00;  // wMaxPacketSize (LSB)
            8'h30 : dr_rd_byte_o = 8'h02;  // wMaxPacketSize (MSB) = 512 Bytes
            8'h31 : dr_rd_byte_o = 8'h00;  // bInterval

            //String Descriptor 0 (Language ID)
            8'h32 : dr_rd_byte_o = 8'h04;  // bLength
            8'h33 : dr_rd_byte_o = 8'h03;  // bDescriptorType (String)
            8'h34 : dr_rd_byte_o = 8'h09;  // LANGID LSB
            8'h35 : dr_rd_byte_o = 8'h04;  // LANGID MSB (0x0409 = English-US)

                //For String Descriptors, these are the current values (dummy)
                //Manufacturer : "Brighty"
                //Product : "USB KSI"
                //Serial Number : "000001"
                
            // String Descriptor 1 ("Brighty")
            8'h36 : dr_rd_byte_o = 8'h10;   // bLength
            8'h37 : dr_rd_byte_o = 8'h03;   // bDescriptorType
            8'h38 : dr_rd_byte_o = 8'h42;   // B
            8'h39 : dr_rd_byte_o = 8'h00;
            8'h3A : dr_rd_byte_o = 8'h72;   // r
            8'h3B : dr_rd_byte_o = 8'h00;
            8'h3C : dr_rd_byte_o = 8'h69;   // i
            8'h3D : dr_rd_byte_o = 8'h00;
            8'h3E : dr_rd_byte_o = 8'h67;   // g
            8'h3F : dr_rd_byte_o = 8'h00;
            8'h40 : dr_rd_byte_o = 8'h68;   // h
            8'h41 : dr_rd_byte_o = 8'h00;
            8'h42 : dr_rd_byte_o = 8'h74;   // t
            8'h43 : dr_rd_byte_o = 8'h00;
            8'h44 : dr_rd_byte_o = 8'h79;   // y
            8'h45 : dr_rd_byte_o = 8'h00;

            // String Descriptor 2 ("USB KSI")
            8'h46 : dr_rd_byte_o = 8'h10;
            8'h47 : dr_rd_byte_o = 8'h03;
            8'h48 : dr_rd_byte_o = 8'h55;   // U
            8'h49 : dr_rd_byte_o = 8'h00;
            8'h4A : dr_rd_byte_o = 8'h53;   // S
            8'h4B : dr_rd_byte_o = 8'h00;
            8'h4C : dr_rd_byte_o = 8'h42;   // B
            8'h4D : dr_rd_byte_o = 8'h00;
            8'h4E : dr_rd_byte_o = 8'h20;   // Space
            8'h4F : dr_rd_byte_o = 8'h00;
            8'h50 : dr_rd_byte_o = 8'h4B;   // K
            8'h51 : dr_rd_byte_o = 8'h00;
            8'h52 : dr_rd_byte_o = 8'h53;   // S
            8'h53 : dr_rd_byte_o = 8'h00;
            8'h54 : dr_rd_byte_o = 8'h49;   // I
            8'h55 : dr_rd_byte_o = 8'h00;

            // String Descriptor 3 ("000001")
            8'h56 : dr_rd_byte_o = 8'h0E;
            8'h57 : dr_rd_byte_o = 8'h03;
            8'h58 : dr_rd_byte_o = 8'h30;   // 0
            8'h59 : dr_rd_byte_o = 8'h00;
            8'h5A : dr_rd_byte_o = 8'h30;   // 0
            8'h5B : dr_rd_byte_o = 8'h00;
            8'h5C : dr_rd_byte_o = 8'h30;   // 0
            8'h5D : dr_rd_byte_o = 8'h00;
            8'h5E : dr_rd_byte_o = 8'h30;   // 0
            8'h5F : dr_rd_byte_o = 8'h00;
            8'h60 : dr_rd_byte_o = 8'h30;   // 0
            8'h61 : dr_rd_byte_o = 8'h00;
            8'h62 : dr_rd_byte_o = 8'h31;   // 1
            8'h63 : dr_rd_byte_o = 8'h00;
        endcase
    end
endmodule
