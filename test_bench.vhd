library IEEE;
use IEEE.std_logic_1164.all;

entity TB is
end entity;

architecture arch of TB is
component hardware is 
	port
	(
		command : in std_logic_vector (31 downto 0);
		light_sensor : in std_logic;
		temperature_sensor_0 : in std_logic_vector (7 downto 0);
		temperature_sensor_1 : in std_logic_vector (7 downto 0);  
		temperature_sensor_2 : in std_logic_vector (7 downto 0);
		camera: in std_logic;
		--  sound : in 
		clk : in std_logic;
		rst : in std_logic;

		--micro blaze out:
		motion_detected : out std_logic ;
		sound_detected : out std_logic;
		--hard out
		light : out std_logic;
		cooler : out std_logic;
		heater : out std_logic
	);
end component;

signal s_command : std_logic_vector (31 downto 0);
signal s_light_sensor : std_logic;
signal s_temperature_sensor_0 : std_logic_vector (7 downto 0);
signal s_temperature_sensor_1 : std_logic_vector (7 downto 0);
signal s_temperature_sensor_2 : std_logic_vector (7 downto 0);
signal s_camera : std_logic;
signal s_clk : std_logic := '0';
signal s_reset : std_logic;
signal s_motion_detected : std_logic;
signal s_sound_detected : std_logic;
signal s_light : std_logic;
signal s_cooler : std_logic;
signal s_heater : std_logic;

begin
hw : hardware port map (
s_command, s_light_sensor, s_temperature_sensor_0, 
s_temperature_sensor_1, s_temperature_sensor_2, s_camera, s_clk, s_reset, 
s_motion_detected, s_sound_detected, s_light, s_cooler, s_heater
);

s_clk <= not s_clk after 2 ns; -- clock signal
s_reset <= '1', '0' after 3 ns; 
s_camera <= '0';
s_temperature_sensor_0 <= "00100111"; -- 39
s_temperature_sensor_1 <= "00100101"; -- 37
s_temperature_sensor_2 <= "00100010"; -- 34

s_command <= (16 => '1', others => '0'), -- light on
             (17 => '1', others => '0') after 12 ns, -- light off
             (1 => '1', 3 => '1', 5 => '1', others => '0') after 16 ns, -- 42
             (0 => '1', 2 => '1', 5 => '1', others => '0') after 20 ns, -- 37
             (4 downto 0 => '1', others => '0') after 24 ns -- 31
             ;
s_light_sensor <= '0', '1' after 8 ns;

--s_data_in <= '1', '0' after 36 ns, '1' after 32098 ns, '0' after 64162 ns;
end architecture;
