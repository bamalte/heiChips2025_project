# SPDX-FileCopyrightText: © 2025 XXX Authors
# SPDX-License-Identifier: Apache-2.0

import os
import sys
from pathlib import Path
import cocotb
from cocotb.clock import Clock
from cocotb.runner import get_runner
from cocotb.triggers import Timer, ClockCycles


@cocotb.test()
async def sap_three_test(dut):
    """Testing the counter of the design."""
    
    # Create a clock with a period of 10ns = 100MHz
    clock = Clock(dut.clk, 10, 'ns')
    await cocotb.start(clock.start())

    dut.io_in.value  = 0

    # TODO CHANGE CHANGE CHANGE CHANGE CHANGE
    # Reset the design for 100ns
    dut.io_in.value = 0
    await Timer(100, 'ns')
    dut.io_in.value = 1
    await Timer(100, 'ns')

    # Wait for 100 clock cycles
    # await ClockCycles(dut.clk, 100)
    await ClockCycles(dut.clk, 100)

    # Ensure the output is 0x01
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x01")
    assert dut.heichips25_template_inst.sap_3_outputReg == 1, "Output is not 1!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x02
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x02")
    assert dut.heichips25_template_inst.sap_3_outputReg == 2, "Output is not 2!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x04
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x04")
    assert dut.heichips25_template_inst.sap_3_outputReg == 4, "Output is not 4!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x08
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x08")
    assert dut.heichips25_template_inst.sap_3_outputReg == 8, "Output is not 8!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (120))

    # Ensure the output is 0x10
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x10")
    assert dut.heichips25_template_inst.sap_3_outputReg == 16, "Output is not 16!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (120))

    # Ensure the output is 0x20
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x20")
    assert dut.heichips25_template_inst.sap_3_outputReg == 32, "Output is not 32!"

    # Wait for 50 clock cycles
    await ClockCycles(dut.clk, (140))

    # Ensure the output is 0x40
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x40")
    assert dut.heichips25_template_inst.sap_3_outputReg == 64, "Output is not 64!"

    # Wait for 50 clock cycles
    await ClockCycles(dut.clk, (180))

    # Ensure the output is 0x80
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x80")
    assert dut.heichips25_template_inst.sap_3_outputReg == 128, "Output is not 128!"

    # Wait for 50 clock cycles
    await ClockCycles(dut.clk, (140))

    # Ensure the output is 0x40
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x40")
    assert dut.heichips25_template_inst.sap_3_outputReg == 64, "Output is not 64!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x20
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x20")
    assert dut.heichips25_template_inst.sap_3_outputReg == 32, "Output is not 32!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x10
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x10")
    assert dut.heichips25_template_inst.sap_3_outputReg == 16, "Output is not 16!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x08
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x08")
    assert dut.heichips25_template_inst.sap_3_outputReg == 8, "Output is not 8!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (140))

    # Ensure the output is 0x04
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x04")
    assert dut.heichips25_template_inst.sap_3_outputReg == 4, "Output is not 4!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x02
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x02")
    assert dut.heichips25_template_inst.sap_3_outputReg == 2, "Output is not 2!"

    # Wait for 100 clock cycles
    await ClockCycles(dut.clk, (100))

    # Ensure the output is 0x01
    print(f"The current output is: {dut.heichips25_template_inst.sap_3_outputReg.value}, and should be: 0x01")
    assert dut.heichips25_template_inst.sap_3_outputReg == 1, "Output is not 1!"


    # Wait for 200 clock cycles
    await ClockCycles(dut.clk, (400))

    # cocotb documentation: https://docs.cocotb.org/en/stable/refcard.html
    # cocotb reference card: https://docs.cocotb.org/en/stable/refcard.html

if __name__ == "__main__":

    sim         = os.getenv("SIM", "icarus")
    pdk_root    = os.getenv("PDK_ROOT", "~/.ciel")
    pdk         = os.getenv("PDK", "ihp-sg13g2")
    scl         = os.getenv("SCL", "sg13g2_stdcell")
    gl          = os.getenv("GL", False)

    testbench_path = Path(__file__).resolve().parent
    sources = []#[testbench_path / 'testbench.sv']
    defines = {}

    MACRO_NL = testbench_path / '../macro/nl/heichips25_template.nl.v'

    if gl:
        if not MACRO_NL.exists():
            print(f"The macro netlist {MACRO_NL} does not exist. Did you implement the macro?")
            sys.exit(0)
    
        sources.append(Path(pdk_root).expanduser() / pdk / "libs.ref" / scl / "verilog" / f"{scl}.v" )
        sources.append(MACRO_NL)
        defines = {'FUNCTIONAL': True, 'UNIT_DELAY': '#0'}
    else:
        sources.extend(list(testbench_path.glob('../src/*')))
        #print(f"Using sources: {sources}") # debug
        defines = {'RTL': True}

    hdl_toplevel = "top_tb"

    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel=hdl_toplevel,
        defines=defines,
        timescale=['1ns', '1ps'],
        waves=True,
        build_args=['--trace', '--trace-fst', '--trace-structs'] if sim == 'verilator' else ['-gno-specify'],
    )

    runner.test(
        hdl_toplevel=hdl_toplevel,
        test_module='testbench,',
        timescale=['1ns', '1ps'],
        waves=True,
        plusargs=['--trace-file', f'{hdl_toplevel}.fst']  if sim == 'verilator' else [],
    )
