module Leading_Zero_4bit(
    input [3:0] data_i,
    output [1:0] index_o,
    output zero_o
    );
    wire temp;
    wire temp_1;
    wire temp_2;
    or (temp, data_i[2], ~data_i[1]);
    nor (index_o[1], data_i[3], data_i[2]);
    and (index_o[0], ~data_i[3], temp);
    
    or (temp_1,data_i[1],data_i[0]);
    or (temp_2,data_i[3],data_i[2]);
    nor (zero_o, temp_1,temp_2);
endmodule
