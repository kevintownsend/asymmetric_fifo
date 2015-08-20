module asymmetric_fifo(rst, clk, push, pop, d, q, full, empty, count, almost_empty, almost_full);
    parameter WIDTH_IN = 64;
    parameter WIDTH_OUT = 8;
    parameter DEPTH_IN = 32;
    localparam RATIO = WIDTH_IN / WIDTH_OUT;
    localparam LOG2_RATIO = log2(RATIO);
    parameter DEPTH_OUT = DEPTH_IN * RATIO;
    parameter DEPTH_IN_ADDR_WIDTH = log2(DEPTH_IN-1);
    parameter DEPTH_OUT_ADDR_WIDTH = log2(DEPTH_OUT-1);
    parameter ALMOST_EMPTY_COUNT = 1;
    parameter ALMOST_FULL_COUNT = 1;
    input rst;
    input clk;
    input push;
    input pop;
    input [WIDTH_IN-1:0] d;
    output [WIDTH_OUT-1:0] q;
    output full;
    output empty;
    output [DEPTH_OUT_ADDR_WIDTH:0]count;
    output almost_empty;
    output almost_full;

    reg [WIDTH_OUT-1:0] r_q;
    reg [DEPTH_OUT_ADDR_WIDTH:0] r_end;
    reg [DEPTH_IN_ADDR_WIDTH:0] r_beg;

    //reg [WIDTH-1:0] ram [DEPTH-1:0];
    asymmetric_distributed_ram #(WIDTH_IN, WIDTH_OUT, DEPTH_IN) ram(clk, push, r_beg[DEPTH_IN_ADDR_WIDTH-1:0], d, r_end[DEPTH_OUT_ADDR_WIDTH-1:0], q); //TODO: complete
    always @(posedge clk) begin
        if(rst) begin
            r_end <= 0;
            r_beg <= 0;
        end else begin
            if(pop)
                r_end <= r_end + 1;
            if(push)
                r_beg <= r_beg + 1;
        end
    end
    assign empty = (r_end[DEPTH_OUT_ADDR_WIDTH:LOG2_RATIO - 1] == r_beg);
    assign full = (r_end[DEPTH_OUT_ADDR_WIDTH-1:LOG2_RATIO - 1] == r_beg[DEPTH_IN_ADDR_WIDTH-1:0]) && (r_end[DEPTH_OUT_ADDR_WIDTH] != r_beg[DEPTH_IN_ADDR_WIDTH]);
    assign count = r_beg * RATIO - r_end;
    assign almost_empty = (count < (1+ALMOST_EMPTY_COUNT));
    assign almost_full = (count > (DEPTH_IN-1-ALMOST_FULL_COUNT) * RATIO);

    always @(posedge clk) begin
        if(full && push) begin
            $display("ERROR: %d Overflow at %m", $time);
            $finish;
        end
        if(empty && pop) begin
            $display("ERROR: %d underflow at %m", $time);
            $finish;
        end
    end

    `include "log2.vh"
endmodule
