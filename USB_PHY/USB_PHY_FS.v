module USB_PHY_FS(
	inout tri dp,
	inout tri dm
	
);
dp_o
assign dp = (dp_en)?dp_o:1'bz
endmodule
