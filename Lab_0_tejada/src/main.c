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
#include "stdlib.h"

int main() {
    // The Reset and Clock Control port has an Enable Register for the
    // ARM’s Advanced High-Performance Bus (AHB)
    int *rcc_ahbenb = (int *)0x40021014;
    // General Purpose I/O port C's Mode register
    int *gpioc_moder = (int *)0x48000800;
    // General Purpose I/O port C's Output Data Register
    int *gpioc_odr = (int *)0x48000814;
    *rcc_ahbenb |= 0x00080000; // Enable the clock to the GPIOC
    *gpioc_moder |= 0x00040000; // Configure PC9 (Green LED) as output
    *gpioc_moder |= 0x00010000; // Configure PC8 (Blue LED) as output
    for(;;) {
        register int x asm("r6"); // Put the x variable in a register.
        for(x=0; x < 114800; x++) { ; } // Wait a 0.1 sec.
        int val = rand() & 1;
        if(val == 1)
            *gpioc_odr |= GPIO_ODR_9; // Turn on only PC9 (Green LED)
        else
            *gpioc_odr &= ~GPIO_ODR_9; // Turn off only PC9 (Green LED)
    }
}
