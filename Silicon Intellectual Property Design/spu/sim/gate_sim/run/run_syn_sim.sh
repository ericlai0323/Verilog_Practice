#!/bin/sh
vcs ../tb/spu_syn_tb.v  ../../../syn/spu_syn.v \
    -v /usr/cad/CBDK_IC_Contest_v2.1/Verilog/tsmc13.v \
    -R -debug_access+all +define+$1+$2+$3+$4+$5+$6 \
    +neg_tchk +lint=TFIPC-L \
#    -negdelay
