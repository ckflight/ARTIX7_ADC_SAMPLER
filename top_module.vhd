library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
    PORT( 
        SYSCLK      : in std_logic;
        RESET       : in std_logic;
        
        BUTTON1     : in std_logic;
        BUTTON2     : in std_logic;

        LED1        : out std_logic;
        LED2        : out std_logic;        

        ADC_OE      : out std_logic;
        ADC_CLK     : out std_logic;

        USB_DATA    : out std_logic_vector(7 downto 0);
        USB_RXF     : in std_logic;
        USB_TXE     : in std_logic;
        USB_RD      : out std_logic;
        USB_WR      : out std_logic;
        
        MCU_START : in std_logic; -- 1 when stm32 loop starts.
        ADF4158_MUX : in std_logic; -- mux = 0 when ramp starts, mux = 1 when gap
        
        CHECK_PIN1 : out std_logic; -- these are for checking the states with scope.
        CHECK_PIN2 : out std_logic;
        CHECK_PIN4 : out std_logic        
    );
end top_module;

architecture Behavioral of top_module is

    COMPONENT clk_wiz_0
    PORT(
        clk_out1 : out std_logic;
        clk_out2 : out std_logic;
        clk_out3 : out std_logic;
        clk_in1  : in std_logic    
    );    
    END COMPONENT;

    COMPONENT ft2232h_module
    PORT(
        SYSCLK           : in STD_LOGIC;
        USB_CLK          : in STD_LOGIC;
        RESET            : in STD_LOGIC;        
        
        USB_DATA_TO_SEND : in STD_LOGIC_VECTOR(7 downto 0);        
        USB_DATA_READY   : in STD_LOGIC;
        
        USB_DATAOUT      : out STD_LOGIC_VECTOR(7 downto 0);
        USB_RXF          : in STD_LOGIC;
        USB_TXE          : in STD_LOGIC;
        USB_RD           : out STD_LOGIC;
        USB_WR           : out STD_LOGIC;
        TX_DONE          : out STD_LOGIC;
        CHECK_OUT        : out STD_LOGIC        
    );
    END COMPONENT;

    COMPONENT fifo_module
    PORT(
        SYSCLK        : in std_logic;
        RESET         : in std_logic;
        FIFO_WRITE_EN : in std_logic;
        FIFO_READ_EN  : in std_logic;
        FIFO_DATA_IN  : in std_logic_vector(7 downto 0);
        FIFO_DATA_OUT : out std_logic_vector(7 downto 0);
        FIFO_FULL     : out std_logic;
        FIFO_EMPTY    : out std_logic
    );
    END COMPONENT;
    
    COMPONENT adc1173_module
    PORT(  
        SYSCLK      : in STD_LOGIC;
        ADC_CLK_IN  : in STD_LOGIC;
        RESET       : in STD_LOGIC;
        
        ADC_OE      : out std_logic;
        ADC_CLK     : out std_logic;
        
        ADC_DATA_READY  : out std_logic;
        ADC_RESULT      : out std_logic_vector(7 downto 0);
        
        ADC_START_SAMPLING : in std_logic
    );
    END COMPONENT;
    
    -- FT2232H signals    
    signal s_usb_data_ready : std_logic := '0';
    signal s_tx_done        : std_logic := '0';
    
    -- Fifo signals
    signal s_fifo_write_en  : std_logic := '0';
    signal s_fifo_read_en   : std_logic := '0';
    signal s_fifo_data_in   : std_logic_vector(7 downto 0) := (others => '0');
    signal s_fifo_data_out  : std_logic_vector(7 downto 0);
    signal s_fifo_full      : std_logic;
    signal s_fifo_empty     : std_logic;
    
    -- ADC signals
    signal s_adc_result         : std_logic_vector(7 downto 0);
    signal s_adc_data_ready     : std_logic;    
    
    signal s_mcu_start          : std_logic := '0';
    signal s_mcu_start_stable   : std_logic := '0';
    
    signal s_adf4158_mux        : std_logic := '0';
    signal s_adf4158_mux_stable : std_logic := '0';
    
    signal s_adc_clk            : std_logic := '0';
    signal s_usb_clk            : std_logic := '0';
    signal s_sysclk             : std_logic := '0';
    
    signal s_check : std_logic := '0';
           
