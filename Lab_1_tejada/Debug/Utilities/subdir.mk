################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Utilities/stm32f0_discovery.c 

OBJS += \
./Utilities/stm32f0_discovery.o 

C_DEPS += \
./Utilities/stm32f0_discovery.d 


# Each subdirectory must supply rules for building sources it contributes
Utilities/%.o: ../Utilities/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: MCU GCC Compiler'
	@echo $(PWD)
	arm-none-eabi-gcc -mcpu=cortex-m0 -mthumb -mfloat-abi=soft -DSTM32 -DSTM32F0 -DSTM32F051R8Tx -DSTM32F0DISCOVERY -DDEBUG -DSTM32F051 -DUSE_STDPERIPH_DRIVER -I"/Users/joseluistejada/Documents/Purdue/Year 3/Semester 1/Computer Engineering 362/ECE362/Lab01_tejada/Utilities" -I"/Users/joseluistejada/Documents/Purdue/Year 3/Semester 1/Computer Engineering 362/ECE362/Lab01_tejada/StdPeriph_Driver/inc" -I"/Users/joseluistejada/Documents/Purdue/Year 3/Semester 1/Computer Engineering 362/ECE362/Lab01_tejada/inc" -I"/Users/joseluistejada/Documents/Purdue/Year 3/Semester 1/Computer Engineering 362/ECE362/Lab01_tejada/CMSIS/device" -I"/Users/joseluistejada/Documents/Purdue/Year 3/Semester 1/Computer Engineering 362/ECE362/Lab01_tejada/CMSIS/core" -O0 -g3 -Wall -fmessage-length=0 -ffunction-sections -c -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


