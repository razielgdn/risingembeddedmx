---
title: "Make: Examples for embedded systems"
permalink: /notes/en/make-example-en
key: make-examples
modify_date: 2025-07-01
date: 2025-06-30
lang: en-US 
---

Several Makefiles are used in the projects documented on this website to automate building, flashing, and cleaning embedded projects.

## Before Starting: IDE Explanation

Most IDEs have tools to generate Makefiles automatically. Throughout my experience, I have used Eclipse-based IDEs to build projects in C and C++. Years ago, I had no idea that the Makefile was created by the IDE tools until I needed to modify the Makefiles myself. Like most of my learning, it was a process of trying, modifying, failing, correcting, and trying again.

### Eclipse

When a version of Eclipse is used, the Makefile is modified through the project properties. 
In the case of STM32CubeIDE with a project open, you can access the properties as follows: 
1. Go to the Project menu and click on Properties.
2. Check C/C++ Build - Settings and Tool Settings.
   - **MCU/MPU Toolchain**: You can configure the ARM toolchain, either the IDE option or an external option. 
   - **MCU/MPU Settings**: Here you can see the information of the CPU.
   - **MCU/MPU Post build outputs**: In this tab, you can set the output formats of your binaries. 
     ![](/assets/images/makepost/make-build.png)
   - **MCU/MPU GCC Assembler**: The options for the preprocessor and assembler can be modified here.
   - **MCU/MPU GCC Compiler**: The options for the compiler are managed here. 
     ![](/assets/images/makepost/make-compiler.png)
   - **MCU/MPU GCC Linker**: The options for linking the project are managed here. 
  
   The makefile is stored in the Release path:
    ```makefile 
    -include ../makefile.init
    RM := rm -rf
    # All of the sources participating in the build are defined here
    -include sources.mk
    -include Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
    -include Core/Startup/subdir.mk
    -include Core/Src/subdir.mk
    -include objects.mk

    ifneq ($(MAKECMDGOALS),clean)
    ifneq ($(strip $(S_DEPS)),)
    -include $(S_DEPS)
    endif
    ifneq ($(strip $(S_UPPER_DEPS)),)
    -include $(S_UPPER_DEPS)
    endif
    ifneq ($(strip $(C_DEPS)),)
    -include $(C_DEPS)
    endif
    endif

    -include ../makefile.defs

    OPTIONAL_TOOL_DEPS := \
    $(wildcard ../makefile.defs) \
    $(wildcard ../makefile.init) \
    $(wildcard ../makefile.targets) \


    BUILD_ARTIFACT_NAME := testOfSTM32F103
    BUILD_ARTIFACT_EXTENSION := elf
    BUILD_ARTIFACT_PREFIX :=
    BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

    # Add inputs and outputs from these tool invocations to the build variables 
    EXECUTABLES += \
    testOfSTM32F103.elf \

    MAP_FILES += \
    testOfSTM32F103.map \

    SIZE_OUTPUT += \
    default.size.stdout \

    OBJDUMP_LIST += \
    testOfSTM32F103.list \


    # All Target
    all: main-build

    # Main-build Target
    main-build: testOfSTM32F103.elf secondary-outputs

    # Tool invocations
    testOfSTM32F103.elf testOfSTM32F103.map: $(OBJS) $(USER_OBJS) /home/octavioguendulain/STM32CubeIDE/workspace_1.16.1/testOfSTM32F103/STM32F103C8TX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-gcc -o "testOfSTM32F103.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m3 -T"/home/octavioguendulain/STM32CubeIDE/workspace_1.16.1/testOfSTM32F103/STM32F103C8TX_FLASH.ld" --specs=nosys.specs -Wl,-Map="testOfSTM32F103.map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
        @echo 'Finished building target: $@'
        @echo ' '

    default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-size  $(EXECUTABLES)
        @echo 'Finished building: $@'
        @echo ' '

    testOfSTM32F103.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-objdump -h -S $(EXECUTABLES) > "testOfSTM32F103.list"
        @echo 'Finished building: $@'
        @echo ' '

    # Other Targets
    clean:
        -$(RM) default.size.stdout testOfSTM32F103.elf testOfSTM32F103.list testOfSTM32F103.map
        -@echo ' '

    secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

    fail-specified-linker-script-missing:
        @echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
        @exit 2

    warn-no-linker-script-specified:
        @echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

    .PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

    -include ../makefile.targets
    ```
 

