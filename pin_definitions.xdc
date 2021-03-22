set_property -dict { PACKAGE_PIN E3   IOSTANDARD LVCMOS33 } [get_ports { SYSCLK }];
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {SYSCLK}];

set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { RESET }]; # rightmost button
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { LED1 }];
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { LED2 }];
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { BUTTON1 }];
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { BUTTON2 }];

#ADC
set_property -dict { PACKAGE_PIN H4   IOSTANDARD LVCMOS33 } [get_ports { ADC_OE }];  #JD1
set_property -dict { PACKAGE_PIN H1   IOSTANDARD LVCMOS33 } [get_ports { ADC_CLK }]; #JD2

#FT2232H USB
set_property -dict { PACKAGE_PIN D14   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_RXF}]; #JB1
set_property -dict { PACKAGE_PIN F16   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_TXE}]; #JB2
set_property -dict { PACKAGE_PIN G16   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_RD}];  #JB3
set_property -dict { PACKAGE_PIN H14   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_WR}];  #JB4

set_property -dict { PACKAGE_PIN C17   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[0]}]; #JA1
set_property -dict { PACKAGE_PIN D18   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[1]}]; #JA2
set_property -dict { PACKAGE_PIN E18   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[2]}]; #JA3
set_property -dict { PACKAGE_PIN G17   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[3]}]; #JA4
set_property -dict { PACKAGE_PIN D17   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[4]}]; #JA7
set_property -dict { PACKAGE_PIN E17   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[5]}]; #JA8
set_property -dict { PACKAGE_PIN F18   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[6]}]; #JA9
set_property -dict { PACKAGE_PIN G18   IOSTANDARD LVTTL   SLEW FAST   DRIVE 8 } [get_ports {USB_DATA[7]}]; #JA10

set_property -dict { PACKAGE_PIN K1   IOSTANDARD LVCMOS33 } [get_ports { CHECK_PIN1 }];  #JC1
set_property -dict { PACKAGE_PIN F6   IOSTANDARD LVCMOS33 } [get_ports { CHECK_PIN2 }];  #JC2
set_property -dict { PACKAGE_PIN G6   IOSTANDARD LVCMOS33 } [get_ports { CHECK_PIN4 }];  #JC4   
set_property -dict { PACKAGE_PIN E7   IOSTANDARD LVCMOS33 } [get_ports { ADF4158_MUX }]; #JC7
set_property -dict { PACKAGE_PIN J3   IOSTANDARD LVCMOS33 } [get_ports { MCU_START }];  #JC8

            
