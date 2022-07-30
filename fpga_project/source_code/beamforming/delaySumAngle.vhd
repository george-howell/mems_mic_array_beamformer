----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2020 19:09:26
-- Design Name: 
-- Module Name: delaySumAngle - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-----------------------------------------------------------------------------
-------------------------- IO DECLERATIONS ----------------------------------
-----------------------------------------------------------------------------

entity delaySumAngle is
    port  ( RST                 : in    std_logic;                      -- system reset
            CLK                 : in    std_logic;                      -- sys clock
            CLK_CE              : in    std_logic;                      -- clock enable
            DIN_1               : in    std_logic_vector (15 downto 0); -- input data
            DIN_2               : in    std_logic_vector (15 downto 0); -- input data
            DIN_3               : in    std_logic_vector (15 downto 0); -- input data
            DIN_4               : in    std_logic_vector (15 downto 0); -- input data
            DIN_5               : in    std_logic_vector (15 downto 0); -- input data
            DIN_6               : in    std_logic_vector (15 downto 0); -- input data
            DIN_7               : in    std_logic_vector (15 downto 0); -- input data
            DIN_8               : in    std_logic_vector (15 downto 0); -- input data
            DOUT                : out   std_logic_vector (18 downto 0)  -- summed output data
            );
end delaySumAngle;

architecture Behavioral of delaySumAngle is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- signed signals
signal din1Signed                       : signed(15 downto 0);
signal din2Signed                       : signed(15 downto 0);
signal din3Signed                       : signed(15 downto 0);
signal din4Signed                       : signed(15 downto 0);
signal din5Signed                       : signed(15 downto 0);
signal din6Signed                       : signed(15 downto 0);
signal din7Signed                       : signed(15 downto 0);
signal din8Signed                       : signed(15 downto 0);

-- resized data signals
signal din1Tmp                          : signed(18 downto 0);
signal din2Tmp                          : signed(18 downto 0);
signal din3Tmp                          : signed(18 downto 0);
signal din4Tmp                          : signed(18 downto 0);
signal din5Tmp                          : signed(18 downto 0);
signal din6Tmp                          : signed(18 downto 0);
signal din7Tmp                          : signed(18 downto 0);
signal din8Tmp                          : signed(18 downto 0);

-- summation signals
signal sumTmp1                          : signed(18 downto 0);
signal sumTmp2                          : signed(18 downto 0);
signal sumTmp3                          : signed(18 downto 0);
signal sumTmp4                          : signed(18 downto 0);
signal sumTmp5                          : signed(18 downto 0);
signal sumTmp6                          : signed(18 downto 0);
signal sumTmp7                          : signed(18 downto 0);
signal sumOutAbs                        : signed(18 downto 0);

-- output data signals
signal sumStd                           : std_logic_vector(18 downto 0);
signal doutTmp                          : std_logic_vector(18 downto 0);
 
begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------------- ANGLE SUMMATION ----------------------------------
    
    -- convert to signed values
    din1Signed <= signed(DIN_1);
    din2Signed <= signed(DIN_2);
    din3Signed <= signed(DIN_3);
    din4Signed <= signed(DIN_4);
    din5Signed <= signed(DIN_5);
    din6Signed <= signed(DIN_6);
    din7Signed <= signed(DIN_7);
    din8Signed <= signed(DIN_8);
    
    -- resize
    din1Tmp <= resize(din1Signed, 19);
    din2Tmp <= resize(din2Signed, 19);
    din3Tmp <= resize(din3Signed, 19);
    din4Tmp <= resize(din4Signed, 19);
    din5Tmp <= resize(din5Signed, 19);
    din6Tmp <= resize(din6Signed, 19);
    din7Tmp <= resize(din7Signed, 19);
    din8Tmp <= resize(din8Signed, 19);
    
    -- summation 
    sumTmp1 <= din1Tmp + din2Tmp;
    sumTmp2 <= sumTmp1 + din3Tmp;
    sumTmp3 <= sumTmp2 + din4Tmp;
    sumTmp4 <= sumTmp3 + din5Tmp;
    sumTmp5 <= sumTmp4 + din6Tmp;
    sumTmp6 <= sumTmp5 + din7Tmp;
    sumTmp7 <= sumTmp6 + din8Tmp;
    
    -- absolute summed output value
    sumOutAbs <= abs(sumTmp7);
    
    -- std_logic_value
    sumStd <= std_logic_vector(sumOutAbs);
    
    -- clock to clk_en
    data_output_process : process(CLK, RST)
    begin
        if (RST = '1') then
            doutTmp <= (others => '0');
        elsif (rising_edge(CLK)) then
            if (CLK_CE = '1') then
                doutTmp <= sumStd;
            end if; 
        end if;
    end process data_output_process;
    
    -- send to data output
    DOUT <= sumStd when (CLK_CE = '1') else doutTmp;
    
end Behavioral;
