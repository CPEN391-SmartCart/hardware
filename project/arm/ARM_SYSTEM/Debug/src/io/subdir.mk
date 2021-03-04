################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/io/digital.c 

OBJS += \
./src/io/digital.o 

C_DEPS += \
./src/io/digital.d 


# Each subdirectory must supply rules for building sources it contributes
src/io/%.o: ../src/io/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc --cpu=Cortex-A9 --no_unaligned_access -DALT_FPGA_ENABLE_DMA_SUPPORT=1 -Dsoc_cv_av -I"/home/jared/Desktop/smartcart/de1-hardware/project/arm/ARM_SYSTEM/lib/hwlib" -I"/home/jared/Desktop/smartcart/de1-hardware/project/arm/ARM_SYSTEM/lib/soc_cv_av" --c99 -O0 -g --md --depend_format=unix_escaped -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


