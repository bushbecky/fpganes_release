
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module vga_ppu_integration_test(

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

	//////////// LED //////////
	output		     [9:0]		LEDR,

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
wire vga_clock, ppu_clock, rst_n, rst_p, vga_clock_locked, clock_locked;
wire cpu_clock;
wire blank;
wire [7:0] vga_r, vga_g, vga_b;
wire [7:0] vram_data_in;
wire [7:0] pixel_out;
wire [13:0] vram_addr_out;
wire vram_rw_sel;
wire [7:0] vram_data_out;
wire nmi;
wire [7:0] red, green, blue;
wire rendering, ppu_frame_end;
wire [7:0] ppu_data;
wire [2:0] address; // address to ppu
wire ppu_rw;
wire ppu_cs;

//=======================================================
//  Structural coding
//=======================================================
assign rst_n = KEY[0];
assign rst_p = ~rst_n;

assign VGA_SYNC_N = 1'b0;

assign HEX5 = 7'b0101011;
assign HEX4 = 7'b0000110;
assign HEX3 = 7'b0010010;
assign HEX2 = 7'b0101011;
assign HEX1 = 7'b0000110;
assign HEX0 = 7'b0010010;

assign LEDR[0] = rst_n;

assign VGA_R = ~blank ? 8'h00 : vga_r;
assign VGA_G = ~blank ? 8'h00 : vga_g;
assign VGA_B = ~blank ? 8'h00 : vga_b;
assign VGA_BLANK_N = blank;
assign VGA_CLK = vga_clock;

VGA_CLOCK_TEST clock0(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(rst_p),      //   reset.reset
		.outclk_0(vga_clock), // outclk0.clk
		.locked(vga_clock_locked)    //  locked.export // ACTIVE LOW!!!
	);
//*	
CPU_CLOCK_TEST clock2(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(rst_p),      //   reset.reset
		.outclk_0(cpu_clock), // outclk0.clk
		.outclk_1(ppu_clock),
		.locked(clock_locked)    //  locked.export
	);
// */

	
PPU_driver driver(
	.clk(cpu_clock), // CPU clock
	.rst_n(rst_n), // global reset
	.nmi(nmi), // PPU nmi out
	.address(address), // address to ppu
	.ppu_data(ppu_data),
	.ppu_rw(ppu_rw),
	.ppu_cs(ppu_cs)
	);

VGA vgaDUT(.vga_clock(vga_clock),
		.ppu_clock(ppu_clock),
		.rendering(rendering),
		.ppu_frame_end(ppu_frame_end),
		.color(pixel_out[5:0]),
		.rst_n(rst_n),
		.vga_r(vga_r),
		.vga_g(vga_g),
		.vga_b(vga_b),
		.hsync(VGA_HS),
		.vsync(VGA_VS),
		.blank(blank));

		/*
PPU_clk_gen clock1(
		.refclk(CLOCK_50),   //  refclk.clk
		.rst(rst_p),      //   reset.reset
		.outclk_0(ppu_clock), // outclk0.clk
		.locked(ppu_clock_locked)    //  locked.export
	);*/
	
PPU DUT (
	.clk(ppu_clock),
	.rst_n(rst_n),
	.data(ppu_data),
	.address(address),
	.vram_data_in(vram_data_in),
	.rw(ppu_rw),
	.cs_in(ppu_cs),
	.irq(nmi),
	.pixel_data(pixel_out),
	.vram_addr_out(vram_addr_out),
	.vram_rw_sel(vram_rw_sel),
	.vram_data_out(vram_data_out),
	.frame_end(ppu_frame_end),

	// DEBUG ONLY NOT FOR RELEASE
	.red(red),
	.green(green),
	.blue(blue),
	.rendering(rendering)
);

test_ram VRAM (
	.address(vram_addr_out),
	.clock(ppu_clock),
	.data(vram_data_out),
	.wren(vram_rw_sel),
	.q(vram_data_in)
);

endmodule