3. If you change the settings you can see the changes in makefile.
   As an example:   

   - Active the binary file and s-record as outputs in Post build output. 
     ![](/assets/images/makepost/make-out.png)

    ```makefile
     -include ../makefile.init

     RM := rm -rf

     # All of the sources participating in the build are defined here
     -include sources.mk
     -include Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
     -include Core/Startup/subdir.mk
     -include Core/Src/subdir.mk
     -include objects.mk

     ifneq ($(MAKECMDGOALS),clean)
     ifneq ($(strip $(S_DEPS)),)
     -include $(S_DEPS)
     endif
     ifneq ($(strip $(S_UPPER_DEPS)),)
     -include $(S_UPPER_DEPS)
     endif
     ifneq ($(strip $(C_DEPS)),)
     -include $(C_DEPS)
     endif
     endif

     -include ../makefile.defs

     OPTIONAL_TOOL_DEPS := \
     $(wildcard ../makefile.defs) \
     $(wildcard ../makefile.init) \
     $(wildcard ../makefile.targets) \


     BUILD_ARTIFACT_NAME := testOfSTM32F103
     BUILD_ARTIFACT_EXTENSION := elf
     BUILD_ARTIFACT_PREFIX :=
     BUILD_ARTIFACT := $(BUILD_ARTIFACT_PREFIX)$(BUILD_ARTIFACT_NAME)$(if $(BUILD_ARTIFACT_EXTENSION),.$(BUILD_ARTIFACT_EXTENSION),)

     # Add inputs and outputs from these tool invocations to the build variables 
     EXECUTABLES += \
     testOfSTM32F103.elf \

     MAP_FILES += \
     testOfSTM32F103.map \

     SIZE_OUTPUT += \
     default.size.stdout \

     OBJDUMP_LIST += \
     testOfSTM32F103.list \

     OBJCOPY_BIN += \
     testOfSTM32F103.bin \

     OBJCOPY_SREC += \
     testOfSTM32F103.srec \
     # All Target
     all: main-build

     # Main-build Target
     main-build: testOfSTM32F103.elf secondary-outputs

     # Tool invocations
     testOfSTM32F103.elf testOfSTM32F103.map: $(OBJS) $(USER_OBJS) /home/octavioguendulain/STM32CubeIDE/workspace_1.16.1/testOfSTM32F103/STM32F103C8TX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-gcc -o "testOfSTM32F103.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m3 -T"/home/octavioguendulain/STM32CubeIDE/workspace_1.16.1/testOfSTM32F103/STM32F103C8TX_FLASH.ld" --specs=nosys.specs -Wl,-Map="testOfSTM32F103.map" -Wl,--gc-sections -static --specs=nano.specs -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
        @echo 'Finished building target: $@'
        @echo ' '

     default.size.stdout: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-size  $(EXECUTABLES)
        @echo 'Finished building: $@'
        @echo ' '

     testOfSTM32F103.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-objdump -h -S $(EXECUTABLES) > "testOfSTM32F103.list"
        @echo 'Finished building: $@'
        @echo ' '

     testOfSTM32F103.bin: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "testOfSTM32F103.bin"
        @echo 'Finished building: $@'
        @echo ' '

     testOfSTM32F103.srec: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
        arm-none-eabi-objcopy  -O srec $(EXECUTABLES) "testOfSTM32F103.srec"
        @echo 'Finished building: $@'
        @echo ' '

     # Other Targets
     clean:
        -$(RM) default.size.stdout testOfSTM32F103.bin testOfSTM32F103.elf testOfSTM32F103.list testOfSTM32F103.map testOfSTM32F103.srec
        -@echo ' '

     secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_BIN) $(OBJCOPY_SREC)

     fail-specified-linker-script-missing:
        @echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
        @exit 2

     warn-no-linker-script-specified:
        @echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

     .PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

     -include ../makefile.targets
    ```  

   - Configure Optimize for size (-Os) in GCC Compiler/Optimization (In the case of Debug)
     ![](/assets/images/makepost/make-opt.png)

     The changes are stored in the subdir.mk files

    ```makefile
    diff --git a/Debug/Core/Src/subdir.mk b/Debug/Core/Src/subdir.mk
    index 878ade1..74e68c0 100644
    --- a/Debug/Core/Src/subdir.mk
    +++ b/Debug/Core/Src/subdir.mk
    @@ -31,7 +31,7 @@ C_DEPS += \
       
    # Each subdirectory must supply rules for building sources it contributes
    Core/Src/%.o Core/Src/%.su Core/Src/%.cyclo: ../Core/Src/%.c Core/Src/subdir.mk
    -	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
    +	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
        
    clean: clean-Core-2f-Src
      
    diff --git a/Debug/Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk b/Debug/Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
    index 372c133..629c746 100644
    --- a/Debug/Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
    +++ b/Debug/Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
    @@ -58,7 +58,7 @@ C_DEPS += \
        
    # Each subdirectory must supply rules for building sources it contributes
    Drivers/STM32F1xx_HAL_Driver/Src/%.o Drivers/STM32F1xx_HAL_Driver/Src/%.su Drivers/STM32F1xx_HAL_Driver/Src/%.cyclo: ../Drivers/STM32F1xx_HAL_Driver/Src/%.c Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
    -	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -O0 -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
    +	arm-none-eabi-gcc "$<" -mcpu=cortex-m3 -std=gnu11 -g3 -DDEBUG -DUSE_HAL_DRIVER -DSTM32F103xB -c -I../Core/Inc -I../Drivers/STM32F1xx_HAL_Driver/Inc/Legacy -I../Drivers/STM32F1xx_HAL_Driver/Inc -I../Drivers/CMSIS/Device/ST/STM32F1xx/Include -I../Drivers/CMSIS/Include -Os -ffunction-sections -fdata-sections -Wall -fstack-usage -fcyclomatic-complexity -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfloat-abi=soft -mthumb -o "$@"
        
    clean: clean-Drivers-2f-STM32F1xx_HAL_Driver-2f-Src    
    ```

**Note:**    
My method for learning new tools is to examine multiple examples and understand what happens when building projects or executables.    
That's why I show you how the autogenerated files change.
{:.info}

# Makefiles used for STM32 with GCC

For the projects documented on this website, the Makefiles were based on the structure provided by **OpenBLT**. This served as a starting point to create customized Makefiles tailored to each project's specific requirements.



