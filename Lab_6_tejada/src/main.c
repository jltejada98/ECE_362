#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
#include <stdio.h>
#include <stdlib.h>
#include "wave.h"

#define RATE 100000
#define N 1000
extern const short int wavetable[N];

//Defined offset and stepsize
//int offset = 0;
//int step = 5.54365 * (1<<16);
int step1;// = 6.98456 * (1<<16);
int step2;//= 5.54365 * (1<<16);
int offset1 = 0;
int offset2 = 0;

// This function
// 1) enables clock to port A,
// 2) sets PA0, PA1, PA2 and PA4 to analog mode
void setup_gpio() {
    /* Student code goes here */
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
	GPIOA->MODER |= 0x33F;
}

// This function should enable the clock to the
// onboard DAC, enable trigger,
// setup software trigger and finally enable the DAC.
void setup_dac() {
    /* Student code goes here */
	RCC->APB1ENR |= RCC_APB1ENR_DACEN;
	DAC->CR &= ~DAC_CR_EN1;
	DAC->CR &= ~DAC_CR_BOFF1;
	DAC->CR |= DAC_CR_TEN1;
	DAC->CR |= DAC_CR_TSEL1;
	DAC->CR |= DAC_CR_EN1; //Enable DAC Channel 1
}
// This function should,
// enable clock to timer6,
// setup pre scalar and arr so that the interrupt is triggered 10us,
// enable the timer 6 interrupt and start the timer.
void setup_timer6() {
    /* Student code goes here */
	RCC->APB1ENR |= RCC_APB1ENR_TIM6EN;
	//(48*10^6)/((47+1)*(9+1)) = 100,000 = 1/10us
	TIM6->PSC = 47;
	TIM6->ARR = 9;
	//Enable Interrupt
	NVIC->ISER[0] |= (1<<TIM6_DAC_IRQn);
	//Start timer
	TIM6->DIER |= TIM_DIER_UIE;
	TIM6->CR1 |= TIM_CR1_CEN;
}

// This function should enable the clock to ADC,
// turn on the clocks, wait for ADC to be ready.
void setup_adc() {
    /* Student code goes here */
	RCC->APB2ENR |= RCC_APB2ENR_ADC1EN;//enable the clock to ADC
	RCC->CR2 |= RCC_CR2_HSI14ON; //Enable Hi-speed internal 14mhz clock
	//Wait for 14mhz clock to be ready
	while(!(RCC->CR2 & RCC_CR2_HSI14RDY));
	//Enable ADC
	ADC1->CR |= ADC_CR_ADEN;
	//Wait for ADC to be ready
	while(!(ADC1->ISR & ADC_ISR_ADRDY));
	//Wait for ADCstart to be ready
	while((ADC1->CR & ADC_CR_ADSTART));
}

// This function should return the value from the ADC
// conversion of the channel specified by the “channel” variable.
// Make sure to set the right bit in channel selection
// register and do not forget to start adc conversion.
int read_adc_channel(unsigned int channel) {
    /* Student code goes here */
	ADC1->CHSELR = 0;
	ADC1->CHSELR = (1<<channel);
	while(!(ADC1->ISR & ADC_ISR_ADRDY)); //Wait for ADC ready
	ADC1->CR |= ADC_CR_ADSTART;
	while(!(ADC1->ISR & ADC_ISR_EOC)); //Wait for ADC end of conversion
	return ADC1->DR;
}

void TIM6_DAC_IRQHandler() {
    /* Student code goes here */
	DAC->SWTRIGR |= DAC_SWTRIGR_SWTRIG1;
	TIM6->SR &= ~TIM_SR_UIF;
	/*
	offset += step;
	if ((offset>>16) >= N){
		offset -= N<<16;
	}
	int sample = wavetable[offset>>16];
	sample = sample / 16 + 2048;
	DAC->DHR12R1 = sample;
	 */
	offset1 += step1;
	if ((offset1>>16) >= N){
		offset1 -= N<<16;
	}
	offset2 +=step2;
	if ((offset2>>16) >= N){
		offset2 -= N<<16;
	}
	int sample = 0;
	sample = wavetable[offset1>>16];
	sample += wavetable[offset2>>16];
	sample = sample / 32 + 2048;
	if (sample > 4095) {
		sample = 4095;
	}
	else if (sample < 0) {
		sample = 0;
	}

	DAC->DHR12R1 = sample;
}

int main(void)
{
    /* Student code goes here */
	setup_gpio();
	init_wavetable(); //Consider calling  init_wavetable()
	setup_dac();
	setup_timer6();
	setup_adc();

	for(;;)
	{
		float a1 = read_adc_channel(0) * 3.0; //Multiply by voltage reference//* 3.0 / 4095.0;
		float a2 = read_adc_channel(1) * 3.0; //* 3.0 / 4095.0;
		float val1 = 800.0/4095.0 * a1 + 200.0; //Linear equation
		float val2 = 800.0/4095.0 * a2 + 200.0;
		val1 = val1 / 1000.0; //Divide by maximum to obtain 0.0000 -> 1.0000
		val2 = val2 / 1000.0;
		step1 = val1 * (1<<16); //Bit shift for fixed point arithmetic
		step2 = val2 * (1<<16);
	}
}
