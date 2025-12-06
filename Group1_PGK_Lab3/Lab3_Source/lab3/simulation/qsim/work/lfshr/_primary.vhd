library verilog;
use verilog.vl_types.all;
entity lfshr is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        seed            : in     vl_logic_vector(15 downto 0);
        \out\           : out    vl_logic_vector(15 downto 0)
    );
end lfshr;
