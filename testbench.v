`timescale 1ns / 1ps

module Top_tb;

    // 输入信号
    reg clk;
    reg rst;
    reg [7:0] data_in[0:10];
    reg [7:0] conv_kernel[0:2][0:2][0:2];
    reg [7:0] fclayer_kernel[0:26];

    // 输出信号
    wire [15:0] fc_out;


    // 实例化被测试模块
    TopModule uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .conv_kernel(conv_kernel),
        .fclayer_kernel(fclayer_kernel),
        .fc_out(fc_out)
    );

    // 时钟生成
    always #5 clk = ~clk;


    // 记录输出内容变化
    initial 
    begin
        $monitor("[*] fc_out: %0h, clk: %0h, rst: %0h", fc_out, clk, rst);
    end


    initial begin
        // 初始化信号
        clk = 0;
        rst = 1;

        // 初始化卷积核
        conv_kernel[0][0][0] = 8'h01; conv_kernel[0][0][1] = 8'h02; conv_kernel[0][0][2] = 8'h03;
        conv_kernel[0][1][0] = 8'h04; conv_kernel[0][1][1] = 8'h05; conv_kernel[0][1][2] = 8'h06;
        conv_kernel[0][2][0] = 8'h07; conv_kernel[0][2][1] = 8'h08; conv_kernel[0][2][2] = 8'h09;

        conv_kernel[1][0][0] = 8'h01; conv_kernel[1][0][1] = 8'h02; conv_kernel[1][0][2] = 8'h03;
        conv_kernel[1][1][0] = 8'h04; conv_kernel[1][1][1] = 8'h05; conv_kernel[1][1][2] = 8'h06;
        conv_kernel[1][2][0] = 8'h07; conv_kernel[1][2][1] = 8'h08; conv_kernel[1][2][2] = 8'h09;

        conv_kernel[2][0][0] = 8'h01; conv_kernel[2][0][1] = 8'h02; conv_kernel[2][0][2] = 8'h03;
        conv_kernel[2][1][0] = 8'h04; conv_kernel[2][1][1] = 8'h05; conv_kernel[2][1][2] = 8'h06;
        conv_kernel[2][2][0] = 8'h07; conv_kernel[2][2][1] = 8'h08; conv_kernel[2][2][2] = 8'h09;

        fclayer_kernel[0] = 8'h01; fclayer_kernel[1] = 8'h02; fclayer_kernel[2] = 8'h01;
        fclayer_kernel[3] = 8'h02; fclayer_kernel[4] = 8'h01; fclayer_kernel[5] = 8'h02;
        fclayer_kernel[6] = 8'h01; fclayer_kernel[7] = 8'h02; fclayer_kernel[8] = 8'h01;
        fclayer_kernel[9] = 8'h02; fclayer_kernel[10] = 8'h01; fclayer_kernel[11] = 8'h02;
        fclayer_kernel[12] = 8'h01; fclayer_kernel[13] = 8'h02; fclayer_kernel[14] = 8'h01;
        fclayer_kernel[15] = 8'h02; fclayer_kernel[16] = 8'h01; fclayer_kernel[17] = 8'h02;
        fclayer_kernel[18] = 8'h01; fclayer_kernel[19] = 8'h02; fclayer_kernel[20] = 8'h01;
        fclayer_kernel[21] = 8'h02; fclayer_kernel[22] = 8'h01; fclayer_kernel[23] = 8'h02;
        fclayer_kernel[24] = 8'h01; fclayer_kernel[25] = 8'h02; fclayer_kernel[26] = 8'h01;


        #10;
        rst = 0;

        // 初始化输入数据
        data_in[0] = 8'h01; data_in[1] = 8'h02; data_in[2] = 8'h03;
        data_in[3] = 8'h04; data_in[4] = 8'h05; data_in[5] = 8'h06;
        data_in[6] = 8'h07; data_in[7] = 8'h08; data_in[8] = 8'h09;
        data_in[9] = 8'h0A; data_in[10] = 8'h0B;

        // 运行仿真一段时间
        #10;
        data_in[0] = 8'h11; data_in[1] = 8'h12; data_in[2] = 8'h13;
        data_in[3] = 8'h14; data_in[4] = 8'h15; data_in[5] = 8'h16;
        data_in[6] = 8'h17; data_in[7] = 8'h18; data_in[8] = 8'h19;
        data_in[9] = 8'h1A; data_in[10] = 8'h1B;

        #10;
        data_in[0] = 8'h21; data_in[1] = 8'h22; data_in[2] = 8'h23;
        data_in[3] = 8'h24; data_in[4] = 8'h25; data_in[5] = 8'h26;
        data_in[6] = 8'h27; data_in[7] = 8'h28; data_in[8] = 8'h29;
        data_in[9] = 8'h2A; data_in[10] = 8'h2B;

        #10;
        data_in[0] = 8'h31; data_in[1] = 8'h32; data_in[2] = 8'h33;
        data_in[3] = 8'h34; data_in[4] = 8'h35; data_in[5] = 8'h36;
        data_in[6] = 8'h37; data_in[7] = 8'h38; data_in[8] = 8'h39;
        data_in[9] = 8'h3A; data_in[10] = 8'h3B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h40; data_in[1] = 8'h42; data_in[2] = 8'h43;
        data_in[3] = 8'h40; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h40; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h40; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h40; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h05; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h40; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h40;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h41; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h40;
        data_in[6] = 8'h47; data_in[7] = 8'h18; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h1B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h22; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h42;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h42;
        data_in[9] = 8'h4A; data_in[10] = 8'h42;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h63;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;
                
        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h47;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;
                
        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h92; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h12; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h57; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h40; data_in[1] = 8'h42; data_in[2] = 8'h43;
        data_in[3] = 8'h40; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h40; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h40; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h40; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h05; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h40; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h40;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h41; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h40;
        data_in[6] = 8'h47; data_in[7] = 8'h18; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h1B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h22; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h42;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h42;
        data_in[9] = 8'h4A; data_in[10] = 8'h42;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h63;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;
                
        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h47;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;
                
        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h92; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h12; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h47; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;

        #10;
        data_in[0] = 8'h41; data_in[1] = 8'h42; data_in[2] = 8'h43;
        data_in[3] = 8'h44; data_in[4] = 8'h45; data_in[5] = 8'h46;
        data_in[6] = 8'h57; data_in[7] = 8'h48; data_in[8] = 8'h49;
        data_in[9] = 8'h4A; data_in[10] = 8'h4B;
        // 运行仿真一段时间
        // #100;

        // 结束仿真
        $finish;
    end


endmodule

// `timescale 1ns / 1ps

