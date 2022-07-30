----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2020 19:41:42
-- Design Name: 
-- Module Name: micArrayBf_top - Behavioral
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

entity micArrayBeamformer_top is
    generic   ( SYS_RST_VAL         : integer   := 10000000; -- no. of sysClk cycles before reset (10000000=0.1ms@100Mhz)
                MMCM_RST_VAL        : integer   := 3072000   -- no. of mmcmClk cycles before reset (3072000=0.1ms@61.44Mhz)
                );
    port      ( CLK                 : in    std_logic;  -- board clock (100Mhz)
                -- PDM SIGNALS
                CLK_PDM_HD          : out   std_logic;  -- pdm mic clock (3.072 MHz)
                PDM_DIN_1           : in    std_logic;  -- pdm input data 1
                PDM_DIN_2           : in    std_logic;  -- pdm input data 2
                PDM_DIN_3           : in    std_logic;  -- pdm input data 3
                PDM_DIN_4           : in    std_logic;  -- pdm input data 4
                -- SEVEN SEG DISPLAY
                SSD_SEG_NUM         : out   std_logic_vector (3 downto 0);
                SSD_SEG_VALUE       : out   std_logic_vector (6 downto 0);
                -- STEPPER MOTOR SIGNALS		
                MOTOR_SIG_OUT       : out   std_logic_vector (3 downto 0)
                );  
end micArrayBeamformer_top;

architecture Behavioral of micArrayBeamformer_top is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component clocks
    port      ( RST_SYS             : in    std_logic;
                RST_MMCM            : in    std_logic;
                CLK_SYS             : in    std_logic;
                -- MMCM CLOCK AND DIVIDED SIGNALS
                CLK_MMCM            : out   std_logic;      -- mmcm clk half-duty (61.44 MHz)
                CLK_MMCM_LOCK       : out   std_logic;      -- mmcm clk lock signal
                CLK_PDM_CE          : out   std_logic;      -- pdm clock enable (3.072 MHz)
                CLK_PDM_CE_PHASE    : out   std_logic;      -- pdm clock enable, 180 deg out of phase
                CLK_PDM_HD          : out   std_logic;      -- pdm clock half duty
                CLK_FLT8_CE         : out   std_logic;      -- clock enable for filter rate (8 times slower than pdm clk) (384 kHz)
                CLK_FLT16_CE        : out   std_logic;      -- clock enable for filter rate (16 times slower than pdm clk) (192 kHz)
                CLK_FLT32_CE        : out   std_logic;      -- clock enable for filter rate (32 times slower than pdm clk) (96 kHz)
                CLK_PCM_CE          : out   std_logic;      -- pcm clock enable (48 kHz)
                CLK_PCM_CE_PHASE    : out   std_logic;      -- pcm clock enable, 180 deg out of phase
                -- SYS CLOCK DIVIDED SIGNALS
                CLK_SPI_CE          : out   std_logic       -- spi clock enable (10 MHz)
                );             
end component;

component pdm2bitDecode
    port      ( RST                 : in    std_logic;          -- system reset
                CLK                 : in    std_logic;          -- system clk
                CLK_PDM_CE          : in    std_logic;          -- pdm clock enable
                -- PDM DATA
                PDM_DIN_1           : in    std_logic;           -- pdm data input pair 1
                PDM_DIN_2           : in    std_logic;           -- pdm data input pair 2
                PDM_DIN_3           : in    std_logic;           -- pdm data input pair 3
                PDM_DIN_4           : in    std_logic;           -- pdm data input pair 4
                PDM_2BIT_DOUT       : out   vector_of_stdLogVec2bit (0 to 7)  -- pdm data output in 2 bit format
                );
end component;

component cicDemod
    port      ( RST                 : in    std_logic;  -- system reset
                CLK                 : in    std_logic;  -- sys clock
                CLK_PDM_CE          : in    std_logic;  -- pdm clock
                PDM_DIN             : in    vector_of_stdLogVec2bit (0 to 7);   -- 2-bit pdm data in
                PCM_DOUT            : out   vector_of_stdLogVec16bit (0 to 7)   -- pcm data out                     
                );
end component;

--component cicFirDemod
--    port      ( RST                 : in    std_logic;                      -- system reset
--                CLK                 : in    std_logic;                      -- sys clock
--                CLK_PDM_CE          : in    std_logic;                      -- pdm clock
--                CLK_FLT8_CE         : in    std_logic;                      -- clock for filter rate (8 times slower than pdm clk)
--                CLK_FLT16_CE        : in    std_logic;                      -- clock for filter rate (16 times slower than pdm clk)
--                CLK_FLT32_CE        : in    std_logic;                      -- clock for filter rate (32 times slower than pdm clk)
--                PDM_DIN             : in    vector_of_stdLogVec2bit (0 to 7);   -- 2-bit pdm data in
--                PCM_DOUT            : out   vector_of_stdLogVec16bit (0 to 7)   -- pcm data out                     
--                );
--end component;

