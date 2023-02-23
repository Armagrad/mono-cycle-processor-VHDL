library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity testbench_ual is
end entity testbench_ual;

architecture behavior of testbench_ual is
    component ual is
        port (
            op : in std_logic_vector(1 downto 0);
            a, b : in std_logic_vector(31 downto 0);
            s : out std_logic_vector(31 downto 0);
            n : out std_logic
        );
    end component;

    signal op : std_logic_vector(1 downto 0) := (others => '0');
    signal a, b : std_logic_vector(31 downto 0) := (others => '0');
    signal s : std_logic_vector(31 downto 0);
    signal n : std_logic;
begin
    uut : ual port map (
        op => op,
        a => a,
        b => b,
        s => s,
        n => n
    );

    process
    begin
	report "TESTING UAL ENTITY..." severity note;
        -- Test case 1 : ADD
        op <= "00";
        a <= x"00000001";
        b <= x"00000001";
        wait for 10 ns;
        assert s = x"00000002" and n = '0' report "Test case 1 [ADD] failed" severity error;
        
        -- Test case 2 : SUB
        op <= "10";
        a <= x"00000001";
        b <= x"00000002";
        wait for 10 ns;
        assert s = x"ffffffff" and n = '1' report "Test case 2 [SUB] failed" severity error;

        -- Test case 3 : B COPY
        op <= "01";
        a <= x"00000001";
        b <= x"00000002";
        wait for 10 ns;
        assert s = x"00000002" and n = '0' report "Test case 3 [B COPY] failed" severity error;

        -- Test case 4 : A COPY
        op <= "11";
        a <= x"00000001";
        b <= x"00000002";
        wait for 10 ns;
        assert s = x"00000001" and n = '0' report "Test case 4 [A COPY] failed" severity error;

        -- Test case 5 : A COPY NEGATIVE
        op <= "11";
        a <= x"fffffffd";
        b <= x"00000002";
        wait for 10 ns;
        assert s = x"fffffffd" and n = '1' report "Test case 5 [A COPY NEGATIVE] failed" severity error;

        -- Test case 6 : B COPY NEGATIVE
        op <= "01";
        a <= x"00000002";
        b <= x"fffffffd";
        wait for 10 ns;
        assert s = x"fffffffd" and n = '1' report "Test case 6 [B COPY NEGATIVE] failed" severity error;

        -- if test completed with no errors, print test passed
        report "All test cases passed" severity note;
        wait;
    end process;
end architecture behavior;

	
