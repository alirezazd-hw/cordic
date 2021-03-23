library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity sign_val_ALU is
generic ( M : integer:= 14;		--number of I/O bits
	  N : integer := 3  --number of shift bits	
);
port(
	mode : in std_logic;				--shift or arith
	sign : in std_logic;				--sign or shift dir
	input_1 : in std_logic_vector(M downto 0);
	input_2 : in std_logic_vector(M downto 0);
	input_3 : in integer range 0 to 15;
	output : out std_logic_vector(M downto 0)
);
end entity;

architecture ALU_AR of sign_val_ALU is
begin
process(input_1 , input_2 , input_3 , mode , sign)
variable val_1 , val_2 : unsigned(M-1 downto 0);
variable sign_1 , sign_2 : std_logic;
variable tmp : unsigned(M downto 0);
begin
sign_1 := input_1(M);
val_1 := unsigned(input_1(M-1 downto 0));
sign_2 := input_2(M);
val_2 := unsigned(input_2(M-1 downto 0));
if(mode = '1') then
	if(input_3 = 0) then
		tmp := unsigned(input_1);
	elsif(sign = '1') then	--shift right
		tmp(M) := sign_1;
		tmp(M-1 downto 0) := shift_right ((val_1),natural(input_3));
		
	else			--shift left
		tmp(M) := sign_1;
		tmp(M-1 downto 0) := shift_left ((val_1),natural(input_3));
	end if;
else
	if (sign = '0') then
		if (sign_1 = '0') then
			if(sign_2 = '0') then
				tmp(M) := '0';
				tmp(M-1 downto 0) := val_1 + val_2;
			else
				if(to_integer(val_1) > to_integer(val_2)) then
					tmp(M) := '0';
					tmp(M-1 downto 0) := val_1 - val_2;
				else
					tmp(M) := '1';
					tmp(M-1 downto 0) := val_2 - val_1;
				end if;
		
			end if;
		
		else
			if(sign_2 = '0') then
				if(to_integer(val_1) > to_integer(val_2)) then
					tmp(M) := '1';
					tmp(M-1 downto 0) := val_1 - val_2;
	
				else
					tmp(M) := '0';
					tmp(M-1 downto 0) := val_2 - val_1;
				end if;
			
			else
				tmp(M) := '1';
				tmp(M-1 downto 0) := val_2 + val_1;
			end if;
		
		end if;
	else
		if(sign_1 = '0') then
			if(sign_2 = '0') then
				if(to_integer(val_1) > to_integer(val_2)) then
					tmp(M) := '0';	
					tmp(M-1 downto 0) := val_1 - val_2;
				
				else
					tmp(M) := '1';	
					tmp(M-1 downto 0) := val_2 - val_1;
				
				end if;
			else
				
				tmp(M) := '0';	
				tmp(M-1 downto 0) := val_2 + val_1;
			end if;
		else
			if(sign_2 = '0') then
				tmp(M) := '1';	
				tmp(M-1 downto 0) := val_2 + val_1;
			else
				if(to_integer(val_1) > to_integer(val_2)) then
					tmp(M) := '1';	
					tmp(M-1 downto 0) := val_1 - val_2;
				
				else
					tmp(M) := '0';	
					tmp(M-1 downto 0) := val_2 - val_1;
				end if;
			end if;
		end if;
	end if;
end if;
output <= std_logic_vector(tmp);
end process;
end architecture;


--------------------test bench
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity test_sign_val_ALU is
generic ( M : integer:= 14;		--number of I/O bits
	  N : integer := 3  --number of shift bits	
);
end entity;

architecture tb of test_sign_val_ALU is
signal	tb_mode :  std_logic;				--shift or arith
signal 	tb_sign :  std_logic;				--sign or shift dir
signal  tb_input_1 :  std_logic_vector(M downto 0);
signal  tb_input_2 :  std_logic_vector(M downto 0);
signal 	tb_input_3 :  integer range 0 to 15;
signal 	tb_output :  std_logic_vector(M downto 0);
begin
p0: entity work.sign_val_ALU(ALU_AR) port map(mode => tb_mode , sign => tb_sign , input_1 => tb_input_1 , input_2 => tb_input_2 , input_3 => tb_input_3 , output => tb_output);
tb_mode <= '0';
tb_sign <= '1' ,'0' after 60 ns;
tb_input_1 <= "000000000001010" , "100000000001010" after 10 ns , "000000000001010" after 20 ns , "100000000001010" after 30 ns , "000000000001100" after 40 ns , "100000000001100" after 50 ns , "000000000001100" after 60 ns , "100000000001100" after 70 ns;
tb_input_2 <= "000000000001100" , "000000000001100" after 10 ns , "100000000001100" after 20 ns , "100000000001100" after 30 ns , "000000000001010" after 40 ns , "000000000001010" after 50 ns , "100000000001010" after 60 ns , "100000000001010" after 70 ns;
tb_input_3 <= 0 , 3 after 60 ns;
end tb;


