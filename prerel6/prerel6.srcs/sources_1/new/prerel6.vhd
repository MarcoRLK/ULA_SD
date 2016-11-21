library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HEX_to_SSEG is
    Port ( 	clk : in  STD_LOGIC;
			hex1 : in  STD_LOGIC_VECTOR (3 downto 0);
			hex2 : in  STD_LOGIC_VECTOR (3 downto 0);
			hex3 : in  STD_LOGIC_VECTOR (3 downto 0);
			hex4 : in  STD_LOGIC_VECTOR (3 downto 0);	
			seg: out STD_LOGIC_VECTOR (0 to 6);				
			an:  out STD_LOGIC_VECTOR (0 to 3));	   
end HEX_to_SSEG;
			  
architecture Behavioral of HEX_to_SSEG is
-- digit_pattern_array holds the bit pattern of the current_BCD_digit being processed.
 signal digit_pattern_array  : std_logic_vector(6 downto 0) := "0000000";
-- current_segment selects one of the four SSEG display anodes.
 signal current_segment   : std_logic_vector(1 downto 0) := "00";
-- cathode_select is a bit pattern to drive the corresponding anode, it is a bit select version of current_segment.
 signal cathode_select   : std_logic_vector(3 downto 0) := "0000";
 
-- count for process clock_divider.
 signal count      : std_logic_vector(22 downto 0) := "00000000000000000000000";
-- MUX_CLK is the clock_divider'd clock.
 signal MUX_CLK      : std_logic;
 
 begin clock_divider: process(clk)
   begin 
    if rising_edge(clk) then
     -- increment count.
     count <= count + 1;
    end if;
    
    MUX_CLK <= count(15);
   end process; -- clock_divider
	
 ----------------------
  -- Continually converts BCD to SSEG patterns and sends to SSEG.
  BCD_convert: process(MUX_CLK) is
   
   -- Holds copy of BCD_x for convinence (less case statments).
   variable current_BCD_digit    : std_logic_vector(3 downto 0);
   
   begin	
    if rising_edge(MUX_CLK) then
     -- the current_segment is incremented every rising_edge(nMHZ_CLK).  
    current_segment <= current_segment + 1;
    
    -- Use current_segment to load the appropriate BCD number into current_BCD_digit and pattern into cathode_select.
    case current_segment is
     when "00" =>  current_BCD_digit := hex1;
          cathode_select <= "0111";         
     when "01" => current_BCD_digit := hex2;
          cathode_select <= "1011"; 
     when "10" =>  current_BCD_digit := hex3;
          cathode_select <= "1101"; 
     when "11" => current_BCD_digit := hex4;
          cathode_select <= "1110"; 
     when others => null;     
    end case; 
      
   -- Read incoming current_BCD_digit and convert to digit_pattern_array.
   case current_BCD_digit is
    when "0000" => digit_pattern_array <= "0000001";
    when "0001" => digit_pattern_array <= "1001111";
    when "0010" => digit_pattern_array <= "0010010";
    when "0011" => digit_pattern_array <= "0000110";
    when "0100" => digit_pattern_array <= "1001100";
    when "0101" => digit_pattern_array <= "0100100";
    when "0110" => digit_pattern_array <= "0100000";
    when "0111" => digit_pattern_array <= "0001111";
    when "1000" => digit_pattern_array <= "0000000";
    when "1001" => digit_pattern_array <= "0001100";
    when "1010" => digit_pattern_array <= "0001000";
    when "1011" => digit_pattern_array <= "1100000";
    when "1100" => digit_pattern_array <= "0110001";
    when "1101" => digit_pattern_array <= "1000010";
    when "1110" => digit_pattern_array <= "0110000";
    when "1111" => digit_pattern_array <= "0111000";
    when others => null;
   end case;    
  
  end if; -- rising_edge(MUX_CLK) 
 end process;  
  

 -- Keep each segment cathode updated according to digit_pattern_array.
seg <= digit_pattern_array;
 
 -- Keep each anode updated according to cathode_select.
an <= cathode_select;


 
end Behavioral;