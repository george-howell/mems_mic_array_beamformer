----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.08.2020 19:09:26
-- Design Name: 
-- Module Name: cicFlt_4thOrd_64DecFact - Behavioral
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

entity cicFlt_4thOrd_64DecFact is
    port      ( RST                 : in    std_logic;                      -- system reset
                CLK                 : in    std_logic;                      -- sys clock
                CLK_CE              : in    std_logic;                      -- clock enable
                DIN                 : in    std_logic_vector (1 downto 0);  -- input data
                DOUT                : out   std_logic_vector (15 downto 0)  -- output data
                );
end cicFlt_4thOrd_64DecFact;

architecture Behavioral of cicFlt_4thOrd_64DecFact is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

signal cur_count                        : unsigned(5 downto 0); -- ufix6
signal phase_0                          : std_logic; -- boolean

signal inData                           : signed(1 downto 0); -- sfix2

--  --   -- Section 1 Signals 
signal section_in1                      : signed(1 downto 0); -- sfix2
signal section_cast1                    : signed(25 downto 0); -- sfix26
signal sum1                             : signed(25 downto 0); -- sfix26
signal section_out1                     : signed(25 downto 0); -- sfix26
signal add_cast                         : signed(25 downto 0); -- sfix26
signal add_cast_1                       : signed(25 downto 0); -- sfix26
signal add_temp                         : signed(26 downto 0); -- sfix27
--   -- Section 2 signals 
signal section_in2                      : signed(25 downto 0); -- sfix26
signal sum2                             : signed(25 downto 0); -- sfix26
signal section_out2                     : signed(25 downto 0); -- sfix26
signal add_cast_2                       : signed(25 downto 0); -- sfix26
signal add_cast_3                       : signed(25 downto 0); -- sfix26
signal add_temp_1                       : signed(26 downto 0); -- sfix27
--   -- Section 3 signals 
signal section_in3                      : signed(25 downto 0); -- sfix26
signal sum3                             : signed(25 downto 0); -- sfix26
signal section_out3                     : signed(25 downto 0); -- sfix26
signal add_cast_4                       : signed(25 downto 0); -- sfix26
signal add_cast_5                       : signed(25 downto 0); -- sfix26
signal add_temp_2                       : signed(26 downto 0); -- sfix27
--   -- Section 4 signals 
signal section_in4                      : signed(25 downto 0); -- sfix26
signal sum4                             : signed(25 downto 0); -- sfix26
signal section_out4                     : signed(25 downto 0); -- sfix26
signal add_cast_6                       : signed(25 downto 0); -- sfix26
signal add_cast_7                       : signed(25 downto 0); -- sfix26
signal add_temp_3                       : signed(26 downto 0); -- sfix27
--   -- Section 5 signals 
signal section_in5                      : signed(25 downto 0); -- sfix26
signal diff1                            : signed(25 downto 0); -- sfix26
signal section_out5                     : signed(25 downto 0); -- sfix26
signal sub_cast                         : signed(25 downto 0); -- sfix26
signal sub_cast_1                       : signed(25 downto 0); -- sfix26
signal sub_temp                         : signed(26 downto 0); -- sfix27
--   -- Section 6 signals 
signal section_in6                      : signed(25 downto 0); -- sfix26
signal diff2                            : signed(25 downto 0); -- sfix26
signal section_out6                     : signed(25 downto 0); -- sfix26
signal sub_cast_2                       : signed(25 downto 0); -- sfix26
signal sub_cast_3                       : signed(25 downto 0); -- sfix26
signal sub_temp_1                       : signed(26 downto 0); -- sfix27
--   -- Section 7 signals 
signal section_in7                      : signed(25 downto 0); -- sfix26
signal diff3                            : signed(25 downto 0); -- sfix26
signal section_out7                     : signed(25 downto 0); -- sfix26
signal sub_cast_4                       : signed(25 downto 0); -- sfix26
signal sub_cast_5                       : signed(25 downto 0); -- sfix26
signal sub_temp_2                       : signed(26 downto 0); -- sfix27
--   -- Section 8 signals 
signal section_in8                      : signed(25 downto 0); -- sfix26
signal diff4                            : signed(25 downto 0); -- sfix26
signal section_out8                     : signed(25 downto 0); -- sfix26
signal sub_cast_6                       : signed(25 downto 0); -- sfix26
signal sub_cast_7                       : signed(25 downto 0); -- sfix26
signal sub_temp_3                       : signed(26 downto 0); -- sfix27

signal normCast                         : signed(51 downto 0);              -- sfix52_En48
signal normOut                          : signed(15 downto 0);              -- sfix16_En14

