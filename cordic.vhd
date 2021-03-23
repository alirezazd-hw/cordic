library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity cordic is
generic ( M : integer:= 14);	--number of I/O bits
port 
(
	clk : in std_logic;
	sinus : out std_logic_vector(M downto 0);
	co_sinus : out std_logic_vector(M downto 0);
	ALU_mode :  out std_logic;
	ALU_sign : out std_logic;
	ALU_output_1 :  out std_logic_vector(M downto 0);
	ALU_output_2 :  out std_logic_vector(M downto 0);
	ALU_output_3 :  out integer range 0 to M+1;
	ALU_input :  in std_logic_vector(M downto 0);
	X_0 : in std_logic_vector(M downto 0);
	Y_0 : in std_logic_vector(M downto 0);
	Z_0 : in integer range -9000 to 9000
);
end entity;

architecture cordic_AR of cordic is
type ROM is array (0 to 13) of integer range 0 to 4500;
constant LUT:ROM := (4500, 2656 , 1403 , 712 , 357 , 178 , 89 , 44 , 22 , 11 , 5 , 2 , 1 , 0);
signal load : std_logic := '0';
begin
process (clk)
variable x_i , y_i : std_logic_vector(M downto 0) := "000000000000000";
variable x_p : std_logic_vector(14 downto 0);
variable y_p : std_logic_vector(14 downto 0);
variable z_p : integer range -27000 to 45000;
variable z_i : integer range -27000 to 45000;
variable tmp : std_logic_vector(M downto 0);
variable d_i : std_logic := '1';
variable i : integer range 0 to M+1 := 0;
variable step_count : integer range 1 to 6 := 1;
begin
if(clk ='1' and load ='1') then
	if (z_p < 0) then
		d_i := '0';
	else
		d_i := '1';
	end if;
	
	if (i < M)then
		if( d_i = '0' ) then
			if(step_count = 1) then		
				x_p := X_0;
				y_p := Y_0;
				z_p := Z_0;
				step_count := step_count+1;
			elsif(step_count =2) then    	--x_i := x_p + shift_right((y_p),i);		
				z_i := z_p + LUT(i);    --z_i := z_p + LUT(i);
				ALU_mode <= '1';		
				ALU_sign <= '1';
				ALU_output_3 <= i;
				ALU_output_1 <=  y_p;
				step_count := step_count+1;
			elsif(step_count =3) then    	--x_i := x_p + shift_right((y_p),i);	
				tmp := ALU_input;
				ALU_output_1 <= tmp;
				ALU_mode <= '0';
				ALU_sign <= '0';
				ALU_output_2 <= x_p;
				step_count := step_count+1;
					------------------------------------------------------------------------
			elsif(step_count =4) then
				x_i := ALU_input;
				ALU_mode <= '1';			--y_i := y_p - shift_right((x_p),i);
				ALU_sign <= '1';
				ALU_output_3 <= i;
				ALU_output_1 <=  x_p;
				step_count := step_count+1;
			elsif(step_count = 5) then
				tmp := ALU_input;
				ALU_output_2 <=tmp;
				ALU_mode <= '0';
				ALU_sign <= '1';
				ALU_output_1 <= y_p;
				step_count := step_count+1;
			else
				y_i := ALU_input;
				i := i+1;
				z_p := z_i;
				x_p := x_i;
				y_p := y_i;
				step_count := 2;
			end if;	------------------------------------------------------------------------
		else
			if(step_count = 1) then 	
				x_p := X_0;
				y_p := Y_0;
				z_p := Z_0;
				step_count := step_count+1;
				------------------------------------------------------------------------
			elsif(step_count = 2) then			--x_i := x_p - shift_right((y_p),i);
				z_i := z_p - LUT(i);             	--z_i := z_p - LUT(i);
				ALU_mode <= '1';			
				ALU_sign <= '1';
				ALU_output_3 <= i;
				ALU_output_1 <=  y_p;
				step_count := step_count+1;	
			elsif(step_count = 3) then
				tmp := ALU_input;
				ALU_output_2 <= tmp;		
				ALU_mode <= '0';
				ALU_sign <= '1';
				ALU_output_1 <= x_p;
				step_count := step_count+1;
				------------------------------------------------------------------------
			elsif(step_count = 4) then
				x_i := ALU_input;
				ALU_mode <= '1';			--y_i := y_p + shift_right((x_p),i);
				ALU_sign <= '1';
				ALU_output_3 <= i;
				ALU_output_1 <=  x_p;
				step_count := step_count+1;				
			elsif(step_count = 5) then
				tmp := ALU_input;
				ALU_output_2 <= tmp;
				ALU_sign <= '0';
				ALU_mode <= '0';
				ALU_output_1 <= y_p;
				step_count := step_count+1;
			else
				y_i := ALU_input;
				i := i+1;
				z_p := z_i;
				x_p := x_i;
				y_p := y_i;
				step_count := 2;
			end if;	------------------------------------------------------------------------
		end if;
	else
		sinus <= y_i;
		co_sinus <= x_i;
	end if;	
end if;
end process;
process (Z_0)
begin
	load <= '1';
end process;
end architecture;



------------------------Test Bench-----------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
entity test_CORDIC is
end entity;

architecture tb of test_CORDIC is
signal tb_clk : std_logic := '0';
signal tb_sinus : std_logic_vector(14 downto 0);
signal tb_co_sinus : std_logic_vector(14 downto 0);
signal tb_theta : std_logic_vector(14 downto 0) := "000111000101110";
signal tb_ALU_mode : std_logic;
signal tb_ALU_sign : std_logic;
signal tb_ALU_output_1 : std_logic_vector(14 downto 0);
signal tb_ALU_output_2 : std_logic_vector(14 downto 0);
signal tb_ALU_output_3 : integer range 0 to 15;
signal tb_ALU_input : std_logic_vector(14 downto 0);
begin
--p0: entity work.cordic(cordic_AR) port map(tb_clk ,tb_sinus ,tb_co_sinus ,tb_theta , tb_ALU_mode,tb_ALU_sign,tb_ALU_output_1, tb_ALU_output_2 , tb_ALU_output_3 ,tb_ALU_input);
p1 : process
begin
wait for 50 ns;
tb_clk <=  not tb_clk;
end process;
end tb;
