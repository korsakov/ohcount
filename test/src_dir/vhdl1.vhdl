library ieee;
use ieee.std_logic_1164.all;

entity tb is
end tb;

architecture behav of tb is

  -- toggle period
  constant period_c : time := 1 ms;

  -- we'll be poking on this signal
  signal toggle_s : std_logic_vector(1 downto 0) := "01";

begin

  -----------------------------------------------------------------------------
  -- Process toggle
  --
  -- Purpose:
  --   Flip the toggle_s signal periodically.
  --
  toggle: process
  begin

    wait for period_c/2;
    toggle_s <= not toggle_s;

  end process toggle;
  --
  -----------------------------------------------------------------------------

end behav;

configuration tb_behav_c0 of tb is

  for behav
  end for;

end tb_behav_c0;
