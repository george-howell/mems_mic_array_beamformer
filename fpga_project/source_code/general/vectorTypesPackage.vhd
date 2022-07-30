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
use IEEE.NUMERIC_STD.ALL;

package instruction_buffer_type is
    type vector_of_stdLogVec is array (NATURAL RANGE <>) of std_logic;
    type vector_of_stdLogVec2bit is array (NATURAL RANGE <>) of std_logic_vector(1 downto 0);
    type vector_of_stdLogVec16bit is array (NATURAL RANGE <>) of std_logic_vector(15 downto 0);
    type vector_of_stdLogVec19bit is array (NATURAL RANGE <>) of std_logic_vector(18 downto 0);
    type vector_of_stdLogVec32bit is array (NATURAL RANGE <>) of std_logic_vector(31 downto 0);
    type vector_of_unsigned32 is array (NATURAL RANGE <>) of unsigned(31 downto 0);
end package instruction_buffer_type;