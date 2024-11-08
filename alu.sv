module alu(input  logic signed [31:0] a, 
           input  logic [31:0] b,
           input  logic [2:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero,
           output logic        less_than);

  logic [31:0] condinvb, sum;
  logic        v;              // overflow
  logic        isAddSub;       // true when is add or subtract operation

  assign condinvb = alucontrol[0] ? ~b : b;
  assign sum = a + condinvb + alucontrol[0];
  assign isAddSub = ~alucontrol[2] & ~alucontrol[1] |
                    ~alucontrol[1] & alucontrol[0];

  always_comb
    case (alucontrol)
      3'b000:  result = sum;                 // add
      3'b001:  result = sum;                 // subtract
      3'b010:  result = a & b;               // and
      3'b011:  result = a | b;       // or
      3'b100:  result = a ^ b;       // xor
      3'b101:  result = a < b ? 31'b01: 31'b0;// slt
      3'b110:  result = a << b;// sll
      //3'b111:  result = a >> b;// srl
      3'b111:  result = a >>> b; //SRA
      default: result = 32'bx;
    endcase

  assign zero = (result == 32'b0);
  assign v = ~(alucontrol[0] ^ a[31] ^ b[31]) & (a[31] ^ sum[31]) & isAddSub;
  //Compares rs1 sign bit to result sign bit.
  //if a < b, set lt flag high, else, set lt flag low
  assign less_than = (a < b) ? 1'b1 : 1'b0;
  
endmodule