signal regout                           : signed(15 downto 0); -- sfix14
signal muxout                           : signed(15 downto 0); -- sfix14

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------

    ----------------------------------- PHASE CE --------------------------------------
    
    ce_output : process (CLK, RST)
    begin
        if RST = '1' then
            cur_count <= to_unsigned(0, 6);
        elsif (rising_edge(CLK)) then
            if CLK_CE = '1' then
                if cur_count >= to_unsigned(63, 6) then
                    cur_count <= to_unsigned(0, 6);
                else
                    cur_count <= cur_count + to_unsigned(1, 6);
                end if;
            end if;
        end if; 
    end process ce_output;
    
    phase_0 <= '1' when (cur_count = to_unsigned(0, 6) and CLK_CE = '1') else '0';
    
    -------------------------------- INTEGRATOR DELAY ---------------------------------
    
    integrator_delay : process (CLK, RST)
    begin
        if RST = '1' then
            section_out1 <= (others => '0');
            section_out2 <= (others => '0');
            section_out3 <= (others => '0');
            section_out4 <= (others => '0');
        elsif (rising_edge(CLK)) then
            if CLK_CE = '1' then
                section_out1 <= sum1;
                section_out2 <= sum2;
                section_out3 <= sum3;
                section_out4 <= sum4;
            end if;
        end if; 
    end process integrator_delay;
    
    -------------------------------- S1: INTEGRATOR -----------------------------------
    
    inData <= signed(DIN);
    
    section_cast1 <= resize(inData, 26);

    add_cast <= section_cast1;
    add_cast_1 <= section_out1;
    add_temp <= resize(add_cast, 27) + resize(add_cast_1, 27);
    sum1 <= add_temp(25 downto 0);
    
    -------------------------------- S2: INTEGRATOR -----------------------------------
    
    section_in2 <= section_out1;
    
    add_cast_2 <= section_in2;
    add_cast_3 <= section_out2;
    add_temp_1 <= resize(add_cast_2, 27) + resize(add_cast_3, 27);
    sum2 <= add_temp_1(25 downto 0);
    
    -------------------------------- S3: INTEGRATOR -----------------------------------
    
    section_in3 <= section_out2;
    
    add_cast_4 <= section_in3;
    add_cast_5 <= section_out3;
    add_temp_2 <= resize(add_cast_4, 27) + resize(add_cast_5, 27);
    sum3 <= add_temp_2(25 downto 0);
    
    -------------------------------- S4: INTEGRATOR -----------------------------------
    
    section_in4 <= section_out3;
    
    add_cast_6 <= section_in4;
    add_cast_7 <= section_out4;
    add_temp_3 <= resize(add_cast_6, 27) + resize(add_cast_7, 27);
    sum4 <= add_temp_3(25 downto 0);
    
    ---------------------------------- COMB DELAY -------------------------------------
    
    comb_delay : process (CLK, RST)
    begin
        if RST = '1' then
            diff1 <= (others => '0');
            diff2 <= (others => '0');
            diff3 <= (others => '0');
            diff4 <= (others => '0');
        elsif (rising_edge(CLK)) then
            if phase_0 = '1' then
                diff1 <= section_in5;
                diff2 <= section_in6;
                diff3 <= section_in7;
                diff4 <= section_in8;
            end if;
        end if; 
    end process comb_delay;
    
    ----------------------------------- S1: COMB --------------------------------------
    
    section_in5 <= section_out4;
    
    sub_cast <= section_in5;
    sub_cast_1 <= diff1;
    sub_temp <= resize(sub_cast, 27) - resize(sub_cast_1, 27);
    section_out5 <= sub_temp(25 downto 0);
    
    ----------------------------------- S2: COMB --------------------------------------
    
    section_in6 <= section_out5;
    
    sub_cast_2 <= section_in6;
    sub_cast_3 <= diff2;
    sub_temp_1 <= resize(sub_cast_2, 27) - resize(sub_cast_3, 27);
    section_out6 <= sub_temp_1(25 downto 0);
    
    ----------------------------------- S3: COMB --------------------------------------
    
    section_in7 <= section_out6;
    
    sub_cast_4 <= section_in7;
    sub_cast_5 <= diff3;
    sub_temp_2 <= resize(sub_cast_4, 27) - resize(sub_cast_5, 27);
    section_out7 <= sub_temp_2(25 downto 0);
    
    ----------------------------------- S4: COMB --------------------------------------
    
    section_in8 <= section_out7;
    
    sub_cast_6 <= section_in8;
    sub_cast_7 <= diff4;
    sub_temp_3 <= resize(sub_cast_6, 27) - resize(sub_cast_7, 27);
    section_out8 <= sub_temp_3(25 downto 0);

    -------------------------- NORMALISE CIC OUTPUT DATA 1 ----------------------------

    normCast <= resize(section_out8 & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 52);
    normOut <= normCast(49 downto 34);
    
    ----------------------------------- DATA OUT --------------------------------------
    
    DataHoldRegister_process : process (CLK, RST)
    begin
        if RST = '1' then
            regout <= (others => '0');
        elsif (rising_edge(CLK)) then
            if phase_0 = '1' then
                regout <= normOut;
            end if;
        end if; 
    end process DataHoldRegister_process;

    muxout <= normOut when (phase_0 = '1') else regout;
  
    DOUT <= std_logic_vector(muxout);

end Behavioral;
