module Leading_Zero(
    input [31:0] data_i,
    output [4:0] index_o,
    output zero_o
    );
    reg [1:0] temp_index;
    assign index_o[1:0] = temp_index;
    wire [1:0] index_0;
    wire [1:0] index_1;
    wire [1:0] index_2;
    wire [1:0] index_3;
    wire [1:0] index_4;
    wire [1:0] index_5;
    wire [1:0] index_6;
    wire [1:0] index_7;
    
    
    wire zero_0;
    wire zero_1;
    wire zero_2;
    wire zero_3;
    wire zero_4;
    wire zero_5;
    wire zero_6;
    wire zero_7;
    
    
    Leading_Zero_4bit ZERO_0(
        . data_i(data_i[3:0]),
        . index_o(index_7),
        . zero_o(zero_7)
    );
    Leading_Zero_4bit ZERO_1(
        . data_i(data_i[7:4]),
        . index_o(index_6),
        . zero_o(zero_6)
    );
    Leading_Zero_4bit ZERO_2(
        . data_i(data_i[11:8]),
        . index_o(index_5),
        . zero_o(zero_5)
    );
    Leading_Zero_4bit ZERO_3(
        . data_i(data_i[15:12]),
        . index_o(index_4),
        . zero_o(zero_4)
    );
    Leading_Zero_4bit ZERO_4(
        . data_i(data_i[19:16]),
        . index_o(index_3),
        . zero_o(zero_3)
    );
    Leading_Zero_4bit ZERO_5(
        . data_i(data_i[23:20]),
        . index_o(index_2),
        . zero_o(zero_2)
    );
    Leading_Zero_4bit ZERO_6(
        . data_i(data_i[27:24]),
        . index_o(index_1),
        . zero_o(zero_1)
    );
    Leading_Zero_4bit ZERO_7(
        . data_i(data_i[31:28]),
        . index_o(index_0),
        . zero_o(zero_0)
    );
    
    wire temp_0;
    wire temp_1;
    and (temp_0,zero_0,zero_1);
    and (temp_1,zero_2,zero_3);
    and (index_o[4],temp_0,temp_1);
    
    wire temp_2;
    wire temp_3;
    wire temp_4;
    wire temp_5;
    wire temp_6;
    wire temp_7;
    and (temp_2,zero_0,zero_1);
    and (temp_3, temp_2, ~zero_2);
    and (temp_4, temp_2, ~zero_3);
    and (temp_5, zero_4, zero_5);
    and (temp_6, temp_2, temp_5);
    or (temp_7, temp_3,temp_4);
    or (index_o[3], temp_7, temp_6);
    
    wire temp_8;
    wire temp_9;
    wire temp_10;
    wire temp_11;
    wire temp_12;
    wire temp_19;
    wire temp_20;
    wire temp_21;
    wire temp_22;
    wire temp_23;
    and (temp_8, zero_0, ~zero_1); //
    and (temp_9, zero_0, zero_2);
    and (temp_10, temp_9, ~zero_3); //
    and (temp_19, zero_4, ~zero_5);
    and (temp_11, temp_19, temp_9); //
    and (temp_20, zero_4, zero_6);
    and (temp_21, temp_20, ~zero_7);
    and (temp_22, temp_9, temp_21); //
    or (temp_12, temp_8, temp_10);
    or (temp_23, temp_11, temp_22);
    or (index_o[2], temp_12, temp_23);
    
    wire temp_13;
    wire temp_14;
    wire temp_15;
    wire temp_16;
    wire temp_17;
    wire temp_18;
    and (temp_13, zero_0, zero_1);
    and (temp_14, zero_2, zero_3);
    and (temp_15, zero_4, zero_5);
    and (temp_16, zero_6, zero_7);
    and (temp_17, temp_13, temp_14);
    and (temp_18, temp_15, temp_16);
    and (zero_o, temp_17, temp_18);
    
    always @(*)begin
        case (index_o[4:2])
            3'b000: temp_index = index_0;
            3'b001: temp_index = index_1;
            3'b010: temp_index = index_2;
            3'b011: temp_index = index_3;
            3'b100: temp_index = index_4;
            3'b101: temp_index = index_5;
            3'b110: temp_index = index_6;
            3'b111: temp_index = index_7;
        endcase
    end
endmodule