// module PoolingLayer_tb;

//     // 输入信号
//     reg clk;
//     reg rst;
//     reg [15:0] data_in_0[0:5];
//     reg [15:0] data_in_1[0:5];
//     reg [15:0] data_in_2[0:5];

//     // 输出信号
//     wire [15:0] poll_out_0[0:2];
//     wire [15:0] poll_out_1[0:2];
//     wire [15:0] poll_out_2[0:2];

//     // 实例化被测试模块
//     PoolingLayer uut (
//         .clk(clk),
//         .rst(rst),
//         .data_in_0(data_in_0),
//         .data_in_1(data_in_1),
//         .data_in_2(data_in_2),
//         .poll_out_0(poll_out_0),
//         .poll_out_1(poll_out_1),
//         .poll_out_2(poll_out_2)
//     );

//     // 时钟生成
//     always #5 clk = ~clk;

//     initial 
//     begin
//         $monitor("poll_out_0: %0h %0h %0h, poll_out_1: %0h %0h %0h, poll_out_2: %0h %0h %0h, clk: %0h, rst: %0h", 
//                  poll_out_0[0], poll_out_0[1], poll_out_0[2],
//                  poll_out_1[0], poll_out_1[1], poll_out_1[2],
//                  poll_out_2[0], poll_out_2[1], poll_out_2[2],
//                  clk, rst
//                  );
//     end     
    

