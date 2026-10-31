`timescale 1ns/1ps

module tb;

  reg [2:0] a;
  reg g1, g2a_n, g2b_n;

  wire [7:0] y_STRU, y_DF, y_BEH;
  reg [7:0] expected;

  integer i, j, err = 0;

  // Khoi tao 3 module
  dec138_str u0 (a, g1, g2a_n, g2b_n, y_STRU);
  dec138_df  u1 (a, g1, g2a_n, g2b_n, y_DF);
  dec138_beh u2 (a, g1, g2a_n, g2b_n, y_BEH);

  initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    $display("G1 G2A G2B A | STRU     DF       BEH      | Check");

    for (i = 0; i < 64; i = i + 1) begin

      {g1, g2a_n, g2b_n, a} = i[5:0];

      // Expected result
      expected = 8'b11111111;

      if (g1 && !g2a_n && !g2b_n) begin

        for (j = 0; j < 8; j = j + 1) begin
          if (a == j)
            expected[j] = 1'b0;
        end

      end

      #10;

      // Kiem tra 3 model
      if ((y_STRU !== expected) ||
          (y_DF !== expected) ||
          (y_BEH !== expected))
        err = err + 1;

      $display("%b  %b  %b  %b | %b %b %b | %s",
               g1, g2a_n, g2b_n, a,
               y_STRU, y_DF, y_BEH,
               ((y_STRU === expected) &&
                (y_DF === expected) &&
                (y_BEH === expected))
               ? "PASS" : "FAIL");

    end

    $display("Checked 64 input combinations");
    $display("Errors = %0d", err);

    $finish;

  end

endmodule
