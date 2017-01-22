library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity command_controller is 
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
end command_controller;

architecture RTL of command_controller is
  begin
   process(clk)
   begin
    if(rising_edge(clk) and clk_en = '1') then
      case (command_in(31 downto 16)) is
			--temperature
			when "0000000000000000" => temperature <= command_in(7 downto 0);
			
			--light
			when "0000000000000001" => light_command <= '1';
			when "0000000000000010" => light_command <= '0';
			
			--sound
			when "0000000000000011" => sound_detection_enable <='1';
			when "0000000000000100" => sound_detection_enable <='0';
			
			--motion
			when "0000000000000101" => motion_detection_enable <='1';
			when "0000000000000110" => motion_detection_enable <='0';
			
			when others => 
      end case;
    end if;
   end process;   
end architecture;
