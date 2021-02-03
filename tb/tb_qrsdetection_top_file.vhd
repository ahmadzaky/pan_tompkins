library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_arith.all;
    use ieee.std_logic_signed.all;
    use ieee.math_real.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
    
    entity tb_qrsdetection_top_file is
        generic ( fclock : time := 5 ms;
                  fsamp : time := 1 ms;
                  filename : string := "arr_nr05.txt");
end entity;

architecture tb of tb_qrsdetection_top_file is 

function encod (a : integer) return std_logic_vector is
variable result : std_logic_vector (7 downto 0);
variable b      : integer;
begin
    b := a/7;
    result := conv_std_logic_vector(b,8);
return result;
end function encod;


component QRSdetector_top is
port (
	reset  : in std_logic;
	clk 	 : in std_logic;
	inecg  : in std_logic_vector (7 downto 0);
	outecg : out std_logic
);
end component;

  file file_VECTORS : text;
 
  constant c_WIDTH : natural := 4;

signal ecgi : std_logic_vector (7 downto 0) ;
signal ecgo : std_logic;
signal clk, reset : std_logic;
 
 begin


     
clock : process
begin
clk <= '1' ; wait for fclock/2 ;
clk <= '0' ; wait for fclock/2 ;       
end process;      

initial : process
begin
    reset <= '1'; wait for fclock/100;
    reset <= '0'; wait;
end process;

  process
    variable v_ILINE     : line;
    variable v_MINUTES   : integer;
    variable v_SCALE     : real;
    variable v_T0        : real := 0.0;
    variable v_T1        : real;
    variable v_DELTA_T   : integer;
    variable v_IN_ECG    : real;
    variable v_MAX       : real := 0.0;
    variable v_MIN       : real := 0.0;
    variable v_RANGE     : real := 0.0;
    variable v_SPACE     : character;
    variable v_COLON     : character;
     
  begin
 
 
    file_open(file_VECTORS, filename,  read_mode);
     readline(file_VECTORS, v_ILINE);
      readline(file_VECTORS, v_ILINE);      
      readline(file_VECTORS, v_ILINE);
    while not endfile(file_VECTORS) loop           
      read(v_ILINE, v_IN_ECG);      
      readline(file_VECTORS, v_ILINE);
      read(v_ILINE, v_SPACE);      
      read(v_ILINE, v_MINUTES);
      read(v_ILINE, v_COLON);
      read(v_ILINE, v_T1);
      read(v_ILINE, v_SPACE);
      if v_IN_ECG > v_MAX then
       v_MAX      := v_IN_ECG;     	
      end if;
      if v_IN_ECG < v_MIN then
       v_MIN      := v_IN_ECG;     	
      end if;
      
    end loop;
    
    file_close(file_VECTORS);
    v_RANGE := v_MAX - v_MIN;
    
    if v_RANGE > 4.0 then
        v_SCALE := 0.2;
    elsif v_RANGE > 2.5 then
        v_SCALE := 0.5;
    elsif v_RANGE > 2.0 then
        v_SCALE := 0.7;
    elsif v_RANGE > 1.0 then
        v_SCALE := 0.8;
    else
        v_SCALE := 1.5; 
    end if;
 
    file_open(file_VECTORS, filename,  read_mode);
      readline(file_VECTORS, v_ILINE);
      readline(file_VECTORS, v_ILINE);      
      readline(file_VECTORS, v_ILINE);
    while not endfile(file_VECTORS) loop           
      read(v_ILINE, v_IN_ECG);      
      readline(file_VECTORS, v_ILINE);
      read(v_ILINE, v_SPACE);      
      read(v_ILINE, v_MINUTES);
      read(v_ILINE, v_COLON);
      read(v_ILINE, v_T1);
      read(v_ILINE, v_SPACE);
       ecgi      <= STD_LOGIC_VECTOR(CONV_SIGNED(INTEGER((v_IN_ECG*v_SCALE)*128.0),8));     	
       v_DELTA_T := INTEGER((v_T1-v_T0)*1000.0);
       v_T0      := v_T1;
      wait for v_DELTA_T*fsamp;
    end loop;
 
    file_close(file_VECTORS);
     
    wait;
  end process;
      



DUT	: QRSdetector_top
port map (
	reset  => reset,
	clk    => clk,
	inecg  => ecgi,
	outecg => ecgo
);


end architecture;

