module comparasor4_2(
input caryin_i,
input input1_i,
input input2_i,
input input3_i,
input input4_i,

output sum_o,
output cary_o,
output caryout_o
                    );
                    
wire s1=~(input2_i^input3_i^input4_i);
wire s2= input1_i^caryin_i;
assign sum_o=~(s1^s2);
assign cary_o= s1 ? caryin_i & input1_i  : caryin_i |input1_i;
assign caryout_o= (input4_i&input3_i) | (input4_i&input2_i) | (input3_i&input2_i);                                
                                 
endmodule