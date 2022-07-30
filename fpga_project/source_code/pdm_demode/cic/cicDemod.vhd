----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.04.2020 19:09:26
-- Design Name: 
-- Module Name: pdmDemod - Behavioral
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

entity cicDemod is
    port      ( RST                 : in    std_logic;  -- system reset
                CLK                 : in    std_logic;  -- sys clock
                CLK_PDM_CE          : in    std_logic;  -- pdm clock
                PDM_DIN             : in    vector_of_stdLogVec2bit (0 to 7);   -- 2-bit pdm data in
                PCM_DOUT            : out   vector_of_stdLogVec16bit (0 to 7)   -- pcm data out                     
                );
end cicDemod;

architecture Behavioral of cicDemod is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component cicFlt_4thOrd_64DecFact
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_CE              : in    std_logic;                      -- clock enable
                DIN                 : in    std_logic_vector (1 downto 0);  -- input data
                DOUT                : out   std_logic_vector (15 downto 0)  -- output data
                );
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    cicFlt_4thOrd_64DecFact_comp_1 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(0),   
                    DOUT            => PCM_DOUT(0)
                    );
                    
    cicFlt_4thOrd_64DecFact_comp_2 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(1),   
                    DOUT            => PCM_DOUT(1)
                    );
                    
    cicFlt_4thOrd_64DecFact_comp_3 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(2),   
                    DOUT            => PCM_DOUT(2)
                    );
    
    cicFlt_4thOrd_64DecFact_comp_4 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(3),   
                    DOUT            => PCM_DOUT(3)
                    );
                    
    cicFlt_4thOrd_64DecFact_comp_5 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(4),   
                    DOUT            => PCM_DOUT(4)
                    );
                    
    cicFlt_4thOrd_64DecFact_comp_6 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(5),   
                    DOUT            => PCM_DOUT(5)
                    );
  
    cicFlt_4thOrd_64DecFact_comp_7 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(6),   
                    DOUT            => PCM_DOUT(6)
                    );
                    
    cicFlt_4thOrd_64DecFact_comp_8 : cicFlt_4thOrd_64DecFact
        port map  ( RST             => RST,     
                    CLK             => CLK,      
                    CLK_CE          => CLK_PDM_CE,
                    DIN             => PDM_DIN(7),   
                    DOUT            => PCM_DOUT(7)
                    );
                                                
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------  

end Behavioral;
