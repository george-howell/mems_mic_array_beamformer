----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2020 23:26:35
-- Design Name: 
-- Module Name: pdm2bitDecode - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

use work.instruction_buffer_type.all;

-----------------------------------------------------------------------------
-------------------------- IO DECLERATIONS ----------------------------------
-----------------------------------------------------------------------------

entity pdm2bitDecode is
    generic   ( PDM_BIT1_OFFSET_VAL : integer       := 2;      -- this is the number of sys clk cycles before mic1 pdm data is captured
                PDM_BIT2_OFFSET_VAL : integer       := 7       -- this is the number of sys clk cycles before mic1 pdm data is captured
                );
    port      ( RST                 : in    std_logic;          -- system reset
                CLK                 : in    std_logic;          -- system clk
                CLK_PDM_CE          : in    std_logic;          -- pdm clock enable
                -- PDM DATA
                PDM_DIN_1           : in    std_logic;           -- pdm data input pair 1
                PDM_DIN_2           : in    std_logic;           -- pdm data input pair 2
                PDM_DIN_3           : in    std_logic;           -- pdm data input pair 3
                PDM_DIN_4           : in    std_logic;           -- pdm data input pair 4
                PDM_2BIT_DOUT       : out   vector_of_stdLogVec2bit (0 to 7)  -- pdm data output in 2 bit format
                );
end pdm2bitDecode;

architecture Behavioral of pdm2bitDecode is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- pdm offset count
signal pdmOffsetCnt                 : integer range 0 to 20;
signal pdmBit1Flg                   : std_logic;
signal pdmBit2Flg                   : std_logic;

-- pdm latch signals
signal pdmLatch1                    : std_logic;
signal pdmLatch2                    : std_logic;
signal pdmLatch3                    : std_logic;
signal pdmLatch4                    : std_logic;
signal pdmLatch5                    : std_logic;
signal pdmLatch6                    : std_logic;
signal pdmLatch7                    : std_logic;
signal pdmLatch8                    : std_logic;

