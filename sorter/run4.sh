#!/bin/bash
iverilog -g2005-sv topn_v4c.v #(it's not 4*32-bit)
#iverilog -g2005-sv topn_v4d_HTmodule.v #_flush.v
#iverilog -g2005-sv "topn_v4d_HT (copy).v" #_flush.v
#./a.out | sed '/^$/d'
vvp a.out -lxt2 | sed '/^$/d'
rm a.out
