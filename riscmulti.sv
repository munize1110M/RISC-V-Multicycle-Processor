module riscmulti ( input clk,
        input reset,
        input logic [31:0] ReadData,
        output WriteEnable,
        output logic [31:0] Address,
        output logic [31:0] WriteData)

        logic [31:0] instr;
        logic zero;
        logic regwrite;
        logic pcwrite;
        logic irwrite;
        logic [2:0] alucontrol;
        logic adrsrc;
        logic [1:0] resultsrc;
        logic [1:0] alusrcA;
        logic [1:0] alusrcB;
        logic [1:0] immsrc;

        controller cont(clk, reset, instr[6:0], instr[14:12], instr[30], zero, immsrc, alusrcA, 
                    alusrcB, resultsrc, adrsrc, alucontrol, irwrite, pcwrite, regwrite, WriteEnable);

        datapath data(clk, reset, pcwrite, adrsrc, irwrite, resultsrc, alucontrol,
                    alusrcB, alusrcA, immsrc, regwrite, ReadData, WriteData, Address, zero);


endmodule

        