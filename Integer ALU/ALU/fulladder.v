module fulladder(
    input x1_i,
    input x2_i,
    input x3_i,
    output out_o,
    output cary_o
    );
    
    assign out_o = x1_i ^ x2_i ^ x3_i;
    assign cary_o = (x1_i & x2_i) | (x1_i & x3_i) | (x3_i & x2_i);
    
endmodule