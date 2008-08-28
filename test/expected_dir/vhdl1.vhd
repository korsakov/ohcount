vhdl	comment	------------------------------------------------------------
vhdl	comment	-- Combinational Logic Design
vhdl	comment	-- (ESD book figure 2.4)
vhdl	comment	-- by Weijun Zhang, 04/2001
vhdl	comment	--
vhdl	comment	-- A simple example of VHDL Structure Modeling
vhdl	comment	-- we might define two components in two separate files,
vhdl	comment	-- in main file, we use port map statement to instantiate
vhdl	comment	-- the mapping relationship between each components
vhdl	comment	-- and the entire circuit.
vhdl	comment	------------------------------------------------------------
vhdl	blank	
vhdl	code	library ieee;				-- component #1
vhdl	code	use ieee.std_logic_1164.all;
vhdl	blank	
vhdl	code	entity OR_GATE is
vhdl	code	port(  	X:	in std_logic;
vhdl	code		Y:	in std_logic;
vhdl	code		F2:	out std_logic
vhdl	code	);
vhdl	code	end OR_GATE;
vhdl	blank	
vhdl	code	architecture behv of OR_GATE is
vhdl	code	begin
vhdl	code	process(X,Y)
vhdl	code	begin
vhdl	code		F2 <= X or Y;			-- behavior des.
vhdl	code	end process;
vhdl	code	end behv;
vhdl	blank	
vhdl	comment	-------------------------------------------------------------
vhdl	blank	
vhdl	code	library ieee;				-- component #2
vhdl	code	use ieee.std_logic_1164.all;
vhdl	blank	
vhdl	code	entity AND_GATE is
vhdl	code	port(  	A:	in std_logic;
vhdl	code		B:	in std_logic;
vhdl	code		F1:	out std_logic
vhdl	code	);
vhdl	code	end AND_GATE;
vhdl	blank	
vhdl	code	architecture behv of AND_GATE is
vhdl	code	begin
vhdl	code	process(A,B)
vhdl	code	begin
vhdl	code		F1 <= A and B;			-- behavior des.
vhdl	code	end process;
vhdl	code	end behv;
vhdl	blank	
vhdl	comment	--------------------------------------------------------------
vhdl	blank	
vhdl	code	library ieee;				-- top level circuit
vhdl	code	use ieee.std_logic_1164.all;
vhdl	code	use work.all;
vhdl	blank	
vhdl	code	entity comb_ckt is
vhdl	code	port(	input1: in std_logic;
vhdl	code		input2: in std_logic;
vhdl	code		input3: in std_logic;
vhdl	code		output: out std_logic
vhdl	code	);
vhdl	code	end comb_ckt;
vhdl	blank	
vhdl	code	architecture struct of comb_ckt is
vhdl	blank	
vhdl	code	    component AND_GATE is		-- as entity of AND_GATE
vhdl	code	    port(   A:	in std_logic;
vhdl	code	    	    B:	in std_logic;
vhdl	code	            F1:	out std_logic
vhdl	code	    );
vhdl	code	    end component;
vhdl	blank	
vhdl	code	    component OR_GATE is		-- as entity of OR_GATE
vhdl	code	    port(   X:	in std_logic;
vhdl	code	    	    Y:	in std_logic;
vhdl	code	    	    F2: out std_logic
vhdl	code	    );
vhdl	code	    end component;
vhdl	blank	
vhdl	code	    signal wire: std_logic;		-- signal just like wire
vhdl	blank	
vhdl	code	begin
vhdl	blank	
vhdl	comment	    -- use sign "=>" to clarify the pin mapping
vhdl	blank	
vhdl	code	    Gate1: AND_GATE port map (A=>input1, B=>input2, F1=>wire);
vhdl	code	    Gate2: OR_GATE port map (X=>wire, Y=>input3, F2=>output);
vhdl	blank	
vhdl	code	end struct;
vhdl	blank	
vhdl	comment	----------------------------------------------------------------