-- pdm output signals
signal pdm2Bit1Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit2Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit3Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit4Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit5Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit6Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit7Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit8Tmp                  : std_logic_vector (1 downto 0);
signal pdm2Bit1                     : std_logic_vector (1 downto 0);
signal pdm2Bit2                     : std_logic_vector (1 downto 0);
signal pdm2Bit3                     : std_logic_vector (1 downto 0);
signal pdm2Bit4                     : std_logic_vector (1 downto 0);
signal pdm2Bit5                     : std_logic_vector (1 downto 0);
signal pdm2Bit6                     : std_logic_vector (1 downto 0);
signal pdm2Bit7                     : std_logic_vector (1 downto 0);
signal pdm2Bit8                     : std_logic_vector (1 downto 0);

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

    --------------------------------- PDM OFFSET --------------------------------------
    
    -- pdm offset state process
    process (RST, CLK)
    begin
        if (RST = '1') then
            pdmOffsetCnt <= 0; 
        elsif (rising_edge(CLK)) then
            if (CLK_PDM_CE = '1') then
                pdmOffsetCnt <= 0;
            else
                pdmOffsetCnt <= pdmOffsetCnt + 1;
            end if; 
        end if;
    end process;
    
    -- PDM OFFSET FLAG
    pdmBit1Flg <= '1' when (pdmOffsetCnt = PDM_BIT1_OFFSET_VAL) else '0';
    pdmBit2Flg <= '1' when (pdmOffsetCnt = PDM_BIT2_OFFSET_VAL) else '0';
    
    --------------------------------- PDM LATCH ---------------------------------------
    
    -- PDM DATA LATCH PROCESS
    -- latches the PDM input data on the offset
    process (RST, CLK)
    begin
        if (RST = '1') then
            pdmLatch1 <= 'U'; 
            pdmLatch2 <= 'U';
            pdmLatch3 <= 'U'; 
            pdmLatch4 <= 'U';
            pdmLatch5 <= 'U'; 
            pdmLatch6 <= 'U';
            pdmLatch7 <= 'U'; 
            pdmLatch8 <= 'U';        
        elsif (rising_edge(CLK)) then -- latches pdm data from the mics at the offset flag
            if (pdmBit1Flg = '1') then
                pdmLatch1 <= PDM_DIN_1;
                pdmLatch3 <= PDM_DIN_2;
                pdmLatch5 <= PDM_DIN_3;
                pdmLatch7 <= PDM_DIN_4;
            elsif (pdmBit2Flg = '1') then
                pdmLatch2 <= PDM_DIN_1;
                pdmLatch4 <= PDM_DIN_2;
                pdmLatch6 <= PDM_DIN_3;
                pdmLatch8 <= PDM_DIN_4;                
            end if;
        end if;
    end process;
    
    
    -- CONVERTS DATA TO 2 BITS
    pdm2Bit1Tmp <=   "01" when (pdmLatch1 = '1') else
                     "11" when (pdmLatch1 = '0') else
                     "00"; 
    
    pdm2Bit2Tmp <=   "01" when (pdmLatch2 = '1') else
                     "11" when (pdmLatch2 = '0') else
                     "00"; 
                        
    pdm2Bit3Tmp <=   "01" when (pdmLatch3 = '1') else
                     "11" when (pdmLatch3 = '0') else
                     "00"; 
    
    pdm2Bit4Tmp <=   "01" when (pdmLatch4 = '1') else
                     "11" when (pdmLatch4 = '0') else
                     "00"; 
                      
    pdm2Bit5Tmp <=   "01" when (pdmLatch5 = '1') else
                     "11" when (pdmLatch5 = '0') else
                     "00"; 
    
    pdm2Bit6Tmp <=   "01" when (pdmLatch6 = '1') else
                     "11" when (pdmLatch6 = '0') else
                     "00"; 
    
    pdm2Bit7Tmp <=   "01" when (pdmLatch7 = '1') else
                     "11" when (pdmLatch7 = '0') else
                     "00"; 
    
    pdm2Bit8Tmp <=   "01" when (pdmLatch8 = '1') else
                     "11" when (pdmLatch8 = '0') else
                     "00";
                         
    --------------------------------- PDM OUTPUT --------------------------------------
    
    process (RST, CLK)
    begin
        if (RST = '1') then
            pdm2Bit1 <= (others => '0');
            pdm2Bit2 <= (others => '0');
            pdm2Bit3 <= (others => '0');
            pdm2Bit4 <= (others => '0');
            pdm2Bit5 <= (others => '0');
            pdm2Bit6 <= (others => '0');
            pdm2Bit7 <= (others => '0');
            pdm2Bit8 <= (others => '0');
        elsif (rising_edge(CLK)) then
            if (CLK_PDM_CE = '1') then
                pdm2Bit1 <= pdm2Bit1Tmp;
                pdm2Bit2 <= pdm2Bit2Tmp;
                pdm2Bit3 <= pdm2Bit3Tmp;
                pdm2Bit4 <= pdm2Bit4Tmp;
                pdm2Bit5 <= pdm2Bit5Tmp;
                pdm2Bit6 <= pdm2Bit6Tmp;
                pdm2Bit7 <= pdm2Bit7Tmp;
                pdm2Bit8 <= pdm2Bit8Tmp;  
            end if;
        end if;
    end process;
    
    -- output
    PDM_2BIT_DOUT(0) <= pdm2Bit1Tmp when (CLK_PDM_CE = '1') else pdm2Bit1;
    PDM_2BIT_DOUT(1) <= pdm2Bit2Tmp when (CLK_PDM_CE = '1') else pdm2Bit2;
    PDM_2BIT_DOUT(2) <= pdm2Bit3Tmp when (CLK_PDM_CE = '1') else pdm2Bit3;
    PDM_2BIT_DOUT(3) <= pdm2Bit4Tmp when (CLK_PDM_CE = '1') else pdm2Bit4;
    PDM_2BIT_DOUT(4) <= pdm2Bit5Tmp when (CLK_PDM_CE = '1') else pdm2Bit5;
    PDM_2BIT_DOUT(5) <= pdm2Bit6Tmp when (CLK_PDM_CE = '1') else pdm2Bit6;
    PDM_2BIT_DOUT(6) <= pdm2Bit7Tmp when (CLK_PDM_CE = '1') else pdm2Bit7;
    PDM_2BIT_DOUT(7) <= pdm2Bit8Tmp when (CLK_PDM_CE = '1') else pdm2Bit8;                                            

end Behavioral;
