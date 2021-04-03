################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/uart/alt_16550_uart.c \
../src/uart/uart.c 

C_DEPS += \
./src/uart/alt_16550_uart.d \
./src/uart/uart.d 

OBJS += \
./src/uart/alt_16550_uart.o \
./src/uart/uart.o 


# Each subdirectory must supply rules for building sources it contributes
src/uart/%.o: ../src/uart/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc --cpu=Cortex-A9 --no_unaligned_access -DALT_FPGA_ENABLE_DMA_SUPPORT=1 -Dsoc_cv_av -I"D:\CPEN\Year3\CPEN391\hardware-7b155bb762288057a624a9cbf5f614c8d2561e35\project\arm\ARM_SYSTEM\lib\hwlib" -I"D:\CPEN\Year3\CPEN391\hardware-7b155bb762288057a624a9cbf5f614c8d2561e35\project\arm\ARM_SYSTEM\lib\soc_cv_av" --c99 -O0 -g --md --depend_format=unix_escaped --no_depend_system_headers --depend_dir="src/uart" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


