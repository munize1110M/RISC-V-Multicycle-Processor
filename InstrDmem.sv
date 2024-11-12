module InstrDmem( input clk,
        input logic [31:0] A,
        input WE,
        input logic [31:0] WD,
        output logic [31:0] RD);

    logic [31:0] RAM[127:0];

    initial
       $readmemh("machinecode_TestProgram.txt", INSTR_MEM);

    

    assign RD = RAM[A[31:2]];

    always_ff @(posedge clk)
        if (WE) RAM[A[31:2]] <= WD;


    
endmodule