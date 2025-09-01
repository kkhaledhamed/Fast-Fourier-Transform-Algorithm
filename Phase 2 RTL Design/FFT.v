// =========================================
// Developer: Khaled Ahmed Hamed
// Description: ADI Summer internship Final Project
// =========================================
module FFT #(
    parameter N  = 8, // FFT Size (Number of points)

    // Input format (Q3.9)
    parameter INPUT_WORD_WIDTH     = 12,
    parameter INPUT_INTEGER_WIDTH  = 3,

    // Output format (Q5.7)
    parameter OUTPUT_WORD_WIDTH    = 12,
    parameter OUTPUT_INTEGER_WIDTH = 5
)(
    input  wire clk,
    input  wire rst_n,

    // ---- Inputs ----
    input  signed [INPUT_WORD_WIDTH-1:0] x0_real, x0_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x1_real, x1_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x2_real, x2_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x3_real, x3_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x4_real, x4_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x5_real, x5_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x6_real, x6_imag,
    input  signed [INPUT_WORD_WIDTH-1:0] x7_real, x7_imag,

    // ---- Outputs ----
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y0_real, y0_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y1_real, y1_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y2_real, y2_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y3_real, y3_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y4_real, y4_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y5_real, y5_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y6_real, y6_imag,
    output reg signed [OUTPUT_WORD_WIDTH-1:0] y7_real, y7_imag
);

    // =========================
    // Input Pipeline Registers
    // =========================
    reg signed [INPUT_WORD_WIDTH-1:0] x0_real_r, x0_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x1_real_r, x1_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x2_real_r, x2_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x3_real_r, x3_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x4_real_r, x4_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x5_real_r, x5_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x6_real_r, x6_imag_r;
    reg signed [INPUT_WORD_WIDTH-1:0] x7_real_r, x7_imag_r;

    // =========================
    // Stage control parameters
    // =========================
    localparam STAGE1 = 2'b00,
               STAGE2 = 2'b01,
               STAGE3 = 2'b10;

    // =========================
    // Stage formats
    // =========================
    localparam STAGE1_INT_WIDTH  = 4; // Q4.8
    localparam STAGE2_INT_WIDTH  = 4; // Q4.8
    localparam STAGE3_INT_WIDTH  = 5; // Q5.7

    // =========================
    // Twiddle constants (Q3.9 & Q4.8)
    // =========================
    localparam signed  W0_REAL = 12'b001_000000000; // +1.0
    localparam signed  W0_IMAG = 12'b000_000000000; //  0.0
    localparam signed  W1_REAL = 12'b0000_10110101; // +0.707
    localparam signed  W1_IMAG = 12'b1111_01001011; // -0.707
    localparam signed  W2_REAL = 12'b000_000000000; //  0.0
    localparam signed  W2_IMAG = 12'b111_000000000; // -1.0
    localparam signed  W3_REAL = 12'b1111_01001011; // -0.707
    localparam signed  W3_IMAG = 12'b1111_01001011; // -0.707

    localparam TW_W0 = 'd0;
    localparam TW_W1 = 'd1;
    localparam TW_W2 = 'd2;
    localparam TW_W3 = 'd3;

    // =========================
    // Stage registers (flattened)
    // =========================
    reg signed [OUTPUT_WORD_WIDTH-1:0] s1_real0, s1_imag0, s1_real1, s1_imag1;
    reg signed [OUTPUT_WORD_WIDTH-1:0] s1_real2, s1_imag2, s1_real3, s1_imag3;
    reg signed [OUTPUT_WORD_WIDTH-1:0] s1_real4, s1_imag4, s1_real5, s1_imag5;
    reg signed [OUTPUT_WORD_WIDTH-1:0] s1_real6, s1_imag6, s1_real7, s1_imag7;

    reg signed [OUTPUT_WORD_WIDTH-1:0] s2_real0, s2_imag0, s2_real1, s2_imag1;
    reg signed [OUTPUT_WORD_WIDTH-1:0] s2_real2, s2_imag2, s2_real3, s2_imag3;
    reg signed [OUTPUT_WORD_WIDTH-1:0] s2_real4, s2_imag4, s2_real5, s2_imag5;
    reg signed [OUTPUT_WORD_WIDTH-1:0] s2_real6, s2_imag6, s2_real7, s2_imag7;

    // =========================
    // Saturation function with instrumentation
    // =========================
    function automatic signed [OUTPUT_WORD_WIDTH-1:0] sat;
        input signed [31:0] in;
        input [1:0] stage;
        
        reg signed [OUTPUT_WORD_WIDTH-1:0] max_val, min_val;
    begin
        
        case (stage)
            // Stage 1: Q4.8 format (S1 from table: -4.133 to 4.798)
            2'b00: begin
                max_val = 12'b0100_11001100; // +4.796875 
                min_val = 12'b1011_11011110; // -4.1328125 
                
                if (in > max_val) begin
                    sat = max_val;
                end else if (in < min_val) begin
                    sat = min_val;
                end else begin
                    sat = in[OUTPUT_WORD_WIDTH-1:0];
                end
            end
            // Stage 2: Q4.8 format (s2 from table: -5.677 to 6.233)
            2'b01: begin
                max_val = 12'b0110_00111100; // +6.234375 (closest to 6.233)
                min_val = 12'b1010_01010011; // -5.67578125 (closest to -5.677)
                
                if (in > max_val) begin
                    sat = max_val;
                    
                end else if (in < min_val) begin
                    sat = min_val;
                    
                end else begin
                    sat = in[OUTPUT_WORD_WIDTH-1:0];
                end
            end
            // Stage 3: Q5.7 format (Y from table: -9.579 to 8.589)
            2'b10: begin
                max_val = 12'b01000_1010011; // +8.5859375 (closest to 8.589)
                min_val = 12'b10110_0110110; // -9.578125 (closest to -9.579)
                
                if (in > max_val) begin
                    sat = max_val;                   
                end else if (in < min_val) begin
                    sat = min_val;                   
                end else begin
                    sat = in[OUTPUT_WORD_WIDTH-1:0];
                end
            end
            // Default case (shouldn't occur)
            default: begin
                max_val = (1 << (OUTPUT_WORD_WIDTH-1)) - 1;
                min_val = -(1 << (OUTPUT_WORD_WIDTH-1));
                if (in > max_val) begin
                    sat = max_val;
                end else if (in < min_val) begin
                    sat = min_val;
                end else begin
                    sat = in[OUTPUT_WORD_WIDTH-1:0];
                end
            end
        endcase
    end
    endfunction

    // =========================
    // Butterfly MAC with saturation
    // =========================
    function [2*OUTPUT_WORD_WIDTH-1:0] butterfly_MAC;
        input [1:0] stage;
        input addsub; 
        input signed [INPUT_WORD_WIDTH:0]  a_real, a_imag;
        input signed [INPUT_WORD_WIDTH:0]  b_real, b_imag;
        input signed [11:0] w_real, w_imag;
        input [2:0] w_sel;

        reg signed [2*INPUT_WORD_WIDTH+1:0] m_rr, m_ii, m_ri, m_ir;
        reg signed [2*INPUT_WORD_WIDTH+1:0] mr, mi;
        reg signed [INPUT_WORD_WIDTH:0]  bw_real, bw_imag;
        reg signed [31:0] t_real, t_imag;
        reg signed [OUTPUT_WORD_WIDTH-1:0] q_real, q_imag;
    begin
        // Twiddle multiply (optimised cases + general case)
        case (stage)
            STAGE1: begin
                bw_real = b_real;
                bw_imag = b_imag;
            end
            STAGE2: begin
                if (w_sel == TW_W0) begin
                    bw_real = b_real;
                    bw_imag = b_imag;
                end else begin
                    bw_real = b_imag;
                    bw_imag = -b_real;
                end
            end
            STAGE3: begin
                if (w_sel == TW_W0) begin
                    bw_real = b_real;
                    bw_imag = b_imag;
                end else if (w_sel == TW_W2) begin
                    bw_real = b_imag;
                    bw_imag = -b_real;
                end else begin
                    m_rr = b_real * w_real;
                    m_ii = b_imag * w_imag;
                    m_ri = b_real * w_imag;
                    m_ir = b_imag * w_real;
                    mr = (m_rr - m_ii);
                    mi = (m_ri + m_ir);
                    bw_real = (mr + (1 <<< 7)) >>> 8;
                    bw_imag = (mi + (1 <<< 7)) >>> 8;
                end
            end
            default: begin
                m_rr = b_real * w_real;
                m_ii = b_imag * w_imag;
                m_ri = b_real * w_imag;
                m_ir = b_imag * w_real;
                mr = (m_rr - m_ii);
                mi = (m_ri + m_ir);
                bw_real = (mr + (1 <<< 7)) >>> 8;
                bw_imag = (mi + (1 <<< 7)) >>> 8;
            end
        endcase

        // Butterfly add/sub
        if (!addsub) begin
            t_real = a_real + bw_real;
            t_imag = a_imag + bw_imag;
        end else begin
            t_real = a_real - bw_real;
            t_imag = a_imag - bw_imag;
        end

        // Stage-specific scaling + saturation
        case (stage)
            STAGE1: begin 
                q_real = sat(t_real >>> 1, 0);
                q_imag = sat(t_imag >>> 1, 0);
            end
            STAGE2: begin 
                q_real = sat(t_real, 1);
                q_imag = sat(t_imag, 1);
            end
            STAGE3: begin 
                q_real = sat(t_real >>> 1, 2);
                q_imag = sat(t_imag >>> 1, 2);
            end
            default: begin
                q_real = sat(t_real, 3);
                q_imag = sat(t_imag, 3);
            end
        endcase

        butterfly_MAC = {q_real, q_imag};
    end
    endfunction

    // =========================
    // Input Pipeline Stage
    // =========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            x0_real_r <= 0; x0_imag_r <= 0;
            x1_real_r <= 0; x1_imag_r <= 0;
            x2_real_r <= 0; x2_imag_r <= 0;
            x3_real_r <= 0; x3_imag_r <= 0;
            x4_real_r <= 0; x4_imag_r <= 0;
            x5_real_r <= 0; x5_imag_r <= 0;
            x6_real_r <= 0; x6_imag_r <= 0;
            x7_real_r <= 0; x7_imag_r <= 0;
        end else begin
            x0_real_r <= x0_real; x0_imag_r <= x0_imag;
            x1_real_r <= x1_real; x1_imag_r <= x1_imag;
            x2_real_r <= x2_real; x2_imag_r <= x2_imag;
            x3_real_r <= x3_real; x3_imag_r <= x3_imag;
            x4_real_r <= x4_real; x4_imag_r <= x4_imag;
            x5_real_r <= x5_real; x5_imag_r <= x5_imag;
            x6_real_r <= x6_real; x6_imag_r <= x6_imag;
            x7_real_r <= x7_real; x7_imag_r <= x7_imag;
        end
    end

    // =========================
    // FFT Pipeline (calls the function)
    // =========================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear S1
            s1_real0 <= 12'b0; s1_imag0 <= 12'b0;
            s1_real1 <= 12'b0; s1_imag1 <= 12'b0;
            s1_real2 <= 12'b0; s1_imag2 <= 12'b0;
            s1_real3 <= 12'b0; s1_imag3 <= 12'b0;
            s1_real4 <= 12'b0; s1_imag4 <= 12'b0;
            s1_real5 <= 12'b0; s1_imag5 <= 12'b0;
            s1_real6 <= 12'b0; s1_imag6 <= 12'b0;
            s1_real7 <= 12'b0; s1_imag7 <= 12'b0;

            // Clear S2
            s2_real0 <= 12'b0; s2_imag0 <= 12'b0;
            s2_real1 <= 12'b0; s2_imag1 <= 12'b0;
            s2_real2 <= 12'b0; s2_imag2 <= 12'b0;
            s2_real3 <= 12'b0; s2_imag3 <= 12'b0;
            s2_real4 <= 12'b0; s2_imag4 <= 12'b0;
            s2_real5 <= 12'b0; s2_imag5 <= 12'b0;
            s2_real6 <= 12'b0; s2_imag6 <= 12'b0;
            s2_real7 <= 12'b0; s2_imag7 <= 12'b0;

            // Clear outputs
            y0_real <= 12'b0; y0_imag <= 12'b0;
            y1_real <= 12'b0; y1_imag <= 12'b0;
            y2_real <= 12'b0; y2_imag <= 12'b0;
            y3_real <= 12'b0; y3_imag <= 12'b0;
            y4_real <= 12'b0; y4_imag <= 12'b0;
            y5_real <= 12'b0; y5_imag <= 12'b0;
            y6_real <= 12'b0; y6_imag <= 12'b0;
            y7_real <= 12'b0; y7_imag <= 12'b0;

        end else begin
            // ---- Stage 1 ----
            {s1_real0, s1_imag0} <= butterfly_MAC(STAGE1, 1'b0, x0_real_r, x0_imag_r, x4_real_r, x4_imag_r, W0_REAL, W0_IMAG, TW_W0);
            {s1_real1, s1_imag1} <= butterfly_MAC(STAGE1, 1'b1, x0_real_r, x0_imag_r, x4_real_r, x4_imag_r, W0_REAL, W0_IMAG, TW_W0);

            {s1_real2, s1_imag2} <= butterfly_MAC(STAGE1, 1'b0, x2_real_r, x2_imag_r, x6_real_r, x6_imag_r, W0_REAL, W0_IMAG, TW_W0);
            {s1_real3, s1_imag3} <= butterfly_MAC(STAGE1, 1'b1, x2_real_r, x2_imag_r, x6_real_r, x6_imag_r, W0_REAL, W0_IMAG, TW_W0);

            {s1_real4, s1_imag4} <= butterfly_MAC(STAGE1, 1'b0, x1_real_r, x1_imag_r, x5_real_r, x5_imag_r, W0_REAL, W0_IMAG, TW_W0);
            {s1_real5, s1_imag5} <= butterfly_MAC(STAGE1, 1'b1, x1_real_r, x1_imag_r, x5_real_r, x5_imag_r, W0_REAL, W0_IMAG, TW_W0);

            {s1_real6, s1_imag6} <= butterfly_MAC(STAGE1, 1'b0, x3_real_r, x3_imag_r, x7_real_r, x7_imag_r, W0_REAL, W0_IMAG, TW_W0);
            {s1_real7, s1_imag7} <= butterfly_MAC(STAGE1, 1'b1, x3_real_r, x3_imag_r, x7_real_r, x7_imag_r, W0_REAL, W0_IMAG, TW_W0);

            // ---- Stage 2 ----
            {s2_real0, s2_imag0} <= butterfly_MAC(STAGE2, 1'b0, s1_real0, s1_imag0, s1_real2, s1_imag2, W0_REAL, W0_IMAG, TW_W0);
            {s2_real2, s2_imag2} <= butterfly_MAC(STAGE2, 1'b1, s1_real0, s1_imag0, s1_real2, s1_imag2, W0_REAL, W0_IMAG, TW_W0);

            {s2_real1, s2_imag1} <= butterfly_MAC(STAGE2, 1'b0, s1_real1, s1_imag1, s1_real3, s1_imag3, W2_REAL, W2_IMAG, TW_W2);
            {s2_real3, s2_imag3} <= butterfly_MAC(STAGE2, 1'b1, s1_real1, s1_imag1, s1_real3, s1_imag3, W2_REAL, W2_IMAG, TW_W2);

            {s2_real4, s2_imag4} <= butterfly_MAC(STAGE2, 1'b0, s1_real4, s1_imag4, s1_real6, s1_imag6, W0_REAL, W0_IMAG, TW_W0);
            {s2_real6, s2_imag6} <= butterfly_MAC(STAGE2, 1'b1, s1_real4, s1_imag4, s1_real6, s1_imag6, W0_REAL, W0_IMAG, TW_W0);

            {s2_real5, s2_imag5} <= butterfly_MAC(STAGE2, 1'b0, s1_real5, s1_imag5, s1_real7, s1_imag7, W2_REAL, W2_IMAG, TW_W2);
            {s2_real7, s2_imag7} <= butterfly_MAC(STAGE2, 1'b1, s1_real5, s1_imag5, s1_real7, s1_imag7, W2_REAL, W2_IMAG, TW_W2);

            // ---- Stage 3 ----
            {y0_real, y0_imag} <= butterfly_MAC(STAGE3, 1'b0, s2_real0, s2_imag0, s2_real4, s2_imag4, W0_REAL, W0_IMAG, TW_W0);
            {y4_real, y4_imag} <= butterfly_MAC(STAGE3, 1'b1, s2_real0, s2_imag0, s2_real4, s2_imag4, W0_REAL, W0_IMAG, TW_W0);

            {y2_real, y2_imag} <= butterfly_MAC(STAGE3, 1'b0, s2_real2, s2_imag2, s2_real6, s2_imag6, W2_REAL, W2_IMAG, TW_W2);
            {y6_real, y6_imag} <= butterfly_MAC(STAGE3, 1'b1, s2_real2, s2_imag2, s2_real6, s2_imag6, W2_REAL, W2_IMAG, TW_W2);

            {y1_real, y1_imag} <= butterfly_MAC(STAGE3, 1'b0, s2_real1, s2_imag1, s2_real5, s2_imag5, W1_REAL, W1_IMAG, TW_W1);
            {y5_real, y5_imag} <= butterfly_MAC(STAGE3, 1'b1, s2_real1, s2_imag1, s2_real5, s2_imag5, W1_REAL, W1_IMAG, TW_W1);

            {y3_real, y3_imag} <= butterfly_MAC(STAGE3, 1'b0, s2_real3, s2_imag3, s2_real7, s2_imag7, W3_REAL, W3_IMAG, TW_W3);
            {y7_real, y7_imag} <= butterfly_MAC(STAGE3, 1'b1, s2_real3, s2_imag3, s2_real7, s2_imag7, W3_REAL, W3_IMAG, TW_W3);
        end
    end


endmodule
