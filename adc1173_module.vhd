library IEEE;

use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- ADC IN is sampled at the falling edge of the adc clock
-- DATA is available at the rising edge of the adc clock
-- OE is active low output enable pin to enable data pins when low.

entity adc1173_module is
    PORT(
        SYSCLK          : in STD_LOGIC;
        ADC_CLK_IN      : in STD_LOGIC;
        RESET           : in STD_LOGIC;
        
        --ADC_DATA        : in std_logic_vector(7 downto 0);
        ADC_OE          : out std_logic;
        ADC_CLK         : out std_logic;
        
        ADC_DATA_READY  : out std_logic;
        ADC_RESULT      : out std_logic_vector(7 downto 0);
        
        ADC_START_SAMPLING : in std_logic       
    );
end adc1173_module;

architecture rtl of adc1173_module is

    signal s_data : std_logic_vector(7 downto 0) := X"00";   

begin

    ADC_RESULT <= s_data;
    
    ADC_OE <= ADC_START_SAMPLING;
    
    ADC_CLK <= ADC_CLK_IN;    

    -- s_adc_clock is 2 x adc_sampling for 2 states.
    ADC_SAMPLE_PROCESS : process(SYSCLK, RESET)
    type fsm_states is (sample_state, wait_state1, wait_state2);
    variable current_state : fsm_states := sample_state;
    constant number_of_samples : integer := 2048;
    variable sample_counter : integer range 0 to number_of_samples := 0;
    variable data_counter : integer range 0 to 255 := 0;
    variable wait_counter : integer range 0 to 100 := 0;
    begin           
        if falling_edge(SYSCLK) then
        
            if RESET = '1' then
                s_data <= X"00";
                current_state := sample_state;
                ADC_DATA_READY <= '0';
                data_counter := 0;
                sample_counter := 0;
                wait_counter := 0;
        
            elsif ADC_START_SAMPLING = '0' and sample_counter < number_of_samples then
                case current_state is
                    
                    -- 1 sample_st + 2 wait_st1 + 7 wait_st2 = 10 cycle * 10ns = 100ns = 10MSPS
                    when sample_state =>
                        data_counter := data_counter + 1;                        
                        if data_counter = 255 then
                            data_counter := 0;    
                        end if; 
                        
                        s_data <= std_logic_vector(to_unsigned(data_counter, 8));                      
                        ADC_DATA_READY <= '1';
                        
                        sample_counter := sample_counter + 1;                       
                        current_state := wait_state1;  
                    
                    when wait_state1 =>
                        wait_counter := wait_counter + 1;
                        if wait_counter = 2 then
                            wait_counter := 0;
                            ADC_DATA_READY <= '0';
                            current_state := wait_state2;                        
                        end if;

                    when wait_state2 =>
                        wait_counter := wait_counter + 1;
                        if wait_counter = 7 then 
                            wait_counter := 0;                            
                            current_state := sample_state;
                        end if;
                end case;
            
            else 
                ADC_DATA_READY <= '0';
                if ADC_START_SAMPLING = '1' then
                    ADC_DATA_READY <= '0';
                    data_counter := 0;
                    sample_counter := 0;
                    wait_counter := 0;
                end if;                                                              
            end if;                    
        end if;
    
    end process;





end rtl;