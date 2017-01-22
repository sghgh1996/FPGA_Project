library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity temperature_controller is
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
end temperature_controller;

architecture arch of temperature_controller is
  
function get_number(Value: in std_logic_vector(7 downto 0)) return integer is
begin
    case Value(7) is
		when '0' => return to_integer(unsigned(value(6 downto 0)));
		when '1' => return -1 * to_integer(unsigned(value(6 downto 0)));
		when others => return 0;
    end case;
end get_number;

begin
    process (clk)
    variable t0 , t1 , t2 , t ,ti : integer range -128 to 128;
    begin  
	  if(rising_edge(clk) and clk_en = '1') then
	    t0 := get_number(temperature_sensor_0(7 downto 0));
			t1 := get_number(temperature_sensor_1(7 downto 0));
			t2 := get_number(temperature_sensor_2(7 downto 0));
			ti := get_number(temperature(7 downto 0));
			
			-- finding the middle temperature sensors
			if(t0>t1)then
				if(t0>t2)then
					--t0 is the biggest
					if(t1>t2)then
						t:=t1;
					else
						t:=t2;
					end if;
				else
					--t2 is the biggest
					t:=t0;
				end if;
			else
				if(t1>t2)then
					--t1 is the biggest
					if(t2>t0)then
						t:=t2;
					else
						t:=t0;
					end if;
				else
					--t2 is the biggest
					t:=t1;
				end if;
			end if;
			
			--command
			if(t<Ti-4)then
				heater <='1';
				cooler <='0';
			elsif(t<Ti+2 and t>Ti-2)then
				heater <='0';
				cooler <='0';
			elsif(t>Ti+4)then
				heater <='0';
				cooler <='1';
			end if;
	  end if; -- rising edge if
    end process;	
end arch;
