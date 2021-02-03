library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity square is
    generic( dwidth : integer := 16);
    port (
        insq  : in std_logic_vector (dwidth-1 downto 0);
        outsq : out std_logic_vector (dwidth-1 downto 0));
end entity;

architecture rtl of square is
	
	function squaring (a : std_logic_vector (dwidth-1 downto 0)) return std_logic_vector is
		variable d : std_logic_vector ((dwidth*2)-1 downto 0);
		variable result : std_logic_vector (dwidth-1 downto 0);
		begin
			d := a * a;
			result := d (dwidth+4 downto 5);
		return result;
	end function squaring;

begin

	outsq <= squaring (insq) ;

end architecture;