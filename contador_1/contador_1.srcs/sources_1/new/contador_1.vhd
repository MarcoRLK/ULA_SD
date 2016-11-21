library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_unsigned.ALL;

entity contador_1 is
    Port ( clk_in : in std_logic;
           reset : in std_logic;
           updown : in std_logic;
           Display : out std_logic_vector(6 downto 0);
           an : out std_logic_vector(3 downto 0)
    );
end contador_1;

architecture Behavioral of contador_1 is
signal count : std_logic_vector (3 downto 0) := "0000";
signal clk : std_logic := '0';

begin

an(0) <= '0';
an(1) <= '1';
an(2) <= '1';
an(3) <= '1';

-- Dividir o clock

process(clk_in)
    variable contador : natural;
begin
    if rising_edge(clk_in) then
        contador := contador + 1;
        if contador = 50000000 then
            contador := 0;
            clk <= not clk;
        end if;
    end if;
end process;


process(clk,reset,count)
begin 
   if rising_edge(clk) then
    if reset = '1' then
        count <= "0000";
    elsif updown = '1' then
        count <= count + '1';
        if count = "1001" then
            count <= "0000";
        end if;
    elsif updown = '0' then
        count <= count - '1';
        if count = "0000" then
            count <= "1001";
        end if;
--    if count > "1001" then
--            count <= "0000";
--        elsif count < "0000" then
--           count <= "1001";
--       end if;    
    end if;
    
  end if;
end process;

with count select
    Display <= "0000001" when "0000",
                "1001111" when "0001",
                "0010010" when "0010",
                "0000110" when "0011",
                "1001100" when "0100",
                "0100100" when "0101",
                "0100000" when "0110",
                "0001111" when "0111",
                "0000000" when "1000",
                "0000100" when "1001",
                "1111111" when others;
                

end Behavioral;
