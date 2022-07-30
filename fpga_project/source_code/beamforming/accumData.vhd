----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2018 18:13:54
-- Design Name: 
-- Module Name: accum_sum - Behavioral
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

entity accumData is
    generic   ( ACC_RST_VAL         : integer   := 48000 --48000 -- no. of samples the accumulator sums 48000@48kHz
                );
    port      ( RST                 : in    std_logic;
                CLK                 : in    std_logic;
                CLK_CE              : in    std_logic;
                DATA_HOLD_FLG       : out   std_logic;
                SUM_DIN             : in    vector_of_stdLogVec19bit (0 to 35);
                ACC_DOUT            : out   vector_of_stdLogVec32bit (0 to 35)              
                );                       
end accumData;

architecture Behavioral of accumData is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component accum
    port      ( RST                 : in    std_logic;
                CLK                 : in    std_logic;
                CLK_CE              : in    std_logic;
                RST_ACC             : in    std_logic;
                DIN                 : in    std_logic_vector (18 downto 0);
                DOUT                : out   std_logic_vector (31 downto 0)            
                ); 
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- data hold out and accumulator reset signals
signal accRstCnt                : integer range 0 to ACC_RST_VAL;
signal accumRstFlg              : std_logic;

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    accum_0deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(0),
                    DOUT            => ACC_DOUT(0)
                    );
    
    accum_10deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(1),
                    DOUT            => ACC_DOUT(1)
                    );
    
    accum_20deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(2),
                    DOUT            => ACC_DOUT(2)
                    );
    
    accum_30deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(3),
                    DOUT            => ACC_DOUT(3)
                    );
    
    accum_40deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(4),
                    DOUT            => ACC_DOUT(4)
                    );
    
    accum_50deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(5),
                    DOUT            => ACC_DOUT(5)
                    );
    
    accum_60deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(6),
                    DOUT            => ACC_DOUT(6)
                    );
    
    accum_70deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(7),
                    DOUT            => ACC_DOUT(7)
                    );
    
    accum_80deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(8),
                    DOUT            => ACC_DOUT(8)
                    );
    
    accum_90deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(9),
                    DOUT            => ACC_DOUT(9)
                    );
    
    accum_100deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(10),
                    DOUT            => ACC_DOUT(10)
                    );
    
    accum_110deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(11),
                    DOUT            => ACC_DOUT(11)
                    );
    
    accum_120deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(12),
                    DOUT            => ACC_DOUT(12)
                    );
    
    accum_130deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(13),
                    DOUT            => ACC_DOUT(13)
                    );
    
    accum_140deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(14),
                    DOUT            => ACC_DOUT(14)
                    );
    
    accum_150deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(15),
                    DOUT            => ACC_DOUT(15)
                    );
    
    accum_160deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(16),
                    DOUT            => ACC_DOUT(16)
                    );
    
    accum_170deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(17),
                    DOUT            => ACC_DOUT(17)
                    );
    
    accum_180deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(18),
                    DOUT            => ACC_DOUT(18)
                    );
    
    accum_190deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(19),
                    DOUT            => ACC_DOUT(19)
                    );
    
    accum_200deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(20),
                    DOUT            => ACC_DOUT(20)
                    );
    
    accum_210deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(21),
                    DOUT            => ACC_DOUT(21)
                    );
    
    accum_220deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(22),
                    DOUT            => ACC_DOUT(22)
                    );
    
    accum_230deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(23),
                    DOUT            => ACC_DOUT(23)
                    );
    
    accum_240deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(24),
                    DOUT            => ACC_DOUT(24)
                    );
    
    accum_250deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(25),
                    DOUT            => ACC_DOUT(25)
                    );
    
    accum_260deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(26),
                    DOUT            => ACC_DOUT(26)
                    );
    
    accum_270deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(27),
                    DOUT            => ACC_DOUT(27)
                    );
    
    accum_280deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(28),
                    DOUT            => ACC_DOUT(28)
                    );
    
    accum_290deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(29),
                    DOUT            => ACC_DOUT(29)
                    );
    
    accum_300deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(30),
                    DOUT            => ACC_DOUT(30)
                    );
    
    accum_310deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(31),
                    DOUT            => ACC_DOUT(31)
                    );
    
    accum_320deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(32),
                    DOUT            => ACC_DOUT(32)
                    );
    
    accum_330deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(33),
                    DOUT            => ACC_DOUT(33)
                    );
    
    accum_340deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(34),
                    DOUT            => ACC_DOUT(34)
                    );
    
    accum_350deg_comp : accum
        port map  ( RST             => RST,
                    CLK             => CLK,
                    CLK_CE          => CLK_CE,
                    RST_ACC         => accumRstFlg,
                    DIN             => SUM_DIN(35),
                    DOUT            => ACC_DOUT(35)
                    );

 
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

    ------------------------------- ACCUMULATOR RESET ---------------------------------
    
    acc_reset_process : process (RST, CLK)
    begin
        if (RST = '1') then
            accRstCnt <= 0;
        elsif (rising_edge(CLK)) then
            if (CLK_CE = '1') then
                if (accRstCnt < (ACC_RST_VAL-1)) then
                    accRstCnt <= accRstCnt + 1;                    
                else
                    accRstCnt <= 0;
                end if;
            end if;
        end if;
    end process acc_reset_process;
    
    -- acc reset flag
    accumRstFlg <= '1' when (accRstCnt = (ACC_RST_VAL-1) and CLK_CE = '1') else '0';
    
    -- data hold flag
    DATA_HOLD_FLG <= '1' when (accumRstFlg = '1' and CLK_CE = '1') else '0';

end Behavioral;