//     initial begin
//         // 初始化信号
//         clk = 0;
//         rst = 1;
//         #10;
//         rst = 0;

//         // 初始化输入数据
//         data_in_0[0] = 16'h0010; data_in_0[1] = 16'h0020; data_in_0[2] = 16'h0030;
//         data_in_0[3] = 16'h0040; data_in_0[4] = 16'h0050; data_in_0[5] = 16'h0060;

//         data_in_1[0] = 16'h0110; data_in_1[1] = 16'h0120; data_in_1[2] = 16'h0130;
//         data_in_1[3] = 16'h0140; data_in_1[4] = 16'h0150; data_in_1[5] = 16'h0160;

//         data_in_2[0] = 16'h0210; data_in_2[1] = 16'h0220; data_in_2[2] = 16'h0230;
//         data_in_2[3] = 16'h0240; data_in_2[4] = 16'h0250; data_in_2[5] = 16'h0260;



//         // 运行仿真一段时间
//         #10;

//         data_in_0[0] = 16'h0011; data_in_0[1] = 16'h0021; data_in_0[2] = 16'h0031;
//         data_in_0[3] = 16'h0041; data_in_0[4] = 16'h0051; data_in_0[5] = 16'h0061;

//         data_in_1[0] = 16'h0111; data_in_1[1] = 16'h0121; data_in_1[2] = 16'h0131;
//         data_in_1[3] = 16'h0141; data_in_1[4] = 16'h0151; data_in_1[5] = 16'h0161;

//         data_in_2[0] = 16'h0211; data_in_2[1] = 16'h0221; data_in_2[2] = 16'h0231;
//         data_in_2[3] = 16'h0241; data_in_2[4] = 16'h0251; data_in_2[5] = 16'h0261;

//         #10;

//         data_in_0[0] = 16'h0012; data_in_0[1] = 16'h0022; data_in_0[2] = 16'h0032;
//         data_in_0[3] = 16'h0042; data_in_0[4] = 16'h0052; data_in_0[5] = 16'h0062;

//         data_in_1[0] = 16'h0112; data_in_1[1] = 16'h0122; data_in_1[2] = 16'h0132;
//         data_in_1[3] = 16'h0142; data_in_1[4] = 16'h0152; data_in_1[5] = 16'h0162;

//         data_in_2[0] = 16'h0212; data_in_2[1] = 16'h0222; data_in_2[2] = 16'h0232;
//         data_in_2[3] = 16'h0242; data_in_2[4] = 16'h0252; data_in_2[5] = 16'h0262;

//         #10;

//         data_in_0[0] = 16'h0013; data_in_0[1] = 16'h0023; data_in_0[2] = 16'h0033;
//         data_in_0[3] = 16'h0043; data_in_0[4] = 16'h0053; data_in_0[5] = 16'h0063;

//         data_in_1[0] = 16'h0113; data_in_1[1] = 16'h0123; data_in_1[2] = 16'h0133;
//         data_in_1[3] = 16'h0143; data_in_1[4] = 16'h0153; data_in_1[5] = 16'h0163;

//         data_in_2[0] = 16'h0213; data_in_2[1] = 16'h0223; data_in_2[2] = 16'h0233;
//         data_in_2[3] = 16'h0243; data_in_2[4] = 16'h0253; data_in_2[5] = 16'h0263;

//         #10;

//         data_in_0[0] = 16'h0014; data_in_0[1] = 16'h0024; data_in_0[2] = 16'h0034;
//         data_in_0[3] = 16'h0044; data_in_0[4] = 16'h0054; data_in_0[5] = 16'h0064;

//         data_in_1[0] = 16'h0114; data_in_1[1] = 16'h0124; data_in_1[2] = 16'h0134;
//         data_in_1[3] = 16'h0144; data_in_1[4] = 16'h0154; data_in_1[5] = 16'h0164;

//         data_in_2[0] = 16'h0214; data_in_2[1] = 16'h0224; data_in_2[2] = 16'h0234;
//         data_in_2[3] = 16'h0244; data_in_2[4] = 16'h0254; data_in_2[5] = 16'h0264;

//         #10;

