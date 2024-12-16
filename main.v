reg signed [7:0] conv_kernel[0:2][0:2][0:2]; //卷积核
reg signed [7:0] fclayer_kernel[0:26]; //全连接层核

module TopModule(
    input wire clk,
    input wire rst,
    input wire signed [7:0] data_in[0:10],    // 输入数据 (8位*11) 行
    input wire signed [7:0] conv_kernel[0:2][0:2][0:2], // 卷积核
    input wire signed [7:0] fclayer_kernel[0:26], // 全连接层核
    output wire signed [15:0] fc_out    // 输出数据 (16位)
);

    wire signed [15:0] conv_out_0[0:5];
    wire signed [15:0] conv_out_1[0:5];
    wire signed [15:0] conv_out_2[0:5];
    wire signed [15:0] poll_out_0[0:2];
    wire signed [15:0] poll_out_1[0:2];
    wire signed [15:0] poll_out_2[0:2];

    reg clk_div2;           // 二分频输出
    reg clk_div4;           // 四分频输出
    reg [1:0] counter2;      // 二分频计数器
    reg [2:0] counter4;      // 四分频计数器

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter2 = 2'b00;
            counter4 = 3'b000;
            clk_div2 = 0;
            clk_div4 = 0;
        end else begin
            // 二分频计数
            if (counter2 == 2'b01) begin
                clk_div2 = ~clk_div2; // 切换输出
                counter2 = 2'b00;     // 重置计数器
            end else begin
                counter2 = counter2 + 1;
            end

            // 四分频计数
            if (counter4 == 3'b011) begin
                clk_div4 = ~clk_div4; // 切换输出
                counter4 = 3'b000;    // 重置计数器
            end else begin
                counter4 = counter4 + 1;
            end
        end
    end


    // 实例化卷积层
    ConvLayer conv_layer (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .conv_kernel(conv_kernel),
        .conv_out_0(conv_out_0),
        .conv_out_1(conv_out_1),
        .conv_out_2(conv_out_2)
    );

    // 实例化池化层
    PoolingLayer pooling_layer (
        .clk(clk_div2),
        .rst(rst),
        .data_in_0(conv_out_0),
        .data_in_1(conv_out_1),
        .data_in_2(conv_out_2),
        .poll_out_0(poll_out_0),
        .poll_out_1(poll_out_1),
        .poll_out_2(poll_out_2)
    );

    // 实例化全连接层
    FCLayer fc_layer (
        .clk(clk_div4),
        .rst(rst),
        .data_in_0(poll_out_0),
        .data_in_1(poll_out_1),
        .data_in_2(poll_out_2),
        .fclayer_kernel(fclayer_kernel),
        .fc_out(fc_out)
    );

endmodule

module ConvLayer(
    input wire clk,
    input wire rst,
    input wire signed [7:0] data_in[0:10],    // 输入数据 (8位*11) 行
    input wire signed [7:0] conv_kernel[0:2][0:2][0:2], // 卷积核
    output reg signed [7:0] conv_out_0[0:5],    // 卷积结果 (16位*6) 行，分别对应三种卷积核的输出
    output reg signed [7:0] conv_out_1[0:5],
    output reg signed [7:0] conv_out_2[0:5]
);

    reg signed [7:0] data_buf_0[0:12];     // 当前行数据
    reg signed [7:0] data_buf_1[0:12];     // 上一行数据
    reg signed [7:0] data_buf_2[0:12];     // 上两行数据
    reg signed [20:0] sum_0[0:5];                 // 累加结果 (16位*6)
    reg signed [20:0] sum_1[0:5];                 // 累加结果 (16位*6)
    reg signed [20:0] sum_2[0:5];                 // 累加结果 (16位*6)
    integer i, j;
    integer cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt = 0;
            for (i = 0; i < 13; i = i + 1) begin
                data_buf_0[i] = 0;
                data_buf_1[i] = 0;
                data_buf_2[i] = 0;
            end
            for (i = 0; i < 6; i = i + 1) begin
                conv_out_0[i] = 0;
                conv_out_1[i] = 0;
                conv_out_2[i] = 0;
            end
        end else begin

            cnt = cnt + 1;

            for (i = 0; i < 13; i = i + 1) begin
                data_buf_2[i] = data_buf_1[i];
                data_buf_1[i] = data_buf_0[i];
            end

            for (i = 0; i < 11; i = i + 1) begin
                data_buf_0[i + 1] = data_in[i];
            end
            
            data_buf_0[0] = 0;     // padding
            data_buf_0[12] = 0;

            if (cnt > 1 && cnt <= 12) begin
                for (i = 0; i < 6; i = i + 1) begin // init sum
                    sum_0[i] = 0;
                    sum_1[i] = 0;
                    sum_2[i] = 0;
                end

                // 卷积运算
                for (i = 0; i < 6; i = i + 1) begin
                    for (j = 0; j < 3; j = j + 1) begin
                        sum_0[i] = sum_0[i] + data_buf_0[i * 2 + j] * conv_kernel[0][2][j];
                        sum_0[i] = sum_0[i] + data_buf_1[i * 2 + j] * conv_kernel[0][1][j];
                        sum_0[i] = sum_0[i] + data_buf_2[i * 2 + j] * conv_kernel[0][0][j];

                        sum_1[i] = sum_1[i] + data_buf_0[i * 2 + j] * conv_kernel[1][2][j];
                        sum_1[i] = sum_1[i] + data_buf_1[i * 2 + j] * conv_kernel[1][1][j];
                        sum_1[i] = sum_1[i] + data_buf_2[i * 2 + j] * conv_kernel[1][0][j];

                        sum_2[i] = sum_2[i] + data_buf_0[i * 2 + j] * conv_kernel[2][2][j];
                        sum_2[i] = sum_2[i] + data_buf_1[i * 2 + j] * conv_kernel[2][1][j];
                        sum_2[i] = sum_2[i] + data_buf_2[i * 2 + j] * conv_kernel[2][0][j];
                    end
                end

                conv_out_0 = sum_0;
                conv_out_1 = sum_1;
                conv_out_2 = sum_2;

            end else begin
                for (i = 0; i < 6; i = i + 1) begin
                    conv_out_0[i] = 0;
                    conv_out_1[i] = 0;
                    conv_out_2[i] = 0;
                end
            end
        end
    end
endmodule

// 由于卷积层步长为2，池化层的clk频率为卷积层的一半
module PoolingLayer(
    input wire clk,
    input wire rst,
    input wire signed [15:0] data_in_0[0:5],    // 输入数据 (16位*6) 行，分别对应三种卷积核的输入
    input wire signed [15:0] data_in_1[0:5],
    input wire signed [15:0] data_in_2[0:5],
    output reg signed [15:0] poll_out_0[0:2],    // 输出数据 (16位*3) 行，分别对应三种卷积核的输入
    output reg signed [15:0] poll_out_1[0:2],
    output reg signed [15:0] poll_out_2[0:2]
);
    reg signed [15:0] data_buf_0[0:3];     // data_in_0 缓存
    reg signed [15:0] data_buf_1[0:3];     // data_in_1 缓存
    reg signed [15:0] data_buf_2[0:3];     // data_in_2 缓存

    integer i;
    integer cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < 6; i = i + 1) begin
                data_buf_0[i] = 0;
                data_buf_1[i] = 0;
                data_buf_2[i] = 0;
            end

            for (i = 0; i < 3; i = i + 1) begin
                poll_out_0[i] = 0;
                poll_out_1[i] = 0;
                poll_out_2[i] = 0;
            end
            cnt = 0;

        end else begin

            cnt = cnt + 1;
            if (cnt > 1 && cnt <= 6) begin

                for (i = 0; i < 3; i = i + 1) begin
                    poll_out_0[i] = data_in_0[i * 2] > data_in_0[i * 2 + 1] ? data_in_0[i * 2] : data_in_0[i * 2 + 1];
                    poll_out_0[i] = poll_out_0[i] > data_buf_0[i] ? poll_out_0[i] : data_buf_0[i];

                    poll_out_1[i] = data_in_1[i * 2] > data_in_1[i * 2 + 1] ? data_in_1[i * 2] : data_in_1[i * 2 + 1];
                    poll_out_1[i] = poll_out_1[i] > data_buf_1[i] ? poll_out_1[i] : data_buf_1[i];

                    poll_out_2[i] = data_in_2[i * 2] > data_in_2[i * 2 + 1] ? data_in_2[i * 2] : data_in_2[i * 2 + 1];
                    poll_out_2[i] = poll_out_2[i] > data_buf_2[i] ? poll_out_2[i] : data_buf_2[i];

                end
            end else begin
                for (i = 0; i < 3; i = i + 1) begin
                    poll_out_0[i] = 0;
                    poll_out_1[i] = 0;
                    poll_out_2[i] = 0;
                end
            end

            for (i = 0; i < 3; i = i + 1) begin
                data_buf_0[i] = data_in_0[i * 2] > data_in_0[i * 2 + 1] ? data_in_0[i * 2] : data_in_0[i * 2 + 1];
                data_buf_1[i] = data_in_1[i * 2] > data_in_1[i * 2 + 1] ? data_in_1[i * 2] : data_in_1[i * 2 + 1];
                data_buf_2[i] = data_in_2[i * 2] > data_in_2[i * 2 + 1] ? data_in_2[i * 2] : data_in_2[i * 2 + 1];
            end
        end
    end

endmodule

// 由于池化层步长为2，全连接层的clk频率为池化层的一半
module FCLayer(
    input wire clk,
    input wire rst,
    input wire signed [15:0] data_in_0[0:2],    // 输入数据 (16位*3) 行，分别对应三种卷积核的输入
    input wire signed [15:0] data_in_1[0:2],
    input wire signed [15:0] data_in_2[0:2],
    input wire signed [7:0] fclayer_kernel[0:26], // 全连接层核
    output reg signed [15:0] fc_out    // 输出数据 (8位*3) 行
);

    integer i;
    integer cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin

            fc_out = 0;
            cnt = 0;

        end else begin

            if (cnt < 3) begin
                for (i = 0; i < 3; i = i + 1) begin
                    fc_out = fc_out + data_in_0[i] * fclayer_kernel[cnt * 3 + i];
                    fc_out = fc_out + data_in_1[i] * fclayer_kernel[cnt * 3 + i + 9];
                    fc_out = fc_out + data_in_2[i] * fclayer_kernel[cnt * 3 + i + 18];
                end
            end
            cnt = cnt + 1;
        
        end
    end
endmodule
