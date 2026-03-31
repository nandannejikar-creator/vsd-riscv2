module gpio_tb;

    reg clk;
    reg rst_n;
    reg wr_en;
    reg rd_en;
    reg [3:0] addr;
    reg [31:0] wdata;
    wire [31:0] rdata;

    reg [31:0] gpio_in;
    wire [31:0] gpio_out;

    // DUT
    gpio_ip uut (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .addr(addr),
        .wdata(wdata),
        .rdata(rdata),
        .gpio_in(gpio_in),
        .gpio_out(gpio_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("gpio.vcd");
        $dumpvars(0, gpio_tb);

        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        addr = 0;
        wdata = 0;
        gpio_in = 32'hAAAA_AAAA;

        // Reset
        #10 rst_n = 1;

        // -----------------------------
        // TEST 1: Set direction (lower 8 bits output)
        // -----------------------------
        #10;
        wr_en = 1;
        addr = 4'h4;   // DIR
        wdata = 32'h000000FF;
        #10 wr_en = 0;

        // -----------------------------
        // TEST 2: Write DATA
        // -----------------------------
        #10;
        wr_en = 1;
        addr = 4'h0;   // DATA
        wdata = 32'hA5A5A5A5;
        #10 wr_en = 0;

        // -----------------------------
        // TEST 3: Read DATA
        // -----------------------------
        #10;
        rd_en = 1;
        addr = 4'h0;
        #10 rd_en = 0;

        // -----------------------------
        // TEST 4: Read DIR
        // -----------------------------
        #10;
        rd_en = 1;
        addr = 4'h4;
        #10 rd_en = 0;

        // -----------------------------
        // TEST 5: Read GPIO_READ
        // -----------------------------
        #10;
        rd_en = 1;
        addr = 4'h8;
        #10 rd_en = 0;

        // -----------------------------
        // Change input values
        // -----------------------------
        #10;
        gpio_in = 32'hFFFF0000;

        #10;
        rd_en = 1;
        addr = 4'h8;
        #10 rd_en = 0;

        #50 $finish;
    end

endmodule