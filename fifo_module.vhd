library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_module is
    PORT(
        SYSCLK        : in std_logic;
        RESET         : in std_logic;
        FIFO_WRITE_EN : in std_logic;
        FIFO_READ_EN  : in std_logic;
        FIFO_DATA_IN  : in std_logic_vector(7 downto 0); -- 8 bit fifo
        FIFO_DATA_OUT : out std_logic_vector(7 downto 0);
        FIFO_FULL     : out std_logic;
        FIFO_EMPTY    : out std_logic
    );
end fifo_module;

architecture Behavioral of fifo_module is

    constant FIFO_DEPTH  : integer := 65536;

begin

	FIFO_Process : process(SYSCLK, RESET)
		type FIFO_Memory is array (0 to FIFO_DEPTH-1) of std_logic_vector(7 downto 0); -- 8bit fifo
		variable Memory : FIFO_Memory;

		variable head : natural range 0 to FIFO_DEPTH-1;
		variable tail : natural range 0 to FIFO_DEPTH-1;
		variable looped : boolean;
	begin
		if rising_edge(SYSCLK) then
			if RESET = '1' then
				head := 0;
				tail := 0;

				looped := false;

				FIFO_FULL <= '0';
				FIFO_EMPTY <= '1';
				
			else
				if (FIFO_READ_EN = '1') then
					if (looped = true) or (head /= tail) then
					
						FIFO_DATA_OUT <= Memory(tail);

						if (tail = FIFO_DEPTH-1) then
							tail := 0;
							looped := false;
						else
							tail := tail + 1;
						end if;

					end if;
				end if;	

				if (FIFO_WRITE_EN = '1') then
					if (looped = false) or  (head /= tail) then
										    
                        Memory(head) := FIFO_DATA_IN;
                        
                        if (head = FIFO_DEPTH-1) then
                            head := 0;
                            looped := true;
                        else
                            head := head + 1;    
                        end if;
                    end if;
				end if;
				
				if (head = tail) then
				    if looped then
                        FIFO_FULL <= '1';
				    else
				        FIFO_EMPTY <= '1';
				    end if;
				else
				    FIFO_FULL <= '0';
				    FIFO_EMPTY <= '0';
				end if;    
			end if;
		end if;

	end process;


end Behavioral;
