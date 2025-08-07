set ::env(STEP_ID) OpenROAD.GlobalRouting
set ::env(TECH_LEF) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef
set ::env(MACRO_LEFS) ""
set ::env(STD_CELL_LIBRARY) sg13g2_stdcell
set ::env(VDD_PIN) VPWR
set ::env(VDD_PIN_VOLTAGE) 1.20
set ::env(GND_PIN) VGND
set ::env(TECH_LEFS) "\"nom_*\" /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef \"min_*\" /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef \"max_*\" /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_tech.lef"
set ::env(PRIMARY_GDSII_STREAMOUT_TOOL) magic
set ::env(DEFAULT_CORNER) nom_typ_1p20V_25C
set ::env(STA_CORNERS) "nom_fast_1p32V_m40C nom_slow_1p08V_125C nom_typ_1p20V_25C"
set ::env(FP_IO_HLAYER) Metal3
set ::env(FP_IO_VLAYER) Metal2
set ::env(RT_MIN_LAYER) Metal2
set ::env(RT_MAX_LAYER) TopMetal1
set ::env(SCL_GROUND_PINS) VSS
set ::env(SCL_POWER_PINS) VDD
set ::env(TRISTATE_CELLS) "\"sg13g2_ebufn_*\" \"sg13g2_einvn_*\""
set ::env(FILL_CELLS) "sg13g2_fill_1 sg13g2_fill_2"
set ::env(DECAP_CELLS) "\"sg13g2_decap_*\""
set ::env(LIB) "nom_typ_1p20V_25C /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_typ_1p20V_25C.lib nom_fast_1p32V_m40C /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_fast_1p32V_m40C.lib nom_slow_1p08V_125C /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lib/sg13g2_stdcell_slow_1p08V_125C.lib"
set ::env(CELL_LEFS) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/lef/sg13g2_stdcell.lef
set ::env(CELL_GDS) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/gds/sg13g2_stdcell.gds
set ::env(CELL_VERILOG_MODELS) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/verilog/sg13g2_stdcell.v
set ::env(CELL_SPICE_MODELS) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/spice/sg13g2_stdcell.spice
set ::env(CELL_CDLS) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.ref/sg13g2_stdcell/cdl/sg13g2_stdcell.cdl
set ::env(SYNTH_EXCLUDED_CELL_FILE) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.tech/librelane/sg13g2_stdcell/synth_exclude.cells
set ::env(PNR_EXCLUDED_CELL_FILE) /home/user/.ciel/ciel/ihp-sg13g2/versions/cb7daaa8901016cf7c5d272dfa322c41f024931f/ihp-sg13g2/libs.tech/librelane/sg13g2_stdcell/pnr_exclude.cells
set ::env(OUTPUT_CAP_LOAD) 6.0
set ::env(MAX_FANOUT_CONSTRAINT) 10
set ::env(CLOCK_UNCERTAINTY_CONSTRAINT) 0.25
set ::env(CLOCK_TRANSITION_CONSTRAINT) 0.15
set ::env(TIME_DERATING_CONSTRAINT) 5
set ::env(IO_DELAY_CONSTRAINT) 20
set ::env(SYNTH_DRIVING_CELL) sg13g2_buf_4/X
set ::env(SYNTH_TIEHI_CELL) sg13g2_tiehi/L_HI
set ::env(SYNTH_TIELO_CELL) sg13g2_tielo/L_LO
set ::env(SYNTH_BUFFER_CELL) sg13g2_buf_1/A/X
set ::env(PLACE_SITE) CoreSite
set ::env(CELL_PAD_EXCLUDE) "\"sg13g2_fill_*\" \"sg13g2_decap_*\""
set ::env(DIODE_CELL) sg13g2_antennanp
set ::env(DESIGN_NAME) heichips25_template
set ::env(CLOCK_PERIOD) 10
set ::env(CLOCK_PORT) clk
set ::env(DIE_AREA) "0 0 500 200"
set ::env(FALLBACK_SDC) /nix/store/3x0iz65q90laa2wjrvxaqx13fnzp1abs-python3-3.12.10-env/lib/python3.12/site-packages/librelane/scripts/base.sdc
set ::env(SET_RC_VERBOSE) 0
set ::env(LAYERS_RC) ""
set ::env(PDN_CONNECT_MACROS_TO_GRID) 1
set ::env(PDN_ENABLE_GLOBAL_CONNECTIONS) 1
set ::env(FP_DEF_TEMPLATE) /home/user/Documents/heiChips2025_project/sap_2_v2/heichips25-template/librelane/def/heichips25_template_small.def
set ::env(DEDUPLICATE_CORNERS) 0
set ::env(GRT_ADJUSTMENT) 0.299999999999999988897769753748434595763683319091796875
set ::env(GRT_MACRO_EXTENSION) 0
set ::env(GRT_LAYER_ADJUSTMENTS) "0.00 0.00 0.00 0.00 0.00 0.00 0.00"
set ::env(GRT_ALLOW_CONGESTION) 0
set ::env(GRT_ANTENNA_ITERS) 3
set ::env(GRT_OVERFLOW_ITERS) 50
set ::env(GRT_ANTENNA_MARGIN) 10
set ::env(PL_OPTIMIZE_MIRRORING) 1
set ::env(PL_MAX_DISPLACEMENT_X) 500
set ::env(PL_MAX_DISPLACEMENT_Y) 100
set ::env(DPL_CELL_PADDING) 0
set ::env(CURRENT_ODB) /home/user/Documents/heiChips2025_project/sap_2_v2/heichips25-template/librelane/runs/RUN_2025-08-07_21-42-39/37-openroad-resizertimingpostcts/heichips25_template.odb
set ::env(SAVE_ODB) /home/user/Documents/heiChips2025_project/sap_2_v2/heichips25-template/librelane/runs/RUN_2025-08-07_21-42-39/39-openroad-globalrouting/heichips25_template.odb
set ::env(SAVE_DEF) /home/user/Documents/heiChips2025_project/sap_2_v2/heichips25-template/librelane/runs/RUN_2025-08-07_21-42-39/39-openroad-globalrouting/heichips25_template.def
