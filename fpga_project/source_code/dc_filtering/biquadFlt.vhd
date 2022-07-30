----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2020 19:41:42
-- Design Name: 
-- Module Name: biquadFlt - Behavioral
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

entity biquadFlt is
    port      ( CLK                             : in    std_logic;
                RST                             : in    std_logic; 
                CLK_EN                          : in    std_logic; 
                DIN                             : in    std_logic_vector(15 downto 0); -- sfix16_En14
                DOUT                            : out   std_logic_vector(15 downto 0)  -- sfix16_En14
                );
end biquadFlt;

architecture Behavioral of biquadFlt is

-----------------------------------------------------------------------------
---------------------- COMPONENT DECLERATIONS -------------------------------
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
------------------------ SIGNAL DECLERATIONS --------------------------------
-----------------------------------------------------------------------------

-- types
type    delay_pipeline_type is array (natural range <>) of signed(55 downto 0); -- sfix56_En30

-- coefficients 
constant scaleConst                     : signed(46 downto 0)   := to_signed(8388608, 47);    -- sfix47_En23
constant coeffB0                        : signed(46 downto 0)   := to_signed(8380847, 47);    -- sfix47_En23
constant coeffB1                        : signed(46 downto 0)   := to_signed(-16761694, 47);  -- sfix47_En23
constant coeffB2                        : signed(46 downto 0)   := to_signed(8380847, 47);    -- sfix47_En23
constant coeffA1                        : signed(46 downto 0)   := to_signed(-16761687, 47);  -- sfix47_En23
constant coeffA2                        : signed(46 downto 0)   := to_signed(8373093, 47);    -- sfix47_En23

-- input data register
signal  dinReg                          : signed(15 downto 0)   := (others => '0'); -- sfix16_En14
signal  dinRegCast                      : signed(55 downto 0); -- sfix56_En30

-- counter
signal  cntState                        : signed(0 downto 0)    := "0";
signal  clkCnt                          : unsigned(2 downto 0)  := to_unsigned(0, 3); -- ufix3
signal  phase1                          : std_logic;
signal  phase2                          : std_logic;
signal  phase3                          : std_logic;
signal  phase4                          : std_logic;
signal  phase5                          : std_logic;
signal  phase6                          : std_logic;
signal  phase1_4                        : std_logic;
signal  phaseFull                       : std_logic;

-- delay pipeline
signal  delayPipe                       : delay_pipeline_type(0 TO 1)   := (others => (others => '0')); -- sfix56_En30
signal  delayPipeCast0                  : signed(55 downto 0); -- sfix56_En30
signal  delayPipeCast1                  : signed(55 downto 0); -- sfix56_En30

-- product section
signal  multiMux                        : signed(55 downto 0); -- sfix56_En30
signal  coeffMux                        : signed(46 downto 0); -- sfix47_En23
signal  prodOut                         : signed(102 downto 0); -- sfix103_En53
signal  prodCast                        : signed(55 downto 0); -- sfix56_En30
signal  prodCastNegTmp                  : signed(56 downto 0); -- sfix57_En30
signal  prodCastNeg                     : signed(55 downto 0); -- sfix56_En30
signal  prodOutMux                      : signed(55 downto 0); -- sfix56_En30

-- accumulator
signal  coeffA0ProdOut                  : signed(15 downto 0); -- sfix16_En14
signal  coeffA0ProdOutCast              : signed(55 downto 0); -- sfix56_En30
signal  accumProdIn                     : signed(55 downto 0); -- sfix56_En30
signal  accumSum                        : signed(56 downto 0); -- sfix57_En30
signal  accumSumCast                    : signed(55 downto 0); -- sfix56_En30
signal  accumMuxOut                     : signed(55 downto 0); -- sfix56_En30
signal  accumReg                        : signed(55 downto 0)   := (others => '0'); -- sfix56_En30
signal  delayPipeCur                    : signed(55 downto 0)   := (others => '0'); -- sfix56_En30

-- output section
signal  outputRegTmp                    : std_logic_vector(15 downto 0) := (others => '0'); -- sfix16_En14
signal  outputReg                       : std_logic_vector(15 downto 0) := (others => '0'); -- sfix16_En14

