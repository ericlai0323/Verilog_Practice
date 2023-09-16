/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : Q-2019.12
// Date      : Thu Dec  8 14:59:14 2022
/////////////////////////////////////////////////////////////


module fx_pt_add ( a, b, sum );
  input [13:0] a;
  input [13:0] b;
  output [28:0] sum;
  wire   n763, n764, n765, n766, n767, n768, n769, n770, n771, n772, n773,
         n774, n775, n776, n777, n778, n779, n780, n781, n782, n783, n784,
         n785, n786, n787, n788, n789, n790, n791, n792, n793, n794, n795,
         n796, n797, n798, n799, n800, n801, n802, n803, n804, n805, n806,
         n807, n808, n809, n810, n811, n812, n813, n814, n815, n816, n817,
         n818, n819, n820, n821, n822, n823, n824, n825, n826, n827, n828,
         n829, n830, n831, n832, n833, n834, n835, n836, n837, n838, n839,
         n840, n841, n842, n843, n844, n845, n846, n847, n848, n849, n850,
         n851, n852, n853, n854, n855, n856, n857, n858, n859, n860, n861,
         n862, n863, n864, n865, n866, n867, n868, n869, n870, n871, n872,
         n873, n874, n875, n876, n877, n878, n879, n880, n881, n882, n883,
         n884, n885, n886, n887, n888, n889, n890, n891, n892, n893, n894,
         n895, n896, n897, n898, n899, n900, n901, n902, n903, n904, n905,
         n906, n907, n908, n909, n910, n911, n912, n913, n914, n915, n916,
         n917, n918, n919, n920, n921, n922, n923, n924, n925, n926, n927,
         n928, n929, n930, n931, n932, n933, n934, n935, n936, n937, n938,
         n939, n940, n941, n942, n943, n944, n945, n946, n947, n948, n949,
         n950, n951, n952, n953, n954, n955, n956, n957, n958, n959, n960,
         n961, n962, n963, n964, n965, n966, n967;

  OAI31XL U405 ( .A0(n763), .A1(a[12]), .A2(n888), .B0(n886), .Y(sum[20]) );
  AOI222XL U406 ( .A0(n958), .A1(n791), .B0(n790), .B1(n915), .C0(n789), .C1(
        n961), .Y(n794) );
  NAND2X4 U407 ( .A(n788), .B(n763), .Y(n963) );
  AOI21X1 U408 ( .A0(n921), .A1(n861), .B0(n839), .Y(n943) );
  NAND2X1 U409 ( .A(n766), .B(n848), .Y(n792) );
  NAND2X1 U410 ( .A(a[0]), .B(b[1]), .Y(n807) );
  CLKINVX1 U411 ( .A(a[2]), .Y(n768) );
  NAND2X1 U412 ( .A(n847), .B(n889), .Y(n766) );
  CLKINVX1 U413 ( .A(b[0]), .Y(n889) );
  CLKINVX1 U414 ( .A(1'b1), .Y(sum[0]) );
  CLKINVX1 U416 ( .A(1'b1), .Y(sum[1]) );
  CLKINVX1 U418 ( .A(1'b1), .Y(sum[2]) );
  CLKINVX1 U420 ( .A(1'b1), .Y(sum[3]) );
  CLKINVX1 U422 ( .A(1'b1), .Y(sum[4]) );
  CLKINVX1 U424 ( .A(1'b1), .Y(sum[5]) );
  CLKINVX1 U426 ( .A(1'b1), .Y(sum[6]) );
  CLKINVX1 U428 ( .A(1'b1), .Y(sum[22]) );
  CLKINVX1 U430 ( .A(1'b1), .Y(sum[23]) );
  CLKINVX1 U432 ( .A(1'b1), .Y(sum[24]) );
  CLKINVX1 U434 ( .A(1'b1), .Y(sum[25]) );
  CLKINVX1 U436 ( .A(1'b1), .Y(sum[26]) );
  CLKINVX1 U438 ( .A(1'b1), .Y(sum[27]) );
  NAND2XL U440 ( .A(a[1]), .B(b[2]), .Y(n806) );
  INVXL U441 ( .A(n860), .Y(n839) );
  INVXL U442 ( .A(n804), .Y(n858) );
  NAND2X1 U443 ( .A(n764), .B(b[1]), .Y(n847) );
  NAND2XL U444 ( .A(n809), .B(b[2]), .Y(n797) );
  NAND2XL U445 ( .A(n819), .B(b[7]), .Y(n840) );
  NAND2XL U446 ( .A(n848), .B(n847), .Y(n890) );
  NAND2XL U447 ( .A(n866), .B(n840), .Y(n947) );
  AO21X1 U448 ( .A0(n956), .A1(n955), .B0(n954), .Y(sum[16]) );
  INVX3 U449 ( .A(n963), .Y(n915) );
  INVX1 U450 ( .A(n799), .Y(n845) );
  INVX1 U451 ( .A(b[1]), .Y(n765) );
  CLKXOR2X4 U452 ( .A(b[13]), .B(a[13]), .Y(n763) );
  NOR2X1 U453 ( .A(n963), .B(n889), .Y(n891) );
  OAI21X1 U454 ( .A0(n884), .A1(n763), .B0(n883), .Y(n885) );
  NAND2X1 U455 ( .A(n936), .B(n845), .Y(n800) );
  NAND3XL U456 ( .A(n775), .B(n866), .C(n860), .Y(n776) );
  NAND2X1 U457 ( .A(n798), .B(n797), .Y(n936) );
  NAND2X1 U458 ( .A(n796), .B(n797), .Y(n849) );
  CLKINVX1 U459 ( .A(n763), .Y(n958) );
  CLKINVX1 U460 ( .A(a[11]), .Y(n878) );
  INVX1 U461 ( .A(b[8]), .Y(n782) );
  AO21XL U462 ( .A0(n911), .A1(n910), .B0(n909), .Y(sum[11]) );
  NAND2XL U463 ( .A(n826), .B(n827), .Y(n830) );
  OAI22X1 U464 ( .A0(n825), .A1(n957), .B0(n763), .B1(n881), .Y(n826) );
  INVX3 U465 ( .A(n876), .Y(n788) );
  INVX1 U466 ( .A(n884), .Y(n888) );
  NAND2XL U467 ( .A(n882), .B(n763), .Y(n883) );
  AOI21X1 U468 ( .A0(n960), .A1(n853), .B0(n854), .Y(n913) );
  NOR2X1 U469 ( .A(n851), .B(n850), .Y(n911) );
  NOR2X1 U470 ( .A(n855), .B(n854), .Y(n967) );
  INVX1 U471 ( .A(n801), .Y(n851) );
  NAND2X1 U472 ( .A(n870), .B(n869), .Y(n932) );
  NAND2X1 U473 ( .A(n848), .B(n796), .Y(n798) );
  NOR2X1 U474 ( .A(n785), .B(a[9]), .Y(n854) );
  NOR2X1 U475 ( .A(n784), .B(b[9]), .Y(n804) );
  NOR2X1 U476 ( .A(n772), .B(b[4]), .Y(n850) );
  NOR2X1 U477 ( .A(n786), .B(b[11]), .Y(n831) );
  NAND2X1 U478 ( .A(n786), .B(b[11]), .Y(n832) );
  NAND2X1 U479 ( .A(n782), .B(a[7]), .Y(n870) );
  NAND2X1 U480 ( .A(n780), .B(b[8]), .Y(n869) );
  NAND2X2 U481 ( .A(n765), .B(a[0]), .Y(n848) );
  NOR2X1 U482 ( .A(n879), .B(a[11]), .Y(n787) );
  NAND2X1 U483 ( .A(n785), .B(a[9]), .Y(n853) );
  NAND2X1 U484 ( .A(n784), .B(b[9]), .Y(n857) );
  INVX1 U485 ( .A(b[10]), .Y(n785) );
  INVX1 U486 ( .A(a[8]), .Y(n784) );
  INVX1 U487 ( .A(a[10]), .Y(n786) );
  INVX1 U488 ( .A(a[6]), .Y(n819) );
  INVX1 U489 ( .A(b[7]), .Y(n818) );
  INVX1 U490 ( .A(b[12]), .Y(n879) );
  INVX1 U491 ( .A(a[3]), .Y(n772) );
  NOR2X6 U505 ( .A(n882), .B(a[12]), .Y(n876) );
  NAND2X1 U506 ( .A(n800), .B(n844), .Y(n906) );
  AOI21X1 U507 ( .A0(n943), .A1(n866), .B0(n867), .Y(n928) );
  NAND2X1 U508 ( .A(n818), .B(a[6]), .Y(n866) );
  AOI22X1 U509 ( .A0(n906), .A1(n961), .B0(n905), .B1(n958), .Y(n908) );
  MXI2XL U510 ( .A(n794), .B(n793), .S0(n849), .Y(sum[9]) );
  OAI22X1 U511 ( .A0(n920), .A1(n817), .B0(b[6]), .B1(a[5]), .Y(n942) );
  OAI22X2 U512 ( .A0(n927), .A1(n821), .B0(b[8]), .B1(a[7]), .Y(n950) );
  OA21X4 U513 ( .A0(n899), .A1(n841), .B0(n802), .Y(n921) );
  OAI21X1 U514 ( .A0(n906), .A1(n851), .B0(n838), .Y(n899) );
  NAND2X2 U515 ( .A(n783), .B(n870), .Y(n859) );
  NAND2XL U516 ( .A(n777), .B(n801), .Y(n779) );
  NAND2X2 U517 ( .A(n767), .B(n796), .Y(n846) );
  NAND2XL U518 ( .A(n792), .B(n797), .Y(n767) );
  OAI21XL U519 ( .A0(n837), .A1(n851), .B0(n838), .Y(n843) );
  AOI21XL U520 ( .A0(n862), .A1(n861), .B0(n839), .Y(n868) );
  NAND2XL U521 ( .A(n845), .B(n844), .Y(n934) );
  NOR2XL U522 ( .A(n842), .B(n841), .Y(n897) );
  NAND2XL U523 ( .A(n892), .B(n896), .Y(n815) );
  NOR2XL U524 ( .A(n895), .B(n813), .Y(n814) );
  AND2X1 U525 ( .A(a[7]), .B(b[8]), .Y(n821) );
  NAND2XL U526 ( .A(n858), .B(n857), .Y(n949) );
  INVXL U527 ( .A(n853), .Y(n855) );
  AOI2BB2X2 U528 ( .B0(b[9]), .B1(a[8]), .A0N(n950), .A1N(n822), .Y(n959) );
  NOR2XL U529 ( .A(a[8]), .B(b[9]), .Y(n822) );
  INVXL U530 ( .A(n918), .Y(n836) );
  INVX3 U531 ( .A(n957), .Y(n961) );
  INVXL U532 ( .A(n850), .Y(n838) );
  NAND2XL U533 ( .A(b[4]), .B(a[3]), .Y(n896) );
  INVXL U534 ( .A(a[4]), .Y(n773) );
  NOR2X1 U535 ( .A(n770), .B(a[4]), .Y(n842) );
  INVXL U536 ( .A(b[5]), .Y(n770) );
  NAND2X1 U537 ( .A(n769), .B(b[6]), .Y(n861) );
  INVXL U538 ( .A(a[5]), .Y(n769) );
  INVXL U539 ( .A(a[7]), .Y(n780) );
  INVXL U540 ( .A(n792), .Y(n790) );
  INVXL U541 ( .A(n848), .Y(n789) );
  NAND2XL U542 ( .A(n811), .B(n810), .Y(n935) );
  NAND2XL U543 ( .A(n807), .B(n806), .Y(n811) );
  NAND2XL U544 ( .A(n809), .B(n808), .Y(n810) );
  AOI22XL U545 ( .A0(n961), .A1(n936), .B0(n958), .B1(n935), .Y(n938) );
  NOR2XL U546 ( .A(n894), .B(n893), .Y(n905) );
  INVXL U547 ( .A(n892), .Y(n893) );
  AOI21XL U548 ( .A0(n905), .A1(n896), .B0(n895), .Y(n898) );
  INVXL U549 ( .A(n842), .Y(n802) );
  OAI22X1 U550 ( .A0(n942), .A1(n820), .B0(n819), .B1(n818), .Y(n927) );
  NOR2XL U551 ( .A(b[7]), .B(a[6]), .Y(n820) );
  OAI21X1 U552 ( .A0(n928), .A1(n803), .B0(n869), .Y(n951) );
  INVXL U553 ( .A(n870), .Y(n803) );
  AOI22XL U554 ( .A0(n951), .A1(n961), .B0(n958), .B1(n950), .Y(n953) );
  INVXL U555 ( .A(n831), .Y(n833) );
  NAND2XL U556 ( .A(a[9]), .B(b[10]), .Y(n823) );
  NOR2XL U557 ( .A(n879), .B(n878), .Y(n880) );
  NOR3XL U558 ( .A(n914), .B(n865), .C(n864), .Y(n873) );
  INVXL U559 ( .A(n944), .Y(n865) );
  NAND4XL U560 ( .A(n900), .B(n937), .C(n852), .D(n907), .Y(n863) );
  NOR2X1 U561 ( .A(n768), .B(b[3]), .Y(n799) );
  INVXL U562 ( .A(n861), .Y(n771) );
  NAND2XL U563 ( .A(n772), .B(b[4]), .Y(n801) );
  NAND2XL U564 ( .A(n774), .B(a[5]), .Y(n860) );
  INVXL U565 ( .A(b[6]), .Y(n774) );
  NAND2XL U566 ( .A(b[3]), .B(a[2]), .Y(n892) );
  NOR2XL U567 ( .A(a[2]), .B(b[3]), .Y(n812) );
  INVXL U568 ( .A(n840), .Y(n867) );
  NOR4XL U569 ( .A(n849), .B(n890), .C(a[12]), .D(b[0]), .Y(n852) );
  INVXL U570 ( .A(n807), .Y(n791) );
  OAI22XL U571 ( .A0(n938), .A1(n941), .B0(n937), .B1(n963), .Y(n939) );
  INVXL U572 ( .A(n934), .Y(n941) );
  INVXL U573 ( .A(n897), .Y(n903) );
  AOI2BB2X1 U574 ( .B0(n945), .B1(n947), .A0N(n944), .A1N(n963), .Y(n946) );
  OAI22XL U575 ( .A0(n953), .A1(n956), .B0(n952), .B1(n963), .Y(n954) );
  INVXL U576 ( .A(n949), .Y(n956) );
  OAI22XL U577 ( .A0(n964), .A1(n967), .B0(n963), .B1(n962), .Y(n965) );
  AOI22XL U578 ( .A0(n961), .A1(n960), .B0(n959), .B1(n958), .Y(n964) );
  AOI22XL U579 ( .A0(n961), .A1(n913), .B0(n912), .B1(n958), .Y(n919) );
  AOI22XL U580 ( .A0(n916), .A1(n918), .B0(n915), .B1(n914), .Y(n917) );
  INVXL U581 ( .A(a[12]), .Y(n887) );
  INVXL U582 ( .A(a[13]), .Y(n875) );
  AND3X1 U583 ( .A(n873), .B(n929), .C(n872), .Y(n877) );
  NOR2XL U584 ( .A(a[4]), .B(b[5]), .Y(n813) );
  CLKINVX1 U585 ( .A(a[0]), .Y(n764) );
  NOR2XL U586 ( .A(b[4]), .B(a[3]), .Y(n895) );
  AND2X1 U587 ( .A(b[6]), .B(a[5]), .Y(n817) );
  INVXL U588 ( .A(n827), .Y(n828) );
  NAND2XL U589 ( .A(n861), .B(n860), .Y(n925) );
  NAND2XL U590 ( .A(n833), .B(n832), .Y(n918) );
  BUFX2 U591 ( .A(b[0]), .Y(sum[7]) );
  CLKINVX1 U592 ( .A(a[1]), .Y(n809) );
  CLKINVX1 U593 ( .A(b[2]), .Y(n808) );
  NAND2X2 U594 ( .A(n808), .B(a[1]), .Y(n796) );
  NAND2X1 U595 ( .A(n768), .B(b[3]), .Y(n844) );
  OAI21X4 U596 ( .A0(n846), .A1(n799), .B0(n844), .Y(n837) );
  NOR2X1 U597 ( .A(n771), .B(n842), .Y(n777) );
  NOR2X1 U598 ( .A(n773), .B(b[5]), .Y(n841) );
  NAND2XL U599 ( .A(n841), .B(n861), .Y(n775) );
  AOI21X1 U600 ( .A0(n777), .A1(n850), .B0(n776), .Y(n778) );
  OAI21X2 U601 ( .A0(n837), .A1(n779), .B0(n778), .Y(n781) );
  NAND3X2 U602 ( .A(n781), .B(n869), .C(n840), .Y(n783) );
  OAI21X4 U603 ( .A0(n859), .A1(n804), .B0(n857), .Y(n856) );
  OAI21X4 U604 ( .A0(n856), .A1(n854), .B0(n853), .Y(n835) );
  OAI21X4 U605 ( .A0(n835), .A1(n831), .B0(n832), .Y(n795) );
  OAI22X4 U606 ( .A0(n795), .A1(n787), .B0(b[12]), .B1(n878), .Y(n882) );
  NAND2X4 U607 ( .A(n876), .B(n763), .Y(n957) );
  AOI222XL U608 ( .A0(n807), .A1(n958), .B0(n848), .B1(n961), .C0(n792), .C1(
        n915), .Y(n793) );
  XOR2X1 U609 ( .A(a[11]), .B(b[12]), .Y(n827) );
  XNOR2X1 U610 ( .A(n795), .B(n827), .Y(n872) );
  NAND2X1 U611 ( .A(n951), .B(n858), .Y(n805) );
  NAND2X1 U612 ( .A(n805), .B(n857), .Y(n960) );
  OA21X4 U613 ( .A0(n913), .A1(n831), .B0(n832), .Y(n825) );
  NOR2X1 U614 ( .A(n935), .B(n812), .Y(n894) );
  OAI21X1 U615 ( .A0(n894), .A1(n815), .B0(n814), .Y(n816) );
  OAI2BB1X1 U616 ( .A0N(a[4]), .A1N(b[5]), .B0(n816), .Y(n920) );
  AOI2BB2X2 U617 ( .B0(n959), .B1(n823), .A0N(b[10]), .A1N(a[9]), .Y(n912) );
  OAI21X1 U618 ( .A0(a[10]), .A1(b[11]), .B0(n912), .Y(n824) );
  OAI2BB1X1 U619 ( .A0N(a[10]), .A1N(b[11]), .B0(n824), .Y(n881) );
  NAND3XL U620 ( .A(n881), .B(n958), .C(n828), .Y(n829) );
  OAI211XL U621 ( .A0(n872), .A1(n963), .B0(n830), .C0(n829), .Y(sum[19]) );
  AOI211XL U622 ( .A0(n856), .A1(n853), .B0(n854), .C0(n918), .Y(n834) );
  AOI2BB1X1 U623 ( .A0N(n836), .A1N(n835), .B0(n834), .Y(n914) );
  AOI2BB1X1 U624 ( .A0N(n843), .A1N(n841), .B0(n842), .Y(n862) );
  XNOR2X1 U625 ( .A(n868), .B(n947), .Y(n944) );
  XNOR2X1 U626 ( .A(n843), .B(n897), .Y(n900) );
  XOR2X1 U627 ( .A(n846), .B(n934), .Y(n937) );
  XOR2X1 U628 ( .A(n837), .B(n911), .Y(n907) );
  XOR2X1 U629 ( .A(n856), .B(n967), .Y(n962) );
  XOR2X1 U630 ( .A(n859), .B(n949), .Y(n952) );
  XOR2X1 U631 ( .A(n862), .B(n925), .Y(n922) );
  NAND4BX1 U632 ( .AN(n863), .B(n962), .C(n952), .D(n922), .Y(n864) );
  OAI21XL U633 ( .A0(n868), .A1(n867), .B0(n866), .Y(n871) );
  XOR2X1 U634 ( .A(n871), .B(n932), .Y(n929) );
  OAI21XL U635 ( .A0(n876), .A1(a[13]), .B0(b[13]), .Y(n874) );
  OAI31XL U636 ( .A0(n877), .A1(n876), .A2(n875), .B0(n874), .Y(sum[28]) );
  OA22X2 U637 ( .A0(n881), .A1(n880), .B0(a[11]), .B1(b[12]), .Y(n884) );
  NAND2X1 U638 ( .A(n885), .B(a[12]), .Y(n886) );
  NOR3XL U639 ( .A(n888), .B(n763), .C(n887), .Y(sum[21]) );
  XOR2X1 U640 ( .A(n891), .B(n890), .Y(sum[8]) );
  AOI22XL U641 ( .A0(n961), .A1(n899), .B0(n898), .B1(n958), .Y(n904) );
  OAI22XL U642 ( .A0(n957), .A1(n899), .B0(n763), .B1(n898), .Y(n901) );
  AOI2BB2X1 U643 ( .B0(n901), .B1(n903), .A0N(n900), .A1N(n963), .Y(n902) );
  OAI21XL U644 ( .A0(n904), .A1(n903), .B0(n902), .Y(sum[12]) );
  OAI22XL U645 ( .A0(n957), .A1(n906), .B0(n763), .B1(n905), .Y(n910) );
  OAI22XL U646 ( .A0(n908), .A1(n911), .B0(n963), .B1(n907), .Y(n909) );
  OAI22XL U647 ( .A0(n957), .A1(n913), .B0(n763), .B1(n912), .Y(n916) );
  OAI21XL U648 ( .A0(n919), .A1(n918), .B0(n917), .Y(sum[18]) );
  AOI22XL U649 ( .A0(n961), .A1(n921), .B0(n958), .B1(n920), .Y(n926) );
  OAI22XL U650 ( .A0(n957), .A1(n921), .B0(n763), .B1(n920), .Y(n923) );
  AOI2BB2X1 U651 ( .B0(n923), .B1(n925), .A0N(n963), .A1N(n922), .Y(n924) );
  OAI21XL U652 ( .A0(n926), .A1(n925), .B0(n924), .Y(sum[13]) );
  AOI22XL U653 ( .A0(n961), .A1(n928), .B0(n958), .B1(n927), .Y(n933) );
  OAI22XL U654 ( .A0(n957), .A1(n928), .B0(n763), .B1(n927), .Y(n930) );
  AOI2BB2X1 U655 ( .B0(n930), .B1(n932), .A0N(n929), .A1N(n963), .Y(n931) );
  OAI21XL U656 ( .A0(n933), .A1(n932), .B0(n931), .Y(sum[15]) );
  OAI22XL U657 ( .A0(n957), .A1(n936), .B0(n763), .B1(n935), .Y(n940) );
  AO21XL U658 ( .A0(n941), .A1(n940), .B0(n939), .Y(sum[10]) );
  OA22X1 U659 ( .A0(n957), .A1(n943), .B0(n763), .B1(n942), .Y(n948) );
  AO22X1 U660 ( .A0(n961), .A1(n943), .B0(n958), .B1(n942), .Y(n945) );
  OAI21XL U661 ( .A0(n948), .A1(n947), .B0(n946), .Y(sum[14]) );
  OAI22XL U662 ( .A0(n951), .A1(n957), .B0(n763), .B1(n950), .Y(n955) );
  OAI22XL U663 ( .A0(n960), .A1(n957), .B0(n763), .B1(n959), .Y(n966) );
  AO21XL U664 ( .A0(n967), .A1(n966), .B0(n965), .Y(sum[17]) );
endmodule

