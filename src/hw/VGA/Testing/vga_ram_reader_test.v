
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module vga_ram_reader_test(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);



//=======================================================
//  REG/WIRE declarations
//=======================================================
wire vga_clock, rst_n, locked;
wire hsync, vsync;
wire[7:0] vga_r, vga_g, vga_b;
wire rd, blank, wr;
wire[5:0] q, data;
wire[15:0] addr, wr_addr;
reg[6:0] test;



//=======================================================
//  Structural coding
//=======================================================
assign HEX5 = 7'b0101011;
assign HEX4 = 7'b0000110;
assign HEX3 = 7'b0010010;
assign HEX2 = 7'b0101011;
assign HEX1 = 7'b0000110;
assign HEX0 = test;

assign rst_n = KEY[0];

assign VGA_R = ~blank ? 8'h00 : vga_r;
assign VGA_G = ~blank ? 8'h00 : vga_g;
assign VGA_B = ~blank ? 8'h00 : vga_b;
assign VGA_BLANK_N = blank;
assign VGA_CLK = vga_clock;
assign VGA_SYNC_N = 1'b0;
assign VGA_HS = hsync;
assign VGA_VS = vsync;

assign data = 6'h08;
assign wr = 0;
assign wr_addr = 16'h0000;

VGARAM_test	VGARAM_test_inst (
	.data ( data ),
	.rdaddress ( addr ),
	.rdclock ( vga_clock ),
	.rden ( rd ),
	.wraddress ( wr_addr ),
	.wrclock ( vga_clock ),
	.wren ( wr ),
	.q ( q )
	);
	

RamReader DUT (vga_clock,
               rst_n,
               q,
               blank,
               addr,
               rd,
               vga_r,
               vga_g,
               vga_b);

vga_time_gen tg(
               .clk(vga_clock),
               .rst_n(rst_n),
               .vsync(vsync),
               .hsync(hsync),
               .blank(blank));
					
VGA_CLOCK_TEST clkgen(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(~rst_n),      //   reset.reset
		.outclk_0(vga_clock), // outclk0.clk
		.locked(locked)    //  locked.export
	);
	/*
	VGA vgaDUT(.vga_clock(vga_clock),
		.ppu_clock(vga_clock),
		.rendering(1'b0),//rendering),
		.color(6'b101010),
		.rst_n(rst_n),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.hsync(hsync),
		.vsync(vsync),
		.blank(blank));*/
					
					
always @(negedge rst_n, posedge vga_clock) begin

	if (!rst_n) begin
		test <= 7'b0000000;
	end
	else if (vga_clock) begin
		test <= 7'b0010010;
	end
	else
		test <= 7'b1100111;

end
					
endmodule
