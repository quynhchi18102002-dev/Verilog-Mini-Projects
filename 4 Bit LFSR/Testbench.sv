`timescale 1ns/1ps

module tb;

  reg clk, rst, load, en;
  reg [3:0] d;

  wire [3:0] q_STRU, q_DF, q_BEH;
  reg [3:0] expected;

  integer i, err = 0, checks = 0;

  lfsr4_str u0(clk, rst, load, en, d, q_STRU);
  lfsr4_df  u1(clk, rst, load, en, d, q_DF);
  lfsr4_beh u2(clk, rst, load, en, d, q_BEH);

  always #5 clk = ~clk;

  always @(posedge clk or posedge rst) begin
    if (rst)
      expected <= 4'b0001;
    else if (load)
      expected <= d;
    else if (en)
      expected <= {expected[2:0],
                   expected[3] ^ expected[2]};
  end

  task check;
    begin
      checks = checks + 1;

      if ((q_STRU !== expected) ||
          (q_DF !== expected) ||
          (q_BEH !== expected)) begin
        err = err + 1;

        $display("%0t | %b %b %b %b | %b | %b %b %b | FAIL",
          $time, rst, load, en, d,
          expected, q_STRU, q_DF, q_BEH);
      end
      else begin
        $display("%0t | %b %b %b %b | %b | %b %b %b | PASS",
          $time, rst, load, en, d,
          expected, q_STRU, q_DF, q_BEH);
      end
    end
  endtask

  initial begin

    clk = 0;
    rst = 0;
    load = 0;
    en = 0;
    d = 4'b0000;

    $dumpfile("dump.vcd");
    $dumpvars(0, tb);

    $display("Time | rst load en d | Expected | STRU DF BEH | Check");

    #2 rst = 1;
    #1 check();

    rst = 0;
    en = 1;

    for (i = 1; i <= 15; i = i + 1) begin
      @(negedge clk);
      #1;
      check();

      if (i < 15 && q_STRU === 4'b0001) begin
        err = err + 1;
        $display("FAIL: Early repeat");
      end

      if (i == 15 && q_STRU !== 4'b0001) begin
        err = err + 1;
        $display("FAIL: Period is not 15");
      end
    end

    en = 0;

    repeat (2) begin
      @(negedge clk);
      #1;
      check();
    end

    load = 1;
    en = 1;
    d = 4'b1010;

    @(negedge clk);
    #1;
    check();

    load = 0;

    repeat (4) begin
      @(negedge clk);
      #1;
      check();
    end

    load = 1;
    d = 4'b0000;

    @(negedge clk);
    #1;
    check();

    load = 0;
    en = 1;

    repeat (3) begin
      @(negedge clk);
      #1;
      check();
    end

    #2 rst = 1;
    #1;
    check();

    rst = 0;
    en = 0;

    @(negedge clk);
    #1;
    check();

    $display("Checked %0d cases", checks);
    $display("Errors = %0d", err);

    $finish;

  end

endmodule
