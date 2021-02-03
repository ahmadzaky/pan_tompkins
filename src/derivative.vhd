library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity derivative is
generic( dwidth : integer := 16);
port (
	reset  : in std_logic;
	clk    : in std_logic;
	enable : in std_logic;
	indef  : in std_logic_vector(dwidth-1 downto 0);
	outdef : out std_logic_vector(dwidth-1 downto 0));
end entity;

architecture rtl of derivative is

	function mul2 (a : std_logic_vector(dwidth-1 downto 0)) return std_logic_vector is
		variable result : std_logic_vector (dwidth-1 downto 0);
		begin
			result := a(dwidth-1) & a(dwidth-3 downto 0) & '0';
		return result;
	end function mul2;
	
	function conv (a : std_logic_vector (dwidth-1 downto 0)) return std_logic_vector is
		variable result, b : std_logic_vector (dwidth-1 downto 0);
		begin
			if a(dwidth-1) = '0' then
				b := not a;
				result := b + "0000000000000001";
			elsif a(dwidth-1) = '1' then
				b := a - "0000000000000001";
				result := not b;
			end if;
		return result;
	end function conv;

	function div8 (a : std_logic_vector(dwidth-1 downto 0)) return std_logic_vector is
		variable result : std_logic_vector (dwidth-1 downto 0);
		begin
			result := a(dwidth-1) & a(dwidth-1) & a(dwidth-1) & a(dwidth-1 downto 3);
		return result;
	end function div8;

	signal res1 : std_logic_vector(dwidth-1 downto 0) ;
	signal res2 : std_logic_vector(dwidth-1 downto 0) ;
	signal res3 : std_logic_vector(dwidth-1 downto 0) ;
	signal res4 : std_logic_vector(dwidth-1 downto 0) ;
	signal y0 : std_logic_vector(dwidth-1 downto 0) ;
	signal x0 : std_logic_vector(dwidth-1 downto 0) ;
	signal x1 : std_logic_vector(dwidth-1 downto 0) ;
	signal x2 : std_logic_vector(dwidth-1 downto 0) ;
	signal x3 : std_logic_vector(dwidth-1 downto 0) ;
	signal x4 : std_logic_vector(dwidth-1 downto 0) ;

begin
	res1 <= mul2(x0);
	res2 <= x1;
	res3 <= conv(x3);
	res4 <= conv(mul2(x4));
	y0 <= res1 + res2 + res3 + res4 ;
	outdef <= div8(y0);

	regx : process (reset, enable, clk)
	begin
		if (reset = '1') then
			x0 <= (others => '0');
			x1 <= (others => '0');
			x2 <= (others => '0');
			x3 <= (others => '0');
			x4 <= (others => '0');
		elsif clk'event and (clk = '1') then
			if enable = '1' then 
				x4 <= x3;
				x3 <= x2;
				x2 <= x1;
				x1 <= x0;
				x0 <= indef;
			end if;
		end if;
	end process;

end architecture;