------------------------------------------------------------
-- Combinational Logic Design
-- (ESD book figure 2.4)
-- by Weijun Zhang, 04/2001
--
-- A simple example of VHDL Structure Modeling
-- we might define two components in two separate files,
-- in main file, we use port map statement to instantiate
-- the mapping relationship between each components
-- and the entire circuit.
------------------------------------------------------------

library ieee;				-- component #1
use ieee.std_logic_1164.all;

entity OR_GATE is
port(  	X:	in std_logic;
	Y:	in std_logic;
	F2:	out std_logic
);
end OR_GATE;

architecture behv of OR_GATE is
begin
process(X,Y)
begin
	F2 <= X or Y;			-- behavior des.
end process;
end behv;

-------------------------------------------------------------

library ieee;				-- component #2
use ieee.std_logic_1164.all;

entity AND_GATE is
port(  	A:	in std_logic;
	B:	in std_logic;
	F1:	out std_logic
);
end AND_GATE;

architecture behv of AND_GATE is
begin
process(A,B)
begin
	F1 <= A and B;			-- behavior des.
end process;
end behv;

--------------------------------------------------------------

library ieee;				-- top level circuit
use ieee.std_logic_1164.all;
use work.all;

entity comb_ckt is
port(	input1: in std_logic;
	input2: in std_logic;
	input3: in std_logic;
	output: out std_logic
);
end comb_ckt;

architecture struct of comb_ckt is

    component AND_GATE is		-- as entity of AND_GATE
    port(   A:	in std_logic;
    	    B:	in std_logic;
            F1:	out std_logic
    );
    end component;

    component OR_GATE is		-- as entity of OR_GATE
    port(   X:	in std_logic;
    	    Y:	in std_logic;
    	    F2: out std_logic
    );
    end component;

    signal wire: std_logic;		-- signal just like wire

begin

    -- use sign "=>" to clarify the pin mapping

    Gate1: AND_GATE port map (A=>input1, B=>input2, F1=>wire);
    Gate2: OR_GATE port map (X=>wire, Y=>input3, F2=>output);

end struct;

----------------------------------------------------------------
