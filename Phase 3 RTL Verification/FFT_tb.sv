// =========================================
// FFT Testbench with File I/O and Compare (Q5.7 support)
// =========================================
`timescale 1ns/1ps

module FFT_tb;

    localparam int N          = 8;
    localparam int W          = 12;
    localparam int FRAC_BITS  = 7;   
    localparam int CLK_PERIOD = 10;

    // -----------------------------
    // Signals
    // -----------------------------
    logic clk, rst_n;

    // Inputs
    logic signed [W-1:0] x0_real, x0_imag;
    logic signed [W-1:0] x1_real, x1_imag;
    logic signed [W-1:0] x2_real, x2_imag;
    logic signed [W-1:0] x3_real, x3_imag;
    logic signed [W-1:0] x4_real, x4_imag;
    logic signed [W-1:0] x5_real, x5_imag;
    logic signed [W-1:0] x6_real, x6_imag;
    logic signed [W-1:0] x7_real, x7_imag;

    // Outputs
    logic signed [W-1:0] y0_real, y0_imag;
    logic signed [W-1:0] y1_real, y1_imag;
    logic signed [W-1:0] y2_real, y2_imag;
    logic signed [W-1:0] y3_real, y3_imag;
    logic signed [W-1:0] y4_real, y4_imag;
    logic signed [W-1:0] y5_real, y5_imag;
    logic signed [W-1:0] y6_real, y6_imag;
    logic signed [W-1:0] y7_real, y7_imag;

    // Reference outputs
    logic signed [W-1:0] REF_real [0:N-1];
    logic signed [W-1:0] REF_imag [0:N-1];

    // -----------------------------
    // DUT
    // -----------------------------
    FFT #(
        .N(8),
        .INPUT_WORD_WIDTH(12),
        .INPUT_INTEGER_WIDTH(3),
        .OUTPUT_WORD_WIDTH(12),
        .OUTPUT_INTEGER_WIDTH(5)
    ) DUT (
        .clk(clk),
        .rst_n(rst_n),
        .x0_real(x0_real), .x0_imag(x0_imag),
        .x1_real(x1_real), .x1_imag(x1_imag),
        .x2_real(x2_real), .x2_imag(x2_imag),
        .x3_real(x3_real), .x3_imag(x3_imag),
        .x4_real(x4_real), .x4_imag(x4_imag),
        .x5_real(x5_real), .x5_imag(x5_imag),
        .x6_real(x6_real), .x6_imag(x6_imag),
        .x7_real(x7_real), .x7_imag(x7_imag),
        .y0_real(y0_real), .y0_imag(y0_imag),
        .y1_real(y1_real), .y1_imag(y1_imag),
        .y2_real(y2_real), .y2_imag(y2_imag),
        .y3_real(y3_real), .y3_imag(y3_imag),
        .y4_real(y4_real), .y4_imag(y4_imag),
        .y5_real(y5_real), .y5_imag(y5_imag),
        .y6_real(y6_real), .y6_imag(y6_imag),
        .y7_real(y7_real), .y7_imag(y7_imag)
    );

    // -----------------------------
    // Clock
    // -----------------------------
    initial begin
        clk = 1'b0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // -----------------------------
    // Tasks
    // -----------------------------
    task automatic reset_dut;
        begin
            rst_n = 1'b0;
            repeat (2) @(negedge clk);
            rst_n = 1'b1;
            @(negedge clk);
        end
    endtask

    task automatic wait_pipeline;
        begin
            repeat (4) @(negedge clk);
        end
    endtask

    // Read one line of 8x12-bit binary values
    task automatic read_vector(input integer f, output logic signed [W-1:0] vec[0:N-1]);
        integer i, code;
        logic signed [W-1:0] temp;
        begin
            for (i = 0; i < N; i++) begin
                code = $fscanf(f, "%b", temp);
                vec[i] = temp;  // keep raw Q5.7 word
            end
        end
    endtask

    // -----------------------------
    // Global stats
    // -----------------------------
    integer total_pass = 0;
    integer total_fail = 0;
    integer total_samples = 0;
    real total_abs_error_real = 0.0;
    real total_abs_error_imag = 0.0;

    // Compare DUT vs REF (in Q5.7)
    task automatic compare_outputs;
        integer k, errors;
        real Y_real_q, Y_imag_q, REF_real_q, REF_imag_q;
        real err_real, err_imag;
        real tol = 0.023438;  // tolerance for Q5.7 comparison

        begin
            errors = 0;

            for (k = 0; k < N; k++) begin
                // Convert fixed → real
                case(k)
                    0: begin Y_real_q = y0_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y0_imag / (1.0*(1<<FRAC_BITS)); end
                    1: begin Y_real_q = y1_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y1_imag / (1.0*(1<<FRAC_BITS)); end
                    2: begin Y_real_q = y2_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y2_imag / (1.0*(1<<FRAC_BITS)); end
                    3: begin Y_real_q = y3_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y3_imag / (1.0*(1<<FRAC_BITS)); end
                    4: begin Y_real_q = y4_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y4_imag / (1.0*(1<<FRAC_BITS)); end
                    5: begin Y_real_q = y5_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y5_imag / (1.0*(1<<FRAC_BITS)); end
                    6: begin Y_real_q = y6_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y6_imag / (1.0*(1<<FRAC_BITS)); end
                    7: begin Y_real_q = y7_real / (1.0*(1<<FRAC_BITS)); Y_imag_q = y7_imag / (1.0*(1<<FRAC_BITS)); end
                endcase

                REF_real_q = REF_real[k] / (1.0*(1<<FRAC_BITS));
                REF_imag_q = REF_imag[k] / (1.0*(1<<FRAC_BITS));

                err_real = Y_real_q - REF_real_q;
                err_imag = Y_imag_q - REF_imag_q;

                total_abs_error_real += (err_real<0 ? -err_real : err_real);
                total_abs_error_imag += (err_imag<0 ? -err_imag : err_imag);
                total_samples++;

                if ((err_real > tol) || (err_real < -tol) ||
                    (err_imag > tol) || (err_imag < -tol)) begin
                    $display("FAIL: k=%0d | RTL =%f+j%f | Matlab Model =%f+j%f | Mismatch = %f+j%f",
                             k, Y_real_q, Y_imag_q,
                             REF_real_q, REF_imag_q,
                             err_real, err_imag);
                    errors++;
                    total_fail++;
                end else begin
                    $display("PASS: k=%0d | RTL =%f+j%f | Matlab Model = %f+j%f | Mismatch = %f+j%f",
                             k, Y_real_q, Y_imag_q,
                             REF_real_q, REF_imag_q,
                             err_real, err_imag);
                    total_pass++;
                end
            end

            if (errors == 0)
                $display("All outputs Match for test number = %0d!", test_count+1);
            else
                $display("%0d mismatches bigger than tolerance found in test number = %0d!", errors, test_count+1);
        end
    endtask

    // -----------------------------
    // Stimulus
    // -----------------------------
    integer f_in_real, f_in_imag, f_out_real, f_out_imag;
    integer test_count, max_tests;

    logic signed [W-1:0] X_real [0:N-1];
    logic signed [W-1:0] X_imag [0:N-1];

    initial begin
        max_tests = 100;

        reset_dut();

        // open files
        f_in_real  = $fopen("FFT_inputs_real.txt", "r");
        f_in_imag  = $fopen("FFT_inputs_imag.txt", "r");
        f_out_real = $fopen("FFT_outputs_real.txt", "r");
        f_out_imag = $fopen("FFT_outputs_imag.txt", "r");

        if (f_in_real==0 || f_in_imag==0 || f_out_real==0 || f_out_imag==0)
            $fatal("Error opening one of the input/output files!");

        for (test_count = 0; test_count < max_tests; test_count++) begin
            reset_dut();
            read_vector(f_in_real , X_real);
            read_vector(f_in_imag , X_imag);
            read_vector(f_out_real, REF_real);
            read_vector(f_out_imag, REF_imag);

            // Apply inputs
            {x0_real, x1_real, x2_real, x3_real,
             x4_real, x5_real, x6_real, x7_real} =
            {X_real[0], X_real[1], X_real[2], X_real[3],
             X_real[4], X_real[5], X_real[6], X_real[7]};

            {x0_imag, x1_imag, x2_imag, x3_imag,
             x4_imag, x5_imag, x6_imag, x7_imag} =
            {X_imag[0], X_imag[1], X_imag[2], X_imag[3],
             X_imag[4], X_imag[5], X_imag[6], X_imag[7]};

            wait_pipeline();
            compare_outputs();
        end

        // Final summary
        $display("====================================");
        $display("            SUMMARY REPORT          ");
        $display("====================================");
        $display(" Total Points Checked           : %0d", total_samples);
        $display(" Total Passes                   : %0d", total_pass);
        $display(" Total Fails                    : %0d", total_fail);
        $display(" Average Abs Error (Real)       : %0f", total_abs_error_real/total_samples);
        $display(" Average Abs Error (Imag)       : %0f", total_abs_error_imag/total_samples);
        $display("====================================");

        $display("Simulation finished after %0d tests.", max_tests);
        $stop;
    end

endmodule