//                 data_in_0[0] = 16'h0010; data_in_0[1] = 16'h0020; data_in_0[2] = 16'h0030;
//         data_in_0[3] = 16'h0040; data_in_0[4] = 16'h0050; data_in_0[5] = 16'h0060;

//         data_in_1[0] = 16'h0110; data_in_1[1] = 16'h0120; data_in_1[2] = 16'h0130;
//         data_in_1[3] = 16'h0140; data_in_1[4] = 16'h0150; data_in_1[5] = 16'h0160;

//         data_in_2[0] = 16'h0210; data_in_2[1] = 16'h0220; data_in_2[2] = 16'h0230;
//         data_in_2[3] = 16'h0240; data_in_2[4] = 16'h0250; data_in_2[5] = 16'h0260;



//         // 运行仿真一段时间
//         #10;

//         data_in_0[0] = 16'h0011; data_in_0[1] = 16'h0021; data_in_0[2] = 16'h0031;
//         data_in_0[3] = 16'h0041; data_in_0[4] = 16'h0051; data_in_0[5] = 16'h0061;

//         data_in_1[0] = 16'h0111; data_in_1[1] = 16'h0121; data_in_1[2] = 16'h0131;
//         data_in_1[3] = 16'h0141; data_in_1[4] = 16'h0151; data_in_1[5] = 16'h0161;

//         data_in_2[0] = 16'h0211; data_in_2[1] = 16'h0221; data_in_2[2] = 16'h0231;
//         data_in_2[3] = 16'h0241; data_in_2[4] = 16'h0251; data_in_2[5] = 16'h0261;

//         #10;

//         data_in_0[0] = 16'h0012; data_in_0[1] = 16'h0022; data_in_0[2] = 16'h0032;
//         data_in_0[3] = 16'h0042; data_in_0[4] = 16'h0052; data_in_0[5] = 16'h0062;

//         data_in_1[0] = 16'h0112; data_in_1[1] = 16'h0122; data_in_1[2] = 16'h0132;
//         data_in_1[3] = 16'h0142; data_in_1[4] = 16'h0152; data_in_1[5] = 16'h0162;

//         data_in_2[0] = 16'h0212; data_in_2[1] = 16'h0222; data_in_2[2] = 16'h0232;
//         data_in_2[3] = 16'h0242; data_in_2[4] = 16'h0252; data_in_2[5] = 16'h0262;

//         #10;

//         data_in_0[0] = 16'h0013; data_in_0[1] = 16'h0023; data_in_0[2] = 16'h0033;
//         data_in_0[3] = 16'h0043; data_in_0[4] = 16'h0053; data_in_0[5] = 16'h0063;

//         data_in_1[0] = 16'h0113; data_in_1[1] = 16'h0123; data_in_1[2] = 16'h0133;
//         data_in_1[3] = 16'h0143; data_in_1[4] = 16'h0153; data_in_1[5] = 16'h0163;

//         data_in_2[0] = 16'h0213; data_in_2[1] = 16'h0223; data_in_2[2] = 16'h0233;
//         data_in_2[3] = 16'h0243; data_in_2[4] = 16'h0253; data_in_2[5] = 16'h0263;

//         #10;

//         data_in_0[0] = 16'h0014; data_in_0[1] = 16'h0024; data_in_0[2] = 16'h0034;
//         data_in_0[3] = 16'h0044; data_in_0[4] = 16'h0054; data_in_0[5] = 16'h0064;

//         data_in_1[0] = 16'h0114; data_in_1[1] = 16'h0124; data_in_1[2] = 16'h0134;
//         data_in_1[3] = 16'h0144; data_in_1[4] = 16'h0154; data_in_1[5] = 16'h0164;

//         data_in_2[0] = 16'h0214; data_in_2[1] = 16'h0224; data_in_2[2] = 16'h0234;
//         data_in_2[3] = 16'h0244; data_in_2[4] = 16'h0254; data_in_2[5] = 16'h0264;

//         #10;

//         // 结束仿真
//         $finish;
//     end

// endmodule

// `timescale 1ns / 1ps

