----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:
-- Design Name: 
-- Module Name: maxValue - Behavioral
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

use work.instruction_buffer_type.all;

-----------------------------------------------------------------------------
-------------------------- IO DECLERATIONS ----------------------------------
-----------------------------------------------------------------------------

entity maxValue is
    port      ( RST                 : in    std_logic;  -- system reset
                CLK                 : in    std_logic;  -- sys clock
                CLK_CE              : in    std_logic;  -- clock enable
                RD_VAL_CE           : in    std_logic;  -- read trigger clock enable
                DIN                 : in    vector_of_stdLogVec32bit (0 to 35);  -- input data
                MAX_VAL_IDX         : out   std_logic_vector (5 downto 0);  -- max value index (ref din)
                DONE_EN             : out   std_logic
                );
end maxValue;

architecture Behavioral of maxValue is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

signal dinReg                   : vector_of_unsigned32 (0 to 35);

signal regIdx                   : integer range 0 to 35;

signal maxValTmp                : unsigned (31 downto 0);
signal maxValIdx                : integer range 0 to 35;

signal maxValIdxStd             : std_logic_vector (5 downto 0);
signal maxValIdxTmp             : std_logic_vector (5 downto 0);

signal doneFlag                 : std_logic;

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
    ---------------------------------- INPUT REG --------------------------------------
    
    -- input data and convert to unsigned   
    din_reg_process: process (CLK, RST)
    begin
        if (RST = '1') then
            dinReg <= (others => (others => '0'));
        elsif (rising_edge(CLK)) then
            if (RD_VAL_CE = '1') then
                for ni in 0 to 35 loop
                   dinReg(ni) <= unsigned(DIN(ni));
                end loop;
            end if;
        end if;
    end process din_reg_process;
    
    ---------------------------------- INPUT REG --------------------------------------
    
    -- reg index
    reg_index_process : process (RST, CLK)
    begin
        if (RST = '1') then
            regIdx <= 0;
        elsif(rising_edge(CLK)) then
            if (regIdx = 35) then
                regIdx <= 0;
            else
                regIdx <= regIdx + 1;
            end if;
        end if;
    end process reg_index_process;   
    
    -- finds max value and index
    max_value_process : process (RST, CLK)
    begin
        if (RST = '1') then
            maxValTmp <= (others => '0');
            maxValIdx <= 0;
        elsif(rising_edge(CLK)) then
            if (RD_VAL_CE = '1') then
                maxValTmp <= (others => '0');
                maxValIdx <= 0;    
            elsif ((maxValTmp < dinReg(regIdx))) then
                maxValTmp <= dinReg(regIdx);
                maxValIdx <= regIdx + 1;
            end if;
        end if;
    end process max_value_process;
    
    -- finds max value and index
    max_value_done_flag_process : process (RST, CLK)
    begin
        if (RST = '1') then
            doneFlag <= '0';
        elsif(rising_edge(CLK)) then
            if (RD_VAL_CE = '1') then
                doneFlag <= '1';    
            elsif (CLK_CE = '1') then
                doneFlag <= '0';
            end if;
        end if;
    end process max_value_done_flag_process;
    
    DONE_EN <= '1' when (doneFlag = '1' and CLK_CE = '1') else '0';
    
    ---------------------------------- OUTPUT DATA ------------------------------------
    
    maxValIdxStd <= std_logic_vector(to_unsigned(maxValIdx, maxValIdxStd'length));
    
    -- outputs the index value
    dout_process : process (CLK, RST)
    begin
        if (RST = '1') then
            maxValIdxTmp <= (others => '0');
        elsif (rising_edge(CLK)) then
            if (CLK_CE = '1') then
                maxValIdxTmp <= maxValIdxStd;
            end if;
        end if;
    end process dout_process;
    
    MAX_VAL_IDX <= maxValIdxStd when (CLK_CE = '1') else maxValIdxTmp;
    
end Behavioral;
