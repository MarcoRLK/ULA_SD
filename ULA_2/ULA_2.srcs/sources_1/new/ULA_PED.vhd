----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.11.2016 20:31:55
-- Design Name: 
-- Module Name: ULA_PED - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ULA_PED is
    Port ( clk : in STD_LOGIC;
             A : in STD_LOGIC_VECTOR (3 downto 0);
             B : in STD_LOGIC_VECTOR (3 downto 0);
             sel : in STD_LOGIC_VECTOR (3 downto 0);
             mode: in STD_LOGIC_VECTOR (1 downto 0); -- this variable defines the presentation of the output mode (dec, hex, bin,oct)
             seg : out STD_LOGIC_VECTOR (6 downto 0);
             an: out STD_LOGIC_VECTOR (0 to 3));
end ULA_PED;

architecture Behavioral of ULA_PED is
    signal digit_pattern_array : std_logic_vector(6 downto 0) := "0000000";
    signal current_segment : std_logic_vector(1 downto 0) := "00";
    signal cathode_select : std_logic_vector(3 downto 0) := "0000";
    signal count : std_logic_vector(22 downto 0) := "00000000000000000000000";
    signal MUX_CLK : std_logic;
    signal temp4 : std_logic_vector(3 downto 0);
    signal temp8 : std_logic_vector(7 downto 0);
    signal temp8a : std_logic_vector(7 downto 0) := "00000000";
    signal temp8b : std_logic_vector(7 downto 0) := "00000000";
    signal temp16 : std_logic_vector(15 downto 0);
    signal error : std_logic;
    signal hex1 : std_logic_vector (3 downto 0);
    signal hex2 : std_logic_vector (3 downto 0);
    signal hex3 : std_logic_vector (3 downto 0);
    signal hex4 : std_logic_vector (3 downto 0);
    signal F : std_logic_vector (3 downto 0);
    signal R : std_logic_vector (3 downto 0);
    signal Auns, Buns, Quns, Runs: unsigned(3 downto 0);

begin clock_divider: process(clk)
begin
     if rising_edge(clk) then
        count <= count + 1;
     end if;
    
     MUX_CLK <= count(15);
end process;

process(A,B,sel)
    --variable cnt   : std_logic_vector(3 downto 0);
    --variable Atemp   : std_logic_vector(3 downto 0);
    --variable R   : std_logic_vector(3 downto 0);
