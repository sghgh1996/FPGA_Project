library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity light_controller is 
	port
	(
		data_in : in std_logic;
		command_in : in std_logic;
		clk : in std_logic;
		clk_en : in std_logic;
		rst : in std_logic;
		light_out : out std_logic
	);
end light_controller;

architecture RTL of light_controller is
begin
    process(clk)
    begin
	    if(rising_edge(clk) and clk_en = '1') then
	    	if(rst = '1') then -- synchronized reset
	    		light_out <= '0';
	    	else
	    		if(command_in = '1')then
		        	if(data_in = '1')then
		            	light_out <= '0';
		        	else
		            	light_out <= '1';
	        		end if;
	    		else  
	        		light_out <='0';
	    		end if;
	    	end if; -- reset if
	    end if; -- rising edge if
    end process;
end architecture;
