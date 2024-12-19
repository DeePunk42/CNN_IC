#!/bin/sh
vcs ./testbench.v ./main.v -sverilog -debug_acc+all -debug_region+cell+encrypt -ucli -R
