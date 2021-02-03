library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity integration is
    generic( dwidth : integer := 16);
    port (
        reset 	 : in std_logic;
        clk 	 : in std_logic;
        enable 	 : in std_logic;
        ininteg  : in std_logic_vector(dwidth-1 downto 0) ;
        outinteg : out std_logic_vector(dwidth-1 downto 0));
end entity;

architecture rtl of integration is

	function div32 (a : std_logic_vector(dwidth-1 downto 0)) return std_logic_vector is
	variable result : std_logic_vector (dwidth-1 downto 0);
		begin
			result := "000" & a(dwidth-1 downto 3);
		return result;
	end function div32;

	signal y0, y1, y2, y3 : std_logic_vector(dwidth-1 downto 0);
	signal y4, y5, y6, y7 : std_logic_vector(dwidth-1 downto 0);
	signal y8, y9, y10, y11 : std_logic_vector(dwidth-1 downto 0);
	signal y12, y13, y14, y15 : std_logic_vector(dwidth-1 downto 0);
	signal x0, x1, x2, x3 : std_logic_vector(dwidth-1 downto 0);
	signal x4, x5, x6, x7 : std_logic_vector(dwidth-1 downto 0);
	signal x8, x9, x10, x11 : std_logic_vector(dwidth-1 downto 0);
	signal x12, x13, x14, x15 : std_logic_vector(dwidth-1 downto 0);
	signal x16, x17, x18, x19 : std_logic_vector(dwidth-1 downto 0);
	signal x20, x21, x22, x23 : std_logic_vector(dwidth-1 downto 0);
	signal x24, x25, x26, x27 : std_logic_vector(dwidth-1 downto 0);
	signal x28, x29, x30, x31 : std_logic_vector(dwidth-1 downto 0);
	signal x32 : std_logic_vector(dwidth-1 downto 0);
	signal s_outinteg : std_logic_vector(dwidth-1 downto 0);

begin

	regx : process (reset, enable, clk)
	begin
		if (reset = '1') then
			x0 <= (others => '0');
			x1 <= (others => '0');
			x2 <= (others => '0');
			x3 <= (others => '0');
			x4 <= (others => '0');
			x5 <= (others => '0');
			x6 <= (others => '0');
			x7 <= (others => '0');
			x8 <= (others => '0');
			x9 <= (others => '0');
			x10 <= (others => '0');
			x11 <= (others => '0');
			x12 <= (others => '0');
			x13 <= (others => '0');
			x14 <= (others => '0');
			x15 <= (others => '0');
			x16 <= (others => '0');
			x17 <= (others => '0');
			x18 <= (others => '0');
			x19 <= (others => '0');
			x20 <= (others => '0');
			x21 <= (others => '0');
			x22 <= (others => '0');
			x23 <= (others => '0');
			x24 <= (others => '0');
			x25 <= (others => '0');
			x26 <= (others => '0');
			x27 <= (others => '0');
			x28 <= (others => '0');
			x29 <= (others => '0');
			x30 <= (others => '0');
			x31 <= (others => '0');
			x32 <= (others => '0');
		elsif clk'event and (clk = '1') then
			if enable = '1' then
				x32 <= x31;
				x31 <= x30;
				x30 <= x29;
				x29 <= x28;
				x28 <= x27;
				x27 <= x26;
				x26 <= x25;
				x25 <= x24;
				x24 <= x23;
				x23 <= x22;
				x22 <= x21;
				x21 <= x20;
				x20 <= x19;
				x19 <= x18;
				x18 <= x17;
				x17 <= x16;
				x16 <= x15;
				x15 <= x14;
				x14 <= x13;
				x13 <= x12;
				x12 <= x11;
				x11 <= x10;
				x10 <= x9;
				x9 <= x8;
				x8 <= x7;
				x7 <= x6;
				x6 <= x5;
				x5 <= x4;
				x4 <= x3;
				x3 <= x2;
				x2 <= x1;
				x1 <= x0;
				x0 <= ininteg;
			end if;
		end if;
	end process;

	y0 <= (x0 + x1) + (x2 + x3);
	y1 <= (x4 + x5) + (x6 + x7);
	y2 <= (x8 + x9) + (x10 + x11);
	y3 <= (x12 + x13) + (x14 + x15);
	y4 <= (x16 + x17) + (x18 + x19);
	y5 <= (x20 + x21) + (x22 + x23);
	y6 <= (x24 + x25) + (x26 + x27);
	y7 <= (x28 + x29) + (x30 + x31);
	y8 <= y0 + y1;
	y9 <= y2 + y3;
	y10 <= y4 + y5;
	y11 <= y6 + y7;
	y12 <= div32(y8);
	y13 <= div32(y9);
	y14 <= div32 (y10);
	y15 <= div32 (y11);
	s_outinteg <= (y12 + y13) ;
	outinteg  <= s_outinteg(dwidth-1 downto 0);
	
end architecture;