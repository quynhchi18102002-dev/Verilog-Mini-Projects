`timescale 1ns/1ps

module bcd2xs3_str (
    input wire [3:0] b,
    output wire [3:0] x
);

    wire nb2, nb1, nb0;
    wire w31, w32;
    wire w21, w22, w23;
    wire w11, w12;

    not g1(nb2, b[2]);
    not g2(nb1, b[1]);
    not g3(nb0, b[0]);

    and g4(w31, b[2], b[1]);
    and g5(w32, b[2], b[0]);
    or  g6(x[3], b[3], w31, w32);

    and g7(w21, nb2, b[1]);
    and g8(w22, nb2, b[0]);
    and g9(w23, b[2], nb1, nb0);
    or  g10(x[2], w21, w22, w23);

    and g11(w11, b[1], b[0]);
    and g12(w12, nb1, nb0);
    or  g13(x[1], w11, w12);

    buf g14(x[0], nb0);

endmodule


module bcd2xs3_df (
    input wire [3:0] b,
    output wire [3:0] x
);

    assign x[3] = b[3] |
                  (b[2] & b[1]) |
                  (b[2] & b[0]);

    assign x[2] = (~b[2] & b[1]) |
                  (~b[2] & b[0]) |
                  (b[2] & ~b[1] & ~b[0]);

    assign x[1] = (b[1] & b[0]) |
                  (~b[1] & ~b[0]);

    assign x[0] = ~b[0];

endmodule


module bcd2xs3_beh (
    input wire [3:0] b,
    output reg [3:0] x
);

    always @(*) begin
        if (b <= 4'd9)
            x = b + 4'd3;
        else
            x = 4'bxxxx;
    end

endmodule
