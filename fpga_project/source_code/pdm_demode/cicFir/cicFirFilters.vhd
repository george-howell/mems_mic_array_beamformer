----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2020 19:09:26
-- Design Name: 
-- Module Name: cicFirFilters - Behavioral
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

entity cicFirFilters is
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_PDM_CE          : in    std_logic;                      -- pdm clock
                CLK_FLT8_CE         : in    std_logic;                      -- clock for filter rate (8 times slower than pdm clk)
                CLK_FLT16_CE        : in    std_logic;                      -- clock for filter rate (16 times slower than pdm clk)
                CLK_FLT32_CE        : in    std_logic;                      -- clock for filter rate (32 times slower than pdm clk)
                PDM_DIN             : in    std_logic_vector(1 downto 0);   -- 2-bit pdm data in
                PCM_DOUT            : out   std_logic_vector (15 downto 0)  -- pcm data out                    
                );
end cicFirFilters;

architecture Behavioral of cicFirFilters is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component cicFlt_4thOrd_8DecFact
    port  ( RST                 : in    std_logic;                      -- system reset
            CLK                 : in    std_logic;                      -- sys clock
            CLK_CE              : in    std_logic;                      -- clock enable
            DIN                 : in    std_logic_vector(1 downto 0);   -- input data
            DOUT                : out   std_logic_vector (13 downto 0)  -- output data
            );
end component;

component firFlt_halfBandDec
    port  ( RST                 : in    std_logic;                      -- system reset
            CLK                 : in    std_logic;                      -- sys clock
            CLK_CE              : in    std_logic;                      -- clock enable
            DIN                 : in    std_logic_vector (15 downto 0); -- input data
            DOUT                : out   std_logic_vector (15 downto 0)  -- output data
            );
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- cic signals
signal cicDout                  : std_logic_vector (13 downto 0);

-- normalisation signals
signal cicDoutSigned            : signed(13 downto 0);  -- sfix14
signal normCast                 : signed(27 downto 0);  -- sfix28_En24
signal normOutTmp               : signed(15 downto 0);  -- sfix16_En14
signal normOut                  : std_logic_vector(15 downto 0);  -- ufix16

-- fir signals
signal fir1Dout                 : std_logic_vector(15 downto 0);
signal fir2Dout                 : std_logic_vector(15 downto 0);

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------------- MIC 1 FILTERS ------------------------------------
    
    cicFlt_4thOrd_8DecFact_comp : cicFlt_4thOrd_8DecFact
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN,
                    DOUT            => cicDout
                    );
    
    firFlt_halfBandDec_1_comp : firFlt_halfBandDec
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_FLT8_CE,
                    DIN             => normOut,
                    DOUT            => fir1Dout
                    );
                    
    firFlt_halfBandDec_2_comp : firFlt_halfBandDec
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_FLT16_CE,
                    DIN             => fir1Dout,
                    DOUT            => fir2Dout
                    );
   
    firFlt_halfBandDec_3_comp : firFlt_halfBandDec
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_FLT32_CE,
                    DIN             => fir2Dout,
                    DOUT            => PCM_DOUT
                    );

    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

    --------------------------- NORMALISE CIC OUTPUT DATA -----------------------------
    
    cicDoutSigned <= signed(cicDout);

    normCast <= resize(cicDoutSigned & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 28);
    normOutTmp <= normCast(25 downto 10);
    
    normOut <= std_logic_vector(normOutTmp);
    
end Behavioral;
