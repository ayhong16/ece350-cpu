module segmentDisplay(
    output reg[6:0] SEG, 
    input [31:0] reg1, reg2, reg3, reg4, reg5, reg6, reg7, reg8, reg9,
    input [3:0] SW,
    input clock);

    reg [31:0] currentRegData;

    // assign currentRegData = SW == 4'b0001 ? reg1 :
    //                         SW == 4'b0010 ? reg2 :
    //                         SW == 4'b0011 ? reg3 :
    //                         SW == 4'b0100 ? reg4 :
    //                         SW == 4'b0101 ? reg5 :
    //                         SW == 4'b0110 ? reg6 :
    //                         SW == 4'b0111 ? reg7 :
    //                         SW == 4'b1000 ? reg8 :
    //                         SW == 4'b1001 ? reg9 :
    //                         32'd0;

    parameter SEGMENT0 = 7'b1000000;
    parameter SEGMENT1 = 7'b1111001;
    parameter SEGMENT2 = 7'b0100100;
    parameter SEGMENT3 = 7'b0110000;
    parameter SEGMENT4 = 7'b0011001;
    parameter SEGMENT5 = 7'b0010010;
    parameter SEGMENT6 = 7'b0000010;
    parameter SEGMENT7 = 7'b1111000;
    parameter SEGMENT8 = 7'b0000000;
    parameter SEGMENT9 = 7'b0010000;
    parameter SEGMENTBROKEN = 7'b1110111;

    // always @(posedge clock) begin
    //     case (reg2[3:0])
    //         4'd0: SEG = SEGMENT0;
    //         4'd1: SEG = SEGMENT1;
    //         4'd2: SEG = SEGMENT2;
    //         4'd3: SEG = SEGMENT3;
    //         4'd4: SEG = SEGMENT4;
    //         4'd5: SEG = SEGMENT5;
    //         4'd6: SEG = SEGMENT6;
    //         4'd7: SEG = SEGMENT7;
    //         4'd8: SEG = SEGMENT8;
    //         4'd9: SEG = SEGMENT9;
    //         default: SEG = SEGMENTBROKEN;
    //     endcase
    // end

    always @(posedge clock) begin
        case (SW)
            4'd1: currentRegData <= reg1;
            4'd2: currentRegData <= reg2;
            4'd3: currentRegData <= reg3;
            4'd4: currentRegData <= reg4;
            4'd5: currentRegData <= reg5;
            4'd6: currentRegData <= reg6;
            4'd7: currentRegData <= reg7;
            4'd8: currentRegData <= reg8;
            4'd9: currentRegData <= reg9;
            default: currentRegData <= 32'd0;
        endcase
        if(currentRegData == 32'd0) begin
            SEG <= SEGMENT0;
        end else if(currentRegData == 32'd1) begin
            SEG <= SEGMENT1;
        end else if(currentRegData == 32'd2) begin
            SEG <= SEGMENT2;
        end else if(currentRegData == 32'd3) begin
            SEG <= SEGMENT3;
        end else if(currentRegData == 32'd4) begin
            SEG <= SEGMENT4;
        end else if(currentRegData == 32'd5) begin
            SEG <= SEGMENT5;
        end else if(currentRegData == 32'd6) begin
            SEG <= SEGMENT6;
        end else if(currentRegData == 32'd7) begin
            SEG <= SEGMENT7;
        end else if(currentRegData == 32'd8) begin
            SEG <= SEGMENT8;
        end else if(currentRegData == 32'd9) begin
            SEG <= SEGMENT9;
        end
    end

    // assign SEG = currentRegData == 32'd0 ? SEGMENT[0] :
    //              currentRegData == 32'd1 ? SEGMENT[1] :
    //              currentRegData == 32'd2 ? SEGMENT[2] :
    //              currentRegData == 32'd3 ? SEGMENT[3] :
    //              currentRegData == 32'd4 ? SEGMENT[4] :
    //              currentRegData == 32'd5 ? SEGMENT[5] :
    //              currentRegData == 32'd6 ? SEGMENT[6] :
    //              currentRegData == 32'd7 ? SEGMENT[7] :
    //              currentRegData == 32'd8 ? SEGMENT[8] :
    //              currentRegData == 32'd9 ? SEGMENT[9] :
    //              7'b0000000;

    // assign SEG = SW == 4'b0001 ? SEGMENT[1] :
    //              SW == 4'b0010 ? SEGMENT[2] :
    //                 SW == 4'b0011 ? SEGMENT[3] :
    //                 SW == 4'b0100 ? SEGMENT[4] :
    //                 SW == 4'b0101 ? SEGMENT[5] :
    //                 SW == 4'b0110 ? SEGMENT[6] :
    //                 SW == 4'b0111 ? SEGMENT[7] :
    //                 SW == 4'b1000 ? SEGMENT[8] :
    //                 SW == 4'b1001 ? SEGMENT[9] :
    //                 SEGMENT[0];

endmodule
