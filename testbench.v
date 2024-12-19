`timescale 1ns / 1ps

module TopModule_tb;

    // 输入信号
    reg clk;
    reg rst;
    reg mode;
    reg signed [7:0] data_in;

    // 输出信号
    wire signed [7:0] data_out;

    integer i, j, k;
    // 实例化被测试模块
    TopModule uut (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .data_in(data_in),
        .data_out(data_out)
    );


    // 时钟生成
    always #5 clk = ~clk;

    initial begin
        // 初始化信号
        clk = 0;
        rst = 1;
        mode = 0;
        data_in = 0;

        // 释放复位信号
        #10;
        rst = 0;

        // 初始化卷积核和全连接层核
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                for (k = 0; k < 3; k = k + 1) begin
                    data_in = i + j + k;
                    #10;
                end
            end
        end

        for (i = 0; i < 27; i = i + 1) begin
            data_in = i + 1;
            #10;
        end
        // 模拟输入数据
        mode = 1; // 切换到数据模式
        rst = 1;
        #10;
        rst = 0;

        for (i = 0; i < 11; i = i + 1) begin
            for(j = 0; j < 12; j = j + 1) begin
                data_in = i + j + 1;
                #10;
            end
        end

        // // 运行仿真一段时间
        #100;

        // 结束仿真
        $finish;
    end

    // 记录输出内容变化
    initial begin
        $monitor("[*] Time: %0t, data_out: %0d, mode: %0d, rst: %0d", $time, data_out, mode, rst);
    end

endmodule