/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12
// Date      : Thu Dec  8 16:39:05 2022
/////////////////////////////////////////////////////////////


module fx_pt_add ( a, b, sum );
  input [9:0] a;
  input [9:0] b;
  output [20:0] sum;
  wire   n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76,
         n77;

  CLKINVX1 U50 ( .A(1'b1), .Y(sum[0]) );
  CLKINVX1 U52 ( .A(1'b1), .Y(sum[20]) );
  NOR2BX1 U54 ( .AN(a[9]), .B(n75), .Y(sum[19]) );
  NAND2XL U55 ( .A(n74), .B(a[6]), .Y(n73) );
  NOR2X1 U58 ( .A(n73), .B(n66), .Y(n76) );
  NOR2XL U59 ( .A(b[9]), .B(a[1]), .Y(n63) );
  NAND2XL U60 ( .A(n70), .B(a[2]), .Y(n69) );
  NOR2XL U61 ( .A(n69), .B(n64), .Y(n72) );
  NAND2XL U62 ( .A(n72), .B(a[4]), .Y(n71) );
  INVXL U63 ( .A(a[5]), .Y(n65) );
  NOR2XL U64 ( .A(n71), .B(n65), .Y(n74) );
  INVXL U65 ( .A(a[7]), .Y(n66) );
  NAND2XL U66 ( .A(n76), .B(a[8]), .Y(n75) );
  XOR2X1 U67 ( .A(n68), .B(n77), .Y(sum[10]) );
  XNOR2X1 U68 ( .A(n75), .B(a[9]), .Y(sum[18]) );
  NAND2XL U69 ( .A(a[0]), .B(b[8]), .Y(n67) );
  INVXL U70 ( .A(n67), .Y(n77) );
  INVXL U71 ( .A(a[3]), .Y(n64) );
  BUFX2 U72 ( .A(b[0]), .Y(sum[1]) );
  BUFX2 U73 ( .A(b[5]), .Y(sum[6]) );
  BUFX2 U74 ( .A(b[7]), .Y(sum[8]) );
  BUFX2 U75 ( .A(b[6]), .Y(sum[7]) );
  BUFX2 U76 ( .A(b[4]), .Y(sum[5]) );
  BUFX2 U77 ( .A(b[3]), .Y(sum[4]) );
  BUFX2 U78 ( .A(b[2]), .Y(sum[3]) );
  BUFX2 U79 ( .A(b[1]), .Y(sum[2]) );
  OAI2BB2XL U80 ( .B0(n63), .B1(n67), .A0N(b[9]), .A1N(a[1]), .Y(n70) );
  AOI21XL U81 ( .A0(n69), .A1(n64), .B0(n72), .Y(sum[12]) );
  AOI21XL U82 ( .A0(n71), .A1(n65), .B0(n74), .Y(sum[14]) );
  AOI21XL U83 ( .A0(n73), .A1(n66), .B0(n76), .Y(sum[16]) );
  XOR2X1 U84 ( .A(b[9]), .B(a[1]), .Y(n68) );
  OA21XL U85 ( .A0(a[2]), .A1(n70), .B0(n69), .Y(sum[11]) );
  OA21XL U86 ( .A0(n72), .A1(a[4]), .B0(n71), .Y(sum[13]) );
  OA21XL U87 ( .A0(n74), .A1(a[6]), .B0(n73), .Y(sum[15]) );
  OA21XL U88 ( .A0(n76), .A1(a[8]), .B0(n75), .Y(sum[17]) );
  AOI2BB1X1 U89 ( .A0N(a[0]), .A1N(b[8]), .B0(n77), .Y(sum[9]) );
endmodule

