library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity hardware is 
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
end hardware;

architecture RTL of hardware is

component motion_detector is 
	port
	(
		data_in : in std_logic;
		clk : in std_logic;
		clk_en : in std_logic;
		reset : in std_logic;
		Err : out std_logic
	);
end component;

component light_controller is 
	port
	(
		data_in : in std_logic;
		command_in : in std_logic;
		clk : in std_logic;
		clk_en : in std_logic;
		rst : in std_logic;
		light_out : out std_logic
	);
end component;

component command_controller is 
	port
	(
		command_in : in std_logic_vector (31 downto 0);
		clk : in std_logic;
		clk_en : in std_logic;

		temperature : out std_logic_vector (7 downto 0);
		light_command: out std_logic;
		motion_detection_enable: out std_logic; -- on : 1, off : 0
		sound_detection_enable: out std_logic   -- on : 1, off : 0
	);
end component;

component temperature_controller is
	port
	(
		temperature_sensor_0:	in std_logic_vector(7 downto 0);
		temperature_sensor_1:	in std_logic_vector(7 downto 0);
		temperature_sensor_2:	in std_logic_vector(7 downto 0);
		temperature : in std_logic_vector(7 downto 0);
		clk : in std_logic;
		clk_en : in std_logic;
		
		heater:	out std_logic;
		cooler:	out std_logic
	);
end component;

signal motion_detection_enable, sound_detection_enable : std_logic;
signal temperature : std_logic_vector(7 downto 0);
signal motion_detector_reset : std_logic;   
signal light_command : std_logic;

begin
cc : command_controller port map (command(31 downto 0), clk, '1', temperature, 
light_command, motion_detection_enable, sound_detection_enable);

lc : light_controller port map (light_sensor, light_command, clk, '1', rst, light);

mc : motion_detector port map (camera, clk, motion_detection_enable, rst, motion_detected);
  
tc : temperature_controller port map (temperature_sensor_0, temperature_sensor_1, 
temperature_sensor_2, temperature, clk, '1', heater, cooler);
end architecture;
