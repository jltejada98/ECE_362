/**
  ******************************************************************************
  * @file    main.c
  * @author  Ac6
  * @version V1.0
  * @date    01-December-2013
  * @brief   Default main function.
  ******************************************************************************
*/


#include "stm32f0xx.h"
#include "stm32f0_discovery.h"
			

//extern autotest(void); Consider removing because no autotest.o file was given
void setup_gpio();

int  rdir=1;
int gdir=1;
int bdir=1;

void tim1_init(void){
	setup_gpio();
	RCC->APB2ENR |= RCC_APB2ENR_TIM1EN;
	//Set the prescaler so that its output is exactly 2 MHz
	//=> PWM freq = CK_INT / (PSC + 1) / (ARR + 1)
	TIM1->PSC = 24-1;
	TIM1->CR1 &= (~(TIM_CR1_DIR) | ~(TIM_CR1_CMS)); //Clear values, results in upcounter edge aligned mode

	//PWM Frequency = 1000Hz
	TIM1->ARR = 2000-1;

	//Channel 1 (PWM = 6%) //Blue
	//Duty Cycle PWM duty cycle = CCRx / (ARR + 1) = 120/2000
	TIM1->CCR1 = 0.06*2000;
	TIM1->CCMR1 |= TIM_CCMR1_OC1M_2 | TIM_CCMR1_OC1M_1| TIM_CCMR1_OC1PE;
	TIM1->CCER |= TIM_CCER_CC1E;

	//Channel 2 //Green
	TIM1->CCR2 = 0.3333*2000;
	TIM1->CCMR1 |= TIM_CCMR1_OC2M_2 | TIM_CCMR1_OC2M_1| TIM_CCMR1_OC2PE;
	TIM1->CCER |= TIM_CCER_CC2E;

	//Channel 3 //Red
	TIM1->CCR3 = 0.6666*2000;
	TIM1->CCMR2 |= TIM_CCMR2_OC3M_2 | TIM_CCMR2_OC3M_1| TIM_CCMR2_OC3PE;
	TIM1->CCER |= TIM_CCER_CC3E;

	//Initialize for
	TIM1->BDTR |= TIM_BDTR_MOE;
	TIM1->CR1 |= TIM_CR1_CEN; //Enable timer.
}


//Lab 7 GPIO init
void setup_gpio() {
	/* Student code goes here */
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN;
	GPIOA->MODER &= ~0x3f0000;
	GPIOA->MODER |= 0x2A0000; //Alternate function code.
	GPIOA->AFR[1] &= ~0xfff;
	GPIOA->AFR[1] |= 0x222;
}


void tim3_init(void){
	RCC->APB1ENR |= RCC_APB1ENR_TIM3EN;
	TIM3->CR1 &= (~(TIM_CR1_DIR) | ~(TIM_CR1_CMS)); //Clear values and set to desired values

	//Timer 3
	TIM3->PSC = 480-1;
	TIM3->ARR = 200-1;

	//Enable Interrupt
	NVIC->ISER[0] |= (1<<TIM3_IRQn); //Dont know if it is correct
	//Start timer
	TIM3->DIER |= TIM_DIER_UIE;
	TIM3->CR1 |= TIM_CR1_CEN;

}


void TIM3_IRQHandler(){
	TIM3->SR &= ~TIM_SR_UIF;

	if(rdir == 1){
		TIM1->CCR3 = (TIM1->CCR3 * 517)>>9;
		if(TIM1->CCR3 >= 1980){
			rdir = -1;
		}
	}
	else{
		TIM1->CCR3 = (TIM1->CCR3 * 506)>>9;
		if(TIM1->CCR3 <= 120){
			rdir = 1;
		}
	}


	if(gdir == 1){
			TIM1->CCR2 = (TIM1->CCR2 * 517)>>9;
			if(TIM1->CCR2 >= 1980){
				gdir = -1;
			}
		}
		else{
			TIM1->CCR2 = (TIM1->CCR2 * 506)>>9;
			if(TIM1->CCR2 <= 120){
				gdir = 1;
			}
		}

	if(bdir == 1){
				TIM1->CCR1 = (TIM1->CCR1 * 517)>>9;
				if(TIM1->CCR1 >= 1980){
					bdir = -1;
				}
			}
			else{
				TIM1->CCR1 = (TIM1->CCR1 * 506)>>9;
				if(TIM1->CCR1 <= 120){
					bdir = 1;
				}
			}

}

int main(void) {
	autotest();
	tim1_init();
	tim3_init();
	while(1) asm("wfi");
	return 0;
}
