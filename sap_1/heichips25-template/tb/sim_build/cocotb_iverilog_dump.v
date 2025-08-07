module cocotb_iverilog_dump();
initial begin
    $dumpfile("/home/user/Documents/heiChips2025_project/sap_1/heichips25-template/tb/sim_build/heichips25_template.fst");
    $dumpvars(0, heichips25_template);
end
endmodule