begin

    -----------------------------------------------------------------------------------
    ------------------------ COMPONENT INSTANTIATIONS ---------------------------------
    -----------------------------------------------------------------------------------
    
    -----------------------------------------------------------------------------------
    -------------------------------- MAIN PROCESSES -----------------------------------
    -----------------------------------------------------------------------------------
    
    -- s1[n] = scaleConst.x[n] - a1.s1[n-1] - a2.s1[n-2]
    -- y[n] = b0.s1[n] + b1.s1[n-1] + b2.s1[n-2]
    
    -- or
    
    -- delayPipe[n] = (scaleConst . din[n]) - (coeffA1 . delayPipe[n-1]) - (coeffA1 . delayPipe[n-2])
    -- outputReg[n] = (coeffB0 . delayPipe[n]) + (coeffB1 . delayPipe[n-1]) + (coeffB2 . delayPipe[n-2])
    
    -------------------------------- INPUT REGISTER -----------------------------------
    -- clock the input data at on the ce clock
    
    din_reg_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if RST = '1' then
                dinReg <= (others => '0');
            elsif CLK_EN = '1' then
                dinReg <= signed(DIN);
            end if;
        end if; 
    end process din_reg_process;
    
    -- cast input register data
    dinRegCast <= resize(dinReg(15 downto 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 56);
    
    ----------------------------------- COUNTER ---------------------------------------
    -- general clock counter
    
    counter_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                clkCnt <= to_unsigned(0, 3);
                cntState <= "0";
            else
                case cntState is
                
                -- idle
                when "0" =>
                    if (CLK_EN = '1') then
                        cntState <= "1";
                    end if;
                
                -- count   
                when "1" =>
                    if (clkCnt >= to_unsigned(6, 3)) then
                        clkCnt <= to_unsigned(0, 3);
                        cntState <= "0";
                    else
                        clkCnt <= clkCnt + to_unsigned(1, 3);
                    end if;  
                
                when others =>
                    clkCnt <= to_unsigned(0, 3);
                
                end case;
            end if;
        end if; 
    end process counter_process;
    
    -- phase enables
    phase1 <= '1' when clkCnt = to_unsigned(1, 3) else '0';
    phase2 <= '1' when clkCnt = to_unsigned(2, 3) else '0';
    phase3 <= '1' when clkCnt = to_unsigned(3, 3) else '0';
    phase4 <= '1' when clkCnt = to_unsigned(4, 3) else '0';
    phase5 <= '1' when clkCnt = to_unsigned(5, 3) else '0';
    phase6 <= '1' when clkCnt = to_unsigned(6, 3) else '0';
    
    -- phase enable combined
    phase1_4 <= phase1 or phase4;
    phaseFull <= phase1 or phase2 or phase3 or phase4 or phase5;
    
    --------------------------------- DELAY PIPELINE ----------------------------------
    -- delay section
    
    delay_pipeline_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                delayPipe <= (others => (others => '0'));
            elsif (phase1 = '1') then
                delayPipe(1) <= delayPipe(0);
                delayPipe(0) <= delayPipeCur;
            end if;
        end if; 
    end process delay_pipeline_process;
    
    -- delay cast
    delayPipeCast0 <= delayPipe(0); 
    delayPipeCast1 <= delayPipe(1);
    
    -------------------------------- PRODUCT SECTION ----------------------------------
    -- product section
    
    -- multiplier mux
    multiMux <= dinRegCast      when (clkCnt = to_unsigned(1, 3)) else
                delayPipeCast0  when (clkCnt = to_unsigned(2, 3)) else
                delayPipeCast1  when (clkCnt = to_unsigned(3, 3)) else
                delayPipeCur    when (clkCnt = to_unsigned(4, 3)) else
                delayPipeCast0  when (clkCnt = to_unsigned(5, 3)) else
                delayPipeCast1;
    
    -- coefficient mux
    coeffMux <= scaleConst      when (clkCnt = to_unsigned(1, 3)) else
                coeffA1         when (clkCnt = to_unsigned(2, 3)) else
                coeffA2         when (clkCnt = to_unsigned(3, 3)) else
                coeffB0         when (clkCnt = to_unsigned(4, 3)) else
                coeffB1         when (clkCnt = to_unsigned(5, 3)) else
                coeffB2;
                
    -- pipeline multiplication
    prodOut <= multiMux * coeffMux;
    
    -- cast product output
    prodCast <= prodOut(78 downto 23);
    
    -- negate ax coefficent products for sum
    prodCastNegTmp <= ('0' & prodCast) when prodCast = "10000000000000000000000000000000000000000000000000000000" else 
                       -resize(prodCast,57);
    
    -- cast negative product                   
    prodCastNeg <= prodCastNegTmp(55 downto 0);
    
    -- product output mux, select between positive and negative product values
    prodOutMux <=   prodCast        when (clkCnt = to_unsigned(1, 3)) else
                    prodCastNeg     when (clkCnt = to_unsigned(2, 3)) else
                    prodCastNeg     when (clkCnt = to_unsigned(3, 3)) else
                    prodCast        when (clkCnt = to_unsigned(4, 3)) else
                    prodCast        when (clkCnt = to_unsigned(5, 3)) else
                    prodCast;
    
    ----------------------------- ACCUMULATOR SECTION ---------------------------------
    -- accumulator section
    
    -- converts output of product so that accumulator output is just the product output for first sum (i.e. acc = prodOut + 0)
    coeffA0ProdOut <= prodOut(54 downto 39);
    coeffA0ProdOutCast <= resize(coeffA0ProdOut(15 downto 0) & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0' & '0', 56);
    
    -- mux which selects either the product output or a0 product output which is normailised to the input data format (i.e 16 bit)
    accumProdIn <= coeffA0ProdOutCast when (phase1 = '1') else
                   prodOutMux;
    
    -- accumulator sum               
    accumSum <= resize(accumReg, 57) + resize(prodOutMux, 57);
    accumSumCast <= accumSum(55 downto 0);
    
    -- mux which selects product output or accumulator output, product output for first coefficients
    accumMuxOut <= accumProdIn when (phase1_4 = '1') else
                   accumSumCast;  
    
    accumulator_reg_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                accumReg <= (others => '0');
            elsif (phaseFull = '1') then
                accumReg <= accumMuxOut;
            end if;
        end if; 
    end process accumulator_reg_process;
    
    -- stores the current result for the the delay pipe delayPipe[n]
    delay_pipe_current_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                delayPipeCur <= (others => '0');
            elsif (phase3 = '1') then
                delayPipeCur <= accumMuxOut;
            end if;
        end if; 
    end process delay_pipe_current_process;
    
    -------------------------------- OUTPUT SECTION -----------------------------------
    -- output data section
    
    output_register_tmp_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                outputRegTmp <= (others => '0');
            elsif (phase6 = '1') then
                outputRegTmp <= std_logic_vector(accumMuxOut(31 downto 16));
            end if;
        end if; 
    end process output_register_tmp_process;
    
    output_register_process : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                outputReg <= (others => '0');
            elsif (CLK_EN = '1') then
                outputReg <= outputRegTmp;
            end if;
        end if; 
    end process output_register_process;
    
    -- data  ouput
    DOUT <= outputRegTmp when (CLK_EN = '1') else 
            outputReg;
    
end Behavioral;
