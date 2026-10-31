`timescale 1ns/1ps

module dec138_str (
    input wire [2:0] a,
    input wire g1, g2a_n, g2b_n,
    output wire [7:0] y_n
);

    wire na2, na1, na0;
    wire ng2a, ng2b, en;

    not g0(na2, a[2]);
    not g1i(na1, a[1]);
    not g2(na0, a[0]);

    not g3(ng2a, g2a_n);
    not g4(ng2b, g2b_n);

    and g5(en, g1, ng2a, ng2b);

    nand g6(y_n[0], en, na2, na1, na0);
    nand g7(y_n[1], en, na2, na1, a[0]);
    nand g8(y_n[2], en, na2, a[1], na0);
    nand g9(y_n[3], en, na2, a[1], a[0]);

    nand g10(y_n[4], en, a[2], na1, na0);
    nand g11(y_n[5], en, a[2], na1, a[0]);
    nand g12(y_n[6], en, a[2], a[1], na0);
    nand g13(y_n[7], en, a[2], a[1], a[0]);

endmodule

module dec138_df (
    input wire [2:0] a,
    input wire g1, g2a_n, g2b_n,
    output wire [7:0] y_n
);

    wire en;

    assign en = g1 & ~g2a_n & ~g2b_n;

    assign y_n = en ? ~(8'b1 << a) : 8'hFF;

endmodule

module dec138_beh (
    input wire [2:0] a,
    input wire g1, g2a_n, g2b_n,
    output reg [7:0] y_n
);

    always @(*) begin

        if (g1 && !g2a_n && !g2b_n) begin

            case (a)
                3'b000: y_n = 8'b11111110;
                3'b001: y_n = 8'b11111101;
                3'b010: y_n = 8'b11111011;
                3'b011: y_n = 8'b11110111;

                3'b100: y_n = 8'b11101111;
                3'b101: y_n = 8'b11011111;
                3'b110: y_n = 8'b10111111;
                default: y_n = 8'b01111111;
            endcase

        end
        else begin
            y_n = 8'b11111111;
        end

    end

endmodule
