module gpio_ip (
    input  wire clk,
    input  wire rst_n,

    input  wire wr_en,
    input  wire rd_en,
    input  wire [3:0] addr,
    input  wire [31:0] wdata,
    output reg  [31:0] rdata,

    input  wire [31:0] gpio_in,
    output wire [31:0] gpio_out
);
reg [31:0] gpio_data;
reg [31:0] gpio_dir;
reg [31:0] gpio_read;
localparam ADDR_DATA = 4'h0;
localparam ADDR_DIR  = 4'h4;
localparam ADDR_READ = 4'h8;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        gpio_data <= 32'b0;
        gpio_dir  <= 32'b0;
    end else if (wr_en) begin
        case (addr)
            ADDR_DATA: gpio_data <= wdata;
            ADDR_DIR : gpio_dir  <= wdata;
        endcase
    end
end
assign gpio_out = gpio_data & gpio_dir;
integer i;

always @(*) begin
    for (i = 0; i < 32; i = i + 1) begin
        if (gpio_dir[i])
            gpio_read[i] = gpio_data[i];
        else
            gpio_read[i] = gpio_in[i];
    end
end
always @(*) begin
    if (rd_en) begin
        case (addr)
            ADDR_DATA: rdata = gpio_data;
            ADDR_DIR : rdata = gpio_dir;
            ADDR_READ: rdata = gpio_read;
            default  : rdata = 32'b0;
        endcase
    end else begin
        rdata = 32'b0;
    end
end
endmodule