// module FCLayer_tb;

//     // 输入信号
//     reg clk;
//     reg rst;
//     reg [15:0] data_in_0[0:2];
//     reg [15:0] data_in_1[0:2];
//     reg [15:0] data_in_2[0:2];
//     reg [7:0] fclayer_kernel[0:26];

//     // 输出信号
//     wire [15:0] fc_out;

//     // 实例化被测试模块
//     FCLayer uut (
//         .clk(clk),
//         .rst(rst),
//         .data_in_0(data_in_0),
//         .data_in_1(data_in_1),
//         .data_in_2(data_in_2),
//         .fclayer_kernel(fclayer_kernel),
//         .fc_out(fc_out)
//     );

//     // 时钟生成
//     always #5 clk = ~clk;

//     initial begin
//         $monitor("fc_out: %0h, clk: %0h, rst: %0h", fc_out, clk, rst);
//     end

//     initial begin
//         // 初始化信号
//         clk = 0;
//         rst = 1;
//         // 初始化全连接层核
//         fclayer_kernel[0] = 8'h01; fclayer_kernel[1] = 8'h02; fclayer_kernel[2] = 8'h01;
//         fclayer_kernel[3] = 8'h02; fclayer_kernel[4] = 8'h01; fclayer_kernel[5] = 8'h02;
//         fclayer_kernel[6] = 8'h01; fclayer_kernel[7] = 8'h02; fclayer_kernel[8] = 8'h01;
//         fclayer_kernel[9] = 8'h02; fclayer_kernel[10] = 8'h01; fclayer_kernel[11] = 8'h02;
//         fclayer_kernel[12] = 8'h01; fclayer_kernel[13] = 8'h02; fclayer_kernel[14] = 8'h01;
//         fclayer_kernel[15] = 8'h02; fclayer_kernel[16] = 8'h01; fclayer_kernel[17] = 8'h02;
//         fclayer_kernel[18] = 8'h01; fclayer_kernel[19] = 8'h02; fclayer_kernel[20] = 8'h01;
//         fclayer_kernel[21] = 8'h02; fclayer_kernel[22] = 8'h01; fclayer_kernel[23] = 8'h02;
//         fclayer_kernel[24] = 8'h01; fclayer_kernel[25] = 8'h02; fclayer_kernel[26] = 8'h01;

//         #10;
//         rst = 0;

//         // 初始化输入数据
//         data_in_0[0] = 16'h0010; data_in_0[1] = 16'h0020; data_in_0[2] = 16'h0030;
//         data_in_1[0] = 16'h0110; data_in_1[1] = 16'h0120; data_in_1[2] = 16'h0130;
//         data_in_2[0] = 16'h0210; data_in_2[1] = 16'h0220; data_in_2[2] = 16'h0230;

//         #10;

//         data_in_0[0] = 16'h0011; data_in_0[1] = 16'h0021; data_in_0[2] = 16'h0031;
//         data_in_1[0] = 16'h0111; data_in_1[1] = 16'h0121; data_in_1[2] = 16'h0131;
//         data_in_2[0] = 16'h0211; data_in_2[1] = 16'h0221; data_in_2[2] = 16'h0231;

//         #10;

//         data_in_0[0] = 16'h0012; data_in_0[1] = 16'h0022; data_in_0[2] = 16'h0032;
//         data_in_1[0] = 16'h0112; data_in_1[1] = 16'h0122; data_in_1[2] = 16'h0132;
//         data_in_2[0] = 16'h0212; data_in_2[1] = 16'h0222; data_in_2[2] = 16'h0232;

//         #10;

//         data_in_0[0] = 16'h0013; data_in_0[1] = 16'h0023; data_in_0[2] = 16'h0033;
//         data_in_1[0] = 16'h0113; data_in_1[1] = 16'h0123; data_in_1[2] = 16'h0133;
//         data_in_2[0] = 16'h0213; data_in_2[1] = 16'h0223; data_in_2[2] = 16'h0233;

//         #10;


//         // 结束仿真
//         $finish;
//     end

// endmodule