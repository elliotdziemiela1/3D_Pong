// RAM. 2KB to be exact. address range = 0x0000-0x07ff

module RAM(
   input logic [15:0] addr,
   input logic [7:0] in,
   input logic write,
   input logic clk,
   output logic [7:0] out);

logic [7:0] mem [65535:0];   // 65536-size array of 8-bit elements

always_ff @(posedge clk) begin
   if (write) 
      mem[addr] <= in;
   else
      out <= mem[addr];
end

endmodule 