`timescale 1ns/1ps
module fa_gate (
    input wire a, b, cin,
    output wire s, cout
);
    wire t, c1, c2;

    xor g1(t, a, b);
    xor g2(s, t, cin);
    and g3(c1, a, b);
    and g4(c2, t, cin);
    or  g5(cout, c1, c2);

endmodule


module rca4 (
    input wire [3:0] a, b,
    input wire cin,
    output wire [3:0] s,
    output wire cout
);
    wire c1, c2, c3;

    fa_gate f0(a[0], b[0], cin, s[0], c1);
    fa_gate f1(a[1], b[1], c1, s[1], c2);
    fa_gate f2(a[2], b[2], c2, s[2], c3);
    fa_gate f3(a[3], b[3], c3, s[3], cout);

endmodule


module bcdadd_str (
    input wire [3:0] a, b,
    input wire cin,
    output wire [3:0] s,
    output wire cout
);
    wire [3:0] z;
    wire k, c, t1, t2;
    wire unused_carry;

    rca4 u0(a, b, cin, z, k);

    and g1(t1, z[3], z[2]);
    and g2(t2, z[3], z[1]);
    or  g3(c, k, t1, t2);

    rca4 u1(
        z,
        {1'b0, c, c, 1'b0},
        1'b0,
        s,
        unused_carry
    );

    buf g4(cout, c);

endmodule


module bcdadd_df (
    input wire [3:0] a, b,
    input wire cin,
    output wire [3:0] s,
    output wire cout
);
    wire [4:0] z;
    wire c;

    assign z = {1'b0, a} + {1'b0, b} + cin;

    assign c = z[4] |
               (z[3] & z[2]) |
               (z[3] & z[1]);

    assign s = z[3:0] +
               (c ? 4'b0110 : 4'b0000);

    assign cout = c;

endmodule


module bcdadd_beh (
    input wire [3:0] a, b,
    input wire cin,
    output reg [3:0] s,
    output reg cout
);
    reg [4:0] z;

    always @(*) begin
        z = {1'b0, a} + {1'b0, b} + cin;

        if (z > 5'd9) begin
            s = z[3:0] + 4'd6;
            cout = 1'b1;
        end
        else begin
            s = z[3:0];
            cout = 1'b0;
        end
    end

endmodule
