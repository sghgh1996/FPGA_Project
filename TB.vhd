library IEEE;
use IEEE.std_logic_1164.all;


entity TB is
end entity;

architecture arch of TB is
component motion_detector is 
  port(
  data_in : in std_logic;
  clk : in std_logic;
  reset : in std_logic;
  Err : out std_logic
  );
end component;

signal s_data_in : std_logic;
signal s_clk : std_logic := '0';
signal s_reset : std_logic;
signal s_Err : std_logic;

begin
d : motion_detector port map(s_data_in, s_clk, s_reset, s_Err);
s_clk <= not s_clk after 2 ns;

s_reset <= '1', '0' after 3 ns;

s_data_in <= '1', '0' after 36 ns, '1' after 32098 ns, '0' after 64162 ns;
end architecture;
