reg signed [7:0] conv_kernel[0:2][0:2][0:2]; //卷积核
reg signed [7:0] fclayer_kernel[0:26]; //全连接层核

module TopModule(
    input wire clk,
    input wire rst,
    input wire mode,    // 0: weight, 1: data
    input wire signed [7:0] data_in,
    output wire signed [7:0] data_out
);
    reg clk_div11;      // 11分频计数器
    reg signed [7:0] conv_kernel[0:2][0:2][0:2]; // 卷积核
    reg signed [7:0] fclayer_kernel[0:26]; // 全连接层核
    reg signed [7:0] data_row[0:10]; // 输入数据 (8位*11) 行

    InputModule input_module (
        .clk(clk),
        .rst(rst),
        .mode(mode),
        .data_in(data_in),
        .data_out(data_row),
        .conv_kernel(conv_kernel),
        .fclayer_kernel(fclayer_kernel)
    );

    Cnt_div_11 cnt_div_11 (
        .clk(clk),
        .rst(rst),
        .clk_div11(clk_div11)
    );

    CalcModule calc_module (
        .clk(clk_div11),
        .rst(rst),
        .data_in(data_row),
        .conv_kernel(conv_kernel),
        .fclayer_kernel(fclayer_kernel),
        .fc_out(data_out)
    );

endmodule

module InputModule(
    input wire clk,
    input wire rst,
    input wire mode,    // 0: weight, 1: data
    input wire signed [7:0] data_in,
    output reg signed [7:0] data_out[0:10],
    output reg signed [7:0] conv_kernel[0:2][0:2][0:2],
    output reg signed [7:0] fclayer_kernel[0:26]
);

    reg signed [7:0] data_buf[0:10];
    integer cnt_0, cnt_1, i, j, k;

    always @(posedge clk or posedge rst) begin
        if (rst && (mode == 0)) begin
            //clean conv_kernel and fclayer_kernel
            for (i = 0; i < 3; i = i + 1) begin
                for (j = 0; j < 3; j = j + 1) begin
                    for (k = 0; k < 3; k = k + 1) begin
                        conv_kernel[i][j][k] = 0;
                    end
                end
            end

            for (i = 0; i < 27; i = i + 1) begin
                fclayer_kernel[i] = 0;
            end

            cnt_0 = 0;
        end else if (rst && (mode == 1)) begin
            cnt_1 = 0;
        end else begin
            if (mode == 0) begin
                //weight mode
                if (cnt_0 < 27) begin
                    conv_kernel[(cnt_0/9)%3][(cnt_0/3)%3][cnt_0%3] = data_in;
                end else if (cnt_0 < 54) begin
                    fclayer_kernel[cnt_0-27] = data_in;
                end
                cnt_0 = cnt_0 + 1;
            end else begin
                //data mode
                data_out[cnt_1%11] = data_in;
                // if (cnt_1%11 == 0) begin
                //     data_out = data_buf;
                // end
                cnt_1 = cnt_1 + 1;
            end

        end

    end

endmodule

module Cnt_div_11
#(
    parameter DIV_CLK = 11
)
(
    input wire clk,
    input wire rst,
    output reg clk_div11
);

    reg [3:0] cnt;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 4'b0000;
        end else if (cnt == DIV_CLK - 1) begin
            cnt <= 4'b0000;
        end else begin
            cnt <= cnt + 1;
        end
    end

    reg clkp_div11;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            clkp_div11 <= 1;
        end else if (cnt == (DIV_CLK >> 1) - 1) begin
            clkp_div11 <= 0;
        end else if (cnt == (DIV_CLK - 1)) begin
            clkp_div11 <= 1;
        end
    end

    reg clkn_div11;
    always @(negedge clk or posedge rst) begin
        if (rst) begin
            clkn_div11 <= 1;
        end else if (cnt == (DIV_CLK >> 1) - 1) begin
            clkn_div11 <= 0;
        end else if (cnt == (DIV_CLK - 1)) begin
            clkn_div11 <= 1;
        end
    end

    assign clk_div11 = clkp_div11 | clkn_div11;

endmodule

