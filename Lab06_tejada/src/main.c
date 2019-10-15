#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include <stdio.h>
#include <stdlib.h>

#define RATE 100000
#define N 1000
extern const short int wavetable[N];

// This function
// 1) enables clock to port A,
// 2) sets PA0, PA1, PA2 and PA4 to analog mode
void setup_gpio() {
    /* Student code goes here */
}

// This function should enable the clock to the
// onboard DAC, enable trigger,
// setup software trigger and finally enable the DAC.
void setup_dac() {
    /* Student code goes here */
}

// This function should,
// enable clock to timer6,
// setup pre scalar and arr so that the interrupt is triggered 100us,
// enable the timer 6 interrupt and start the timer.
void setup_timer6() {
    /* Student code goes here */
}



// This function should enable the clock to ADC,
// turn on the clocks, wait for ADC to be ready.
void setup_adc() {
    /* Student code goes here */
}

// This function should return the value from the ADC
// conversion of the channel specified by the “channel” variable.
// Make sure to set the right bit in channel selection
// register and do not forget to start adc conversion.
int read_adc_channel(unsigned int channel) {
    /* Student code goes here */
}

void TIM6_DAC_IRQHandler() {
    /* Student code goes here */
}

int main(void)
{
    /* Student code goes here */
}
