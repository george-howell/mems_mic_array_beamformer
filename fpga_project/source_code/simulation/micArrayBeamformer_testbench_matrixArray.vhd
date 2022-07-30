----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2020 20:53:59
-- Design Name: 
-- Module Name: micArrayBf_tb - Behavioral
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

-- libraries
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_textio.all;

library std;
use std.textio.all;  --include package textio.vhd

use work.instruction_buffer_type.all;

-----------------------------------------------------------------------------
-------------------------- IO DECLERATIONS ----------------------------------
-----------------------------------------------------------------------------

entity micArrayBeamformer_testbench is
--  Port ( );
end micArrayBeamformer_testbench;

architecture Behavioral of micArrayBeamformer_testbench is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

component micArrayBeamformer_top
    generic   ( SYS_RST_VAL         : integer   := 20;  -- no. of sysClk cycles before reset
                MMCM_RST_VAL        : integer   := 20   -- no. of mmcmClk cycles before reset
                );
    port      ( CLK                 : in    std_logic;  -- board clock (100Mhz)
                -- PDM SIGNALS
                CLK_PDM_HD          : out   std_logic;  -- pdm mic clock (3.072 MHz)
                PDM_DIN             : in    vector_of_stdLogVec (0 to 7); -- pdm data input
                -- SEVEN SEG DISPLAY
                SSD_SEG_NUM         : out std_logic_vector (3 downto 0);
                SSD_SEG_VALUE       : out std_logic_vector (6 downto 0)
                );    
end component;

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

constant    dataDir             : string                            := "C:\Users\G\Documents\vivado_projects\mems_mic_array_beamformer\fpga_project\sim_mic_data\";

-- clock signals
constant    clkHalfPeriod       : time                              := 5ns;         -- half the sample period for 100MHz system board clock
signal      simClk              : std_logic                         := '0';
signal      clkPdmHD            : std_logic;  

-- pdm signals
constant    clkPdmHP            : time                              := 162.7604ns;  -- half period of pdm clock signal [162.7604@3.072MHz]
signal      dataStartCue        : std_logic                         := '0';         -- signal that only allows pdm data start once
constant    pdmDataStart        : time                              := 7881.068ns;  -- time before pdm data starts
signal      endoffile           : bit                               := '0';         -- bit for indicating end of file.
signal      pdmDataTmp1         : std_logic_vector (0 downto 0);
signal      pdmDataTmp2         : std_logic_vector (0 downto 0);
signal      pdmDataTmp3         : std_logic_vector (0 downto 0);
signal      pdmDataTmp4         : std_logic_vector (0 downto 0);
signal      pdmDataTmp5         : std_logic_vector (0 downto 0);
signal      pdmDataTmp6         : std_logic_vector (0 downto 0);
signal      pdmDataTmp7         : std_logic_vector (0 downto 0);
signal      pdmDataTmp8         : std_logic_vector (0 downto 0);
signal      pdmData             : vector_of_stdLogVec (0 to 7);

