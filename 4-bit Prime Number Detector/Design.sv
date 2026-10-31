`timescale 1ns/1ps

module tb;

  reg [3:0] n;

  wire p_STRU, p_DF, p_BEH;
  reg expected;

  integer i, j, err = 0;

  // Khoi tao 3 module
  prime4_str u0 (n, p_STRU);
  prime4_df  u1 (n, p_DF);
  prime4_beh u2 (n, p_BEH);

  initial begin

    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    $display("n | p_STRU p_DF p_BEH | Check");

    for (i = 0; i < 16; i = i + 1) begin

      n = i[3:0];

      // Tinh expected bang phep chia thu
      expected = 1'b1;

      if (i < 2)
        expected = 1'b0;
      else begin
        for (j = 2; j < i; j = j + 1) begin
          if (i % j == 0)
            expected = 1'b0;
        end
      end

      #10;

      // Kiem tra 3 model
      if ((p_STRU !== expected) ||
          (p_DF !== expected) ||
          (p_BEH !== expected))
        err = err + 1;

      $display("%2d | %b %b %b | %s",
               i,
               p_STRU, p_DF, p_BEH,
               ((p_STRU === expected) &&
                (p_DF === expected) &&
                (p_BEH === expected))
               ? "PASS" : "FAIL");

    end

    $display("Checked 16 input combinations");
    $display("Errors = %0d", err);

    $finish;

  end

endmodule
