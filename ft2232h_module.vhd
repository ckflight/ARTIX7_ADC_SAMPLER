library IEEE;

use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

-- use this code with python scripts at FT2232H folder

-- FT2232H Asynchronous FT245  FIFO mode implementation
-- Datasheet section 4.5, page 43

-- I am using Channel A
-- ADBUS0-7     <---> Spartan Edge Board D4 to D11 (fastest pins around 25 MHz)
-- ACBUS0       <---> Spartan Edge Board IO0
-- ACBUS1       <---> Spartan Edge Board IO1
-- ACBUS2       <---> Spartan Edge Board IO2
-- ACBUS3       <---> Spartan Edge Board IO6
-- ACBUS4(SIWU) <---> GND if this is not ground then transfer is so slow.

-- Spartan pinout is not good rooted, even 20MHz clock is not working properly.
-- Nexys4 handles 40MHz speed with its gpios


entity ft2232h_module is
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
        
        ADF_MUX          : in STD_LOGIC;
        MCU_START        : in STD_LOGIC                  
    );
end ft2232h_module;

architecture rtl of ft2232h_module is

    signal rxf_meta : std_logic := '1';
    signal txe_meta : std_logic := '1';
    signal rxf_sync : std_logic := '1';
    signal txe_sync : std_logic := '1';

    signal s_rd : std_logic     := '1';
    signal s_wr : std_logic     := '1';
    
    signal s_tx_done : std_logic := '1';
    
    signal s_check_out : std_logic := '0';
    
    signal s_data : std_logic_vector(7 downto 0) := (others => '0');  
    
    signal s_led : std_logic := '0';  
    
begin

    USB_RD <= s_rd;
    USB_WR <= s_wr;
    
    TX_DONE <= s_tx_done;
    
    Metastability: process(SYSCLK)
    begin
        if rising_edge(SYSCLK) then
            rxf_meta            <= USB_RXF;
            txe_meta            <= USB_TXE;
            rxf_sync            <= rxf_meta;
            txe_sync            <= txe_meta;
        end if;
    end process;

    -- Data tx process
    FSM_Process: process(SYSCLK, RESET)
    type states is (idle_st, wait_txe, wait_st, st1, st2, st4);
    variable state : states := idle_st;    
    variable counter : integer range 0 to 100 := 0;
    variable data_counter : integer range 0 to 65536 := 0;
    begin
        if rising_edge(SYSCLK) then        
            
            if RESET = '1' then
                state   := idle_st;
                s_rd  <= '1';
                s_wr  <= '1';
                counter := 0;
                USB_DATAOUT <= (others => '0');
                s_tx_done <= '1';
                s_data <= (others => '0'); 
            
            elsif ADF_MUX = '1' and MCU_START = '1' then -- mux gap started                   
                
                case state is  
                    when idle_st =>
                        if USB_DATA_READY = '1' then                       
                            state   := wait_txe;
                            s_data <= USB_DATA_TO_SEND;                                                       
                        else
                            state   := idle_st;
                        end if;
                        
                    when wait_txe =>
                        if txe_sync = '0' then                    
                            USB_DATAOUT <= s_data;
                            state := wait_st;
                        else
                            state := wait_txe;
                        end if;
                        
                    when wait_st =>
                        s_wr  <= '0';
                        counter := counter + 1;
                        if counter = 10 then
                            state   := st1;
                            counter := 0;
                        end if;
        
                    when st1 =>
                        s_wr  <= '1';                    
                        counter := counter + 1;                                        
                        if counter = 4  then
                            s_tx_done <= '1';
                            s_data <= (others => '0');                                                                        
                            state := st2;                        
                            counter := 0;
                        end if;
                        
                    when st2 =>                    
                        s_tx_done <= '0';
                        data_counter := data_counter + 1;
                        if data_counter = 1024 then
                            state := st4;
                        else
                            state := idle_st;    
                        end if;
                        
                     when st4 =>
                        state := st4;
                              
                
                end case;                   
    
            elsif ADF_MUX = '0' and MCU_START = '1' then                
                state := idle_st;
                data_counter := 0;
                           
            end if;            
            
        end if;
    end process;
    
end rtl;