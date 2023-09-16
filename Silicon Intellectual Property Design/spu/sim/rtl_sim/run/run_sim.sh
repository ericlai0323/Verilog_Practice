#!/bin/sh
if [ "$1" == "cov" ]; then
   vcs -f $2 -full64 -cm cond+line+tgl+fsm+branch \
       -R -debug_access+all \
       +define+$3+$4+$5 \
       -l sim.log
   dve -full64 -cov -dir simv.vdb &
else 
   vcs -f $1 -full64 -R -debug_access+all \
       +define+$2+$3+$4 \
       -l sim.log
fi
