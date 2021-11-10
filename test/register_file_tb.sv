//Register file testbench
//author: Miguel Bucio miguel_angel_bucio@hotmail.com
//date: November 10 2021

`timescale 1ns/1ns
module register_file_tb;

    parameter NUM_REGISTERS = 32;
    parameter DATA_WIDTH    = 32;
    localparam ADDR_WIDTH   = $clog2(NUM_REGISTERS);

    typedef logic[ADDR_WIDTH-1:0] addr_t;
    typedef logic[DATA_WIDTH-1:0] data_t;

    logic clk;
    logic rst_n;
    addr_t A1, A2, A3;
    data_t RD1, RD2, WD3;
    logic WE3;

    //Dut
    register_file dut(
        .clk(clk),
        .rst_n(rst_n),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .RD1(RD1),
        .RD2(RD2),
        .WD3(WD3),
        .WE3(WE3)
    );

    //CLock
    initial begin 
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end 

    //CLocking block
    clocking cb @(posedge clk);
        output A1;
        output A2;
        output A3;
        input  RD1;
        input  RD2;
        output WD3;
        output WE3;
    endclocking: cb

    initial begin
        $display("Starting test");
        test();
        $display("Finishing test");
        $finish;
    end

    //Write register
    task automatic write_register (addr_t addr = 0, data_t data = 0);
        cb.WE3 <= 1'b1;
        cb.A3  <= addr;
        cb.WD3 <= data;
        @(cb);
        cb.WE3 <= 1'b0;
        cb.A3  <= 0;
        cb.WD3 <= 0;
    endtask: write_data

    task automatic read_register (bit port_1 = 1, addr_t addr = 0, output data_t data);
        if (port_1) begin
            read_register_1(addr, data);
        end else begin
            read_register_2(addr, data);
        end
    endtask: read_register

    task automatic read_register_1(addr_t addr = 0, output data_t data);
        cb.A1 <= addr;
        @(cb);
        data <= cb.RD1;
        cb.A1 <= 0;
    endtask: read_register_1

    task automatic read_register_2(addr_t addr = 0, output data_t data);
        cb.A2 <= addr;
        @(cb);
        data <= cb.RD2;
        cb.A2 <= 0;
    endtask: read_register_2

    task automatic test();
        data_t data1;
        data_t data2;
        rst_n = 0;
        #20;
        rst_n = 1;
        @(cb);
        //Write all registers
        for (int i=0; i<NUM_REGISTERS; i++) begin 
            @(cb);
            write_register(i, $urandom());
        end
        #100;
        @(cb);
        fork
            begin 
                //Read registers from bottoom to top
                for (int i=0; i<NUM_REGISTERS; i++) begin
                    @(cb);
                    read_register(
                        .port_1(1),
                        .addr(i),
                        .data(data1)
                    );
                end
            end
            begin
                //Read registers from top to bottom
                for(int i=NUM_REGISTERS-1; i>=0; i--) begin
                    @(cb);
                    read_register(
                        .port_1(0),
                        .addr(i),
                        .data(data2)
                    );
                end
            end
        join        //join_all
        #100;
    endtask: test

endmodule: register_file_tb