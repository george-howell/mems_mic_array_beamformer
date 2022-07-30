----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2020 19:09:26
-- Design Name: 
-- Module Name: delaySum - Behavioral
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

entity delaySum is
    port      ( CLK                 : in    std_logic;
                RST                 : in    std_logic;
                CLK_CE              : in    std_logic;
                DIN                 : in    vector_of_stdLogVec16bit (0 to 7);
                SUM                 : out   vector_of_stdLogVec19bit (0 to 35)
                );
end delaySum;

architecture Behavioral of delaySum is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component delaySumAngle
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
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- delay values - matrix
constant m1_00deg                      : integer   := 13;
constant m2_00deg                      : integer   := 11;
constant m3_00deg                      : integer   := 7;
constant m4_00deg                      : integer   := 2;
constant m5_00deg                      : integer   := 0;
constant m6_00deg                      : integer   := 2;
constant m7_00deg                      : integer   := 7;
constant m8_00deg                      : integer   := 11;
constant m1_10deg                      : integer   := 13;
constant m2_10deg                      : integer   := 12;
constant m3_10deg                      : integer   := 8;
constant m4_10deg                      : integer   := 3;
constant m5_10deg                      : integer   := 0;
constant m6_10deg                      : integer   := 1;
constant m7_10deg                      : integer   := 5;
constant m8_10deg                      : integer   := 10;
constant m1_20deg                      : integer   := 13;
constant m2_20deg                      : integer   := 12;
constant m3_20deg                      : integer   := 8;
constant m4_20deg                      : integer   := 3;
constant m5_20deg                      : integer   := 0;
constant m6_20deg                      : integer   := 0;
constant m7_20deg                      : integer   := 4;
constant m8_20deg                      : integer   := 9;
constant m1_30deg                      : integer   := 12;
constant m2_30deg                      : integer   := 13;
constant m3_30deg                      : integer   := 10;
constant m4_30deg                      : integer   := 5;
constant m5_30deg                      : integer   := 1;
constant m6_30deg                      : integer   := 0;
constant m7_30deg                      : integer   := 3;
constant m8_30deg                      : integer   := 8;
constant m1_40deg                      : integer   := 12;
constant m2_40deg                      : integer   := 13;
constant m3_40deg                      : integer   := 11;
constant m4_40deg                      : integer   := 6;
constant m5_40deg                      : integer   := 1;
constant m6_40deg                      : integer   := 0;
constant m7_40deg                      : integer   := 2;
constant m8_40deg                      : integer   := 7;
constant m1_50deg                      : integer   := 11;
constant m2_50deg                      : integer   := 13;
constant m3_50deg                      : integer   := 12;
constant m4_50deg                      : integer   := 7;
constant m5_50deg                      : integer   := 2;
constant m6_50deg                      : integer   := 0;
constant m7_50deg                      : integer   := 1;
constant m8_50deg                      : integer   := 6;
constant m1_60deg                      : integer   := 10;
constant m2_60deg                      : integer   := 13;
constant m3_60deg                      : integer   := 12;
constant m4_60deg                      : integer   := 8;
constant m5_60deg                      : integer   := 3;
constant m6_60deg                      : integer   := 0;
constant m7_60deg                      : integer   := 1;
constant m8_60deg                      : integer   := 5;
constant m1_70deg                      : integer   := 8;
constant m2_70deg                      : integer   := 12;
constant m3_70deg                      : integer   := 13;
constant m4_70deg                      : integer   := 9;
constant m5_70deg                      : integer   := 4;
constant m6_70deg                      : integer   := 0;
constant m7_70deg                      : integer   := 0;
constant m8_70deg                      : integer   := 3;
constant m1_80deg                      : integer   := 8;
constant m2_80deg                      : integer   := 12;
constant m3_80deg                      : integer   := 13;
constant m4_80deg                      : integer   := 10;
constant m5_80deg                      : integer   := 5;
constant m6_80deg                      : integer   := 1;
constant m7_80deg                      : integer   := 0;
constant m8_80deg                      : integer   := 3;
constant m1_90deg                      : integer   := 7;
constant m2_90deg                      : integer   := 11;
constant m3_90deg                      : integer   := 13;
constant m4_90deg                      : integer   := 11;
constant m5_90deg                      : integer   := 7;
constant m6_90deg                      : integer   := 2;
constant m7_90deg                      : integer   := 0;
constant m8_90deg                      : integer   := 2;
constant m1_100deg                     : integer   := 5;
constant m2_100deg                     : integer   := 10;
constant m3_100deg                     : integer   := 13;
constant m4_100deg                     : integer   := 12;
constant m5_100deg                     : integer   := 8;
constant m6_100deg                     : integer   := 3;
constant m7_100deg                     : integer   := 0;
constant m8_100deg                     : integer   := 1;
constant m1_110deg                     : integer   := 4;
constant m2_110deg                     : integer   := 9;
constant m3_110deg                     : integer   := 13;
constant m4_110deg                     : integer   := 12;
constant m5_110deg                     : integer   := 8;
constant m6_110deg                     : integer   := 3;
constant m7_110deg                     : integer   := 0;
constant m8_110deg                     : integer   := 0;
constant m1_120deg                     : integer   := 3;
constant m2_120deg                     : integer   := 8;
constant m3_120deg                     : integer   := 12;
constant m4_120deg                     : integer   := 13;
constant m5_120deg                     : integer   := 10;
constant m6_120deg                     : integer   := 5;
constant m7_120deg                     : integer   := 1;
constant m8_120deg                     : integer   := 0;
constant m1_130deg                     : integer   := 2;
constant m2_130deg                     : integer   := 7;
constant m3_130deg                     : integer   := 12;
constant m4_130deg                     : integer   := 13;
constant m5_130deg                     : integer   := 11;
constant m6_130deg                     : integer   := 6;
constant m7_130deg                     : integer   := 1;
constant m8_130deg                     : integer   := 0;
constant m1_140deg                     : integer   := 1;
constant m2_140deg                     : integer   := 6;
constant m3_140deg                     : integer   := 11;
constant m4_140deg                     : integer   := 13;
constant m5_140deg                     : integer   := 12;
constant m6_140deg                     : integer   := 7;
constant m7_140deg                     : integer   := 2;
constant m8_140deg                     : integer   := 0;
constant m1_150deg                     : integer   := 1;
constant m2_150deg                     : integer   := 5;
constant m3_150deg                     : integer   := 10;
constant m4_150deg                     : integer   := 13;
constant m5_150deg                     : integer   := 12;
constant m6_150deg                     : integer   := 8;
constant m7_150deg                     : integer   := 3;
constant m8_150deg                     : integer   := 0;
constant m1_160deg                     : integer   := 0;
constant m2_160deg                     : integer   := 3;
constant m3_160deg                     : integer   := 8;
constant m4_160deg                     : integer   := 12;
constant m5_160deg                     : integer   := 13;
constant m6_160deg                     : integer   := 9;
constant m7_160deg                     : integer   := 4;
constant m8_160deg                     : integer   := 0;
constant m1_170deg                     : integer   := 0;
constant m2_170deg                     : integer   := 3;
constant m3_170deg                     : integer   := 8;
constant m4_170deg                     : integer   := 12;
constant m5_170deg                     : integer   := 13;
constant m6_170deg                     : integer   := 10;
constant m7_170deg                     : integer   := 5;
constant m8_170deg                     : integer   := 1;
constant m1_180deg                     : integer   := 0;
constant m2_180deg                     : integer   := 2;
constant m3_180deg                     : integer   := 7;
constant m4_180deg                     : integer   := 11;
constant m5_180deg                     : integer   := 13;
constant m6_180deg                     : integer   := 11;
constant m7_180deg                     : integer   := 7;
constant m8_180deg                     : integer   := 2;
constant m1_190deg                     : integer   := 0;
constant m2_190deg                     : integer   := 1;
constant m3_190deg                     : integer   := 5;
constant m4_190deg                     : integer   := 10;
constant m5_190deg                     : integer   := 13;
constant m6_190deg                     : integer   := 12;
constant m7_190deg                     : integer   := 8;
constant m8_190deg                     : integer   := 3;
constant m1_200deg                     : integer   := 0;
constant m2_200deg                     : integer   := 0;
constant m3_200deg                     : integer   := 4;
constant m4_200deg                     : integer   := 9;
constant m5_200deg                     : integer   := 13;
constant m6_200deg                     : integer   := 12;
constant m7_200deg                     : integer   := 8;
constant m8_200deg                     : integer   := 3;
constant m1_210deg                     : integer   := 1;
constant m2_210deg                     : integer   := 0;
constant m3_210deg                     : integer   := 3;
constant m4_210deg                     : integer   := 8;
constant m5_210deg                     : integer   := 12;
constant m6_210deg                     : integer   := 13;
constant m7_210deg                     : integer   := 10;
constant m8_210deg                     : integer   := 5;
constant m1_220deg                     : integer   := 1;
constant m2_220deg                     : integer   := 0;
constant m3_220deg                     : integer   := 2;
constant m4_220deg                     : integer   := 7;
constant m5_220deg                     : integer   := 12;
constant m6_220deg                     : integer   := 13;
constant m7_220deg                     : integer   := 11;
constant m8_220deg                     : integer   := 6;
constant m1_230deg                     : integer   := 2;
constant m2_230deg                     : integer   := 0;
constant m3_230deg                     : integer   := 1;
constant m4_230deg                     : integer   := 6;
constant m5_230deg                     : integer   := 11;
constant m6_230deg                     : integer   := 13;
constant m7_230deg                     : integer   := 12;
constant m8_230deg                     : integer   := 7;
constant m1_240deg                     : integer   := 3;
constant m2_240deg                     : integer   := 0;
constant m3_240deg                     : integer   := 1;
constant m4_240deg                     : integer   := 5;
constant m5_240deg                     : integer   := 10;
constant m6_240deg                     : integer   := 13;
constant m7_240deg                     : integer   := 12;
constant m8_240deg                     : integer   := 8;
constant m1_250deg                     : integer   := 4;
constant m2_250deg                     : integer   := 0;
constant m3_250deg                     : integer   := 0;
constant m4_250deg                     : integer   := 3;
constant m5_250deg                     : integer   := 8;
constant m6_250deg                     : integer   := 12;
constant m7_250deg                     : integer   := 13;
constant m8_250deg                     : integer   := 9;
constant m1_260deg                     : integer   := 5;
constant m2_260deg                     : integer   := 1;
constant m3_260deg                     : integer   := 0;
constant m4_260deg                     : integer   := 3;
constant m5_260deg                     : integer   := 8;
constant m6_260deg                     : integer   := 12;
constant m7_260deg                     : integer   := 13;
constant m8_260deg                     : integer   := 10;
constant m1_270deg                     : integer   := 7;
constant m2_270deg                     : integer   := 2;
constant m3_270deg                     : integer   := 0;
constant m4_270deg                     : integer   := 2;
constant m5_270deg                     : integer   := 7;
constant m6_270deg                     : integer   := 11;
constant m7_270deg                     : integer   := 13;
constant m8_270deg                     : integer   := 11;
constant m1_280deg                     : integer   := 8;
constant m2_280deg                     : integer   := 3;
constant m3_280deg                     : integer   := 0;
constant m4_280deg                     : integer   := 1;
constant m5_280deg                     : integer   := 5;
constant m6_280deg                     : integer   := 10;
constant m7_280deg                     : integer   := 13;
constant m8_280deg                     : integer   := 12;
constant m1_290deg                     : integer   := 8;
constant m2_290deg                     : integer   := 3;
constant m3_290deg                     : integer   := 0;
constant m4_290deg                     : integer   := 0;
constant m5_290deg                     : integer   := 4;
constant m6_290deg                     : integer   := 9;
constant m7_290deg                     : integer   := 13;
constant m8_290deg                     : integer   := 12;
constant m1_300deg                     : integer   := 10;
constant m2_300deg                     : integer   := 5;
constant m3_300deg                     : integer   := 1;
constant m4_300deg                     : integer   := 0;
constant m5_300deg                     : integer   := 3;
constant m6_300deg                     : integer   := 8;
constant m7_300deg                     : integer   := 12;
constant m8_300deg                     : integer   := 13;
constant m1_310deg                     : integer   := 11;
constant m2_310deg                     : integer   := 6;
constant m3_310deg                     : integer   := 1;
constant m4_310deg                     : integer   := 0;
constant m5_310deg                     : integer   := 2;
constant m6_310deg                     : integer   := 7;
constant m7_310deg                     : integer   := 12;
constant m8_310deg                     : integer   := 13;
constant m1_320deg                     : integer   := 12;
constant m2_320deg                     : integer   := 7;
constant m3_320deg                     : integer   := 2;
constant m4_320deg                     : integer   := 0;
constant m5_320deg                     : integer   := 1;
constant m6_320deg                     : integer   := 6;
constant m7_320deg                     : integer   := 11;
constant m8_320deg                     : integer   := 13;
constant m1_330deg                     : integer   := 12;
constant m2_330deg                     : integer   := 8;
constant m3_330deg                     : integer   := 3;
constant m4_330deg                     : integer   := 0;
constant m5_330deg                     : integer   := 1;
constant m6_330deg                     : integer   := 5;
constant m7_330deg                     : integer   := 10;
constant m8_330deg                     : integer   := 13;
constant m1_340deg                     : integer   := 13;
constant m2_340deg                     : integer   := 9;
constant m3_340deg                     : integer   := 4;
constant m4_340deg                     : integer   := 0;
constant m5_340deg                     : integer   := 0;
constant m6_340deg                     : integer   := 3;
constant m7_340deg                     : integer   := 8;
constant m8_340deg                     : integer   := 12;
constant m1_350deg                     : integer   := 13;
constant m2_350deg                     : integer   := 10;
constant m3_350deg                     : integer   := 5;
constant m4_350deg                     : integer   := 1;
constant m5_350deg                     : integer   := 0;
constant m6_350deg                     : integer   := 3;
constant m7_350deg                     : integer   := 8;
constant m8_350deg                     : integer   := 12;

