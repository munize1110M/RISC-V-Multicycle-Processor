// Code for the main FSM
module FSM( input clk,
            input reset,
            input logic [6:0] op,
            output logic Branch,
            output logic PCUpdate,
            output logic RegWrite,
            output logic MemWrite,
            output logic IRWrite,
            output logic [1:0]ResultSrc,
            output logic [1:0]ALUSrcB,
            output logic [1:0]ALUSrcA,
            output logic AdrSrc,
            output logic [1:0]ALUOp
        );


reg [3:0]state;
reg [3:0]next_state;

parameter FETCH= 0, DECODE = 1, MEMADR = 2, MEMREAD = 3, MEMWB = 4, MEMWRITE = 5, EXECUTER = 6, ALUWB = 7, EXECUTEEL = 8,JAL = 9, BEQ = 10;

always_comb begin 
    next_state = state;
    case(state)
        FETCH: begin
            next_state = DECODE;
        end
        DECODE: begin
            if (op == 7'b0000011 || op == 7'b0100011) begin//lw or sw
                next_state = MEMADR;
            end
            else if (op == 7'b0110011) begin //r-type
                next_state = EXECUTER;
            end
            else if(op == 7'b0010011) begin // i-type ALU
                next_state = EXECUTEEL;
            end
            else if(op == 7'b1101111) begin //JAL
                next_state = JAL;
            end
            else if(op == 7'b1100011) begin // BEQ
                next_state = BEQ;
            end
        end
        MEMADR: begin
            if (op == 7'b0000011) begin //lw
                next_state = MEMREAD;
            end
            else if (op == 7'b0100011) begin //sw
                next_state = MEMWRITE;
            end
        end
        MEMREAD: begin
            next_state = MEMWB;
        end
        MEMWRITE: begin
            next_state = FETCH;
        end
        MEMWB: begin
            next_state = FETCH;
        end
        EXECUTER: begin
            next_state = ALUWB;
        end
        EXECUTEEL: begin
            next_state = ALUWB;
        end
        JAL: begin
            next_state = ALUWB;
        end
        ALUWB: begin
            next_state = FETCH;
        end
        BEQ: begin
            next_state = FETCH;
        end

    endcase
end

always_ff @(posedge clk ) begin 
    if (reset) begin
        state <= FETCH;
    end
    else 
        state <= next_state;    
end
/*
always_comb begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b00;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;

    if (state == FETCH) begin
        Branch = 1'b0;
        PCUpdate = 1'b1;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b1;
        ResultSrc = 2'b10;
        ALUSrcB = 2'b10;
        ALUSrcA = 2'b00;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;
    end
    else if(state == DECODE) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b01;
        ALUSrcA = 2'b01;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;
    end
    else if (state == MEMADR) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b000;
        ALUSrcB = 2'b01;
        ALUSrcA = 2'b10;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;
    end
    else if (state == MEMREAD) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b00;
        AdrSrc = 1'b1;
        ALUOp = 2'b00;
    end
    else if(state == MEMWB) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b1;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b01;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b00;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;
    end
    else if (state == MEMWRITE) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b1;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b00;
        AdrSrc = 1'b1;
        ALUOp = 2'b00;
    end
    else if (state == EXECUTER) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b10;
        AdrSrc = 1'b0;
        ALUOp = 2'b10;
    end
    else if (state == EXECUTEEL) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b01;
        ALUSrcA = 2'b10;
        AdrSrc = 1'b0;
        ALUOp = 2'b10;
    end
    else if(state == JAL) begin
        Branch = 1'b0;
        PCUpdate = 1'b1;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b10;
        ALUSrcA = 2'b01;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;
    end
    else if(state == ALUWB) begin
        Branch = 1'b0;
        PCUpdate = 1'b0;
        RegWrite = 1'b1;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b00;
        AdrSrc = 1'b0;
        ALUOp = 2'b00;
    end
    else if(state == BEQ) begin
        Branch = 1'b1;
        PCUpdate = 1'b0;
        RegWrite = 1'b0;
        MemWrite = 1'b0;
        IRWrite = 1'b0;
        ResultSrc = 2'b00;
        ALUSrcB = 2'b00;
        ALUSrcA = 2'b10;
        AdrSrc = 1'b0;
        ALUOp = 2'b01;
    end

end*/
always_comb begin
    // Set default values for all signals
    Branch = 1'b0;
    PCUpdate = 1'b0;
    RegWrite = 1'b0;
    MemWrite = 1'b0;
    IRWrite = 1'b0;
    ResultSrc = 2'b00;
    ALUSrcB = 2'b00;
    ALUSrcA = 2'b00;
    AdrSrc = 1'b0;
    ALUOp = 2'b00;

    // Use a case statement to assign values based on the state
    case (state)
        FETCH: begin
            PCUpdate = 1'b1;
            IRWrite = 1'b1;
            ResultSrc = 2'b10;
            ALUSrcB = 2'b10;
        end
        DECODE: begin
            ALUSrcB = 2'b01;
            ALUSrcA = 2'b01;
        end
        MEMADR: begin
            ALUSrcB = 2'b01;
            ALUSrcA = 2'b10;
        end
        MEMREAD: begin
            AdrSrc = 1'b1;
        end
        MEMWB: begin
            RegWrite = 1'b1;
            ResultSrc = 2'b01;
        end
        MEMWRITE: begin
            MemWrite = 1'b1;
            AdrSrc = 1'b1;
        end
        EXECUTER: begin
            ALUSrcA = 2'b10;
            ALUOp = 2'b10;
        end
        EXECUTEEL: begin
            ALUSrcB = 2'b01;
            ALUSrcA = 2'b10;
            ALUOp = 2'b10;
        end
        JAL: begin
            PCUpdate = 1'b1;
            ALUSrcB = 2'b10;
            ALUSrcA = 2'b01;
        end
        ALUWB: begin
            RegWrite = 1'b1;
        end
        BEQ: begin
            Branch = 1'b1;
            ALUSrcA = 2'b10;
            ALUOp = 2'b01;
        end
        default: begin
            // Default case is handled by the initial assignments
        end
    endcase
end


endmodule


