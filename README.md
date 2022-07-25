# XILINX Artix 7 High Speed ADC Sampler

## Project Info:

 * This hardware design samples the data of parallel interface 10 MSPS ADC. 
 
 * The sampled data is stored in the FIFO module implemented. The FIFO module is capable of responding to read and write operations in one clock cycle simultaneously.
 
 * FT2232H USB 2.0 interface is implemented in FT2232H Asynchronous FT245 FIFO mode.
 
 * The ADC samples are buffered to HOST PC over FT2232H USB interface.

 * To test, ADC data counter is used.

 * I designed this board to use it with my FMCW Radar design for higher speed ADC sampling. The benefit of higher sampling frequency is, it lowers the ADC noise floor.
 
 * ADC Noise Floor Calculation:
 
 $$ Signal Power = {10 * \log _{10} {Vrms^2 \over RIN}} + 30dB $$
 
 $$ Vrms = 0.707 * Vpeak $$
 
 $$ SubtractNormalize = {10 * \log _{10} {fsample \over 2}} $$
 
  * Parameters: SNR(adc) = 61 dB (for -1dBFS input level), Vpp = 2V and Rin = 200Ohm, fsample = 10MHz, framp = 1ms
  * For Vpp = 2V, Vrms = 0.707 * 1 = 0.707V
  * Signal Power = -26dB + 30dB = 4dB
  * Nyquist Band Noise Power = +4dB - 1dB - 61dB = -58dB
  * SubtractNormalize = 67 dB 
  * Normalized Noise Power = -58dB - 67dB = -125dB
  * In the case of Radar the Subtract Normalize number formula is:
  
   $$ SubtractNormalize = {10 * \log _{10} {framp * fsample}} $$

  * As we can see from the formulas above, the noise floor decreases as the sampling rate is increased. That is the main reason of this FPGA design for better Radar reception sensitivity.

 * Kicad files for adc sampler board design with max1426, spartan 7 or artix 7 fpga and ft2232h ic will be included in near future stay tuned!