begin
    
    LED1 <= BUTTON1;    
    LED2 <= BUTTON2;
    
    --CHECK_PIN4 <= s_adf4158_mux_stable;
    CHECK_PIN4 <= s_check;
    
    INST_MODULE1 : ft2232h_module
    PORT MAP(    
        SYSCLK           => s_sysclk,
        USB_CLK          => s_usb_clk,
        RESET            => RESET,
        USB_DATA_TO_SEND => s_fifo_data_out,
        USB_DATA_READY   => s_usb_data_ready,
        USB_DATAOUT      => USB_DATA,        
        USB_RXF          => USB_RXF,
        USB_TXE          => USB_TXE,
        USB_RD           => USB_RD,
        USB_WR           => USB_WR,
        TX_DONE          => s_tx_done,
        CHECK_OUT        => s_check
    );

    INST_MODULE2 : fifo_module
    PORT MAP(
        SYSCLK        => s_sysclk,
        RESET         => RESET,
        FIFO_WRITE_EN => s_fifo_write_en,
        FIFO_READ_EN  => s_fifo_read_en,
        FIFO_DATA_IN  => s_fifo_data_in,
        FIFO_DATA_OUT => s_fifo_data_out,
        FIFO_FULL     => s_fifo_full,
        FIFO_EMPTY    => s_fifo_empty    
    );
    
    INST_MODULE3 : adc1173_module
    PORT MAP(
        SYSCLK           => s_sysclk,
        ADC_CLK_IN       => s_adc_clk,
        RESET            => RESET,
        ADC_OE           => ADC_OE,
        ADC_CLK          => ADC_CLK,
        ADC_DATA_READY   => s_adc_data_ready,
        ADC_RESULT       => s_adc_result,
        ADC_START_SAMPLING => s_adf4158_mux_stable        
    );
    
    INST_MODULE4 : clk_wiz_0
    PORT MAP(
        clk_out1 => s_sysclk, -- 100 MHz
        clk_out2 => s_adc_clk, -- 20 MHz
        clk_out3 => s_usb_clk, -- 40 MHz
        clk_in1 => SYSCLK    
    );
    
    Metastability: process(s_sysclk)
    begin
        if rising_edge(s_sysclk) then
            s_mcu_start          <= MCU_START;
            s_adf4158_mux        <= ADF4158_MUX;
            
            s_mcu_start_stable   <= s_mcu_start;
            s_adf4158_mux_stable <= s_adf4158_mux;
        end if;
    end process;

    -- Write data to fifo module from adc module
    Fifo_Write_FSM : process(s_sysclk, RESET)
    type fsm_states is (idle_st, write_start, write_stop);
    variable current_state : fsm_states := idle_st;
    variable isDone : std_logic := '0'; 
    begin
          
        if rising_edge(s_sysclk) then
        
            if (RESET = '1') then
                current_state := idle_st;
                isDone := '0';      
                CHECK_PIN1 <= '0';
           
            elsif s_adf4158_mux_stable = '0' and s_mcu_start_stable = '1' then
                
                -- isDone check prevents multiple enterance until next data.
                case current_state is  
                                  
                    when idle_st => 
                        if (s_adc_data_ready = '1') and (isDone = '0') then
                            current_state := write_start;
                        elsif (s_adc_data_ready = '0') and (isDone = '1') then
                            isDone := '0';
                        end if;   
                        
                    when write_start =>
                        if s_fifo_full = '0' then
                            CHECK_PIN1 <= '1';
                            s_fifo_data_in <= s_adc_result;                            
                            s_fifo_write_en <= '1';
                        end if;
                        current_state := write_stop; 
                     
                    when write_stop =>                        
                        CHECK_PIN1 <= '0';
                        s_fifo_write_en <= '0';
                        current_state := idle_st; 
                        isDone := '1';
                        
                end case;
            
            end if;
            
        end if;     
    end process;
    
    -- Read data from fifo and send to ft2232h module
    Fifo_Read_FSM : process(s_sysclk, RESET)
    type fsm_states is (idle_st, read_start, read_stop);
    variable current_state : fsm_states := idle_st;
    begin        
        if rising_edge(s_sysclk) then
                
            if (RESET = '1') then
                current_state := idle_st;   
                CHECK_PIN2 <= '0';
                     
            elsif s_adf4158_mux_stable = '1' and s_mcu_start_stable = '1' then -- mux gap started            
                
                case current_state is                                        
                    
                    when idle_st =>                          
                        if s_tx_done = '1' then                      
                            current_state := read_start;
                        else
                            current_state := idle_st;
                        end if;
                       
                    when read_start =>
                        s_usb_data_ready <= '0';
                        if s_fifo_empty = '0' then
                            CHECK_PIN2 <= '1';
                            s_fifo_read_en <= '1';    
                        end if;                                                
                        current_state := read_stop;
                        
                    when read_stop =>             
                        CHECK_PIN2 <= '0';
                        s_usb_data_ready <= '1';
                        s_fifo_read_en <= '0';                        
                        current_state := idle_st;

                end case;  
                  
            end if;  
                       
        end if;    
    end process;
    
        

end Behavioral;


