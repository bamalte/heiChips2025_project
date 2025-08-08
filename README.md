# heiChips2025_project

## Project idea
Our project idea was to fit a small 8-bit core on our tile. We wanted to use the SRAM on the chip as RAM for our core and the FPGA fabric for routing between the core and SRAM, and for housing one custom instruction/acceleator that could be dynamically reconfigured by triggering a partial FPGA reconfiguration, while the connection to the SRAM stays intact and the core can ideally keep working.
On our quest to finding a suitable small core, we found the SAP (Simple-As-Possible Computer) core. This was first described in the book "Digital Computer Electronics" by Albert Paul Malvino and Jerald A. Brown. SAP-2 and 3 are Turing-complete [[1]](#ref1). There is source code under an MIT license and an extensive documentation by Austin Morlan available under [[2-5]](#ref5). This was the starting point for this project.

## First Approach: SAP-1 
In our quest to finding a suitable small core, we found the SAP-1 implementation by Austin Morlan [[2]](#ref2). It is a very minimal 8-bit core with 8-bit instructions and two 8-bit registers. Aside from the registers, it has an adder module, a PC, an instruction register, a memory and a controller. Those modules communicate through an 8-bit bus. Austin Morlan's SAP-1 implementation only supports 4 instructions: 
```
[0000] LDA $X Load the value at memory location $X into A.
[0001] ADD $X Add the value at memory location $X to A and store the sum in A.
[0010] SUB $X Subtract the value at memory location $X from A and store the difference in A.
[1111] HLT    Halt execution of the program
``` 
[Fig 1: the four instructions SAP-1 supports (taken from [2])](#ref2)  

SAP-1 has a 16-byte-memory that can store 16 8-bit words. We implemented this memory on our tile since we had enough space because the core is so small. For getting an area estimate we ran the physical implementation of the design by using the provided toolchain with librelane etc. We hardcoded a program into the RAM, which was also given on Austin Morlan's page. It uses all four instructions and can be seen below.
``` 
$0 |   0D  // LDA [$D]   Load A with the value at address $D  
$1 |   1E  // ADD [$E]   Add the value at address $E to A  
$2 |   2F  // SUB [$F]   Subtract the value at address $F from A
$3 |   F0  // HLT        Stop execution
```
[Fig 2: the example program (taken from [2])](#ref2)  
The instructions are executed over 6 stages, each stage takes one clock cycle to complete. The first three stages fetch the next instruction from memory. The next three stages vary depending on the current instruction. Some stages can also be idle. The HLT instruction stops the clock and therefore ends the program execution. This state where the clock is stopped can only be exited by resetting the core.

<figure>
  <img src="drawings/sap-1.png" alt="">
  <figcaption>Figure 3: The physical implementation of the SAP-1 takes roughly a fourth of the area on our tile.</figcaption>
</figure>

## Going bigger
Because the physical implementation of the SAP-1 only took about a fourth of the area of our tile, we decided to try out a bigger and more capable version. SAP-2 and 3 are both Turing-complete. SAP-2 [[3]](#ref3) supports 39 instructions and uses a ROM to store the control signals for every instruction to avoid a large switch statement. This is problematic for us since we want to avoid having memory on our tile and using the SRAM would slow us down and we would have to rewrite a large part of the code and we would have to find a way to pass all signals through the few interface pins between our tile and the FPGA fabric. So we decided to skip the SAP-2 and go directly to the most complex core, the SAP-3. Even though the SAP-3 [[4]](#ref4) supports significantly more instructions than the SAP-2, which only supports 39 instructions, it is simpler in many ways. 

## Second Approach: SAP-3
The SAP-3 [[4]](#ref4) uses the same instruction set as the Intel 8085, but omits some instructions.

 
<figure>
  <img src="drawings/sap-3.png" alt="">
  <figcaption>Figure 4: The physical implementation of the SAP-3 on our tile.</figcaption>
</figure>


The source code for all three SAP versions can be found here: [[5]](#ref5)
## System overview

<figure>
  <img src="drawings/system_overview.svg" alt="">
  <figcaption>Figure 5: </figcaption>
</figure>

## TODOs

- [ ] Simulation
- [ ] 
- [ ] 
- [ ] 
- [ ] 
- [ ] 

## References
[1] <a id="ref1"> Wikipedia SAP computer https://en.wikipedia.org/wiki/Simple-As-Possible_computer   
[2] <a id="ref2"> Blog post to Andrew Morlan's SAP-1 https://austinmorlan.com/posts/fpga_computer_sap1  
[3] <a id="ref3"> Blog post to Andrew Morlan's SAP-2 https://austinmorlan.com/posts/fpga_computer_sap2  
[4] <a id="ref4"> Blog post to Andrew Morlan's SAP-3 https://austinmorlan.com/posts/fpga_computer_sap3  
[5] <a id="ref5"> Source code for Andrew Morlan's SAP-1,2,3 https://code.austinmorlan.com/austin/2023-fpga-computer  
