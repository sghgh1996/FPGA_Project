library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity motion_detector is 
  port(
  data_in : in std_logic;
  clk : in std_logic;
  reset : in std_logic;
  Err : out std_logic
  );
end motion_detector;

architecture ARCH of motion_detector is
  type states is(S0,S1,S2,S3,S4,S5);
  signal state : states := S0;
  
begin
   -- next state register
   process(clk)
   variable counter : integer range 0 to 8;
   variable tcounter : integer range 0 to 1001;   
   variable current_frame : integer range 0 to 255255;
   variable last_frame : integer range 0 to 255255;
   variable pixel : std_logic_vector(7 downto 0);
   variable comparitor : integer range 0 to 255255;
   begin
     if(rising_edge(clk)) then
       if(reset = '1') then
          counter := 0;
          tcounter := 0;
          current_frame := 0;
          last_frame := 0;
          pixel := "00000000";
          comparitor := 0;
       else
         case state is
          when S0  => --start
          if (data_in = '0')then
              state <= S0; -- it is not pixel input
          else
              state <= S1; -- have the potential to be a valid pixel input
              counter := counter + 1;
          end if;
          Err <= '0';
          when S1  => --realized pixel
          if (data_in = '1' ) then 
               counter := counter + 1; -- counting until 8
          if( counter > 7 ) then
                state <= S2;  -- start pixel input found
                counter := 0; 
          else 
                state <= S1;  -- keep counting
          end if;
          else 
               counter := 0 ;  --it is not pixel input
               state <= S0;
          end if;
          Err <= '0'; 
          when S2  => --pixel get
          counter := counter +1;
          pixel(counter - 1) := data_in;
          if(counter = 8 )then
              tcounter := tcounter +1;
              counter := 0;
              current_frame := conv_integer(pixel) + current_frame;
              if(tcounter = 1001)then
                state <= S3;    --last pixel got
                tcounter := 0;
              else
                state <= S2; -- keep getting
              end if;
          else          
              state <= S2; -- pixel not completly got
          end if;
          Err <= '0';
          when S3  => --frame get
              if(data_in = '1')then   --it is not pixel input
                  state <= S4;
                  counter := 0;  
              else
                  counter := counter +1;
                  if(counter = 8)then
                      state <= S5;  -- Successfully got a frame
                      counter := 0;
                  else
                      state <= S3;  -- keep counting
                  end if;
              end if;
              Err <= '0';
          when S4  => --error           
              state <= S0;
              current_frame := 0;
              last_frame := 0;
              Err <= '0';
          when S5  => --result     
          --comparision
              comparitor := current_frame - last_frame;
              if(comparitor > 50) then
                  Err <= '1';
              else
                  Err <= '0';
              end if;
          --updating frames data
              last_frame := current_frame;
              state <= S0;
         end case;
       end if;
     end if;
   end process;
   
end architecture;


