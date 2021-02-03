----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Ahmad Zaky Ramdani
-- 
-- Create Date:    01/07/2011
-- Design Name: 
-- Module Name:    QRSdetection_top - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity QRSdetector_top is
generic( dwidth : integer := 16);
port (
	reset  : in std_logic;
	clk    : in std_logic;
	inecg  : in std_logic_vector(7 downto 0);
	outecg : out std_logic
);
end entity;

architecture QRSdet_bhv of QRSdetector_top is

component lpf
generic( dwidth : integer := 16);
port (
	reset  : in std_logic;
	clk    : in std_logic;
	enable : in std_logic;
	inlpf  : in std_logic_vector(9 downto 0);
	outlpf : out std_logic_vector(dwidth-1 downto 0));
end component;

component hpf
generic( dwidth : integer := 16);
port (
	reset  : in std_logic;
	clk    : in std_logic;
	enable : in std_logic;
	inhpf  : in std_logic_vector(dwidth-1 downto 0);
	outhpf : out std_logic_vector(dwidth-1 downto 0));
end component;

component derivative
generic( dwidth : integer := 16);
port (
	reset  : in std_logic;
	clk    : in std_logic;
	enable : in std_logic;
	indef  : in std_logic_vector(dwidth-1 downto 0);
	outdef : out std_logic_vector(dwidth-1 downto 0));
end component;

component square
generic( dwidth : integer := 16);
port (
	insq  : in std_logic_vector(dwidth-1 downto 0);
	outsq : out std_logic_vector(dwidth-1 downto 0));
end component;

component integration
generic( dwidth : integer := 16);
port (
	reset    : in std_logic;
	clk      : in std_logic;
	enable   : in std_logic;
	ininteg  : in std_logic_vector(dwidth-1 downto 0);
	outinteg : out std_logic_vector(dwidth-1 downto 0));
end component;

component decision
generic ( dwidth : integer := 16);
port (
	reset  : in std_logic;
	clk    : in std_logic;
	enable : in std_logic;
	indec  : in std_logic_vector(dwidth-1 downto 0);
	outdec : out std_logic );
end component;

component divider
    generic (   DIVIDEND_WIDTH : integer := 16;
                DIVISOR_WIDTH  : integer := 8);
	port
	(   clk_i     	: in  std_logic;
		rstn_i     	: in  std_logic;
		start_i    	: in  std_logic;
		dividend_i  : in  std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		divisor_i   : in  std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		valid_o    	: out std_logic;
        mod_o       : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
        q_o         : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0));
end component;

signal rst_n    : std_logic;
signal s_qrs    : std_logic;
signal s_qrs_d  : std_logic;
signal enable   : std_logic;
signal qrs_detect : std_logic;
signal bpm      : std_logic_vector(15 downto 0);
signal beat_count : std_logic_vector(9 downto 0);
signal beat     : std_logic_vector(9 downto 0);
signal insystem : std_logic_vector(9 downto 0);
signal outlpf1  : std_logic_vector(dwidth-1 downto 0);
signal outhpf1  : std_logic_vector(dwidth-1 downto 0);
signal outdef1  : std_logic_vector(dwidth-1 downto 0);
signal outsq1   : std_logic_vector(dwidth-1 downto 0);
signal outint1  : std_logic_vector(dwidth-1 downto 0);
signal outint2  : std_logic_vector(dwidth-1 downto 0);

begin						---begin architecture---


		enable <= '1'; --wait;

	
	insystem <= inecg(7) & inecg(7) & inecg;

	LP : lpf
    generic map( dwidth => 16)
	port map(
		reset  => reset,
		clk    => clk,
		enable => enable,
		inlpf  => insystem,
		outlpf => outlpf1
	);
	
	HP : hpf
    generic map( dwidth => 16)
	port map(
		reset  => reset,
		clk    => clk,
		enable => enable,
		inhpf  => outlpf1,
		outhpf => outhpf1
	);
		
	DF : derivative
    generic map( dwidth => 16)
	port map(
		reset  => reset,
		clk    => clk,
		enable => enable,
		indef  => outhpf1,
		outdef => outdef1
	);
	
	SQ : square
    generic map( dwidth => 16)
	port map(
		insq  => outdef1,
		outsq => outsq1
	);
	
	INT : integration
    generic map( dwidth => 16)
	port map (
		reset    => reset,
		clk      => clk,
		enable   => enable,
		ininteg  => outsq1,
		outinteg => outint1
	);
	INT2 : integration
    generic map( dwidth => 16)
	port map (
		reset    => reset,
		clk      => clk,
		enable   => enable,
		ininteg  => outint1,
		outinteg => outint2
	);
	
	DEC : decision
    generic map( dwidth => 16)
	port map (
		reset  => reset,
		clk 	 => clk,
		enable => enable,
		indec  => outint2,
		outdec => qrs_detect
	);
    
    DIV : divider
    generic map(   DIVIDEND_WIDTH => 16,
                DIVISOR_WIDTH  => 10)
	port map
	(   clk_i     	=> clk,  
		rstn_i     	=> rst_n,
		start_i    	=> s_qrs_d,
		dividend_i  => X"2EE0",
		divisor_i   => beat,
        q_o         => bpm);
	
    rst_n <= not reset;
   
    
    process(clk, reset)
    begin
    if reset = '1' then
        s_qrs   <= '0';
        s_qrs_d <= '0';
        outecg  <= '0';
    elsif clk'event and clk = '1' then 
        s_qrs   <= qrs_detect;
        s_qrs_d <= s_qrs;
        outecg  <= s_qrs_d;
    end if;
    end process;
    
    process(clk, reset)
    begin
    if reset = '1' then
        beat_count <= (others => '0');
        beat       <= (others => '0');
    elsif clk'event and clk = '1' then 
        if qrs_detect = '1' then
            beat    <= beat_count;
            beat_count <= (others => '0');
        else
            beat_count <= beat_count+1;
        end if;
    end if;
    end process;
    
    
end architecture;
