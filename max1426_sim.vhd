library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adc1173_sim is
end adc1173_sim;

architecture Behavioral of adc1173_sim is

    COMPONENT max1426_module
    PORT(
        SYSCLK          : in STD_LOGIC;
        ADC_CLK_IN      : in STD_LOGIC;
        RESET           : in STD_LOGIC;
        
        ADC_OE          : out std_logic;
        ADC_CLK         : out std_logic;
        
        ADC_DATA_READY  : out std_logic;
        ADC_RESULT      : out std_logic_vector(7 downto 0);
        
        ADC_START_SAMPLING : in std_logic
    );    
    END COMPONENT;

    signal sysclk : std_logic := '0';
    signal adc_clk_in : std_logic := '0';
    signal reset : std_logic := '0';
    
    signal adc_oe : std_logic;
    signal adc_clk : std_logic;
    
    signal adc_data_ready : std_logic;
    signal adc_result : std_logic_vector(7 downto 0);
    
    signal adc_start_sampling : std_logic := '0';
    
    constant clock_period : time := 10ns;
    constant clock_period2 : time := 50ns;


begin

    UUT : max1426_module
    PORT MAP(
        SYSCLK => sysclk,
        ADC_CLK_IN => adc_clk_in,
        RESET => reset,
        ADC_OE => adc_oe,
        ADC_CLK => adc_clk,
        ADC_DATA_READY => adc_data_ready,
        ADC_RESULT => adc_result,
        ADC_START_SAMPLING => adc_start_sampling    
    );
    
    process 
    begin
        reset <= '1';
        wait for clock_period;
        reset <= '0';
        wait;
    end process;
    
    process
    begin
        sysclk <= '1';
        wait for clock_period / 2;
        sysclk <= '0';
        wait for clock_period / 2;
    end process;
    
    process
    begin
        adc_clk_in <= '1';
        wait for clock_period2 / 2;
        adc_clk_in <= '0';
        wait for clock_period2 / 2;    
    end process;
    
    process
    constant counter1 : integer := 10;
    constant counter2 : integer := 22;
    variable counter : integer range 0 to counter2 := 0;    
    begin
        if counter = 0 then
            wait for clock_period * 10;
            adc_start_sampling <= '1';                 
        
        elsif counter > 0 and counter < counter1 then
            adc_start_sampling <= '1';
            wait for 100us;
        
        elsif counter = counter1 then
            adc_start_sampling <= '0';
            wait for 100us;

        elsif counter > counter1 and counter < counter2 then
            adc_start_sampling <= '1';
            wait for 100us; 
                
        else
            adc_start_sampling <= '0';
            wait;
        end if;
        
        counter := counter + 1;
    
    end process;




end Behavioral;

