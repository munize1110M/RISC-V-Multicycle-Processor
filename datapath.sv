module datapath(input clk,
                input reset,
                input instr,
                input ReadData,
                output zero,
                output PC,
                output ALUResult,
                output WriteData);

    flopr pcflop();
    flopr oldpcflop();
    flopr InstructionRegister();
    flopr DataRegister();
    flopr RD1register();
    flopr RD2register();
    flopr ALUoutRegister();
    mux2 adrmux();
    mux3 mux3_1();
    mux3 mux3_2();
    mux3 ALUoutMux();
    alu ALU();
    regfile registerfile();
    extend Extend();


endmodule