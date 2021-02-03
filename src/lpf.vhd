library ieee;
   use ieee.std_logic_1164.all;
   use ieee.std_logic_arith.all;
   use ieee.std_logic_signed.all;
	
entity lpf is
generic( dwidth : integer := 16);
port (
      clk    : in std_logic;
      reset  : in std_logic;
      enable : in std_logic;
      inlpf  : in std_logic_vector(9 downto 0) ;
      outlpf : out std_logic_vector(dwidth-1 downto 0));
end entity;

architecture rtl of lpf is

   function mul2 (a : std_logic_vector(dwidth-1 downto 0)) return std_logic_vector is
      variable result : std_logic_vector (dwidth-1 downto 0);
		begin
			result := a(dwidth-2 downto 0) & '0';
		return result;
	end function mul2;

   function conv (a : std_logic_vector (dwidth-1 downto 0)) return std_logic_vector is
      variable result, b : std_logic_vector (dwidth-1 downto 0);
		begin
			if a(dwidth-1) = '0' then
				b := not a;
				result :=  b + "00000000000001";
			elsif a(dwidth-1) = '1' then
				b := a - "00000000000001";
				result := not b;
			end if;
	return result;
	end function conv;

signal res1 : std_logic_vector(dwidth-1 downto 0) ;
signal res2 : std_logic_vector(dwidth-1 downto 0) ;
signal res3 : std_logic_vector(dwidth-1 downto 0) ;
signal res4 : std_logic_vector(dwidth-1 downto 0) ;
signal res5 : std_logic_vector(dwidth-1 downto 0) ;
signal y0, y1, y2 : std_logic_vector(dwidth-1 downto 0) ;
signal x0, x1, x2 : std_logic_vector(dwidth-1 downto 0) ;
signal x3, x4, x5 : std_logic_vector(dwidth-1 downto 0) ;
signal x6, x7, x8 : std_logic_vector(dwidth-1 downto 0) ;
signal x9, x10, x11 : std_logic_vector(dwidth-1 downto 0) ;
signal x12 : std_logic_vector (dwidth-1 downto 0) ;

begin

	res1 <= mul2(y1);
	res2 <= conv(y2);
	res3 <= x0;
	res4 <= conv(mul2(x6));
	res5 <= x12;
	y0 <= res1 + res2 + res3 + res4 + res5;
	outlpf <= y0;
	
	regy : process (reset, clk)
	begin
		if (reset = '1') then
			y1 <= (others => '0');
			y2 <= (others => '0');
		elsif (clk'event and clk = '1') then
			if enable = '1' then
				y2 <= y1 ;
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
		elsif clk'event and (clk = '1') then
			if enable = '1' then
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
				x0 <= inlpf(9) & inlpf(9) & inlpf(9) & inlpf(9) & inlpf(9) & inlpf(9) & inlpf;
			end if;
		end if;
	end process;

end architecture;