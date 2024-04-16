module Alu(
    input clk,rst,
    input [31:0] a,
    input [31:0] b,
    input [4:0] opcode,
    input alu_start,
    
    output [31:0] result,
    output reg alu_flag ,
    output reg valid  
    );
    
    // signed inputs
    wire signed [31:0] a_signed = a;
    wire signed [31:0] b_signed = b;
    
    
    // add/subb
    wire [31:0] add = ( a + b );
    wire [31:0] subb = ( a - b );
    
    // Comparison
    
    wire equal = ( a == b );
    wire unequal = ~equal ;
    
    wire lower_unsigned = ( a < b ) ;
    wire greater_unsigned = ~lower_unsigned ;
    
    wire lower_signed = ( a_signed < b_signed ) ;
    wire greater_signed = ~lower_signed ;
    
    // Logical
    wire [31:0] srl = a >> b[4:0] ;
    wire [31:0] sll = a << b[4:0] ;
    
    wire [31:0] sra = a >>> b[4:0];
    
    wire [31:0] Xor = ( a ^ b ) ;
    wire [31:0] Or = ( a | b ) ;
    wire [31:0] And = ( a & b ) ;
    
    // Multiplier and Divider
    wire multiplier_valid, divider_valid ;
    reg multiplier_start, divider_start;
    reg divider_signed, divider_remainder_queotient;
    
    wire [31:0] divider_result;
    wire [63:0] multiplier_result;
    
    reg [31:0] multiplier_input1, multiplier_input2;
    wire [31:0] multiplier_input1_signed = a[31] ? ~a+1 : a ;
    wire [31:0] multiplier_input2_signed = b[31] ? ~b+1 : b ;
    
    wire result_sign = a[31] ^ b[31] ;
    
multiplier mult(
   .rs1_i(multiplier_input1),
   .rs2_i(multiplier_input2),
   .start(multiplier_start),
   .clk_i(clk),
   .rst_i(rst),
   
   .result_o(multiplier_result),
   .valid(multiplier_valid)
        );
        
Divider Div(
    .clk(clk),
    .rst_i(rst),
    .divident(a),
    .divisor(b),
    .return_remainder_or_queotient(divider_remainder_queotient),    // 1 = remainder , 0 = queotient
    .signed_i(divider_signed),
    .start_flag(divider_start),
    .busy_o(),
    .valid_o(divider_valid),
    .error_o(),
    .result_o(divider_result)
    );
    
    reg [31:0] tempresult;
    assign result = tempresult;
    always @(*) begin
        
        
        case (opcode)
        
            5'b00000 : begin  // ADD
                tempresult = add;
                valid = alu_start;
            end
            
            5'b00001 : begin  // SUB
                tempresult = subb;
                valid = alu_start;
            end
            
            5'b00010 : begin  // MUL
                multiplier_input1 = multiplier_input1_signed;
                multiplier_input2 = multiplier_input2_signed;
                multiplier_start = alu_start ;
                valid = multiplier_valid;
                tempresult = result_sign ? ~multiplier_result[31:0]+1: multiplier_result[31:0];
            end
            
            5'b00011 : begin // MULH
                multiplier_input1 = multiplier_input1_signed;
                multiplier_input2 = multiplier_input2_signed;
                multiplier_start = alu_start ;
                valid = multiplier_valid;
                tempresult = result_sign ? ~multiplier_result[63:32]+1: multiplier_result[63:32];
            end
            
            5'b00100 : begin // MULHSU
                multiplier_input1 = multiplier_input1_signed;
                multiplier_input2 = b;
                multiplier_start = alu_start ;
                valid = multiplier_valid;
                tempresult = a[31]? ~multiplier_result[63:32]+1 : multiplier_result[63:32];
            end
            
            5'b00101 : begin // MULHU
                multiplier_input1 = a ;
                multiplier_input2 = b ;
                multiplier_start = alu_start ;
                valid = multiplier_valid ;
                tempresult = multiplier_result[63:32] ;
            end
            
            5'b00110 : begin // DIV
                divider_start = alu_start ;
                valid = divider_valid ;
                divider_signed=1;
                divider_remainder_queotient = 0;
                tempresult = divider_result;
            end
            
            5'b00111 : begin // DIVU
                divider_start = alu_start ;
                valid = divider_valid ;
                divider_signed=0;
                divider_remainder_queotient = 0;
                tempresult = divider_result;
            end
            
            5'b01000 : begin // REM
                divider_start = alu_start ;
                valid = divider_valid ;
                divider_signed=1;
                divider_remainder_queotient = 1;
                tempresult = divider_result;
            end
            
            5'b01001 : begin // REMU
                divider_start = alu_start ;
                valid = divider_valid ;
                divider_signed=0;
                divider_remainder_queotient = 1;
                tempresult = divider_result;
            end
            
            5'b01010 : begin // shift right logical
                tempresult = srl;
                valid = alu_start;
            end
            
            5'b01011 : begin // shift right arithmetic
                tempresult = sra;
                valid = alu_start;
            end
            
            5'b01100 : begin // shift left logical
                tempresult = sll;
                valid = alu_start;
            end
            
            5'b01101 : begin // Xor
                tempresult = Xor;
                valid = alu_start;
            end
            
            5'b01110 : begin // Or
                tempresult = Or;
                valid = alu_start;
                
            end
            
            5'b01111 : begin // And
                tempresult = And;
                valid = alu_start;
            
            end
            
            5'b10000 : begin // Equal
                tempresult = {{31{1'b0}},equal};
                valid = alu_start;
                alu_flag = equal;
            end
            
            5'b10001 : begin // Not Equal
                tempresult = {{31{1'b0}},unequal};
                valid = alu_start;
                alu_flag = unequal;
            end
            
            5'b10010 : begin // Lower Signed
                tempresult = {{31{1'b0}},lower_signed};
                valid = alu_start;
                alu_flag = lower_signed;
            
            end
            5'b10011 : begin // Greater Signed
                tempresult ={{31{1'b0}},greater_signed};
                valid = alu_start;
                alu_flag = greater_signed;   
            end
            5'b10100 : begin // Lower Unsigned
                tempresult = {{31{1'b0}},lower_unsigned};
                valid = alu_start;
                alu_flag = lower_unsigned;
            end
            5'b10101 : begin // Greater Unsigned
                tempresult = {{31{1'b0}},greater_unsigned};
                valid = alu_start;
                alu_flag = greater_unsigned;
            end
        endcase
    
    end
endmodule