component dcFiltering
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_CE              : in    std_logic;                      -- clock enable
                DIN                 : in    vector_of_stdLogVec16bit (0 to 7);  -- data inin
                DOUT                : out   vector_of_stdLogVec16bit (0 to 7)   -- data out                   
                );
end component;

component delaySum
    port      ( CLK                 : in    std_logic;
                RST                 : in    std_logic;
                CLK_CE              : in    std_logic;
                DIN                 : in    vector_of_stdLogVec16bit (0 to 7);
                SUM                 : out   vector_of_stdLogVec19bit (0 to 35)
                );
end component;

component accumData
    port      ( RST                 : in    std_logic;
                CLK                 : in    std_logic;
                CLK_CE              : in    std_logic;
                DATA_HOLD_FLG       : out   std_logic;
                SUM_DIN             : in    vector_of_stdLogVec19bit (0 to 35);
                ACC_DOUT            : out   vector_of_stdLogVec32bit (0 to 35)              
                );                        
end component;

component maxValue
    port      ( RST                 : in    std_logic;  -- system reset
                CLK                 : in    std_logic;  -- sys clock
                CLK_CE              : in    std_logic;  -- clock enable
                RD_VAL_CE           : in    std_logic;  -- read trigger clock enable
                DIN                 : in    vector_of_stdLogVec32bit (0 to 35);  -- input data
                MAX_VAL_IDX         : out   std_logic_vector (5 downto 0);   -- max value index (ref din)
                DONE_EN             : out   std_logic
                );
end component;

component sevenSegDisp
    port      ( RST                 : in    std_logic;                          -- reset
                CLK                 : in    std_logic;                          -- 100 MHz clock input
                SEV_SEG_SEL         : in    std_logic_vector (5 downto 0);      -- input that selects which number to display
                SEG_NUM             : out   std_logic_vector (3 downto 0);      -- selects the segment to light
                SEG_VAL             : out   std_logic_vector (6 downto 0)       -- the value that the segment displays
                );
end component;

component stepperMotor_dirPoint		
    port      ( RST_SYS             : in    std_logic;		
                CLK_SYS             : in    std_logic;		
                RD_EN_FLG           : in    std_logic;		
                POSITION            : in    std_logic_vector (5 downto 0);		
                MOTOR_SIG_OUT       : out   std_logic_vector (3 downto 0)		
                );		
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- reset function
signal  rstCnt              : integer range 0 to SYS_RST_VAL;
signal  rstSys              : std_logic                         := '1';

-- rst MMCM
signal  rstCntMMCM          : integer range 0 to MMCM_RST_VAL;
signal  rstMMCM             : std_logic                         := '1';

-- clocking signals
signal  clkMmcm             : std_logic; 
signal  clkMmcmLock         : std_logic; 
signal  clkPdmCE            : std_logic;    
signal  clkPdmCEphase       : std_logic;
signal  clkPcmCE            : std_logic;
signal  clkFlt8Ce           : std_logic;
signal  clkFlt16Ce          : std_logic;
signal  clkFlt32Ce          : std_logic;  
signal  clkPcmCEphase       : std_logic;
signal  clkSpiCE            : std_logic;

-- pdm 2 bit signals
signal  pdm2BitVec          : vector_of_stdLogVec2bit (0 to 7);

-- pcm signals
signal  pcmDataVec          : vector_of_stdLogVec16bit (0 to 7);

-- high pass filtered data signals
signal  dcFltDataVec        : vector_of_stdLogVec16bit (0 to 7);

-- delay and sum signals
signal sumVec               : vector_of_stdLogVec19bit (0 to 35);

-- accumulated outputs
signal accVec               : vector_of_stdLogVec32bit (0 to 35);
signal accDataRdFlg         : std_logic;

-- max value signal
signal maxValIdx            : std_logic_vector (5 downto 0); 
signal maxValDoneEn         : std_logic;

-- seven segment display
signal sevenSegSelect       : std_logic_vector (5 downto 0);

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    clocking_comp : clocks                     
        port map  ( RST_SYS             => rstSys,
                    RST_MMCM            => rstMMCM,
                    CLK_SYS             => CLK,
                    -- MMCM CLOCK DIVIDED SIGNALS
                    CLK_MMCM            => clkMmcm, 
                    CLK_MMCM_LOCK       => clkMmcmLock,
                    CLK_PDM_CE          => clkPdmCE,
                    CLK_PDM_CE_PHASE    => clkPdmCEphase,
                    CLK_PDM_HD          => CLK_PDM_HD,
                    CLK_FLT8_CE         => clkFlt8Ce,
                    CLK_FLT16_CE        => clkFlt16Ce,
                    CLK_FLT32_CE        => clkFlt32Ce,    
                    CLK_PCM_CE          => clkPcmCE,
                    CLK_PCM_CE_PHASE    => clkPcmCEphase,
                    -- SYS CLOCK DIVIDED SIGNALS
                    CLK_SPI_CE          => clkSpiCE
                    );
                    
    pdm2bitDecode_comp : pdm2bitDecode
        port map  ( RST                 => rstMMCM,
                    CLK                 => clkMmcm,
                    CLK_PDM_CE          => clkPdmCE,
                    -- PDM DATA
                    PDM_DIN_1           => PDM_DIN_1,
                    PDM_DIN_2           => PDM_DIN_2,
                    PDM_DIN_3           => PDM_DIN_3,
                    PDM_DIN_4           => PDM_DIN_4,
                    PDM_2BIT_DOUT       => pdm2BitVec
                    );
 
     cicDemod_comp : cicDemod
        port map  ( RST                 => rstMMCM,
                    CLK                 => clkMmcm,
                    CLK_PDM_CE          => clkPdmCE,
                    PDM_DIN             => pdm2BitVec,
                    PCM_DOUT            => pcmDataVec                     
                    ); 
                   