-- mic delay registers
signal delayReg1                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg2                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg3                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg4                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg5                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg6                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg7                        : vector_of_stdLogVec16bit(0 TO 13);
signal delayReg8                        : vector_of_stdLogVec16bit(0 TO 13);

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    delay_sum_angle_0deg_comp : delaySumAngle
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_CE              => CLK_CE,
                    DIN_1               => delayReg1(m1_00deg),
                    DIN_2               => delayReg2(m2_00deg),
                    DIN_3               => delayReg3(m3_00deg),
                    DIN_4               => delayReg4(m4_00deg),
                    DIN_5               => delayReg5(m5_00deg),
                    DIN_6               => delayReg6(m6_00deg),
                    DIN_7               => delayReg7(m7_00deg),
                    DIN_8               => delayReg8(m8_00deg),
                    DOUT                => SUM(0)
                    );

    delay_sum_angle_10deg_comp : delaySumAngle
        port map  ( RST                 => RST,
                    CLK                 => CLK,
                    CLK_CE              => CLK_CE,
                    DIN_1               => delayReg1(m1_10deg),
                    DIN_2               => delayReg2(m2_10deg),
                    DIN_3               => delayReg3(m3_10deg),
                    DIN_4               => delayReg4(m4_10deg),
                    DIN_5               => delayReg5(m5_10deg),
                    DIN_6               => delayReg6(m6_10deg),
                    DIN_7               => delayReg7(m7_10deg),
                    DIN_8               => delayReg8(m8_10deg),
                    DOUT                => SUM(1)
                    );
    
    delay_sum_angle_20deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_20deg),
                        DIN_2               => delayReg2(m2_20deg),
                        DIN_3               => delayReg3(m3_20deg),
                        DIN_4               => delayReg4(m4_20deg),
                        DIN_5               => delayReg5(m5_20deg),
                        DIN_6               => delayReg6(m6_20deg),
                        DIN_7               => delayReg7(m7_20deg),
                        DIN_8               => delayReg8(m8_20deg),
                        DOUT                => SUM(2)
                        );
    
    delay_sum_angle_30deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_30deg),
                        DIN_2               => delayReg2(m2_30deg),
                        DIN_3               => delayReg3(m3_30deg),
                        DIN_4               => delayReg4(m4_30deg),
                        DIN_5               => delayReg5(m5_30deg),
                        DIN_6               => delayReg6(m6_30deg),
                        DIN_7               => delayReg7(m7_30deg),
                        DIN_8               => delayReg8(m8_30deg),
                        DOUT                => SUM(3)
                        );
    
    delay_sum_angle_40deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_40deg),
                        DIN_2               => delayReg2(m2_40deg),
                        DIN_3               => delayReg3(m3_40deg),
                        DIN_4               => delayReg4(m4_40deg),
                        DIN_5               => delayReg5(m5_40deg),
                        DIN_6               => delayReg6(m6_40deg),
                        DIN_7               => delayReg7(m7_40deg),
                        DIN_8               => delayReg8(m8_40deg),
                        DOUT                => SUM(4)
                        );
    
    delay_sum_angle_50deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_50deg),
                        DIN_2               => delayReg2(m2_50deg),
                        DIN_3               => delayReg3(m3_50deg),
                        DIN_4               => delayReg4(m4_50deg),
                        DIN_5               => delayReg5(m5_50deg),
                        DIN_6               => delayReg6(m6_50deg),
                        DIN_7               => delayReg7(m7_50deg),
                        DIN_8               => delayReg8(m8_50deg),
                        DOUT                => SUM(5)
                        );
    
    delay_sum_angle_60deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_60deg),
                        DIN_2               => delayReg2(m2_60deg),
                        DIN_3               => delayReg3(m3_60deg),
                        DIN_4               => delayReg4(m4_60deg),
                        DIN_5               => delayReg5(m5_60deg),
                        DIN_6               => delayReg6(m6_60deg),
                        DIN_7               => delayReg7(m7_60deg),
                        DIN_8               => delayReg8(m8_60deg),
                        DOUT                => SUM(6)
                        );
    
    delay_sum_angle_70deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_70deg),
                        DIN_2               => delayReg2(m2_70deg),
                        DIN_3               => delayReg3(m3_70deg),
                        DIN_4               => delayReg4(m4_70deg),
                        DIN_5               => delayReg5(m5_70deg),
                        DIN_6               => delayReg6(m6_70deg),
                        DIN_7               => delayReg7(m7_70deg),
                        DIN_8               => delayReg8(m8_70deg),
                        DOUT                => SUM(7)
                        );
    
    delay_sum_angle_80deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_80deg),
                        DIN_2               => delayReg2(m2_80deg),
                        DIN_3               => delayReg3(m3_80deg),
                        DIN_4               => delayReg4(m4_80deg),
                        DIN_5               => delayReg5(m5_80deg),
                        DIN_6               => delayReg6(m6_80deg),
                        DIN_7               => delayReg7(m7_80deg),
                        DIN_8               => delayReg8(m8_80deg),
                        DOUT                => SUM(8)
                        );
    
    delay_sum_angle_90deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_90deg),
                        DIN_2               => delayReg2(m2_90deg),
                        DIN_3               => delayReg3(m3_90deg),
                        DIN_4               => delayReg4(m4_90deg),
                        DIN_5               => delayReg5(m5_90deg),
                        DIN_6               => delayReg6(m6_90deg),
                        DIN_7               => delayReg7(m7_90deg),
                        DIN_8               => delayReg8(m8_90deg),
                        DOUT                => SUM(9)
                        );
    
    delay_sum_angle_100deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_100deg),
                        DIN_2               => delayReg2(m2_100deg),
                        DIN_3               => delayReg3(m3_100deg),
                        DIN_4               => delayReg4(m4_100deg),
                        DIN_5               => delayReg5(m5_100deg),
                        DIN_6               => delayReg6(m6_100deg),
                        DIN_7               => delayReg7(m7_100deg),
                        DIN_8               => delayReg8(m8_100deg),
                        DOUT                => SUM(10)
                        );
    
    delay_sum_angle_110deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_110deg),
                        DIN_2               => delayReg2(m2_110deg),
                        DIN_3               => delayReg3(m3_110deg),
                        DIN_4               => delayReg4(m4_110deg),
                        DIN_5               => delayReg5(m5_110deg),
                        DIN_6               => delayReg6(m6_110deg),
                        DIN_7               => delayReg7(m7_110deg),
                        DIN_8               => delayReg8(m8_110deg),
                        DOUT                => SUM(11)
                        );
    
    delay_sum_angle_120deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_120deg),
                        DIN_2               => delayReg2(m2_120deg),
                        DIN_3               => delayReg3(m3_120deg),
                        DIN_4               => delayReg4(m4_120deg),
                        DIN_5               => delayReg5(m5_120deg),
                        DIN_6               => delayReg6(m6_120deg),
                        DIN_7               => delayReg7(m7_120deg),
                        DIN_8               => delayReg8(m8_120deg),
                        DOUT                => SUM(12)
                        );
    
    delay_sum_angle_130deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_130deg),
                        DIN_2               => delayReg2(m2_130deg),
                        DIN_3               => delayReg3(m3_130deg),
                        DIN_4               => delayReg4(m4_130deg),
                        DIN_5               => delayReg5(m5_130deg),
                        DIN_6               => delayReg6(m6_130deg),
                        DIN_7               => delayReg7(m7_130deg),
                        DIN_8               => delayReg8(m8_130deg),
                        DOUT                => SUM(13)
                        );
    
    delay_sum_angle_140deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_140deg),
                        DIN_2               => delayReg2(m2_140deg),
                        DIN_3               => delayReg3(m3_140deg),
                        DIN_4               => delayReg4(m4_140deg),
                        DIN_5               => delayReg5(m5_140deg),
                        DIN_6               => delayReg6(m6_140deg),
                        DIN_7               => delayReg7(m7_140deg),
                        DIN_8               => delayReg8(m8_140deg),
                        DOUT                => SUM(14)
                        );
    
    delay_sum_angle_150deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_150deg),
                        DIN_2               => delayReg2(m2_150deg),
                        DIN_3               => delayReg3(m3_150deg),
                        DIN_4               => delayReg4(m4_150deg),
                        DIN_5               => delayReg5(m5_150deg),
                        DIN_6               => delayReg6(m6_150deg),
                        DIN_7               => delayReg7(m7_150deg),
                        DIN_8               => delayReg8(m8_150deg),
                        DOUT                => SUM(15)
                        );
    
    delay_sum_angle_160deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_160deg),
                        DIN_2               => delayReg2(m2_160deg),
                        DIN_3               => delayReg3(m3_160deg),
                        DIN_4               => delayReg4(m4_160deg),
                        DIN_5               => delayReg5(m5_160deg),
                        DIN_6               => delayReg6(m6_160deg),
                        DIN_7               => delayReg7(m7_160deg),
                        DIN_8               => delayReg8(m8_160deg),
                        DOUT                => SUM(16)
                        );
    
    delay_sum_angle_170deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_170deg),
                        DIN_2               => delayReg2(m2_170deg),
                        DIN_3               => delayReg3(m3_170deg),
                        DIN_4               => delayReg4(m4_170deg),
                        DIN_5               => delayReg5(m5_170deg),
                        DIN_6               => delayReg6(m6_170deg),
                        DIN_7               => delayReg7(m7_170deg),
                        DIN_8               => delayReg8(m8_170deg),
                        DOUT                => SUM(17)
                        );
    
    delay_sum_angle_180deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_180deg),
                        DIN_2               => delayReg2(m2_180deg),
                        DIN_3               => delayReg3(m3_180deg),
                        DIN_4               => delayReg4(m4_180deg),
                        DIN_5               => delayReg5(m5_180deg),
                        DIN_6               => delayReg6(m6_180deg),
                        DIN_7               => delayReg7(m7_180deg),
                        DIN_8               => delayReg8(m8_180deg),
                        DOUT                => SUM(18)
                        );
    
    delay_sum_angle_190deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_190deg),
                        DIN_2               => delayReg2(m2_190deg),
                        DIN_3               => delayReg3(m3_190deg),
                        DIN_4               => delayReg4(m4_190deg),
                        DIN_5               => delayReg5(m5_190deg),
                        DIN_6               => delayReg6(m6_190deg),
                        DIN_7               => delayReg7(m7_190deg),
                        DIN_8               => delayReg8(m8_190deg),
                        DOUT                => SUM(19)
                        );
    
    delay_sum_angle_200deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_200deg),
                        DIN_2               => delayReg2(m2_200deg),
                        DIN_3               => delayReg3(m3_200deg),
                        DIN_4               => delayReg4(m4_200deg),
                        DIN_5               => delayReg5(m5_200deg),
                        DIN_6               => delayReg6(m6_200deg),
                        DIN_7               => delayReg7(m7_200deg),
                        DIN_8               => delayReg8(m8_200deg),
                        DOUT                => SUM(20)
                        );
    
    delay_sum_angle_210deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_210deg),
                        DIN_2               => delayReg2(m2_210deg),
                        DIN_3               => delayReg3(m3_210deg),
                        DIN_4               => delayReg4(m4_210deg),
                        DIN_5               => delayReg5(m5_210deg),
                        DIN_6               => delayReg6(m6_210deg),
                        DIN_7               => delayReg7(m7_210deg),
                        DIN_8               => delayReg8(m8_210deg),
                        DOUT                => SUM(21)
                        );
    
    delay_sum_angle_220deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_220deg),
                        DIN_2               => delayReg2(m2_220deg),
                        DIN_3               => delayReg3(m3_220deg),
                        DIN_4               => delayReg4(m4_220deg),
                        DIN_5               => delayReg5(m5_220deg),
                        DIN_6               => delayReg6(m6_220deg),
                        DIN_7               => delayReg7(m7_220deg),
                        DIN_8               => delayReg8(m8_220deg),
                        DOUT                => SUM(22)
                        );
    
    delay_sum_angle_230deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_230deg),
                        DIN_2               => delayReg2(m2_230deg),
                        DIN_3               => delayReg3(m3_230deg),
                        DIN_4               => delayReg4(m4_230deg),
                        DIN_5               => delayReg5(m5_230deg),
                        DIN_6               => delayReg6(m6_230deg),
                        DIN_7               => delayReg7(m7_230deg),
                        DIN_8               => delayReg8(m8_230deg),
                        DOUT                => SUM(23)
                        );
    
    delay_sum_angle_240deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_240deg),
                        DIN_2               => delayReg2(m2_240deg),
                        DIN_3               => delayReg3(m3_240deg),
                        DIN_4               => delayReg4(m4_240deg),
                        DIN_5               => delayReg5(m5_240deg),
                        DIN_6               => delayReg6(m6_240deg),
                        DIN_7               => delayReg7(m7_240deg),
                        DIN_8               => delayReg8(m8_240deg),
                        DOUT                => SUM(24)
                        );
    
    delay_sum_angle_250deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_250deg),
                        DIN_2               => delayReg2(m2_250deg),
                        DIN_3               => delayReg3(m3_250deg),
                        DIN_4               => delayReg4(m4_250deg),
                        DIN_5               => delayReg5(m5_250deg),
                        DIN_6               => delayReg6(m6_250deg),
                        DIN_7               => delayReg7(m7_250deg),
                        DIN_8               => delayReg8(m8_250deg),
                        DOUT                => SUM(25)
                        );
    
    delay_sum_angle_260deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_260deg),
                        DIN_2               => delayReg2(m2_260deg),
                        DIN_3               => delayReg3(m3_260deg),
                        DIN_4               => delayReg4(m4_260deg),
                        DIN_5               => delayReg5(m5_260deg),
                        DIN_6               => delayReg6(m6_260deg),
                        DIN_7               => delayReg7(m7_260deg),
                        DIN_8               => delayReg8(m8_260deg),
                        DOUT                => SUM(26)
                        );
    
    delay_sum_angle_270deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_270deg),
                        DIN_2               => delayReg2(m2_270deg),
                        DIN_3               => delayReg3(m3_270deg),
                        DIN_4               => delayReg4(m4_270deg),
                        DIN_5               => delayReg5(m5_270deg),
                        DIN_6               => delayReg6(m6_270deg),
                        DIN_7               => delayReg7(m7_270deg),
                        DIN_8               => delayReg8(m8_270deg),
                        DOUT                => SUM(27)
                        );
    
    delay_sum_angle_280deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_280deg),
                        DIN_2               => delayReg2(m2_280deg),
                        DIN_3               => delayReg3(m3_280deg),
                        DIN_4               => delayReg4(m4_280deg),
                        DIN_5               => delayReg5(m5_280deg),
                        DIN_6               => delayReg6(m6_280deg),
                        DIN_7               => delayReg7(m7_280deg),
                        DIN_8               => delayReg8(m8_280deg),
                        DOUT                => SUM(28)
                        );
    
    delay_sum_angle_290deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_290deg),
                        DIN_2               => delayReg2(m2_290deg),
                        DIN_3               => delayReg3(m3_290deg),
                        DIN_4               => delayReg4(m4_290deg),
                        DIN_5               => delayReg5(m5_290deg),
                        DIN_6               => delayReg6(m6_290deg),
                        DIN_7               => delayReg7(m7_290deg),
                        DIN_8               => delayReg8(m8_290deg),
                        DOUT                => SUM(29)
                        );
    
    delay_sum_angle_300deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_300deg),
                        DIN_2               => delayReg2(m2_300deg),
                        DIN_3               => delayReg3(m3_300deg),
                        DIN_4               => delayReg4(m4_300deg),
                        DIN_5               => delayReg5(m5_300deg),
                        DIN_6               => delayReg6(m6_300deg),
                        DIN_7               => delayReg7(m7_300deg),
                        DIN_8               => delayReg8(m8_300deg),
                        DOUT                => SUM(30)
                        );
    
    delay_sum_angle_310deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_310deg),
                        DIN_2               => delayReg2(m2_310deg),
                        DIN_3               => delayReg3(m3_310deg),
                        DIN_4               => delayReg4(m4_310deg),
                        DIN_5               => delayReg5(m5_310deg),
                        DIN_6               => delayReg6(m6_310deg),
                        DIN_7               => delayReg7(m7_310deg),
                        DIN_8               => delayReg8(m8_310deg),
                        DOUT                => SUM(31)
                        );
    
    delay_sum_angle_320deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_320deg),
                        DIN_2               => delayReg2(m2_320deg),
                        DIN_3               => delayReg3(m3_320deg),
                        DIN_4               => delayReg4(m4_320deg),
                        DIN_5               => delayReg5(m5_320deg),
                        DIN_6               => delayReg6(m6_320deg),
                        DIN_7               => delayReg7(m7_320deg),
                        DIN_8               => delayReg8(m8_320deg),
                        DOUT                => SUM(32)
                        );
    
    delay_sum_angle_330deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_330deg),
                        DIN_2               => delayReg2(m2_330deg),
                        DIN_3               => delayReg3(m3_330deg),
                        DIN_4               => delayReg4(m4_330deg),
                        DIN_5               => delayReg5(m5_330deg),
                        DIN_6               => delayReg6(m6_330deg),
                        DIN_7               => delayReg7(m7_330deg),
                        DIN_8               => delayReg8(m8_330deg),
                        DOUT                => SUM(33)
                        );
    
    delay_sum_angle_340deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_340deg),
                        DIN_2               => delayReg2(m2_340deg),
                        DIN_3               => delayReg3(m3_340deg),
                        DIN_4               => delayReg4(m4_340deg),
                        DIN_5               => delayReg5(m5_340deg),
                        DIN_6               => delayReg6(m6_340deg),
                        DIN_7               => delayReg7(m7_340deg),
                        DIN_8               => delayReg8(m8_340deg),
                        DOUT                => SUM(34)
                        );
    
    delay_sum_angle_350deg_comp : delaySumAngle
            port map  ( RST                 => RST,
                        CLK                 => CLK,
                        CLK_CE              => CLK_CE,
                        DIN_1               => delayReg1(m1_350deg),
                        DIN_2               => delayReg2(m2_350deg),
                        DIN_3               => delayReg3(m3_350deg),
                        DIN_4               => delayReg4(m4_350deg),
                        DIN_5               => delayReg5(m5_350deg),
                        DIN_6               => delayReg6(m6_350deg),
                        DIN_7               => delayReg7(m7_350deg),
                        DIN_8               => delayReg8(m8_350deg),
                        DOUT                => SUM(35)
                        );


    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------------- DELAY REGISTER ----------------------------------
    
    -- data input process
    data_input_shift_process : process (RST, CLK)
    begin
        if (RST = '1') then
            delayReg1 <= (others => (others => '0'));
            delayReg2 <= (others => (others => '0'));
            delayReg3 <= (others => (others => '0'));
            delayReg4 <= (others => (others => '0'));
            delayReg5 <= (others => (others => '0'));
            delayReg6 <= (others => (others => '0'));
            delayReg7 <= (others => (others => '0'));
            delayReg8 <= (others => (others => '0'));
        elsif (rising_edge(CLK)) then
            if (CLK_CE = '1') then
                -- input data
                delayReg1(0) <= DIN(0);
                delayReg2(0) <= DIN(1);
                delayReg3(0) <= DIN(2);
                delayReg4(0) <= DIN(3);
                delayReg5(0) <= DIN(4);
                delayReg6(0) <= DIN(5);
                delayReg7(0) <= DIN(6);
                delayReg8(0) <= DIN(7);
                -- shift register data
                delayReg1(1 to 13) <= delayReg1(0 to 12);
                delayReg2(1 to 13) <= delayReg2(0 to 12);
                delayReg3(1 to 13) <= delayReg3(0 to 12);
                delayReg4(1 to 13) <= delayReg4(0 to 12);
                delayReg5(1 to 13) <= delayReg5(0 to 12);
                delayReg6(1 to 13) <= delayReg6(0 to 12);
                delayReg7(1 to 13) <= delayReg7(0 to 12);
                delayReg8(1 to 13) <= delayReg8(0 to 12);
            end if;
        end if;
    end process data_input_shift_process;

end Behavioral;

