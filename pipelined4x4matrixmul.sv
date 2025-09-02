module pipelined4x4matrixmul(
  input  logic clk,
  input  logic rst,
  input  logic [7:0] A [0:3][0:3],
  input  logic [7:0] B [0:3][0:3],
  output logic [15:0] C [0:3][0:3]
);

  // Stage 1: Partial products
  logic [15:0] mult_stage [0:3][0:3][0:3];

  // Stage 2: First level sums
  logic [16:0] add_stage1 [0:3][0:3][1:0]; // 2 partial sums per C[i][j]

  // Stage 3: Final sums
  logic [17:0] add_stage2 [0:3][0:3];

  // ============================
  // Stage 1: Multiplications
  // ============================
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i=0; i<4; i++) begin
        for (int j=0; j<4; j++) begin
          for (int k=0; k<4; k++) begin
            mult_stage[i][j][k] <= 0;
          end
        end
      end
    end else begin
      for (int i=0; i<4; i++) begin
        for (int j=0; j<4; j++) begin
          for (int k=0; k<4; k++) begin
            mult_stage[i][j][k] <= A[i][k] * B[k][j];
          end
        end
      end
    end
  end

  // ============================
  // Stage 2: Pairwise additions
  // ============================
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i=0; i<4; i++) begin
        for (int j=0; j<4; j++) begin
          add_stage1[i][j][0] <= 0;
          add_stage1[i][j][1] <= 0;
        end
      end
    end else begin
      for (int i=0; i<4; i++) begin
        for (int j=0; j<4; j++) begin
          add_stage1[i][j][0] <= mult_stage[i][j][0] + mult_stage[i][j][1];
          add_stage1[i][j][1] <= mult_stage[i][j][2] + mult_stage[i][j][3];
        end
      end
    end
  end

  // ============================
  // Stage 3: Final addition
  // ============================
  always_ff @(posedge clk or posedge rst) begin
    if (rst) begin
      for (int i=0; i<4; i++) begin
        for (int j=0; j<4; j++) begin
          C[i][j] <= 0;
        end
      end
    end else begin
      for (int i=0; i<4; i++) begin
        for (int j=0; j<4; j++) begin
          C[i][j] <= add_stage1[i][j][0] + add_stage1[i][j][1];
        end
      end
    end
  end

endmodule
