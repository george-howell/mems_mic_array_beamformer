----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2022 23:59:04
-- Design Name: 
-- Module Name: stepperMotor_dirPoint - Behavioral
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

entity stepperMotor_dirPoint is
    generic   ( STEP_ROT_VAL    : integer   := 153600;
                -- number of system clock cycles before flagging
                -- STEP_ROT_VAL = CLK_SYS / no. of steps per second
                -- 30.72MHz / 200steps/s = 153600;
                STEP_ROT_VAL_P  : integer   := 76800 
                -- number of system clock cycles before flagging phase signal
                -- STEP_ROT_VAL_P = CLK_SYS / (2*no. of steps per second)
                -- 30.72MHz / (2*200steps/s) = 76800;
                );
    port      ( RST_SYS         : in    std_logic;
                CLK_SYS         : in    std_logic;
                RD_EN_FLG       : in    std_logic;
                POSITION        : in    std_logic_vector (5 downto 0);
                MOTOR_SIG_OUT   : out   std_logic_vector (3 downto 0)
                );
end stepperMotor_dirPoint;

architecture Behavioral of stepperMotor_dirPoint is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- step clock signals
signal  countRot            : integer range 0 to STEP_ROT_VAL;
signal  clkRotCe            : std_logic;  
signal  clkRotCePhase       : std_logic;

-- difference and previous values
signal  diff                : integer range -35 to 35 := 0;
signal  pos                 : integer range 0 to 35 := 0;
signal  prevPos             : integer range 0 to 35 := 0;

-- rotation state machine
type    rotState_type is (idle, diffOffset, moveAngle, moveStep);
signal  rotState            : rotState_type;

-- step table
type    stepTableType is array (0 to 8) of integer;
signal  stepTable           : stepTableType := (6, 5, 6, 5, 6, 5, 6, 5, 6);
signal  stepTableIdx        : integer range 0 to 9;
signal  stepCnt             : integer range 0 to 6;

-- direction
signal  dir                 : std_logic;

-- output signal count
signal  sigCnt              : integer range 0 to 4;

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
    -------------------------- STEP ROTATION CLOCK ENABLE -----------------------------
    -- creates a clock enable signal to signal a step change
    
    -- step clock counter
    process (CLK_SYS)
    begin
        if (rising_edge(CLK_SYS)) then
            if (RST_SYS = '1') then
                countRot <= 0;
            elsif (countRot < (STEP_ROT_VAL-1)) then
                countRot <= countRot + 1;
            else
                countRot <= 0;              
            end if;
        end if;
    end process;
    
    clkRotCe <= '1' when (countRot = (STEP_ROT_VAL-1)) else '0';
    clkRotCePhase <= '1' when (countRot = (STEP_ROT_VAL_P-1)) else '0';
    
    ---------------------------- ROTATION STATE MACHINE -------------------------------
    -- Handles the reading of data and rotation of the step motor through the angles.
    
    -- position offset (handles the fact that the max value comp is between 1 -> 36)
    pos <= to_integer(unsigned(POSITION)) - 1;
    
    -- step clock counter
    process (CLK_SYS)
    begin
        if (rising_edge(CLK_SYS)) then
            if (RST_SYS = '1') then
                stepTableIdx <= 0;
                stepCnt <= 0;
                diff <= 0;
                prevPos <= 0;
                dir <= '0';
                rotState <= idle;
            else
                case rotState is
                
                -- Stays in idle mode until read enable is triggered, calculates
                -- difference between current and previous position and stores the
                -- previous position.
                when idle =>
                    if (RD_EN_FLG = '1') then
                        diff <= prevPos - pos;
                        prevPos <= pos; 
                        rotState <= diffOffset;   
                    end if;
                
                -- Offsets the initial difference if over 180 degrees, hence difference
                -- is now number of angles to step with a + indicating clockwise
                -- direction and - anti-clockwise direction
                when diffOffset =>
                    if (diff > 18) then
                        diff <= diff - 36;
                    elsif (diff < -18) then
                        diff <= diff + 36;
                    end if;
                    rotState <= moveAngle;
                
                -- Initiates a move of a single angle in either clockwise or anti-
                -- clockwise direction depending on sign of difference. Counts down
                -- difference value until 0 is reached, while rotating through 
                -- associated step table value, before returning back to idle.
                when moveAngle =>
                    -- move clockwise
                    if (diff > 0) then
                        dir <= '0';
                        diff <= diff - 1;
                        rotState <= moveStep;
                        if (stepTableIdx < 9) then
                            stepTableIdx <= stepTableIdx + 1;
                        else
                            stepTableIdx <= 1;
                        end if;
                    -- move anti-clockwise
                    elsif (diff < 0) then
                        dir <= '1';
                        diff <= diff + 1;
                        rotState <= moveStep;
                        if (stepTableIdx > 1) then
                            stepTableIdx <= stepTableIdx - 1;
                        else
                            stepTableIdx <= 9;
                        end if;
                    else
                        stepCnt <= 0;
                        rotState <= idle;  
                    end if;
                
                -- Moves through the number of steps in the respective step table for
                -- each angle.
                when moveStep =>
                    if (clkRotCe = '1') then
                        if (stepCnt < stepTable(stepTableIdx-1)) then
                            stepCnt <= stepCnt + 1;
                        else
                            stepCnt <= 1;
                            rotState <= moveAngle;  
                        end if;
                    end if;
                 
                end case;              
            end if;
        end if;
    end process;
    
    -------------------------------- STEP COUNTER -------------------------------------
    -- Counts through the steps required in forward or reverse direction, with each
    -- step associated with a corresponding signal output
    
    process (CLK_SYS)
    begin
        if (rising_edge(CLK_SYS)) then
            if (RST_SYS = '1') then
                sigCnt <= 0;
            elsif (clkRotCePhase = '1' and stepCnt > 0) then
                if (dir = '0') then
                    if (sigCnt < 4) then
                        sigCnt <= sigCnt + 1;
                    else 
                        sigCnt <= 1;
                    end if;
                else
                    if (sigCnt > 1) then
                        sigCnt <= sigCnt - 1;
                    else
                        sigCnt <= 4;    
                    end if;
                end if;              
            end if;
        end if;
    end process;
    
    -- send the corresponding signal to the motor
    MOTOR_SIG_OUT <=    "0100" when (sigCnt = 1) else
                        "0001" when (sigCnt = 2) else
                        "1000" when (sigCnt = 3) else
                        "0010" when (sigCnt = 4) else
                        "0000";

end Behavioral;
