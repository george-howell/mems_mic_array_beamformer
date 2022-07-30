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
    generic   ( PDM_BIT1_OFFSET_VAL : integer       := 7;      -- this is the number of sys clk cycles before mic1 pdm data is captured
                PDM_BIT2_OFFSET_VAL : integer       := 2       -- this is the number of sys clk cycles before mic1 pdm data is captured
                );
    port      ( RST                 : in    std_logic;          -- system reset
                CLK                 : in    std_logic;          -- system clk
                CLK_PDM_CE          : in    std_logic;          -- pdm clock enable
                -- PDM DATA
                PDM_DIN             : in    std_logic_vector (3 downto 0);    -- pdm data input
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
signal pdmLatch                     : std_logic_vector (7 downto 0);

-- pdm output signals
signal pdm2BitTmp                   : vector_of_stdLogVec2bit (0 to 7);
signal pdm2Bit                      : vector_of_stdLogVec2bit (0 to 7);

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
            pdmLatch <= (others => 'U');       
        elsif (rising_edge(CLK)) then -- latches pdm data from the mics at the offset flag
            if (pdmBit1Flg = '1') then
                pdmLatch(0) <= PDM_DIN(0);
                pdmLatch(2) <= PDM_DIN(1);
                pdmLatch(4) <= PDM_DIN(2);
                pdmLatch(6) <= PDM_DIN(3);
            elsif (pdmBit2Flg = '1') then
                pdmLatch(1) <= PDM_DIN(0);
                pdmLatch(3) <= PDM_DIN(1);
                pdmLatch(5) <= PDM_DIN(2);
                pdmLatch(7) <= PDM_DIN(3);                
            end if;
        end if;
    end process;
    
    g1: for micIdx in 0 to 7 generate 
        pdm2BitTmp(micIdx) <=   "01" when (pdmLatch(micIdx) = '1') else
                                "11" when (pdmLatch(micIdx) = '0') else
                                "00";
    end generate;
    
    --------------------------------- PDM OUTPUT --------------------------------------
    
    process (RST, CLK)
    begin
        if (RST = '1') then
            pdm2Bit <= (others => (others => '0'));
        elsif (rising_edge(CLK)) then
            if (CLK_PDM_CE = '1') then
                pdm2Bit <= pdm2BitTmp; 
            end if;
        end if;
    end process;
    
    -- output
    PDM_2BIT_DOUT <= pdm2BitTmp when (CLK_PDM_CE = '1') else pdm2Bit;                                            

end Behavioral;
