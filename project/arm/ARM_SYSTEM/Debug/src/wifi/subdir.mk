################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/wifi/wifi.c 

OBJS += \
./src/wifi/wifi.o 

C_DEPS += \
./src/wifi/wifi.d 


# Each subdirectory must supply rules for building sources it contributes
src/wifi/%.o: ../src/wifi/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc --cpu=Cortex-A9 --no_unaligned_access -DALT_FPGA_ENABLE_DMA_SUPPORT=1 -Dsoc_cv_av -I"/home/jared/Desktop/smartcart/de1-hardware/project/arm/ARM_SYSTEM/lib/hwlib" -I"/home/jared/Desktop/smartcart/de1-hardware/project/arm/ARM_SYSTEM/lib/soc_cv_av" --c99 -O0 -g --md --depend_format=unix_escaped -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


