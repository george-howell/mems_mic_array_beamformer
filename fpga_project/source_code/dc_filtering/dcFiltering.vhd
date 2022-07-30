----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2020 19:09:26
-- Design Name: 
-- Module Name: dcFiltering - Behavioral
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

entity dcFiltering is
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_CE              : in    std_logic;                      -- clock enable
                DIN                 : in    vector_of_stdLogVec16bit (0 to 7);  -- data inin
                DOUT                : out   vector_of_stdLogVec16bit (0 to 7)   -- data out                   
                );
end dcFiltering;

architecture Behavioral of dcFiltering is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component biquadFlt
    port      ( CLK                             : in    std_logic;
                RST                             : in    std_logic; 
                CLK_EN                          : in    std_logic; 
                DIN                             : in    std_logic_vector(15 downto 0); -- sfix16_En14
                DOUT                            : out   std_logic_vector(15 downto 0)  -- sfix16_En14
                );
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------------- DATA 1 FILTERS -----------------------------------
    
    bq1_1 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(0),
                    DOUT                => DOUT(0) 
                    );
                    
    -------------------------------- DATA 2 FILTERS -----------------------------------
    
    bq1_2 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(1),
                    DOUT                => DOUT(1) 
                    );
                    
    -------------------------------- DATA 3 FILTERS -----------------------------------
    
    bq1_3 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(2),
                    DOUT                => DOUT(2)
                    );
    
    -------------------------------- DATA 4 FILTERS -----------------------------------
    
    bq1_4 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(3),
                    DOUT                => DOUT(3)
                    );
 
    -------------------------------- DATA 5 FILTERS -----------------------------------
    
    bq1_5 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(4),
                    DOUT                => DOUT(4)
                    );
                    
    -------------------------------- DATA 6 FILTERS -----------------------------------
    
    bq1_6 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(5),
                    DOUT                => DOUT(5) 
                    );
                    
    -------------------------------- DATA 7 FILTERS -----------------------------------
    
    bq1_7 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(6),
                    DOUT                => DOUT(6)
                    );
    
    -------------------------------- DATA 8 FILTERS -----------------------------------
    
    bq1_8 : biquadFlt
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_EN              => CLK_CE,
                    DIN                 => DIN(7),
                    DOUT                => DOUT(7)
                    );  
                    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

end Behavioral;
