module top(input clk, reset,
        output logic [31:0] WriteData, DataAdr,
        output logic MemWrite);


    logic [31:0] ReadData

    riscmulti processor(clk, reset, ReadData, MemWrite, DataAdr, WriteData);


    InstrDmem u_mem(clk, DataAdr, MemWrite, WriteData, ReadData);
    

    



endmodule


