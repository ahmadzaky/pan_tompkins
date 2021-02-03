library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decision is
generic ( dwidth : integer := 16) ;
port(
		reset  : in std_logic;
		clk    : in std_logic;
		enable : in std_logic;
		indec  : in std_logic_vector(dwidth-1 downto 0) ;
		outdec : out std_logic );
end entity;

architecture rtl of decision is

    constant threshold : std_logic_vector(dwidth-1 downto 0) := "0000000011000000";
	signal s_qrs_d : std_logic;
	signal s_peak   : std_logic;
	signal s_peak_d : std_logic;
	signal sum1 : std_logic_vector(dwidth-1 downto 0);
	signal sum2 : std_logic_vector(dwidth-1 downto 0);
	signal sum3 : std_logic_vector(dwidth-1 downto 0);
	signal sum4 : std_logic_vector(dwidth-1 downto 0);
	signal sum5 : std_logic_vector(dwidth-1 downto 0);
	signal sum6 : std_logic_vector(dwidth-1 downto 0);
	signal sum7 : std_logic_vector(dwidth-1 downto 0);
	signal sum8 : std_logic_vector(dwidth-1 downto 0);
	signal sumx : std_logic_vector(dwidth-1 downto 0);
	signal sumy : std_logic_vector(dwidth-1 downto 0);
	signal sum  : std_logic_vector(dwidth-1 downto 0);
	signal x0, x1, x2, x3 : std_logic_vector(dwidth-1 downto 0);
	signal x4, x5, x6, x7 : std_logic_vector(dwidth-1 downto 0);
	signal x8, x9, x10, x11 : std_logic_vector(dwidth-1 downto 0);
	signal x12, x13, x14, x15 : std_logic_vector(dwidth-1 downto 0);
	signal x16, x17, x18, x19 : std_logic_vector(dwidth-1 downto 0);
	signal x20, x21, x22, x23 : std_logic_vector(dwidth-1 downto 0);
	signal x24, x25, x26, x27 : std_logic_vector(dwidth-1 downto 0);
	signal x28, x29, x30, x31 : std_logic_vector(dwidth-1 downto 0);

begin
	sum1 <= (x0 + x1 + x2 + x3);
	sum2 <= (x4 + x5 + x6 + x7);
	sum3 <= (x8 + x9 + x10 + x11);
	sum4 <= (x12 + x13 + x14 + x15);
	sum5 <= (x16 + x17 + x18 + x19);
	sum6 <= (x20 + x21 + x22 + x23);
	sum7 <= (x24 + x25 + x26 + x27);
	sum8 <= (x28 + x29 + x30 + x31);
	sumx <= sum1 + sum2 + sum3 + sum4;
	sumy <= sum5 + sum6 + sum7 + sum8;
	sum <= sumx + sumy;

	process (reset, clk)
	begin
	if reset = '1' then
		s_qrs_d <= '0';
	elsif clk'event and (clk = '1') then
		if sum7 > threshold then
			s_qrs_d <= '1';
		else
			s_qrs_d <= '0';
		end if;
	end if;
	end process;
    
	process (reset, clk)
	begin
	if reset = '1' then
		s_peak   <= '0';
		s_peak_d <= '0';
	elsif clk'event and (clk = '1') then
		if s_qrs_d = '1' then
            if x25 >= x26 and x25 > x24 then
                s_peak <= '1';
            end if;
        else
            s_peak <= '0'; 
        end if;
        s_peak_d <= s_peak;
	end if;
	end process;
    
   outdec <= s_peak when (s_peak_d = '0') else '0';

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
		elsif clk'event and (clk = '1') then
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
			x0 <= indec;
		end if;
	end process;
	
end architecture;