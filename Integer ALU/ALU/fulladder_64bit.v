module fulladder_64bit(
    input [63:0]x1_i,
    input [63:0]x2_i,
    input [63:0]x3_i,
    output [63:0]out_o,
    output [63:0]cary_o
    );
    
    wire [63:0]temp_cary;
 fulladder uut[63:0](.x1_i(x1_i),.x2_i(x2_i),.x3_i(x3_i),.out_o(out_o),.cary_o(temp_cary));
 assign cary_o = temp_cary << 1 ;
endmodule