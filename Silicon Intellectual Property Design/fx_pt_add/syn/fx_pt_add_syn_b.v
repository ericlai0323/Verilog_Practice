/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12
// Date      : Thu Dec  8 15:35:59 2022
/////////////////////////////////////////////////////////////


module fx_pt_add ( a, b, sum );
  input [4:0] a;
  input [4:0] b;
  output [10:0] sum;
  wire   n69, n70, n71, n72, n73, n74, n75, n76, n77, n78, n79, n80, n81, n82,
         n83, n84, n85, n86, n87, n88;

  CLKINVX1 U22 ( .A(1'b1), .Y(sum[0]) );
  CLKINVX1 U24 ( .A(1'b1), .Y(sum[1]) );
  CLKINVX1 U26 ( .A(1'b1), .Y(sum[2]) );
  CLKINVX1 U28 ( .A(1'b1), .Y(sum[3]) );
  NAND2XL U34 ( .A(a[0]), .B(b[0]), .Y(n77) );
  NOR2XL U35 ( .A(a[1]), .B(b[1]), .Y(n74) );
  NAND2XL U36 ( .A(a[1]), .B(b[1]), .Y(n75) );
  NAND2XL U37 ( .A(b[2]), .B(a[2]), .Y(n85) );
  OR2X2 U38 ( .A(b[2]), .B(a[2]), .Y(n86) );
  NOR2XL U39 ( .A(a[3]), .B(b[3]), .Y(n80) );
  NAND2XL U40 ( .A(a[3]), .B(b[3]), .Y(n81) );
  AOI21XL U41 ( .A0(n88), .A1(n86), .B0(n69), .Y(n84) );
  INVXL U42 ( .A(n85), .Y(n69) );
  NAND2XL U43 ( .A(n76), .B(n75), .Y(n79) );
  NAND2XL U44 ( .A(n86), .B(n85), .Y(n87) );
  NAND2XL U45 ( .A(n82), .B(n81), .Y(n83) );
  INVXL U46 ( .A(n80), .Y(n82) );
  INVXL U47 ( .A(a[4]), .Y(n73) );
  INVXL U48 ( .A(b[4]), .Y(n72) );
  INVXL U49 ( .A(n70), .Y(sum[9]) );
  INVXL U50 ( .A(n74), .Y(n76) );
  INVXL U51 ( .A(n77), .Y(n78) );
  XNOR2X1 U52 ( .A(n88), .B(n87), .Y(sum[6]) );
  OAI21XL U53 ( .A0(n74), .A1(n77), .B0(n75), .Y(n88) );
  OAI21XL U54 ( .A0(n84), .A1(n80), .B0(n81), .Y(n71) );
  BUFX2 U55 ( .A(sum[9]), .Y(sum[10]) );
  ADDFXL U56 ( .A(n73), .B(n72), .CI(n71), .CO(n70), .S(sum[8]) );
  XNOR2X1 U57 ( .A(n79), .B(n78), .Y(sum[5]) );
  XOR2X1 U58 ( .A(n84), .B(n83), .Y(sum[7]) );
  XOR2X1 U59 ( .A(a[0]), .B(b[0]), .Y(sum[4]) );
endmodule

