//////////////////////////////////////////////////////////////////////////////////
// Company: Slasic
// Engineer: Cimonk
// 
// Create Date: 02/11/2024 04:12:39 PM
// Design Name: Multplier
// Module Name: multplier
// Project Name: CPU
// Target Devices: nexys3 100T
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module multiplier#(parameter width=32)(
input [width-1:0]rs1_i,
input [width-1:0]rs2_i,
input start,
input clk_i,
input rst_i,
  
output [2*width-1:0]result_o,
output reg valid
    );
  reg [31:0]rs1_ir;
  reg [32:0]rs2_ir;   
    
wire [32:0]radix4_decoder = {rs1_ir,1'b0};    
reg  [32:0]PartialProducts [0:15];    // all partial products that generated via radix4 decoder
wire [32:0] rs2_2scomp = ~rs2_ir;

// radix 4 booth decode stage  
reg [31:0]cary; 
reg [15:0]sign,sign1;
genvar k;    
generate
    for(k=0 ;k<16; k=k+1)begin
        always @(*)begin
            case(radix4_decoder[2+2*k:2*k])
                3'b000:begin
                  	PartialProducts[k]=33'b0;
                    cary[2*k]=0;
                    cary[2*k+1]=0;
                  	sign[k]=0;
                end
                3'b001:begin
                  	PartialProducts[k]=rs2_ir;
                    cary[2*k]=0;
                    cary[2*k+1]=0;
                  	sign[k]=0;
                end
                3'b010:begin
                  	PartialProducts[k]=rs2_ir;
                    cary[2*k]=0;
                    cary[2*k+1]=0;
                  	sign[k]=0;
                end
                3'b011:begin
                  	PartialProducts[k]=rs2_ir<<1;
                    cary[2*k]=0;
                    cary[2*k+1]=0;
                  	sign[k]=0;
                end
                3'b100:begin
                    PartialProducts[k]=rs2_2scomp<<1;
                    cary[2*k]=0;
                    cary[2*k+1]=1;
                  	sign[k]=1;
                end
                3'b101:begin
                    PartialProducts[k]=rs2_2scomp;
                    cary[2*k]=1;
                    cary[2*k+1]=0;
                  	sign[k]=1;
                end
                3'b110:begin
                    PartialProducts[k]=rs2_2scomp;
                    cary[2*k]=1;
                    cary[2*k+1]=0;
                  	sign[k]=1;
                end
                3'b111:begin
                  	PartialProducts[k]=33'b0;
                    cary[2*k]=0;
                    cary[2*k+1]=0;
                  	sign[k]=0;
                end
            endcase

        end  
    
    end
    endgenerate
reg  [32:0] PartialProducts1 [0:15];
wire [63:0] partialproducts64bit [0:15];    
  assign partialproducts64bit[0] =sign1[0] ? {{31{1'b1}},PartialProducts1[0]}     :{31'b0,PartialProducts1[0]}  ;     
  assign partialproducts64bit[1] =sign1[1] ? {{29{1'b1}},PartialProducts1[1],2'h0}:{29'b0,PartialProducts1[1],2'h0}  ;   
  assign partialproducts64bit[2] =sign1[2] ? {{27{1'b1}},PartialProducts1[2],4'h0} :{27'b0,PartialProducts1[2],4'h0}  ;   
  assign partialproducts64bit[3] =sign1[3] ? {{25{1'b1}},PartialProducts1[3],6'h0} :{25'b0,PartialProducts1[3],6'h0}  ;   
  assign partialproducts64bit[4] =sign1[4] ? {{23{1'b1}},PartialProducts1[4],8'h0}  :{23'b0,PartialProducts1[4],8'h0}  ;   
  assign partialproducts64bit[5] =sign1[5] ? {{21{1'b1}},PartialProducts1[5],10'h0} :{21'b0,PartialProducts1[5],10'h0}  ;   
  assign partialproducts64bit[6] =sign1[6] ? {{19{1'b1}},PartialProducts1[6],12'h0}  :{19'b0,PartialProducts1[6],12'h0}  ;   
  assign partialproducts64bit[7] =sign1[7] ? {{17{1'b1}},PartialProducts1[7],14'h0}  :{17'b0,PartialProducts1[7],14'h0}  ;   
  assign partialproducts64bit[8] =sign1[8] ? {{15{1'b1}},PartialProducts1[8],16'h0}   :{15'b0,PartialProducts1[8],16'h0}  ;   
  assign partialproducts64bit[9] =sign1[9] ? {{13{1'b1}},PartialProducts1[9],18'h0}   :{13'b0,PartialProducts1[9],18'h0}  ;   
  assign partialproducts64bit[10]=sign1[10]? {{11{1'b1}},PartialProducts1[10],20'h0}   :{11'b0,PartialProducts1[10],20'h0} ;   
  assign partialproducts64bit[11]=sign1[11]? {{9{1'b1}},PartialProducts1[11],22'h0}   :{9'b0,PartialProducts1[11],22'h0} ;   
  assign partialproducts64bit[12]=sign1[12]? {{7{1'b1}}, PartialProducts1[12],24'h0}   :{7'b0,PartialProducts1[12],24'h0} ;   
  assign partialproducts64bit[13]=sign1[13]? {{5{1'b1}}, PartialProducts1[13],26'h0}   :{5'b0,PartialProducts1[13],26'h0} ;   
  assign partialproducts64bit[14]=sign1[14]? {{3{1'b1}}, PartialProducts1[14],28'h0}    :{3'b0,PartialProducts1[14],28'h0} ; 
  assign partialproducts64bit[15]=sign1[15]? {{1{1'b1}}, PartialProducts1[15],30'h0}    :{1'b0,PartialProducts1[15],30'h0} ;        
// wallace tree adder  
reg [31:0] cary1,cary2,cary3,cary4;
reg  [63:0]pipeline1[0:9],pipeline2[0:5],pipeline3[0:3],pipeline4[0:1];
wire [63:0] comp1_out1,comp1_out2,comp1_out3;
comparasor_64bit  first1(.x1(partialproducts64bit[0]),.x2(partialproducts64bit[1]),.x3(partialproducts64bit[2]),.x4(partialproducts64bit[3]),.x5(partialproducts64bit[4]),.out1(comp1_out1),.out2(comp1_out2),.out3(comp1_out3));

wire [63:0] comp2_out1,comp2_out2,comp2_out3;
comparasor_64bit  first2(.x1(partialproducts64bit[5]),.x2(partialproducts64bit[6]),.x3(partialproducts64bit[7]),.x4(partialproducts64bit[8]),.x5(partialproducts64bit[9]),.out1(comp2_out1),.out2(comp2_out2),.out3(comp2_out3));

wire [63:0] comp3_out1,comp3_out2,comp3_out3;
comparasor_64bit  first3(.x1(partialproducts64bit[10]),.x2(partialproducts64bit[11]),.x3(partialproducts64bit[12]),.x4(partialproducts64bit[13]),.x5(partialproducts64bit[14]),.out1(comp3_out1),.out2(comp3_out2),.out3(comp3_out3));


wire [63:0] comp2_1_out1,comp2_1_out2,comp2_1_out3;
comparasor_64bit  second1(.x1(pipeline1[0]),.x2(pipeline1[1]),.x3(pipeline1[2]),.x4(pipeline1[3]),.x5(pipeline1[4]),.out1(comp2_1_out1),.out2(comp2_1_out2),.out3(comp2_1_out3));

wire [63:0] comp2_2_out1,comp2_2_out2,comp2_2_out3;
comparasor_64bit  second2(.x1(pipeline1[5]),.x2(pipeline1[6]),.x3(pipeline1[7]),.x4(pipeline1[8]),.x5(pipeline1[9]),.out1(comp2_2_out1),.out2(comp2_2_out2),.out3(comp2_2_out3));

wire [63:0] comp3_1_out1,comp3_1_out2,comp3_1_out3;
comparasor_64bit  third(.x1(pipeline2[0]),.x2(pipeline2[1]),.x3(pipeline2[2]),.x4(pipeline2[3]),.x5(pipeline2[4]),.out1(comp3_1_out1),.out2(comp3_1_out2),.out3(comp3_1_out3));

wire [63:0] comp4_1_out1,comp4_1_out2,comp4_1_out3;
comparasor_64bit  fourth(.x1(pipeline3[0]),.x2(pipeline3[1]),.x3(pipeline3[2]),.x4(pipeline3[3]),.x5({32'b0,cary4}),.out1(comp4_1_out1),.out2(comp4_1_out2),.out3(comp4_1_out3));

wire [63:0] comp4_2_out1,comp4_2_out2;
fulladder_64bit uut(.x1_i(comp4_1_out1),.x2_i(comp4_1_out2),.x3_i(comp4_1_out3),.out_o(comp4_2_out1),.cary_o(comp4_2_out2));


assign result_o=pipeline4[0]+pipeline4[1];

reg start1,start2,start3,start4,start5;  

integer i;
	generate
		always @(posedge clk_i)begin
			if(rst_i)begin
				for(i=0; i<16; i=i+1)begin
				PartialProducts1[i]<=0;
				end
			end
			else begin
				for(i=0; i<16; i=i+1)begin
					PartialProducts1[i]<=PartialProducts[i];
				end
			end
		end
	endgenerate


always @(posedge clk_i)begin
    if(rst_i)begin     
        pipeline1[0]<=0 ;
        pipeline1[1]<=0 ;
        pipeline1[2]<=0 ;
        pipeline1[3]<=0 ;
        pipeline1[4]<=0 ;
        pipeline1[5]<=0 ;             
        pipeline1[6]<=0 ;
        pipeline1[7]<=0 ;
        pipeline1[8]<=0 ;        
        pipeline1[9]<=0 ;       
        pipeline2[0]<=0 ;
        pipeline2[1]<=0 ;
        pipeline2[2]<=0 ;
        pipeline2[3]<=0 ;
        pipeline2[4]<=0 ;
        pipeline2[5]<=0 ;     
        pipeline3[0]<=0 ;
        pipeline3[1]<=0 ;
        pipeline3[2]<=0 ;
        pipeline3[3]<=0 ;
        pipeline4[0]<=0 ;
        pipeline4[1]<=0 ;
        sign1<=0;
        cary1<=0;cary2<=0;cary3<=0;cary4<=0;
      	start1<=0;start2<=0;start3<=0;start4<=0;start5<=0;
      	rs1_ir<=0;rs2_ir<=0;
    end
    else begin
      	if(start)begin
        	rs1_ir <= rs1_i;
          	rs2_ir <= {1'b0,rs2_i};
          	start1 <= 1;
      	end
      	else begin
        	start1<=0;  
        end
//     	start1<= start;
		start2<= start1;
        start3<= start2;
      	start4<= start3;
      	start5<= start4;
      	valid<= start5;
        sign1<=sign;
        
        pipeline1[0]<= comp1_out1;
        pipeline1[1]<= comp1_out2;
        pipeline1[2]<= comp1_out3;
        cary1<=cary;
        
        pipeline1[3]<= comp2_out1;
        pipeline1[4]<= comp2_out2;
        pipeline1[5]<= comp2_out3;
        
        pipeline1[6]<= comp3_out1;
        pipeline1[7]<=comp3_out2;
        pipeline1[8]<=comp3_out3;
        
        pipeline1[9]<=partialproducts64bit[15];
        
        pipeline2[0]<=comp2_1_out1;
        pipeline2[1]<=comp2_1_out2;
        pipeline2[2]<=comp2_1_out3;
        pipeline2[3]<=comp2_2_out1;
        pipeline2[4]<=comp2_2_out2;
        pipeline2[5]<=comp2_2_out3;
        cary2<=cary1;
        
        pipeline3[0]<=comp3_1_out1;
        pipeline3[1]<=comp3_1_out2;
        pipeline3[2]<=comp3_1_out3;
        pipeline3[3]<=pipeline2[5];
        cary3<=cary2;
        
        pipeline4[0]<=comp4_2_out1;
        pipeline4[1]<=comp4_2_out2;    
        cary4<=cary3;   
    end
end 
endmodule