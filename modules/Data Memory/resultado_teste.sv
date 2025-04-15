
[2025-04-15 01:53:17 UTC] iverilog '-Wall' '-g2012' design.sv testbench.sv  && unbuffer vvp a.out  
design.sv:16: warning: @* is sensitive to all 1024 words in array 'memory'.
Read data (addr 4): abcd1234
Read data (addr 8): 55555555
testbench.sv:74: $finish called at 55 (1s)
