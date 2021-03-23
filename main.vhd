library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity main is
port 
(
	sinus : out std_logic_vector(14 downto 0);
	co_sinus : out std_logic_vector(14 downto 0));
end entity;
architecture main_ar of main is

signal s0 : std_logic :='1';	-- clock
signal s1 : std_logic; --ALU_mode
signal s2 : std_logic; --ALU_sign
signal s3 : std_logic_vector(14 downto 0); --ALU_input_1
signal s4 : std_logic_vector(14 downto 0); --ALU_input_2?
signal s5 : integer range 0 to 15; --ALU_input_3
signal s6 : std_logic_vector(14 downto 0); --ALU_output
signal s7 : std_logic_vector(14 downto 0); --X_0 
signal s8 : std_logic_vector(14 downto 0); --Y_0
signal s9 : integer range -27000 to 45000; --Z_0
signal s10 : integer range -18000 to 18000 := 45; --*THETA INPUT range -180.00 to 180.00 degrees
begin

ALU: entity work.sign_val_ALU(ALU_AR) port map(s1,s2,s3,s4,s5,s6);
IO : entity work.IO_corrector(IO_AR) port map(s10,s7,s8,s9);
CORDIC: entity work.cordic(cordic_AR) port map(s0,sinus,co_sinus,s1,s2,s3,s4,s5,s6,s7,s8,s9);
clk: process
begin
wait for 20 ns;
s0 <= not s0;
end process;
end architecture;