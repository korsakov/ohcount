vhdl	code	library ieee;
vhdl	code	use ieee.std_logic_1164.all;
vhdl	blank	
vhdl	code	entity tb is
vhdl	code	end tb;
vhdl	blank	
vhdl	code	architecture behav of tb is
vhdl	blank	
vhdl	comment	  -- toggle period
vhdl	code	  constant period_c : time := 1 ms;
vhdl	blank	
vhdl	comment	  -- we'll be poking on this signal
vhdl	code	  signal toggle_s : std_logic_vector(1 downto 0) := "01";
vhdl	blank	
vhdl	code	begin
vhdl	blank	
vhdl	comment	  -----------------------------------------------------------------------------
vhdl	comment	  -- Process toggle
vhdl	comment	  --
vhdl	comment	  -- Purpose:
vhdl	comment	  --   Flip the toggle_s signal periodically.
vhdl	comment	  --
vhdl	code	  toggle: process
vhdl	code	  begin
vhdl	blank	
vhdl	code	    wait for period_c/2;
vhdl	code	    toggle_s <= not toggle_s;
vhdl	blank	
vhdl	code	  end process toggle;
vhdl	comment	  --
vhdl	comment	  -----------------------------------------------------------------------------
vhdl	blank	
vhdl	code	end behav;
vhdl	blank	
vhdl	code	configuration tb_behav_c0 of tb is
vhdl	blank	
vhdl	code	  for behav
vhdl	code	  end for;
vhdl	blank	
vhdl	code	end tb_behav_c0;
