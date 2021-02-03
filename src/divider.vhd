library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


entity divider is
    generic (
                DIVIDEND_WIDTH : integer := 16;
                DIVISOR_WIDTH  : integer := 8
            );
	port
	(
		clk_i     	: in  std_logic;
		rstn_i     	: in  std_logic;
		start_i    	: in  std_logic;
		dividend_i  : in  std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
		divisor_i   : in  std_logic_vector(DIVISOR_WIDTH-1 downto 0);
		valid_o    	: out std_logic;
        mod_o       : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0);
        q_o         : out std_logic_vector(DIVIDEND_WIDTH-1 downto 0)
	);
end entity divider;


architecture rtl of divider is

    
    function makenegative (a: std_logic_vector(DIVISOR_WIDTH-1 downto 0)) return std_logic_vector is
    variable invers : std_logic_vector (DIVISOR_WIDTH-1 downto 0);
    variable result : std_logic_vector (DIVISOR_WIDTH-1 downto 0);
    begin    
        for i in 0 to DIVISOR_WIDTH-1 loop
            invers(i) := not a(i);
        end loop;
        result := invers + 1;
    return result;
    end function makenegative;
    
    function addcompare (a: std_logic_vector(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto 0); b: std_logic_vector(DIVISOR_WIDTH-1 downto 0)) return std_logic_vector is
    variable result : std_logic_vector (DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto 0);
    variable add_result : std_logic_vector (DIVISOR_WIDTH-1 downto 0);
    begin    
            add_result := a(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto DIVIDEND_WIDTH) + b;
            if add_result(DIVISOR_WIDTH-1) = '1' then
                result := a(DIVIDEND_WIDTH+DIVISOR_WIDTH-2 downto 1) & "00";
            else
                result := add_result(DIVISOR_WIDTH-2 downto 0) & a(DIVIDEND_WIDTH-1 downto 1) & "01";
             end if;   
    return result;
    end function addcompare;


    constant zero_padded  : std_logic_vector(DIVISOR_WIDTH-2 downto 0) := (others => '0');
    signal bitcount       : integer range 0 to DIVIDEND_WIDTH;

    
begin

       
    process(clk_i, rstn_i)
    variable v_ext_div      : std_logic_vector(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto 0) := (others => '0');
    variable v_temp         : std_logic_vector(DIVIDEND_WIDTH-1 downto 0) := (others => '0');
    variable v_neg_divisor  : std_logic_vector(DIVISOR_WIDTH-1 downto 0); 
    begin
    if rstn_i = '0' then    
        v_ext_div     := (others => '0');
        v_temp        := (others => '0');
        v_neg_divisor := (others => '0');
        q_o           <= (others => '0');
        mod_o         <= (others => '0');
        bitcount      <= 0;
        valid_o       <= '0';
    elsif clk_i'event and clk_i = '0' then
        if start_i = '1' then
            v_ext_div     := zero_padded & dividend_i & '0';
            v_neg_divisor := makenegative(divisor_i);
            valid_o       <= '0';
            bitcount      <= DIVIDEND_WIDTH;
        elsif bitcount = 0 then
            valid_o   <= '1';
            q_o       <= v_temp;
            mod_o     <= '0' & v_ext_div(DIVIDEND_WIDTH+DIVISOR_WIDTH-1 downto DIVISOR_WIDTH+1);
        else
            v_ext_div := addcompare(v_ext_div, v_neg_divisor);
            v_temp    := v_temp(DIVIDEND_WIDTH-2 downto 0) & v_ext_div(0);
            bitcount  <= bitcount - 1;
        end if;
    end if;
    end process;
    
   

 
end rtl;