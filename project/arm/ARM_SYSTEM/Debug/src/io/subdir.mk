################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../src/io/digital.c 

C_DEPS += \
./src/io/digital.d 

OBJS += \
./src/io/digital.o 


# Each subdirectory must supply rules for building sources it contributes
src/io/%.o: ../src/io/%.c
	@echo 'Building file: $<'
	@echo 'Invoking: ARM C Compiler 5'
	armcc --cpu=Cortex-A9 --no_unaligned_access -DALT_FPGA_ENABLE_DMA_SUPPORT=1 -Dsoc_cv_av -I"C:\Users\jonat\Bunker\01_Documents\01_UBC_2020-2021\W2\03_CPEN391\hardware\project\arm\ARM_SYSTEM\lib\hwlib" -I"C:\Users\jonat\Bunker\01_Documents\01_UBC_2020-2021\W2\03_CPEN391\hardware\project\arm\ARM_SYSTEM\lib\soc_cv_av" --c99 -O0 -g --md --depend_format=unix_escaped --no_depend_system_headers --depend_dir="src/io" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


