################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/hx711/hx711.c 

C_DEPS += \
./src/hx711/hx711.d 

OBJS += \
./src/hx711/hx711.o 


# Each subdirectory must supply rules for building sources it contributes
src/hx711/%.o: ../src/hx711/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc --cpu=Cortex-A9 --no_unaligned_access -DALT_FPGA_ENABLE_DMA_SUPPORT=1 -Dsoc_cv_av -I"D:\CPEN\Year3\CPEN391\hardware-7b155bb762288057a624a9cbf5f614c8d2561e35\project\arm\ARM_SYSTEM\lib\hwlib" -I"D:\CPEN\Year3\CPEN391\hardware-7b155bb762288057a624a9cbf5f614c8d2561e35\project\arm\ARM_SYSTEM\lib\soc_cv_av" --c99 -O0 -g --md --depend_format=unix_escaped --no_depend_system_headers --depend_dir="src/hx711" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


