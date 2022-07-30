----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2018 18:13:54
-- Design Name: 
-- Module Name: accum - Behavioral
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

entity accum is
    port      ( RST                 : in    std_logic;
                CLK                 : in    std_logic;
                CLK_CE              : in    std_logic;
                RST_ACC             : in    std_logic;
                DIN                 : in    std_logic_vector (18 downto 0);
                DOUT                : out   std_logic_vector (31 downto 0)            
                );                       
end accum;

architecture Behavioral of accum is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

signal dinTmp               : unsigned (31 downto 0);
signal rstAcc               : std_logic;
signal accTmp               : unsigned (31 downto 0);
signal clkCePhase           : std_logic;
signal doutTmp              : std_logic_vector (31 downto 0);
signal doutReg              : std_logic_vector (31 downto 0);

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

    --------------------------------- CLOCK PHASE -------------------------------------
    
    clock_ce_phase_process: process (CLK, RST)
    begin
        if (RST = '1') then
            clkCePhase <= '0';
        elsif (rising_edge(CLK)) then
            clkCePhase <= CLK_CE;
        end if;
    end process clock_ce_phase_process;
    
    --------------------------------- ACCUM DATA -------------------------------------
    
    dinTmp <= resize(unsigned(DIN), 32);
    
    -- accumulator reset signal
    rstAcc <= CLK_CE and RST_ACC;
    
    acc_process : process (CLK, RST)
    begin
        if (RST = '1') then
            accTmp <= (others => '0');
        elsif (rising_edge(CLK)) then
            if (rstAcc = '1') then
                accTmp <= (others => '0');
            elsif (clkCePhase = '1') then
                accTmp <= accTmp + dinTmp;  
            end if;
        end if;
    end process acc_process;
    
    --------------------------------- DATA OUTPUT ------------------------------------
    
    doutTmp <= std_logic_vector(accTmp);
    
    data_out_process : process (CLK, RST)
    begin
        if (RST = '1') then
            doutReg <= (others => '0');
        elsif (rising_edge(CLK)) then
            if (CLK_CE = '1') then
                doutReg <= doutTmp;
            end if;
        end if;
    end process data_out_process;
    
    -- data output mux
    DOUT <= doutTmp when (CLK_CE = '1') else doutReg;
    
end Behavioral;
