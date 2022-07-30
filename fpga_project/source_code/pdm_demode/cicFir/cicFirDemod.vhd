----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2020 19:09:26
-- Design Name: 
-- Module Name: cicFirDemod - Behavioral
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

entity cicFirDemod is
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_PDM_CE          : in    std_logic;                      -- pdm clock
                CLK_FLT8_CE         : in    std_logic;                      -- clock for filter rate (8 times slower than pdm clk)
                CLK_FLT16_CE        : in    std_logic;                      -- clock for filter rate (16 times slower than pdm clk)
                CLK_FLT32_CE        : in    std_logic;                      -- clock for filter rate (32 times slower than pdm clk)
                PDM_DIN             : in    vector_of_stdLogVec2bit (0 to 7);   -- 2-bit pdm data in
                PCM_DOUT            : out   vector_of_stdLogVec16bit (0 to 7)   -- pcm data out                     
                );
end cicFirDemod;

architecture Behavioral of cicFirDemod is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component cicFirFilters
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_PDM_CE          : in    std_logic;                      -- pdm clock
                CLK_FLT8_CE         : in    std_logic;                      -- clock for filter rate (8 times slower than pdm clk)
                CLK_FLT16_CE        : in    std_logic;                      -- clock for filter rate (16 times slower than pdm clk)
                CLK_FLT32_CE        : in    std_logic;                      -- clock for filter rate (32 times slower than pdm clk)
                PDM_DIN             : in    std_logic_vector(1 downto 0);   -- 2-bit pdm data in
                PCM_DOUT            : out   std_logic_vector (15 downto 0)  -- pcm data out                    
                );
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------------- MIC 1 FILTERS ------------------------------------
    
    cicFirFilters_comp_1 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(0),
                    PCM_DOUT            => PCM_DOUT(0)               
                    );
    
    cicFirFilters_comp_2 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(1),
                    PCM_DOUT            => PCM_DOUT(1)               
                    );
                    
    cicFirFilters_comp_3 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(2),
                    PCM_DOUT            => PCM_DOUT(2)               
                    );
                    
    cicFirFilters_comp_4 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(3),
                    PCM_DOUT            => PCM_DOUT(3)               
                    );
                    
    cicFirFilters_comp_5 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(4),
                    PCM_DOUT            => PCM_DOUT(4)               
                    );
                    
    cicFirFilters_comp_6 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(5),
                    PCM_DOUT            => PCM_DOUT(5)               
                    );
                    
    cicFirFilters_comp_7 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(6),
                    PCM_DOUT            => PCM_DOUT(6)               
                    ); 
    
    cicFirFilters_comp_8 : cicFirFilters
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_PDM_CE          => CLK_PDM_CE,
                    CLK_FLT8_CE         => CLK_FLT8_CE,
                    CLK_FLT16_CE        => CLK_FLT16_CE,
                    CLK_FLT32_CE        => CLK_FLT32_CE,
                    PDM_DIN             => PDM_DIN(7),
                    PCM_DOUT            => PCM_DOUT(7)               
                    );
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
end Behavioral;
