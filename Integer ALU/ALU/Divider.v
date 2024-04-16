module Divider#(parameter width = 32)(
    input clk,
    input rst_i,
    input [width-1:0] divident,
    input [width-1:0] divisor,
    input return_remainder_or_queotient,    // 1 = remainder , 0 = queotient
    input signed_i,
    input start_flag,
    output reg busy_o,
    output reg valid_o,
    output reg error_o,
    output reg [width-1:0] result_o
    );
    
    reg [2*width:0] A_Q_reg;
    reg [width:0] B_reg;
    reg [5:0] count;
    reg start_reg;
    reg clear_reg;
    reg xor_sign;
    reg div_sign;
    reg signed_reg;
    
    wire [2*width:0] A_Q_reg_shift = A_Q_reg << 1;
    wire [width:0] A_subtract_B = A_Q_reg_shift[2*width:width] + B_reg;
    wire [width-1:0] remainder = A_Q_reg[2*width-1:width];
    wire [width-1:0] queotient = A_Q_reg[width-1:0];
    
    always @(posedge clk)begin
        if(rst_i == 1'b1)begin
            A_Q_reg <= {(2*width+1){1'b0}};
            B_reg <= {(width+1){1'b0}};
            count <= {(width+1){1'b0}};
            busy_o <= 1'b0;
            valid_o <= 1'b0;
            result_o <= {(width){1'b0}};
            start_reg <= 1'b0;
            clear_reg <= 1'b0;
            error_o <= 1'b0;
            xor_sign <= 1'b0;
            div_sign <= 1'b0;
            signed_reg <= 1'b0;
        end
        else if(clk == 1'b1)begin
            if(start_flag && (divisor!=0))begin
                A_Q_reg <= (signed_i && divident[31]) ? ({{(width+1){1'b0}}, (~(divident)+1) }) : ({{(width+1){1'b0}}, divident });
                B_reg <= (signed_i && divisor[31]) ? ({1'b1,divisor}) : (~({1'b0,divisor})+1);
                xor_sign <= divident[31] ^ divisor[31];
                div_sign <= divident[31];
                signed_reg <= signed_i;
                busy_o <= 1'b1;
                error_o <= 1'b0;
                count <= width;
                start_reg <= 1'b1;
            end
            else if (start_reg )begin
                A_Q_reg <= A_Q_reg_shift;
                if(A_subtract_B[width])begin
                    A_Q_reg[0] <= 1'b0;
                end
                else begin
                    A_Q_reg[0] <= 1'b1;
                    A_Q_reg[2*width:width] <= A_subtract_B;
                end
                if(!count)begin
                    busy_o <= 1'b0;
                    valid_o <= 1'b1;
                    if (return_remainder_or_queotient && signed_reg)begin
                        if (remainder == 32'b0)begin
                            result_o <= remainder;
                        end
                        else begin
                            result_o <= (div_sign) ? ((~remainder)+1) : (remainder);
                        end
                    end
                    else if (!return_remainder_or_queotient && signed_reg)begin
                        if (queotient == 32'b0)begin
                            result_o <= queotient;
                        end
                        else begin
                            result_o <= (xor_sign) ? ((~queotient)+1) : (queotient);
                        end
                    end
                    else begin
                        result_o <= (return_remainder_or_queotient) ? (remainder) : (queotient);
                    end
                    clear_reg <= 1'b1;
                    start_reg <= 1'b0;
                end
                else begin
                    count <= count -1;
                end
            end
            else if (clear_reg)begin
                A_Q_reg <= {(2*width+1){1'b0}};
                B_reg <= {(width+1){1'b0}};
                valid_o <= 1'b0;
                busy_o <= 1'b0;
                clear_reg <= 1'b0;
            end
            else if (start_flag && (!divisor))begin
                error_o <= 1'b1;
            end
        end
    end
endmodule