library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fifo_sim is
end fifo_sim;

architecture Behavioral of fifo_sim is

    COMPONENT fifo_module
    GENERIC(
        constant FIFO_DEPTH  : integer := 64;
        constant DATA_WIDTH  : integer := 12   
    );
    PORT(
        SYSCLK        : in std_logic;
        RESET         : in std_logic;
        FIFO_WRITE_EN : in std_logic;
        FIFO_READ_EN  : in std_logic;
        FIFO_DATA_IN  : in std_logic_vector(DATA_WIDTH-1 downto 0);
        FIFO_DATA_OUT : out std_logic_vector(DATA_WIDTH-1 downto 0);
        FIFO_FULL     : out std_logic;
        FIFO_EMPTY    : out std_logic
    );
    END COMPONENT;
    
    signal sysclk : std_logic := '0';
    signal reset : std_logic := '0';
    signal fifo_write_en : std_logic := '0';
    signal fifo_read_en : std_logic := '0';
    signal fifo_data_in : std_logic_vector(11 downto 0) := (others => '0');
    signal fifo_data_out : std_logic_vector(11 downto 0);
    signal fifo_full : std_logic;
    signal fifo_empty : std_logic;
    
    constant clock_period : time := 10ns;
    
begin

    UUT : fifo_module
    PORT MAP(
        SYSCLK => sysclk,
        RESET => reset,
        FIFO_WRITE_EN => fifo_write_en,
        FIFO_READ_EN => fifo_read_en,
        FIFO_DATA_IN => fifo_data_in,
        FIFO_DATA_OUT => fifo_data_out,
        FIFO_FULL => fifo_full,
        FIFO_EMPTY => fifo_empty    
    );
    
    process 
    begin
        sysclk <= '0';
        wait for clock_period / 2;
        sysclk <= '1';
        wait for clock_period / 2;                
    end process;
    
    process
    begin
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        wait;        
    end process;
    
    process
    variable counter : integer range 0 to 140 := 0;
    constant counter_range1 : integer := 12;
    constant counter_range2 : integer := 24;
    constant counter_range3 : integer := 36;
    begin           
        if counter < counter_range1 then  
                       
            fifo_data_in <= fifo_data_in(10 downto 0) & '1';
            wait for clock_period;        
            fifo_write_en <= '1';
            wait for clock_period;
            fifo_write_en <= '0';    
                
        elsif counter >= counter_range1 and counter < counter_range2 then                    
            fifo_read_en <= '1';
            wait for clock_period;
            fifo_read_en <= '0';
            wait for clock_period;  
            
        elsif counter >= counter_range2 and counter < counter_range3 then
            if counter = counter_range2 then
                fifo_data_in <= (others => '0');
            else
                fifo_data_in <= '1' & fifo_data_in(11 downto 1);
            end if;
            
            fifo_write_en <= '1';
            fifo_read_en <= '1';
            wait for clock_period;
            fifo_write_en <= '0';
            fifo_read_en <= '0';
                                                      
        else            
            wait;
        end if;
        
        counter := counter + 1;
        
    end process;
        
end Behavioral;

