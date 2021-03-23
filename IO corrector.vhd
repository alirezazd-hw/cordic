library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity IO_corrector is
generic ( M : integer:= 14);	--number of I/O bits
port 
(
	theta : in integer range -18000 to 18000;
	X_prime_0 : out std_logic_vector(M downto 0);
	Y_prime_0 : out std_logic_vector(M downto 0);
	Z_prime_0 : out integer range -9000 to 9000
);

end entity;

architecture IO_AR of IO_corrector is
begin
process (theta)
begin
if(theta > 9000) then
	X_prime_0 <= "000000000000000";
	Y_prime_0 <= "001011110110111";
	Z_prime_0 <=  theta - 9000;
elsif(theta < -9000) then
	X_prime_0 <= "000000000000000";
	Y_prime_0 <= "101011110110111";
	Z_prime_0 <=  theta + 9000;
else
	X_prime_0 <= "001011110110111";
	Y_prime_0 <= "000000000000000";
	Z_prime_0 <= theta;
end if;
end process;
end architecture;