-- seven segment display signals
signal      ssdSegNum           : std_logic_vector (3 downto 0);
signal      ssdSegVal           : std_logic_vector (6 downto 0);

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    TOP : micArrayBeamformer_top
    port map  ( CLK             => simClk,     
                CLK_PDM_HD      => clkPdmHD,
                -- PDM SIGNALS
                PDM_DIN         => pdmData,
                -- SEVEN SEG DISPLAY
                SSD_SEG_NUM     => ssdSegNum,
                SSD_SEG_VALUE   => ssdSegVal
                );    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

    ------------------------------------ CLOCKS ---------------------------------------
    
    -- sys clock Process
    process
        begin
            simClk <= '0';
        wait for clkHalfPeriod;  --for 0.5 ns signal is '0'.
            simClk <= '1';          
        wait for clkHalfPeriod;  --for next 0.5 ns signal is '1'.     
    end process;
    
    ---------------------------------- PDM SIGNAL -------------------------------------
    
    --- read pdm data from text file
    process
        -- data 1, pair 1
        file        infile1_1        : text is in  dataDir & "pdm_out_1.txt";  -- declare input file
        variable    inline1_1        : line;                     -- line number declaration
        variable    dataread1_1      : real;
        -- data 2, pair 1
        file        infile2_1        : text is in  dataDir & "pdm_out_2.txt";  -- declare input file
        variable    inline2_1        : line;                     -- line number declaration
        variable    dataread2_1      : real;
        -- data 1, pair 2
        file        infile1_2        : text is in  dataDir & "pdm_out_3.txt";  -- declare input file
        variable    inline1_2        : line;                     -- line number declaration
        variable    dataread1_2      : real;
        -- data 2, pair 2
        file        infile2_2        : text is in  dataDir & "pdm_out_4.txt";  -- declare input file
        variable    inline2_2        : line;                     -- line number declaration
        variable    dataread2_2      : real;
        -- data 1, pair 3
        file        infile1_3        : text is in  dataDir & "pdm_out_5.txt";  -- declare input file
        variable    inline1_3        : line;                     -- line number declaration
        variable    dataread1_3      : real;
        -- data 2, pair 3
        file        infile2_3        : text is in  dataDir & "pdm_out_6.txt";  -- declare input file
        variable    inline2_3        : line;                     -- line number declaration
        variable    dataread2_3      : real;
        -- data 1, pair 4
        file        infile1_4        : text is in  dataDir & "pdm_out_7.txt";  -- declare input file
        variable    inline1_4        : line;                     -- line number declaration
        variable    dataread1_4      : real;
        -- data 2, pair 4
        file        infile2_4        : text is in  dataDir & "pdm_out_8.txt";  -- declare input file
        variable    inline2_4        : line;                     -- line number declaration
        variable    dataread2_4      : real;
    begin
        if (dataStartCue = '0') then
            dataStartCue <= '1';
            wait for pdmDataStart;
        else
            -- data 1, pair 1
            if (not endfile(infile1_1)) then       -- checking the "END OF FILE" is not reached.
                readline(infile1_1, inline1_1);       -- reading a line from the file.         
                read(inline1_1, dataread1_1);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp1 <= conv_std_logic_vector(integer(dataread1_1),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if; 
            
            -- data 1, pair 2
            if (not endfile(infile1_2)) then       -- checking the "END OF FILE" is not reached.
                readline(infile1_2, inline1_2);       -- reading a line from the file.         
                read(inline1_2, dataread1_2);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp3 <= conv_std_logic_vector(integer(dataread1_2),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if; 
            
            -- data 1, pair 3
            if (not endfile(infile1_3)) then       -- checking the "END OF FILE" is not reached.
                readline(infile1_3, inline1_3);       -- reading a line from the file.         
                read(inline1_3, dataread1_3);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp5 <= conv_std_logic_vector(integer(dataread1_3),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if; 
            
            -- data 1, pair 4
            if (not endfile(infile1_4)) then       -- checking the "END OF FILE" is not reached.
                readline(infile1_4, inline1_4);       -- reading a line from the file.         
                read(inline1_4, dataread1_4);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp7 <= conv_std_logic_vector(integer(dataread1_4),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if; 
                     
            wait for clkPdmHP;
            
            -- data 2, pair 1
            if (not endfile(infile2_1)) then       -- checking the "END OF FILE" is not reached.
                readline(infile2_1, inline2_1);       -- reading a line from the file.         
                read(inline2_1, dataread2_1);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp2 <= conv_std_logic_vector(integer(dataread2_1),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if;
            
            -- data 2, pair 2
            if (not endfile(infile2_2)) then       -- checking the "END OF FILE" is not reached.
                readline(infile2_2, inline2_2);       -- reading a line from the file.         
                read(inline2_2, dataread2_2);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp4 <= conv_std_logic_vector(integer(dataread2_2),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if;
            
            -- data 2, pair 3
            if (not endfile(infile2_3)) then       -- checking the "END OF FILE" is not reached.
                readline(infile2_3, inline2_3);       -- reading a line from the file.         
                read(inline2_3, dataread2_3);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp6 <= conv_std_logic_vector(integer(dataread2_3),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if;
            
            -- data 2, pair 4
            if (not endfile(infile2_4)) then       -- checking the "END OF FILE" is not reached.
                readline(infile2_4, inline2_4);       -- reading a line from the file.         
                read(inline2_4, dataread2_4);         -- reading the data from the line and putting it in a real type variable.
                pdmDataTmp8 <= conv_std_logic_vector(integer(dataread2_4),1);   -- put the value available in variable in a signal.
            else
                endoffile <= '1';                   --set signal to tell end of file read file is reached.
            end if;
                    
            wait for clkPdmHP;
            
        end if;                 
    end process;
    
    -- pdm pair 1
    pdmData(0) <=  '1' when (pdmDataTmp1 = "1") else
                   '0' when (pdmDataTmp1 = "0") else
                   'U';
                 
    -- pdm pair 2
    pdmData(1) <=  '1' when (pdmDataTmp2 = "1") else
                   '0' when (pdmDataTmp2 = "0") else
                   'U';
    
    -- pdm pair 3
    pdmData(2) <=  '1' when (pdmDataTmp3 = "1") else
                   '0' when (pdmDataTmp3 = "0") else
                   'U';
    
    -- pdm pair 4
    pdmData(3) <=  '1' when (pdmDataTmp4 = "1") else
                   '0' when (pdmDataTmp4 = "0") else
                   'U';
                 
    -- pdm pair 1
    pdmData(4) <=  '1' when (pdmDataTmp5 = "1") else
                   '0' when (pdmDataTmp5 = "0") else
                   'U';
                 
    -- pdm pair 2
    pdmData(5) <=  '1' when (pdmDataTmp6 = "1") else
                   '0' when (pdmDataTmp6 = "0") else
                   'U';
    
    -- pdm pair 3
    pdmData(6) <=  '1' when (pdmDataTmp7 = "1") else
                   '0' when (pdmDataTmp7 = "0") else
                   'U';
    
    -- pdm pair 4
    pdmData(7) <=  '1' when (pdmDataTmp8 = "1") else
                   '0' when (pdmDataTmp8 = "0") else
                   'U';
                 
    
                
end Behavioral;