--    cicFirDemod_comp : cicFirDemod
--        port map  ( RST                 => rstMMCM,
--                    CLK                 => clkMmcm,
--                    CLK_PDM_CE          => clkPdmCE,
--                    CLK_FLT8_CE         => clkFlt8Ce,
--                    CLK_FLT16_CE        => clkFlt16Ce,
--                    CLK_FLT32_CE        => clkFlt32Ce,
--                    PDM_DIN             => pdm2BitVec,
--                    PCM_DOUT            => pcmDataVec                     
--                    );
                      
    dcFiltering_comp : dcFiltering
        port map  ( RST                 => rstMMCM,
                    CLK                 => clkMmcm,
                    CLK_CE              => clkPcmCE,
                    DIN                 => pcmDataVec,
                    DOUT                => dcFltDataVec                     
                    );
                    
    delay_sum_comp : delaySum  
        port map  ( CLK                 => clkMMCM,
                    RST                 => rstMMCM,
                    CLK_CE              => clkPcmCE,
                    DIN                 => dcFltDataVec,
                    SUM                 => sumVec
                    ); 
    
    accum_comp : accumData
        port map  ( RST                 => rstMMCM,
                    CLK                 => clkMMCM,
                    CLK_CE              => clkPcmCe,
                    DATA_HOLD_FLG       => accDataRdFlg,
                    SUM_DIN             => sumVec,
                    ACC_DOUT            => accVec               
                );
    max_value_comp : maxValue          
        port map  ( RST                 => rstMMCM,
                    CLK                 => clkMMCM,
                    CLK_CE              => clkPcmCe,
                    RD_VAL_CE           => accDataRdFlg,
                    DIN                 => accVec,
                    MAX_VAL_IDX         => maxValIdx,
                    DONE_EN             => maxValDoneEn
                    );
                
    seven_seg_disp_comp : sevenSegDisp
        port map  ( RST                 => rstMMCM,
                    CLK                 => clkMMCM,
                    SEV_SEG_SEL         => sevenSegSelect,
                    SEG_NUM             => SSD_SEG_NUM,
                    SEG_VAL             => SSD_SEG_VALUE
                    );
                    
    stepper_motor_comp: stepperMotor_dirPoint		
        port map  ( RST_SYS             => rstMMCM,		
                    CLK_SYS             => clkMMCM,		
                    RD_EN_FLG           => maxValDoneEn,		
                    POSITION            => maxValIdx,		
                    MOTOR_SIG_OUT       => MOTOR_SIG_OUT		
                    );
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------------- SYSTEM RESET -------------------------------------
    
    -- rst counting process
    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (rstSys = '1') then
                if (rstCnt = SYS_RST_VAL) then 
                    rstCnt <= 0;
                else
                    rstCnt <= rstCnt + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- system reset line (high when active)
    rstSys <= '0' when (rstCnt = SYS_RST_VAL) else '1';       
       
    -- mmcm rst counting process
    process(clkMmcm)
    begin
        if (rising_edge(clkMmcm)) then
            if (rstMMCM = '1') then
                if (rstCntMMCM = MMCM_RST_VAL) then
                    rstCntMMCM <= 0;
                else
                    rstCntMMCM <= rstCntMMCM + 1;
                end if;
            end if;
        end if;
    end process;
    
    -- system reset line (high when active)
    rstMMCM <= '0' when (rstCntMMCM = MMCM_RST_VAL and clkMmcmLock = '1') else '1'; 
    
    ------------------------------ SEVEN SEG DISP -------------------------------------

    -- SEVEN SEG SELECT APPLY
    sevenSegSelect_process : process (rstMMCM, clkMMCM)
    begin
        if (rstMMCM = '1') then
            sevenSegSelect <= (others => '0');
        elsif(rising_edge(clkMMCM)) then
            if (clkPcmCePhase = '1') then
                sevenSegSelect <= maxValIdx;
            end if;
        end if;
    end process; 
    
    
end Behavioral;
