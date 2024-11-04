module controller(input logic clk,
                input logic reset,
                input logic [6:0] op,
                input logic [2:0] funct3,
                input logic funct7b5,
                input logic zero,
                output logic [1:0] immsrc,
                output logic [1:0] alusrca, alusrcb,
                output logic [1:0] resultsrc,
                output logic adrsrc,
                output logic [2:0] alucontrol,
                output logic irwrite, pcwrite,
                output logic regwrite, memwrite);

    logic branchwire;
    logic pcupdatewire;
    logic [1:0]aluopwire;

    FSM mainFSM (clk, reset,op, branchwire, pcupdatewire, regwrite, memwrite, irwrite, resultsrc,alusrcb, alusrca,
    adrsrc, aluopwire);

    aludec aludecoder(op[5], funct3, funct7b5, aluopwire, alucontrol);
    instrdec instructiondecoder(op, immsrc);

    assign pcwrite = ((zero & branchwire) | pcupdatewire);


endmodule