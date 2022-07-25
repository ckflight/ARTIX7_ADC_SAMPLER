# XILINX Artix 7 High Speed ADC Sampler

## Project Info:

 * This hardware design samples the data of parallel interface 10 MSPS ADC. 
 
 * The sampled data is stored in the FIFO module implemented. The FIFO module is capable of responding to read and write operations in one clock cycle simultaneously.
 
 * FT2232H USB 2.0 interface is implemented in FT2232H Asynchronous FT245 FIFO mode.
 
 * The ADC samples are buffered to HOST PC over FT2232H USB interface.

 * I designed this board to use it with my FMCW Radar design for higher speed ADC sampling. The benefit of higher sampling frequency is, it lowers the ADC noise floor.
 The noise floor for the Radar's receiver chain is around -120 dBm.


SNR =  SNR(adc) + 10log(framp * fsampling)

To test adc data counter is used.

Kicad files for adc sampler board design with max1426, spartan 7 or artix 7 fpga and ft2232h ic will be included in near future stay tuned!
