module datapath(input clk,
                input reset,
                input PCWrite,
                input AdrSrc,
                
                input IRWrite,
                input [1:0] ResultSrc,
                input [2:0] ALUControl,
                input [1:0] ALUSrcB,
                input [1:0] ALUSrcA,
                input [1:0] ImmSrc,
                input RegWrite,
                input logic [31:0] ReadData,
                output logic [31:0] Instr,
                output logic [31:0] WriteData,
                output logic [31:0] Adr,
                output Zero);

    logic [31:0] Result;
    logic [31:0] PC;
    logic [31:0] OldPC;
    //logic [31:0] Instruction
    logic [31:0] Data;
    logic [31:0] RD1;
    logic [31:0] RD2;
    logic [31:0] A;
    logic [31:0] ImmExt;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] ALUResult;
    logic [31:0] ALUOut;
    


    flopr_en #(32) pcflop(clk, reset, PCWrite, Result, PC);

    flopr_en #(32) oldpcflop(clk, reset, IRWrite, PC, OldPC);

    flopr_en #(32) InstructionRegister(clk, reset, IRWrite, ReadData, Instr);

    flopr #(32) DataRegister(clk, reset, ReadData, Data);

    flopr #(32) RD1register(clk, reset, RD1, A);

    flopr #(32) RD2register(clk, reset, RD2, WriteData);

    flopr #(32) ALUoutRegister(clk, reset, ALUResult, ALUOut);

    mux2 #(32) adrmux(PC, Result, AdrSrc, Adr);

    mux3 #(32) mux3_1(PC, OldPC, A, ALUSrcA, SrcA);

    mux3 #(32) mux3_2(WriteData, ImmExt, 32'd4 , ALUSrcB, SrcB);

    mux3 #(32) ALUoutMux(ALUOut, Data, ALUResult, ResultSrc, Result);

    alu ALU(SrcA, SrcB, ALUControl, ALUResult, Zero);

    regfile registerfile(clk, RegWrite, Instr[19:15], Instr[24:20], Instr[11:7], Result, RD1, RD2);

    extend Extend(Instr[31:7], ImmSrc, ImmExt);



endmodule