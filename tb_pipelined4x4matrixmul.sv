// Code your testbench here
// or browse Examples
module tb;
  logic clk;
  logic rst;
  logic [7:0] A [0:3][0:3];
  logic [7:0] B [0:3][0:3];
  logic [15:0] C [0:3][0:3];
  
  pipelined4x4matrixmul utt(.clk(clk),.rst(rst), .A(A), .B(B), .C(C));
  
  initial clk = 0;
  always #5 clk = ~clk;
  
  initial begin
    rst=1;
    #10 ;
    rst=0;
    $dumpfile("wave.vcd");
    $dumpvars(0, tb);
        // Matrix A
        A[0] = '{1, 2, 3, 4};
        A[1] = '{5, 6, 7, 8};
        A[2] = '{9,10,11,12};
        A[3] = '{13,14,15,16};

        // Matrix B
        B[0] = '{1, 0, 0, 0};
        B[1] = '{0, 1, 0, 0};
        B[2] = '{0, 0, 1, 0};
        B[3] = '{0, 0, 0, 1};

        #50;

        $display("Result matrix C:");
    	for (int i = 0; i < 4; i++) begin
          $write("[ ");
          for (int j = 0; j < 4; j++) begin
            $write("%0d ", C[i][j]);
          end
          $write("]\n");
        end
        $finish;
    end
endmodule

  