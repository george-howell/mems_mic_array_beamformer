----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2017 21:16:06
-- Design Name: 
-- Module Name: sevenSegDisp - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sevenSegDisp is
    port      ( RST                 : in    std_logic;                          -- reset
                CLK                 : in    std_logic;                          -- 100 MHz clock input
                SEV_SEG_SEL         : in    std_logic_vector (5 downto 0);      -- input that selects which number to display
                SEG_NUM             : out   std_logic_vector (3 downto 0);      -- selects the segment to light
                SEG_VAL             : out   std_logic_vector (6 downto 0)       -- the value that the segment displays
                );
end sevenSegDisp;

architecture Behavioral of sevenSegDisp is

---------------------- SIGNAL DECLERATION ---------------------------------
signal segVal1              : std_logic_vector (6 downto 0);
signal segVal2              : std_logic_vector (6 downto 0);
signal segVal3              : std_logic_vector (6 downto 0);
signal segVal4              : std_logic_vector (6 downto 0);

signal refreshCounter       : std_logic_vector (18 downto 0);
signal segCounter           : std_logic_vector (1 downto 0);


begin
    
    -- allocates segment values for each angle
    process (SEV_SEG_SEL)
    begin
        case (SEV_SEG_SEL) is
                
        when "000001" =>                       -- 0 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0"
            segVal3 <= "0000001"; -- "0"
            segVal4 <= "0000001"; -- "0"
       
        when "000010" =>                       -- 10 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0"
            segVal3 <= "1001111"; -- "1" 
            segVal4 <= "0000001"; -- "0"       
        
        when "000011" =>                       -- 20 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0"
            segVal3 <= "0010010"; -- "2" 
            segVal4 <= "0000001"; -- "0"       
        
        when "000100" =>                       -- 30 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0"
            segVal3 <= "0000110"; -- "3"
            segVal4 <= "0000001"; -- "0"       
         
        when "000101" =>                       -- 40 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0"
            segVal3 <= "1001100"; -- "4"
            segVal4 <= "0000001"; -- "0"       
        
        when "000110" =>                       -- 50 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0" 
            segVal3 <= "0100100"; -- "5" 
            segVal4 <= "0000001"; -- "0"   
            
        when "000111" =>                       -- 60 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0" 
            segVal3 <= "0100000"; -- "6"
            segVal4 <= "0000001"; -- "0"
            
        when "001000" =>                       -- 70 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0" 
            segVal3 <= "0001111"; -- "7"
            segVal4 <= "0000001"; -- "0"  
            
        when "001001" =>                       -- 80 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0" 
            segVal3 <= "0000000"; -- "8"
            segVal4 <= "0000001"; -- "0" 
                
        when "001010" =>                       -- 90 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000001"; -- "0" 
            segVal3 <= "0000100"; -- "9"
            segVal4 <= "0000001"; -- "0"  

        when "001011" =>                       -- 100 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1"
            segVal3 <= "0000001"; -- "0"
            segVal4 <= "0000001"; -- "0"  

        when "001100" =>                       -- 110 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "1001111"; -- "1"
            segVal4 <= "0000001"; -- "0"  

        when "001101" =>                       -- 120 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "0010010"; -- "2"
            segVal4 <= "0000001"; -- "0"  
            
        when "001110" =>                       -- 130 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "0000110"; -- "3"
            segVal4 <= "0000001"; -- "0" 
            
        when "001111" =>                       -- 140 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "1001100"; -- "4"
            segVal4 <= "0000001"; -- "0"  

        when "010000" =>                       -- 150 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "0100100"; -- "5"
            segVal4 <= "0000001"; -- "0"  
            
        when "010001" =>                       -- 160 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1"
            segVal3 <= "0100000"; -- "6"    
            segVal4 <= "0000001"; -- "0" 
            
        when "010010" =>                       -- 170 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "0001111"; -- "7"
            segVal4 <= "0000001"; -- "0"

        when "010011" =>                       -- 180 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1" 
            segVal3 <= "0000000"; -- "8"
            segVal4 <= "0000001"; -- "0"

        when "010100" =>                       -- 190 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "1001111"; -- "1"
            segVal3 <= "0000100"; -- "9"
            segVal4 <= "0000001"; -- "0" 

        when "010101" =>                       -- 200 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2" 
            segVal3 <= "0000001"; -- "0"
            segVal4 <= "0000001"; -- "0" 

        when "010110" =>                       -- 210 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2"
            segVal3 <= "1001111"; -- "1"
            segVal4 <= "0000001"; -- "0" 
            
        when "010111" =>                       -- 220 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2"
            segVal3 <= "0010010"; -- "2"
            segVal4 <= "0000001"; -- "0" 

        when "011000" =>                       -- 230 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2"
            segVal3 <= "0000110"; -- "3"
            segVal4 <= "0000001"; -- "0" 

        when "011001" =>                       -- 240 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2" 
            segVal3 <= "1001100"; -- "4"
            segVal4 <= "0000001"; -- "0" 

        when "011010" =>                       -- 250 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2"  
            segVal3 <= "0100100"; -- "5"
            segVal4 <= "0000001"; -- "0" 

        when "011011" =>                       -- 260 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2" 
            segVal3 <= "0100000"; -- "6"
            segVal4 <= "0000001"; -- "0"

        when "011100" =>                       -- 270 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2" 
            segVal3 <= "0001111"; -- "7"
            segVal4 <= "0000001"; -- "0" 
            
        when "011101" =>                       -- 280 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2" 
            segVal3 <= "0000000"; -- "8"
            segVal4 <= "0000001"; -- "0" 

        when "011110" =>                       -- 290 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0010010"; -- "2" 
            segVal3 <= "0000100"; -- "9"
            segVal4 <= "0000001"; -- "0"

        when "011111" =>                       -- 300 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000110"; -- "3" 
            segVal3 <= "0000001"; -- "0"
            segVal4 <= "0000001"; -- "0" 

        when "100000" =>                       -- 310 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000110"; -- "3" 
            segVal3 <= "1001111"; -- "1"
            segVal4 <= "0000001"; -- "0" 

        when "100001" =>                       -- 320 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000110"; -- "3" 
            segVal3 <= "0010010"; -- "2"
            segVal4 <= "0000001"; -- "0" 

        when "100010" =>                       -- 330 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000110"; -- "3" 
            segVal3 <= "0000110"; -- "3"
            segVal4 <= "0000001"; -- "5" 
        
        when "100011" =>                       -- 340 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000110"; -- "3" 
            segVal3 <= "1001100"; -- "4"
            segVal4 <= "0000001"; -- "0"               
            
        when "100100" =>                       -- 350 deg angle
            segVal1 <= "0000001"; -- "0"
            segVal2 <= "0000110"; -- "3" 
            segVal3 <= "0100100"; -- "5"
            segVal4 <= "0000001"; -- "0"             
            
        when others =>
            segVal1 <= "1111110"; -- "-"
            segVal2 <= "1111110"; -- "-"
            segVal3 <= "1111110"; -- "-"
            segVal4 <= "1111110"; -- "-"  
            
        end case;    

    end process;

    -- clock at 190HZ, used to refresh the segments
    process(CLK, RST)
    begin 
        if (RST = '1') then
            refreshCounter <= (others => '0');            
        elsif(rising_edge(CLK)) then
            refreshCounter <= refreshCounter + 1;            
        end if;
    end process;
    
    segCounter <= refreshCounter(18 downto 17);    -- 4-to-1 MUX to generate anode activating signals for 4 LEDs 
   
    -- goes through the segments setting the values for each position
    process(segCounter, segVal1, segVal2, segVal3, segVal4)
    begin
        case (segCounter) is
        
        when "00" =>                -- 1st segment
            SEG_NUM <= "0111";
            SEG_VAL <= segVal1;
            
        when "01" =>                -- 2nd segment
            SEG_NUM <= "1011";
            SEG_VAL <= segVal2;
        
        when "10" =>                -- 3rd segment
            SEG_NUM <= "1101";
            SEG_VAL <= segVal3;
        
        when "11" =>                -- 4th segment
            SEG_NUM <= "1110";
            SEG_VAL <= segVal4;
            
        when others => 
            SEG_NUM <= "0111";
            SEG_VAL <= segVal1;
        end case;
    end process;

end Behavioral;