module CalcModule(
    input wire clk,
    input wire rst,
    input wire signed [7:0] data_in[0:10],    // 输入数据 (8位*11) 行
    input wire signed [7:0] conv_kernel[0:2][0:2][0:2], // 卷积核
    input wire signed [7:0] fclayer_kernel[0:26], // 全连接层核
    output wire signed [7:0] fc_out    // 输出数据 (8位)
);

    wire signed [7:0] conv_out_0[0:5];
    wire signed [7:0] conv_out_1[0:5];
    wire signed [7:0] conv_out_2[0:5];
    wire signed [7:0] poll_out_0[0:2];
    wire signed [7:0] poll_out_1[0:2];
    wire signed [7:0] poll_out_2[0:2];

    reg clk_div2;           // 二分频输出
    reg clk_div4;           // 四分频输出
    reg [1:0] counter2;      // 二分频计数器
    reg [1:0] counter4;      // 四分频计数器

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter4 = 2'b01;
            clk_div2 = 0;
            clk_div4 = 0;
        end else begin
            // 二分频计数
            clk_div2 = ~clk_div2; // 切换输出

            // 四分频计数
            if (counter4 == 2'b01) begin
                clk_div4 = ~clk_div4; // 切换输出
                counter4 = 2'b00;    // 重置计数器
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
    reg signed [19:0] sum_0[0:5];                 // 累加结果 (20位*6)
    reg signed [19:0] sum_1[0:5];                 // 累加结果 (20位*6)
    reg signed [19:0] sum_2[0:5];                 // 累加结果 (20位*6)
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

                for (i = 0; i < 6; i = i + 1) begin
                    conv_out_0[i] = ($signed(sum_0[i][19:8]) > 127) ? 127 : ($signed(sum_0[i][19:8]) < -128) ? -128 : sum_0[i][15:8];
                    conv_out_1[i] = ($signed(sum_1[i][19:8]) > 127) ? 127 : ($signed(sum_1[i][19:8]) < -128) ? -128 : sum_1[i][15:8];
                    conv_out_2[i] = ($signed(sum_2[i][19:8]) > 127) ? 127 : ($signed(sum_2[i][19:8]) < -128) ? -128 : sum_2[i][15:8];
                end

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
    input wire signed [7:0] data_in_0[0:5],    // 输入数据 (16位*6) 行，分别对应三种卷积核的输入
    input wire signed [7:0] data_in_1[0:5],
    input wire signed [7:0] data_in_2[0:5],
    output reg signed [7:0] poll_out_0[0:2],    // 输出数据 (16位*3) 行，分别对应三种卷积核的输入
    output reg signed [7:0] poll_out_1[0:2],
    output reg signed [7:0] poll_out_2[0:2]
);
    reg signed [7:0] data_buf_0[0:3];     // data_in_0 缓存
    reg signed [7:0] data_buf_1[0:3];     // data_in_1 缓存
    reg signed [7:0] data_buf_2[0:3];     // data_in_2 缓存

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
    input wire signed [7:0] data_in_0[0:2],    // 输入数据 (8位*3) 行，分别对应三种卷积核的输入
    input wire signed [7:0] data_in_1[0:2],
    input wire signed [7:0] data_in_2[0:2],
    input wire signed [7:0] fclayer_kernel[0:26], // 全连接层核
    output reg signed [7:0] fc_out    // 输出数据
);

    integer i;
    integer cnt;
    reg signed [20:0] fc_out_buf;   // 输出缓存 21位

    always @(posedge clk or posedge rst) begin
        if (rst) begin

            fc_out_buf = 0;
            cnt = 0;

        end else begin

            if (cnt < 3) begin
                for (i = 0; i < 3; i = i + 1) begin
                    fc_out_buf = fc_out_buf + data_in_0[i] * fclayer_kernel[cnt * 3 + i];
                    fc_out_buf = fc_out_buf + data_in_1[i] * fclayer_kernel[cnt * 3 + i + 9];
                    fc_out_buf = fc_out_buf + data_in_2[i] * fclayer_kernel[cnt * 3 + i + 18];
                end
            end
            cnt = cnt + 1;
        
        end
        fc_out = ($signed(fc_out_buf[20:8]) > 127) ? 127 : ($signed(fc_out_buf[20:8]) < -128) ? -128 : fc_out_buf[15:8];
    end
endmodule
