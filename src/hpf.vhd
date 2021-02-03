library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity hpf is
    generic( dwidth : integer := 16);
	port (
		reset  : in std_logic;
		clk    : in std_logic;
		enable : in std_logic;
		inhpf  : in std_logic_vector (dwidth-1 downto 0) ;
		outhpf : out std_logic_vector (dwidth-1 downto 0));
end entity;

architecture rtl of hpf is

	function div32 (a : std_logic_vector(dwidth-1 downto 0)) return std_logic_vector is
		variable result : std_logic_vector (dwidth-1 downto 0);
		begin
			result := a(dwidth-1) & a(dwidth-1) & a(dwidth-1) & a(dwidth-1) & a(dwidth-1) & a(dwidth-1 downto 5);
		return result;
	end function div32;
	
	function conv (a : std_logic_vector (dwidth-1 downto 0)) return std_logic_vector is
		variable result, b : std_logic_vector (dwidth-1 downto 0);
		begin
			if a(dwidth-1) = '0' then
				b := not a;
				result := b + "000000000000001";
			elsif a(dwidth-1) = '1' then
				b := a - "000000000000001";
				result := not b;
			end if;
		return result;
	end function conv;

	signal res1 : std_logic_vector(dwidth-1 downto 0) ;
	signal res2 : std_logic_vector(dwidth-1 downto 0) ;
	signal res3 : std_logic_vector(dwidth-1 downto 0) ;
	signal res4 : std_logic_vector(dwidth-1 downto 0) ;
	signal res5 : std_logic_vector(dwidth-1 downto 0) ;
	signal res6 : std_logic_vector(dwidth-1 downto 0) ;
	signal res7 : std_logic_vector(dwidth-1 downto 0) ;
	signal res8 : std_logic_vector(dwidth-1 downto 0) ;
	signal y1, y0 : std_logic_vector(dwidth-1 downto 0) ;
	signal x0, x1, x2, x3 : std_logic_vector(dwidth-1 downto 0);
	signal x4, x5, x6, x7 : std_logic_vector(dwidth-1 downto 0);
	signal x8, x9, x10, x11 : std_logic_vector(dwidth-1 downto 0);
	signal x12, x13, x14, x15 : std_logic_vector(dwidth-1 downto 0);
	signal x16, x17, x18, x19 : std_logic_vector(dwidth-1 downto 0);
	signal x20, x21, x22, x23 : std_logic_vector(dwidth-1 downto 0);
	signal x24, x25, x26, x27 : std_logic_vector(dwidth-1 downto 0);
	signal x28, x29, x30, x31 : std_logic_vector(dwidth-1 downto 0);
	signal x32 : std_logic_vector(dwidth-1 downto 0);

begin
	res1 <= x16;
	res2 <= conv(x17);
	res3 <= y1;
	res4 <= x0 + x32;
	res5 <= div32(res4);
	res6 <= conv(res5);
	res7 <= res1 + res2;
	res8 <= res7 + res3;
	outhpf <= res8 + res6;
	
	regy : process (reset, clk)
	begin
		if (reset = '1') then
			y0 <= (others => '0');
			y1 <= (others => '0');
		elsif (clk'event and clk = '1') then
			if enable = '1' then
				y1 <= y0 ;
			end if;
		end if ;
	end process;

	regx : process (reset, clk)
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
				x0 <= inhpf;
			end if;
		end if;
	end process;
	
end architecture;