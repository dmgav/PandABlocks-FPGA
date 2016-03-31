library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package type_defines is

subtype std8_t is std_logic_vector(7 downto 0);
type std8_array is array(natural range <>) of std8_t;

subtype std32_t is std_logic_vector(31 downto 0);
type std32_array is array(natural range <>) of std32_t;

subtype std4_t is std_logic_vector(3 downto 0);
type std4_array is array(natural range <>) of std4_t;

--
-- Functions
--
function TO_INTEGER(arg : std_logic_vector) return integer;
function TO_SVECTOR(arg, size: natural) return std_logic_vector;
function LOG2(arg : natural) return natural;
function ZEROS(num : positive) return std_logic_vector;
function COMP(a : std_logic_vector; b: std_logic_vector) return std_logic;
function BITREV(A : std_logic_vector) return std_logic_vector;

end type_defines;

package body type_defines is

-- Converts integer to std_logic_vector
function TO_INTEGER(arg : std_logic_vector) return integer is
begin
    return to_integer(unsigned(arg));
end TO_INTEGER;

-- Converts integer to std_logic_vector
function TO_SVECTOR(arg, size: natural) return std_logic_vector is
begin
    return std_logic_vector(to_unsigned(arg, size));
end TO_SVECTOR;

function LOG2(arg: natural) return natural is
    variable t : natural := arg;
    variable n : natural := 0;
begin
    while t > 0 loop
        t := t / 2;
        n := n + 1;
    end loop;
    return n-1;
end function;

-- Return a std_logic_vector filled with zeros
function ZEROS(num : positive) return std_logic_vector is
    variable vector : std_logic_vector(num-1 downto 0) := (others => '0');
begin
    return (vector);
end ZEROS;

function COMP (a : std_logic_vector; b: std_logic_vector) return std_logic is
begin
    if (a/= b) then
        return '1';
    else
        return '0';
    end if;
end COMP;

function BITREV(A : std_logic_vector) return std_logic_vector is
    variable B : std_logic_vector(A'length-1 downto 0);
begin
    for i in A'range loop
        B(B'left - i) := A(i);
    end loop;

    return B;
end BITREV;

end type_defines;
