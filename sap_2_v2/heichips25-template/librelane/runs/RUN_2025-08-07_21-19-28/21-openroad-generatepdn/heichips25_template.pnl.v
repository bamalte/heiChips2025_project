module heichips25_template (clk,
    ena,
    rst_n,
    ui_in,
    uio_in,
    uio_oe,
    uio_out,
    uo_out,
    VPWR,
    VGND);
 input clk;
 input ena;
 input rst_n;
 input [7:0] ui_in;
 input [7:0] uio_in;
 output [7:0] uio_oe;
 output [7:0] uio_out;
 output [7:0] uo_out;
 inout VPWR;
 inout VGND;


 sg13g2_tiehi _00_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[0]));
 sg13g2_tiehi _01_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[1]));
 sg13g2_tiehi _02_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[2]));
 sg13g2_tiehi _03_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[3]));
 sg13g2_tiehi _04_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[4]));
 sg13g2_tiehi _05_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[5]));
 sg13g2_tiehi _06_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[6]));
 sg13g2_tiehi _07_ (.VDD(VPWR),
    .VSS(VGND),
    .L_HI(uio_oe[7]));
 sg13g2_tielo _08_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[0]));
 sg13g2_tielo _09_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[1]));
 sg13g2_tielo _10_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[2]));
 sg13g2_tielo _11_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[3]));
 sg13g2_tielo _12_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[4]));
 sg13g2_tielo _13_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[5]));
 sg13g2_tielo _14_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[6]));
 sg13g2_tielo _15_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uio_out[7]));
 sg13g2_tielo _16_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[0]));
 sg13g2_tielo _17_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[1]));
 sg13g2_tielo _18_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[2]));
 sg13g2_tielo _19_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[3]));
 sg13g2_tielo _20_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[4]));
 sg13g2_tielo _21_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[5]));
 sg13g2_tielo _22_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[6]));
 sg13g2_tielo _23_ (.VDD(VPWR),
    .VSS(VGND),
    .L_LO(uo_out[7]));
endmodule
