module heichips25_template (clk,
    ena,
    rst_n,
    ui_in,
    uio_in,
    uio_oe,
    uio_out,
    uo_out);
 input clk;
 input ena;
 input rst_n;
 input [7:0] ui_in;
 input [7:0] uio_in;
 output [7:0] uio_oe;
 output [7:0] uio_out;
 output [7:0] uo_out;

 wire net18;
 wire net19;
 wire net20;
 wire net21;
 wire net22;
 wire net23;
 wire net24;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire net10;
 wire net11;
 wire net12;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;
 wire net1;

 sg13g2_tiehi heichips25_template_18 (.L_HI(net18));
 sg13g2_tiehi heichips25_template_19 (.L_HI(net19));
 sg13g2_tiehi heichips25_template_20 (.L_HI(net20));
 sg13g2_tiehi heichips25_template_21 (.L_HI(net21));
 sg13g2_tiehi heichips25_template_22 (.L_HI(net22));
 sg13g2_tiehi heichips25_template_23 (.L_HI(net23));
 sg13g2_tiehi heichips25_template_24 (.L_HI(net24));
 sg13g2_tielo heichips25_template_2 (.L_LO(net2));
 sg13g2_tielo heichips25_template_3 (.L_LO(net3));
 sg13g2_tielo heichips25_template_4 (.L_LO(net4));
 sg13g2_tielo heichips25_template_5 (.L_LO(net5));
 sg13g2_tielo heichips25_template_6 (.L_LO(net6));
 sg13g2_tielo heichips25_template_7 (.L_LO(net7));
 sg13g2_tielo heichips25_template_8 (.L_LO(net8));
 sg13g2_tielo heichips25_template_9 (.L_LO(net9));
 sg13g2_tielo heichips25_template_10 (.L_LO(net10));
 sg13g2_tielo heichips25_template_11 (.L_LO(net11));
 sg13g2_tielo heichips25_template_12 (.L_LO(net12));
 sg13g2_tielo heichips25_template_13 (.L_LO(net13));
 sg13g2_tielo heichips25_template_14 (.L_LO(net14));
 sg13g2_tielo heichips25_template_15 (.L_LO(net15));
 sg13g2_tielo heichips25_template_16 (.L_LO(net16));
 sg13g2_tiehi heichips25_template_17 (.L_HI(net17));
 sg13g2_tielo heichips25_template_1 (.L_LO(net1));
 assign uio_oe[0] = net17;
 assign uio_oe[1] = net18;
 assign uio_oe[2] = net19;
 assign uio_oe[3] = net20;
 assign uio_oe[4] = net21;
 assign uio_oe[5] = net22;
 assign uio_oe[6] = net23;
 assign uio_oe[7] = net24;
 assign uio_out[0] = net1;
 assign uio_out[1] = net2;
 assign uio_out[2] = net3;
 assign uio_out[3] = net4;
 assign uio_out[4] = net5;
 assign uio_out[5] = net6;
 assign uio_out[6] = net7;
 assign uio_out[7] = net8;
 assign uo_out[0] = net9;
 assign uo_out[1] = net10;
 assign uo_out[2] = net11;
 assign uo_out[3] = net12;
 assign uo_out[4] = net13;
 assign uo_out[5] = net14;
 assign uo_out[6] = net15;
 assign uo_out[7] = net16;
endmodule