begin



     if sel = "0000" then --ZERA
         F <= "0000";
         error <= '0';
     elsif sel = "0001" then --TUDO UM
         F <= "1111";
         error <= '0';
     elsif sel = "0010" then --OP A
         F <= A;
         error <= '0';
     elsif sel = "0011" then --OP B
         F <= B;
         error <= '0';
     elsif sel = "0100" then --OR(A,B) BIT A BIT
         F(0) <= A(0) or B(0);
         F(1) <= A(1) or B(1);
         F(2) <= A(2) or B(2);
         F(3) <= A(3) or B(3);
         error <= '0';
     elsif sel = "0101" then --AND(A,B) BIT A BIT
         F(0) <= A(0) and B(0);
         F(1) <= A(1) and B(1);
         F(2) <= A(2) and B(2);
         F(3) <= A(3) and B(3);
         error <= '0';
     elsif sel = "0110" then --XOR(A,B) BIT A BIT
         F(0) <= A(0) xor B(0);
         F(1) <= A(1) xor B(1);
         F(2) <= A(2) xor B(2);
         F(3) <= A(3) xor B(3);
         error <= '0';
     elsif sel = "0111" then --NOT A
         F(0) <= not A(0);
         F(1) <= not A(1);
         F(2) <= not A(2);
         F(3) <= not A(3);
         error <= '0';
     elsif sel = "1000" then --SOMA (A + B)
         -- usa-se variáveis temporárias de 8 bits para detectar o overflow sem bugar
         temp8a(0) <= A(0);
         temp8a(1) <= A(1);
         temp8a(2) <= A(2);
         temp8a(3) <= A(3);
         temp8b(0) <= B(0);
         temp8b(1) <= B(1);
         temp8b(2) <= B(2);
         temp8b(3) <= B(3);
         temp8 <= temp8a + temp8b;
         if temp8 > "00001111" then --overflow dos 4 bits
             error <= '1';
             F <= "0000";
         elsif temp8 < "00010000" then
             F <= A + B;
             error <= '0';
         end if;
     elsif sel = "1001" then --SUBT (A - B)
         if A > B then
             F <= A - B;
             error <= '0';
         elsif B > A then -- Erro se o B for maior que A
             error <= '1';
         elsif B = A then
             F <= "0000";
             error <= '0';
         end if;
     elsif sel = "1010" then -- MULT ( A*B )
         temp8 <= A * B;
         if temp8 > "1111" then -- Overflow
             F <= "0000";
             error <= '1';
         elsif temp8 < "10000" then
             F(0) <= temp8(0);
             F(1) <= temp8(1);
             F(2) <= temp8(2);
             F(3) <= temp8(3);
             error <= '0';
         end if;
     elsif sel = "1011" then -- DIV (A/B)
        --F <= conv_std_logic_vector(A / B, 4);
        --error <= '1';
        --cnt   := "0000";
        --Atemp := A;
        --while (Atemp >= B) loop
        --  Atemp := (Atemp - B);
        --  cnt   := cnt + "0001";
        --end loop;
        --F <= cnt; --O contador é a resposta da divisão
        --R := Atemp; --Resto
        Auns <= unsigned(A);
          Buns <= unsigned(B);
          --Do the division:
          Quns <= Auns/Buns;
          Runs <= Auns rem Buns; --Or: Runs <= Auns - resize(Quns*Buns, size);
          F <= std_logic_vector(Quns);
          R <= std_logic_vector(Runs); 
     
     elsif sel = "1100" then -- MOD (A mod B)
        --F <= conv_std_logic_vector(A mod B, 4);
        --error <= '1';
                Auns <= unsigned(A);
          Buns <= unsigned(B);
          --Do the division:
          Quns <= Auns/Buns;
          Runs <= Auns rem Buns; --Or: Runs <= Auns - resize(Quns*Buns, size);

          F <= std_logic_vector(Runs); 
        
     elsif sel = "1101" then -- QUADRADO DE A
         temp8 <= A * A;
         if temp8 > "00001111" then -- Overflow
            F <= "0000";
            error <= '1';
         elsif temp8 < "00010000" then
             F(0) <= temp8(0);
             F(1) <= temp8(1);
             F(2) <= temp8(2);
             F(3) <= temp8(3);
             error <= '0';
         end if;
     elsif sel = "1110" then -- NEGA A
        F <= not A;
        error <= '0';
     elsif sel = "1111" then -- ADD1 (A+1) Complemento de 1
         if A < "1111" then
             F <= A + "0001";
             error <= '0';
         elsif A = "1111" then
             error <= '1';
             F <= "0000";
         end if;
     end if;
    
end process;

process(F)
    begin
    if error = '0' then
        case F(0) is
             when '0' => hex1 <= "0000";
             when '1' => hex1 <= "0001";
             when others => NULL;
        end case;
        case F(1) is
             when '0' => hex2 <= "0000";
             when '1' => hex2 <= "0001";
             when others => NULL;
        end case;
        case F(2) is
             when '0' => hex3 <= "0000";
             when '1' => hex3 <= "0001";
             when others => NULL;
        end case;
        case F(3) is
             when '0' => hex4 <= "0000";
             when '1' => hex4 <= "0001";
             when others => NULL;
        end case;
    elsif error = '1' then -- Alterar junto com o vetor DOWNTO - deve estar de trás pra frente
         hex1 <= "0000";
         hex2 <= "1111";
         hex3 <= "1111";
         hex4 <= "1110";
    end if;
    
end process;

BCD_convert: process(MUX_CLK) is
variable current_BCD_digit : std_logic_vector(3 downto 0);
begin
     
     if rising_edge(MUX_CLK) then
         current_segment <= current_segment + 1;
         case current_segment is
             when "00" => current_BCD_digit := hex1;
                cathode_select <= "0111";
             when "01" => current_BCD_digit := hex2;
                cathode_select <= "1011";
             when "10" => current_BCD_digit := hex3;
                cathode_select <= "1101";
             when "11" => current_BCD_digit := hex4;
                cathode_select <= "1110";
             when others => null;
         end case;
        
         case current_BCD_digit is --ALTERAR junto com o vetor "DOWNTO".
             when "0000" => digit_pattern_array <= "1000000";
             when "0001" => digit_pattern_array <= "1111001";
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
             when "1110" => digit_pattern_array <= "0000100";
             when "1111" => digit_pattern_array <= "1001110";
             when others => null;
         end case;
        
     end if;
end process;
    seg <= digit_pattern_array;
    an <= cathode_select;
end Behavioral;
