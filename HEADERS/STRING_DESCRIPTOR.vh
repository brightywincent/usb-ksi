`ifndef STRING_DESCRIPTOR_VH
`define STRING_DESCRIPTOR_VH
    //Fields in String Descriptor
        //STRING DESCRIPTOR 0
        `define bLength 8'h04 //bLength + DescriptorType + LANGID_1 = 4 bytes
        `define bDescriptorType 8'h03
        `define LANGID_1 16'h0409   //Two bytes for one language. 16'h0409 is for Eng (US)
        //Normal STRONG DESCRIPTOR
            //MANUFACTURER STRING - INDEX 1
                `define bLength 8'h02  //Header(2bytes)+DATA(2*N bytes)=(2+2*N) bytes for N characters.
                `define bDescriptorType 8'h03  //Always 8'h03 - string descsriptor
                `define UnicodeCharacters 16'h0000    //USB uses UTF-16LE. Each character - 2 bytes.
                                             //USB requires all strings to be encoded in UTF-16 Little Endian.
            // So on for the Next STRING INDEX.
`endif
