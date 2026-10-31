`timescale 1ns/1ps

module mux2_g (
    input wire a, b, s,
    output wire y
);
    wire ns, w0, w1;

    not g0(ns, s);
    and g1(w0, a, ns);
    and g2(w1, b, s);
    or  g3(y, w0, w1);

endmodule


module dff_r (
    input wire d, clk, rst,
    output reg q
);
    always @(posedge clk or posedge rst)
        if (rst)
            q <= 1'b0;
        else
            q <= d;
endmodule


module dff_s (
    input wire d, clk, rst,
    output reg q
);
    always @(posedge clk or posedge rst)
        if (rst)
            q <= 1'b1;
        else
            q <= d;
endmodule


module lfsr4_str (
    input wire clk, rst, load, en,
    input wire [3:0] d,
    output wire [3:0] q
);
    wire fb;
    wire [3:0] shifted;
    wire [3:0] en_result;
    wire [3:0] next_bit;

    xor g0(fb, q[3], q[2]);

    buf g1(shifted[0], fb);
    buf g2(shifted[1], q[0]);
    buf g3(shifted[2], q[1]);
    buf g4(shifted[3], q[2]);

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : stage
            mux2_g m0(
                q[i], shifted[i], en, en_result[i]
            );

            mux2_g m1(
                en_result[i], d[i], load, next_bit[i]
            );
        end
    endgenerate

    dff_s ff0(next_bit[0], clk, rst, q[0]);
    dff_r ff1(next_bit[1], clk, rst, q[1]);
    dff_r ff2(next_bit[2], clk, rst, q[2]);
    dff_r ff3(next_bit[3], clk, rst, q[3]);

endmodule


module lfsr4_df (
    input wire clk, rst, load, en,
    input wire [3:0] d,
    output reg [3:0] q
);
    wire [3:0] q_next;

    assign q_next = load ? d :
                    en ? {q[2:0], q[3] ^ q[2]} :
                    q;

    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 4'b0001;
        else
            q <= q_next;
    end

endmodule


module lfsr4_beh (
    input wire clk, rst, load, en,
    input wire [3:0] d,
    output reg [3:0] q
);

    always @(posedge clk or posedge rst) begin

        if (rst)
            q <= 4'b0001;

        else if (load)
            q <= d;

        else if (en)
            q <= {q[2:0], q[3] ^ q[2]};

    end

endmodule
