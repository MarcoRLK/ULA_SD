----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.11.2016 11:32:44
-- Design Name: 
-- Module Name: ULA - Behavioral
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
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ULA is
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           sel : in STD_LOGIC_VECTOR (3 downto 0);
           mode: out STD_LOGIC_VECTOR (1 downto 0); -- this variable defines the presentation of the output mode (dec, hex, bin,oct)
           F : inout STD_LOGIC_VECTOR (6 downto 0);
           seg : out STD_LOGIC_VECTOR (6 downto 0));
end ULA;

architecture Behavioral of ULA is
begin

process(A,B,sel)
begin
    if sel = "0000" then
        F <= "0000";
    elsif sel = "0001" then
        F <= "1111";
    elsif sel = "0010" then
        F <= A;
    elsif sel = "0011" then
        F <= B;
    elsif sel = "0100" then
        F(0) <= A(0) or B(0);
        F(1) <= A(1) or B(1);
        F(2) <= A(2) or B(2);
        F(3) <= A(3) or B(3);
        
    elsif sel = "0101" then
        F(0) <= A(0) and B(0);
        F(1) <= A(1) and B(1);
        F(2) <= A(2) and B(2);
        F(3) <= A(3) and B(3);
        
    elsif sel = "0110" then
        F(0) <= A(0) xor B(0);
        F(1) <= A(1) xor B(1);
        F(2) <= A(2) xor B(2);
        F(3) <= A(3) xor B(3);
        
    elsif sel = "0111" then
        F(0) <= A(0);
        F(1) <= A(1);
        F(2) <= A(2);
        F(3) <= A(3);
        
    elsif sel = "1000" then
        F <= A + B;
    elsif sel = "1001" then
        F <= A - B;
    elsif sel = "1010" then
        F <= A * B;
    elsif sel = "1011" then
        F <= A / B;
    elsif sel = "1100" then
        F <= A mod B;
    elsif sel = "1101" then
        F <= A * A;
    elsif sel = "1110" then
        F <= not A;
    elsif sel = "1111" then
        F <= A + "0001";
    end if;
    
end process;

if mode = "10" then
    with F select
    seg <= "0000001" when "0000",
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
elsif mode = "11" then


end Behavioral;
