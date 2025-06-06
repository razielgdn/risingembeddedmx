---
title: OpenBLT para la tarjeta Bluepill Plus STM32F103C8Tx
permalink: /projects/es/1-openblt/openblt-bluepill
key: openblt-es
---

# Introducción
Este proyecto permite el uso del *bootloader* de arranque OpenBLT en las tarjetas de desarrollo Bluepill Plus y Blackpill, proporcionando una solución ligera y flexible para actualizaciones de firmware en sistemas basados en STM32.

## Motivación
Este proyecto se desarrolló con el objetivo de habilitar la actualización de firmware a través del protocolo CAN para una red de microcontroladores. En aplicaciones futuras, como un sistema acuapónico automatizado para la cría de peces, crustáceos y plantas, estos microcontroladores gestionarán subsistemas como riego, iluminación y humedad. Las actualizaciones de firmware confiables y escalables son esenciales para mantener un sistema de control distribuido.

## Tarjeta Bluepill Plus STM32F103C8T6
En esta etapa, el *bootloader* OpenBLT es completamente funcional a través de las interfaces RS232 y CAN en la tarjeta **Bluepill Plus**.  

La documentación para el dispositivo está disponible en su [repositorio de GitHub](https://github.com/WeActStudio/BluePill-Plus), y también se puede encontrar un buen resumen en [stm32-base.org](https://stm32-base.org/boards/STM32F103C8T6-WeAct-Blue-Pill-Plus-Clone).  

## Tarjeta Blackpill V3.0 STM32F411CEU6
También estoy evaluando la board Blackpill V3.0 para uso futuro. Aunque carece de soporte integrado para CAN y tiene menor prioridad para el proyecto con OpenBLT, planeo portar el *bootloader* una vez que la implementación basada en Bluepill esté completa.  
La documentación está disponible en el [repositorio de GitHub de la tarjeta](https://github.com/WeActStudio/WeActStudio.BlackPill). Según el esquema y los detalles del hardware, el Microcontrolador STM32F411 parece ser compatible con el STM32F403, requiriendo solo adaptaciones menores para el desarrollo.  
Un resumen útil también se proporciona en [stm32-base.org](https://stm32-base.org/boards/STM32F401CEU6-WeAct-Black-Pill-V3.0).  

## OpenBLT
**OpenBLT** es de código abierto y está licenciado bajo la Licencia Pública General de GNU v3 (GPLv3). Fue creado y es mantenido por **Feaser**. Puedes visitar su [sitio web oficial](https://www.feaser.com/openblt/doku.php?id=homepage) para obtener más información y documentación.

## Aplicaciones de Prueba
Las aplicaciones de prueba fueron obtenidas del [repositorio de GitHub](https://github.com/miniwinwm/BluePillDemo) de **John Blaiklock**, y el código fuente original fue adaptado para este proyecto.

# Portando OpenBLT a STM32F103C8Tx
El código fue portado del demo del proyecto openblt STM32F103RB (con la tarjeta STM32 Nucleo-64) a una bluepill con el micro STM32F103C8Tx.

## Descargar OpenBLT
El paquete completo de OpenBLT está disponible en la [página de descargas de Feaser](https://www.feaser.com/openblt/doku.php?id=download).

## Preparar un entorno de trabajo
1. Crea un directorio de trabajo para el proyecto Bluepill:
 ```bash 
 mkdir ~/openBLT_bluepill
 cd ~/openBLT_bluepill 
 ```
2. Copia las carpetas desde `openblt_v011901/Target/Demo/ARMCM3_STM32F1_Nucleo_F103RB_GCC/` a `~/openBLT_bluepill/`:
  - **Boot/**
  - **Prog/**  

3. Copia la carpeta `openblt_v011901/Target/Source/ARMCM3_STM32F1/` a `~/openBLT_bluepill/Source`. 

4. Copia los siguientes archivos `.c` y `.h` desde `openblt_v011901/Target/Source/` al directorio `~/openBLT_bluepill/Source/`:
    ```
     openblt_v011901/Target/Source/asserts.c 
     openblt_v011901/Target/Source/asserts.h 
     openblt_v011901/Target/Source/backdoor.c 
     openblt_v011901/Target/Source/backdoor.h 
     openblt_v011901/Target/Source/boot.c 
     openblt_v011901/Target/Source/boot.h
     openblt_v011901/Target/Source/can.h 
     openblt_v011901/Target/Source/com.c
     openblt_v011901/Target/Source/com.h
     openblt_v011901/Target/Source/cop.c
     openblt_v011901/Target/Source/cop.h
     openblt_v011901/Target/Source/cpu.h  
     openblt_v011901/Target/Source/file.c  
     openblt_v011901/Target/Source/file.h  
     openblt_v011901/Target/Source/mb.c  
     openblt_v011901/Target/Source/mb.h  
     openblt_v011901/Target/Source/net.c  
     openblt_v011901/Target/Source/net.h  
     openblt_v011901/Target/Source/nvm.h  
     openblt_v011901/Target/Source/plausibility.h 
     openblt_v011901/Target/Source/rs232.h  
     openblt_v011901/Target/Source/timer.h  
     openblt_v011901/Target/Source/usb.h  
     openblt_v011901/Target/Source/xcp.c  
     openblt_v011901/Target/Source/xcp.h
    ```
5. Actualiza las definiciones del microcontrolador: 
   Usa un proyecto existente de STM32CubeIDE dirigido al Micro **STM32F103C8Tx**. Reemplaza su script del linker y el startup con los correspondientes del micro en el proyecto.
   1. Crea un nuevo proyecto en STM32CubeIDE, ve a **File > New > STM32 Project** 
      <img  src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/openblt/newProject01.png"/>      
   2. Selecciona el MCU.
      - En la pestaña de selección de MCU/MPU, busca y selecciona STM32F103C8T6.
      - Nombra tu proyecto y haz clic en Finalizar.    
      <img  src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/openblt/newProject02.png"/>    
   3. Configura los ajustes de periféricos 
      - Abre el archivo .ioc de tu proyecto.
      - Habilita los siguientes periféricos:
          - Bus CAN
          - USART1
          - RCC: Configura para usar HSE (Fuente de Reloj Externa)     
      <img  src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/openblt/newProject03.png"/>    

   4. Configura el reloj del sistema.
      1. Abre la pestaña de Configuración de Reloj.
      2. Conecta o configura:
        - **PLL Source Mux** a **HSE**
        - **PLLMUL** a **×9**
        - **System Clock Mux** a **PLLCLK**
        - **APB1** Prescaler a **/2**    
      <img  src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/openblt/newProject04.png"/>      

   5. Reemplaza los archivos de inicio en el proyecto OpenBLT
      - Elimina los archivos predeterminados del demo de  OpenBLT:
         ```bash
          cd ~/openBLT_bluepill/Boot
          rm STM32F103RB_FLASH.ld startup_stm32f103xb.s
         ```
      - Copia los archivos de **STM32CubeIDE**:
         ```bash 
          cp ~/STM32CubeIDE/workspace_1.18.1/`YourProjectName`/STM32F103C8TX_FLASH.ld .
          cp ~/STM32CubeIDE/workspace_1.18.1/`YourProjectName`/Core/Startup/startup_stm32f103c8tx.s .
         ```      
   6. Cambia el tamaño de la sección de memoria FLASH en las difiniciones del linker.   
  ```diff       
   /* Memories definition */
   MEMORY 
    {
     RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 20K
   -  FLASH    (rx)    : ORIGIN = 0x8000000,   LENGTH = 64K   
   +  FLASH    (rx)    : ORIGIN = 0x8000000,   LENGTH = 8K 
    }
  ```    
6. Compila el proyecto. 
   - Modifica el archivo Makefile    
   Actualiza el Makefile para usar tu ARM toolchain instalada y para referenciar los archivos de enlace y de inicio correctos:    
     ```diff
     #TOOL_PATH=C:/PROGRA~2/GNUTOO~1/82018-~1/bin/
     -TOOL_PATH=
     +TOOL_PATH=~/arm-tools/gcc-arm-none-eabi-10.3-2021.10/bin/      
     STDFLAGS    = -mcpu=cortex-m3 -mthumb -std=gnu11 -fstack-usage -Wall -specs=nano.specs
     STDFLAGS   += -fdata-sections -ffunction-sections -Wall -g -Wno-strict-aliasing  
     -OPTFLAGS    = -Os
     +OPTFLAGS    = -Os -flto 
     DEPFLAGS  = -MT $@ -MMD -MP -MF $(OBJ_PATH)/$*.d
     CFLAGS      = $(STDFLAGS) $(OPTFLAGS)
     CFLAGS     += -DUSE_FULL_LL_DRIVER -DUSE_HAL_DRIVER -DSTM32F103xB
     CFLAGS     += -D__weak="__attribute__((weak))" -D__packed="__attribute__((__packed__))"
     CFLAGS     += $(INC_PATH)
     AFLAGS      = $(CFLAGS)
     LFLAGS      = $(STDFLAGS) $(OPTFLAGS)
     -LFLAGS     += -T"STM32F103RB_FLASH.ld" -Wl,-Map=$(BIN_PATH)/$(PROJ_NAME).map
     +LFLAGS     += -T"STM32F103C8TX_FLASH.ld" -Wl,-Map=$(BIN_PATH)/$(PROJ_NAME).map
     LFLAGS     += -Wl,--gc-sections $(LIB_PATH)
     OFLAGS      = -O srec
     ODFLAGS     = -x
     SZFLAGS     = -B -d
     RMFLAGS     = -f
     ...
     #| Make ALL                                                                             |
     #|--------------------------------------------------------------------------------------|
     +.PHONY: prepare_dirs
     +prepare_dirs: 
     +mkdir -p $(OBJ_PATH)
     +mkdir -p $(BIN_PATH)
      
     .PHONY: all
     -all: $(BIN_PATH)/$(PROJ_NAME).srec
     +all: prepare_dirs $(BIN_PATH)/$(PROJ_NAME).srec 
     
     $(BIN_PATH)/$(PROJ_NAME).srec : $(BIN_PATH)/$(PROJ_NAME).elf
     ...
             @echo +++ Linking [$(notdir $@)]
             @$(LN) $(LFLAGS) -o $@ $(patsubst %.o,$(OBJ_PATH)/%.o,$(^F)) $(LIBS)
     +.PHONY: $(BIN_PATH)/$(PROJ_NAME).bin
     +$(BIN_PATH)/$(PROJ_NAME).bin:
     +      @$(OC)  -O binary $(BIN_PATH)/$(PROJ_NAME).elf $@
     +
     #|--------------------------------------------------------------------------------------|
     #| Compile and assemble                                                                 |     
     ```  
   - Prueba la compilación.    
   Navega a la carpeta del proyecto y compila:
   ```bash 
   cd ~/openBLT_bluepill/Boot/
   make clean all
   ```    
   Si todo está configurado correctamente, el proceso de compilación debería completarse sin errores y generar los binarios del firmware.

7. Ahora estás listo para portar el código fuente.

## Configurar y desplegar OpenBLT en la tarjeta Bluepill

Para habilitar la comunicación a través de las interfaces **UART** y **CAN** con **OpenBLT** en la tarjeta **Bluepill (STM32F103C8T6)**, necesitarás modificar varios archivos fuente en el directorio `Boot/`. Estos cambios configuran cómo el *bootloader* interactúa con el hardware del microcontrolador.

### Consideraciones de hardware
La tarjeta original **NUCLEO-STM32F103RB** usa **USART2** para la comunicación serial, con **USART2 RX** en **Port A3** y **USART2 TX** en **Port A2**. También usa **CAN1** para la comunicación **CAN**, típicamente remapeada a **CAN_RX** en **Port B8** y **CAN_TX** en **Port B9** mediante la función de remapeo alternativo. Además, el **LED** de usuario en la tarjeta **NUCLEO** está conectado a **Port A5**.     
 <img  src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/openblt/schematic-f103c8t6.jpg"/>   
 
#### UART
Para este proyecto, la comunicación UART usará **USART1**, que está mapeada a:
  - **USART1 TX**: Port A9
  - **USART1 RX**: Port A10

Estos pines son estándar en la tarjeta Bluepill para USART1 y son compatibles con el hardware.

#### CAN
Para la comunicación **CAN** en la tarjeta Bluepill Plus, se usa **CAN1**. El mapeo de pines sigue siendo el mismo que en la tarjeta NUCLEO debido al uso de remapeo de funciones alternativas:
  - **CAN1_RX**: Port B8
  - **CAN1_TX**: Port B9
    
#### GPIOs
- El mecanismo de entrada de puerta trasera no se considera en este proyecto, ya que es poco probable que las aplicaciones futuras lo requieran. Por esta razón, el Port C13, que típicamente se usa para la entrada de puerta trasera en OpenBLT, se desactivará en esta configuración.    

- El **LED** de usuario en la tarjeta **Bluepill Plus** está conectado a **Port B2**. Esto difiere de la tarjeta Nucleo original (que usa Port A5), por lo que la configuración del LED en el proyecto OpenBLT debe actualizarse para reflejar este cambio de hardware.

### Conexiones de hardware
La imagen presenta el sistema.    
  <img  src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/openblt/system01.png"/>    
El sistema está compuesto por los siguientes componentes:   
- Tarjeta Bluepill Plus   
  Una versión modificada de la clásica tarjeta Bluepill STM32F103C8T6, equipada con un sitema  de energía más estable.
- Adaptador USB a TTL    
  Basado en el chip PL2303 USB-to-serial, este adaptador proporciona una interfaz UART entre la PC y la tarjeta Bluepill Plus, utilizada para actualizaciones de firmware a través de UART.    
  Conecta los pines GPIO como se especifica en la tabla a continuación:

    | Resource  | GPIO | Board Connector | Device           |  
    |-----------|------|-----------------|------------------|    
    | USART1_TX | PA9  |       A9        | USB to TTL - Rx  |
    | USART1_RX | PA10 |       A10       | USB to TTL - Tx  |  
    |     5V    |  --  |       5V        | USB to TTL - 5V  |
    |    GND    |  --  |       GND       | USB to TTL - GND |

- Transceptor CTJA1051 CAN   
  Un transceptor CAN de alta velocidad que conecta el periférico CAN del STM32 con el bus CAN físico. Maneja la conversión de niveles de señal y la protección del bus.
- CANable v1.0 Nano   
  Un adaptador USB-to-CAN que conecta el sistema a una PC a través de USB. Permite la carga de firmware y la comunicación a través del bus CAN utilizando protocolos como slcan o candlelight firmware.    
  El dispositivo CANable debe conectarse directamente al transceptor TJA1051, que sirve como interfaz entre el microcontrolador y el bus CAN. Esta configuración asegura que los niveles de voltaje y la integridad de la señal sea adecuada para una comunicación CAN confiable.    

   |    CTJA1051     | CANable V1.0 Nano|  
   |-----------------|------------------|
   |      CAN-L      |        CAN-L     |
   |      CAN-H      |        CAN-H     |
   |      5V         |        5V        |
   |      GND        |        GND       |  

El transceptor TJA1051 debe conectarse a los pines GPIO del microcontrolador como se especifica en la tabla a continuación:    

   | Resource  | GPIO | Board Connector | Device           |  
   |-----------|------|-----------------|------------------|    
   | CAN1_RX   | PB8  |       B8        |  CTJA1051 - CRx  |   
   | CAN1_TX   | PB9  |       B9        |  CTJA1051 - CTx  |    
   |     5V    |  --  |       5V        |  CTJA1051 - 5V   |
   |    GND    |  --  |       GND       |  CTJA1051 - GND  |   

### Cambios de software

#### **blt_conf.h** — Header de Configuración del *bootloader*    
Este archivo contiene opciones de compilación que definen el comportamiento de OpenBLT. Debes habilitar las interfaces de comunicación. Para activar UART y CAN, verifica que los puertos estén habilitados en el canal correcto para el caso de Bluepill:    
- UART: Solo cambia el canal a 0 porque el puerto usado será UART1.   
  ```diff
  /** \brief Enable/disable UART transport layer. */
  #define BOOT_COM_RS232_ENABLE            (1) 
  /** \brief Configure the desired communication speed. */
  #define BOOT_COM_RS232_BAUDRATE          (57600) 
  /** \brief Configure number of bytes in the target->host data packet. */ 
  #define BOOT_COM_RS232_TX_MAX_DATA       (129) 
  /** \brief Configure number of bytes in the host->target data packet. */
  #define BOOT_COM_RS232_RX_MAX_DATA       (129) 
  /** \brief Select the desired UART peripheral as a zero based index. */
  -#define BOOT_COM_RS232_CHANNEL_INDEX     (1)
  +#define BOOT_COM_RS232_CHANNEL_INDEX     (0)
  ```
- CAN: Para este ejemplo, CAN no necesita cambios. 
  ```c
  #define BOOT_COM_CAN_ENABLE             (1)
  /** \brief Configure the desired CAN baudrate. */
  #define BOOT_COM_CAN_BAUDRATE           (500000)
  /** \brief Configure CAN message ID target->host. */
  #define BOOT_COM_CAN_TX_MSG_ID          (0x7E1 /*| 0x80000000*/)
  /** \brief Configure number of bytes in the target->host CAN message. */
  #define BOOT_COM_CAN_TX_MAX_DATA        (8)
  /** \brief Configure CAN message ID host->target. */
  #define BOOT_COM_CAN_RX_MSG_ID          (0x667 /*| 0x80000000*/)
  /** \brief Configure number of bytes in the host->target CAN message. */
  #define BOOT_COM_CAN_RX_MAX_DATA        (8)
  /** \brief Select the desired CAN peripheral as a zero based index. */
  #define BOOT_COM_CAN_CHANNEL_INDEX      (0)
  ```     

#### **main.c** 

Este archivo debe actualizarse para configurar el reloj del sistema, los GPIOs y los periféricos requeridos por OpenBLT. Esto incluye:
1. Inicialización del reloj del sistema (coincidiendo con las configuraciones de PLL de STM32CubeIDE).
2. Configuración de GPIO para el LED (Port B2).
3. Inicialización de USART1 para la comunicación UART (TX: PA9, RX: PA10).
4. Inicialización de CAN1 (RX: PB8, TX: PB9 con remapeo necesario).
5. Deshabilitar o eliminar la configuración de GPIO de entrada de puerta trasera (por ejemplo, PC13).  
   **Nota**: La función de puerta trasera en la arquitectura de este proyecto requiere mayor analisis para un futuro uso. Por ahora, se deshabilitará la configuración del pin GPIO correspondiente. Con esto nos ahorramos el tener que deshabilitar la caracteristica por completo.  
    
6. Desinicialización de GPIO.  

```diff
static void SystemClock_Config(void)
{
-  /* Set flash latency. */
-  LL_FLASH_SetLatency(LL_FLASH_LATENCY_2);
-  if (LL_FLASH_GetLatency() != LL_FLASH_LATENCY_2)
-  {
-    /* Error setting flash latency. */
-    ASSERT_RT(BLT_FALSE);
-  }
-
-  /* Enable the HSE clock. */
-  LL_RCC_HSE_EnableBypass();
-  LL_RCC_HSE_Enable();
-  /* Wait till HSE is ready. */
-  while (LL_RCC_HSE_IsReady() != 1)
-  {
-    ;
-  }
-
-  /* Configure and enable the PLL. */
-  LL_RCC_PLL_ConfigDomain_SYS(LL_RCC_PLLSOURCE_HSE_DIV_1, LL_RCC_PLL_MUL_9);
-  LL_RCC_PLL_Enable();
- 
-  /* Wait till PLL is ready. */
-  while (LL_RCC_PLL_IsReady() != 1)
-  {
-    ;
-  }
-  LL_RCC_SetAHBPrescaler(LL_RCC_SYSCLK_DIV_1);
-  LL_RCC_SetAPB1Prescaler(LL_RCC_APB1_DIV_2);
-  LL_RCC_SetAPB2Prescaler(LL_RCC_APB2_DIV_1);
-  LL_RCC_SetSysClkSource(LL_RCC_SYS_CLKSOURCE_PLL);
-  /* Wait till System clock is ready. */

-  while (LL_RCC_GetSysClkSource() != LL_RCC_SYS_CLKSOURCE_STATUS_PLL)
- {
-    ;
-  }
-  /* Update the system clock speed setting. */
-  LL_SetSystemCoreClock(BOOT_CPU_SYSTEM_SPEED_KHZ * 1000u);
+   RCC_OscInitTypeDef RCC_OscInitStruct = {0};
+   RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};
+
+  /** Initializes the CPU, AHB and APB busses clocks 
+  */
+  RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
+  RCC_OscInitStruct.HSEState = RCC_HSE_ON;
+  RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
+  RCC_OscInitStruct.HSIState = RCC_HSI_ON;
+  RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
+  RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
+  RCC_OscInitStruct.PLL.PLLMUL = RCC_PLL_MUL9;
+  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
+  {
+    ;
+  }
+  /** Initializes the CPU, AHB and APB busses clocks 
+  */
+  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
+                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
+  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
+  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
+  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV2;
+  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV1;
+
+  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_2) != HAL_OK)
+  {
+    ;
+  }
} /*** end of SystemClock_Config ***/
... 
#if (BOOT_COM_RS232_ENABLE > 0)
   /* UART clock enable. */
-  LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_USART2);
+  LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_USART1);
#endif 
#if (BOOT_COM_CAN_ENABLE > 0)
/* CAN clock enable. */
   LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_CAN1);
#endif
/* Configure GPIO pin for the LED. */
-  GPIO_InitStruct.Pin = LL_GPIO_PIN_5;
+  GPIO_InitStruct.Pin = LL_GPIO_PIN_2;   //LED conectado a PB2 
   GPIO_InitStruct.Mode = LL_GPIO_MODE_OUTPUT;
   GPIO_InitStruct.Speed = LL_GPIO_SPEED_FREQ_LOW;
   GPIO_InitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
-  LL_GPIO_Init(GPIOA, &GPIO_InitStruct);
-  LL_GPIO_ResetOutputPin(GPIOA, LL_GPIO_PIN_5);
+  LL_GPIO_Init(GPIOB, &GPIO_InitStruct);
+  LL_GPIO_ResetOutputPin(GPIOB, LL_GPIO_PIN_2);
   /* Configure GPIO pin for (optional) backdoor entry input. */
#if (BOOT_BACKDOOR_HOOKS_ENABLE > 0)
    GPIO_InitStruct.Pin = LL_GPIO_PIN_13;
    GPIO_InitStruct.Mode = LL_GPIO_MODE_FLOATING;
    LL_GPIO_Init(GPIOC, &GPIO_InitStruct);
+#endif  
#if (BOOT_COM_RS232_ENABLE > 0)
   /* UART TX and RX GPIO pin configuration. */
- GPIO_InitStruct.Pin = LL_GPIO_PIN_2;
+ GPIO_InitStruct.Pin = LL_GPIO_PIN_9;   //TX: Serial1 PA9
  GPIO_InitStruct.Mode = LL_GPIO_MODE_ALTERNATE;
  GPIO_InitStruct.Speed = LL_GPIO_SPEED_FREQ_HIGH;
  GPIO_InitStruct.OutputType = LL_GPIO_OUTPUT_PUSHPULL;
  LL_GPIO_Init(GPIOA, &GPIO_InitStruct);
- GPIO_InitStruct.Pin = LL_GPIO_PIN_3;
+ GPIO_InitStruct.Pin = LL_GPIO_PIN_10; //RX: Serial1 PA10-
  GPIO_InitStruct.Mode = LL_GPIO_MODE_FLOATING;
  LL_GPIO_Init(GPIOA, &GPIO_InitStruct);
#endif
...
if (BOOT_COM_CAN_ENABLE > 0)
  /* CAN clock disable. */
  LL_APB1_GRP1_DisableClock(LL_APB1_GRP1_PERIPH_CAN1);
#endif
#if (BOOT_COM_RS232_ENABLE > 0)
   /* UART clock disable. */
-  LL_APB1_GRP1_DisableClock(LL_APB1_GRP1_PERIPH_USART2);
+  LL_APB2_GRP1_DisableClock(LL_APB2_GRP1_PERIPH_USART1);
#endif
```

#### led.c
Este archivo gestiona la funcionalidad del LED de usuario para indicar la actividad del *bootloader*. Localiza el código de configuración de GPIO y cámbialo para utilizar el pin adecuado:    
```diff
void LedBlinkTask(void)
{
  static blt_bool ledOn = BLT_FALSE;
  static blt_int32u nextBlinkEvent = 0;

  /* check for blink event */
  if (TimerGet() >= nextBlurEvent)
  {
    /* toggle the LED state */
    if (ledOn == BLT_FALSE)
    {
      ledOn = BLT_TRUE;
-      LL_GPIO_SetOutputPin(GPIOA, LL_GPIO_PIN_5);
+      LL_GPIO_SetOutputPin(GPIOB, LL_GPIO_PIN_2);
    }
    else
    {
      ledOn = BLT_FALSE;
-      LL_GPIO_ResetOutputPin(GPIOA, LL_GPIO_PIN_5);
+      LL_GPIO_ResetOutputPin(GPIOB, LL_GPIO_PIN_2);
    }
    /* schedule the next blink event */
    nextBlinkEvent = TimerGet() + ledBlinkIntervalMs;
  }
} /*** end of LedBlinkTask ***/
...
void LedBlinkExit(void)
{
  /* turn the LED off */
-  LL_GPIO_ResetOutputPin(GPIOA, LL_GPIO_PIN_5);
+  LL_GPIO_ResetOutputPin(GPIOB, LL_GPIO_PIN_2);
} end of LedBlinkExit ***/
```

# Preparando los Demos para la Bluepill Plus
La carpeta `Prog/` contiene un demo que presenta un LED parpadeante. Esta aplicación tiene dos propósitos principales:
- Verificar que el firmware se carga a través de OpenBLT y funciona correctamente.
- Proporcionar un ejemplo funcional que usa el diseño de memoria correcto para la compatibilidad con el *bootloader*.    

Al igual que el proyecto del *bootloader* en la carpeta **Boot/**, varios archivos en la aplicación **Prog/** deben modificarse para coincidir con el hardware de Bluepill Plus y la configuración de memoria utilizada por OpenBLT.

## Archivos a Modificar
### **Makefile**     
Actualiza la ruta de la cadena de herramientas y las banderas de optimización en el Makefile para que coincidan con las usadas en el *bootloader*. Esto asegura la compatibilidad y el uso correcto del Toolchain de ARM instalado.    

```diff
-TOOL_PATH =
+TOOL_PATH = ~/arm-tools/gcc-arm-none-eabi-10.3-2021.10/bin/

-OPTFLAGS = -Os
+OPTFLAGS = -Os -flto
```

Además, actualiza el script del linker para usar uno alineado con la reserva de memoria del *bootloader* (por ejemplo, omitiendo los primeros 16 KB de flash para OpenBLT):
```diff
-LFLAGS     += -T"STM32F103RB_FLASH.ld" -Wl,-Map=$(BIN_PATH)/$(PROJ_NAME).map
+LFLAGS     += -T"STM32F103C8TX_FLASH.ld" -Wl,-Map=$(BIN_PATH)/$(PROJ_NAME).map
```

### Linker File    
Debes usar un script del linker  para la aplicación, para asegurar que el firmware comience después del *bootloader*. Por ejemplo, si el *bootloader* ocupa los primeros 0x2000 (8KB) de flash:
```diff
/* Memories definition */
MEMORY
{
  RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 20K
-  FLASH    (rx)    : ORIGIN = 0x8000000,   LENGTH = 64K  
+  FLASH    (rx)    : ORIGIN = 0x8002000,   LENGTH = 64K-8K
} 
```

### Startup File    
Para el proyecto de la aplicación en `Prog/`, necesitas reservar espacio para la checksumen el archivo de inicio. OpenBLT usa esta checksum de 32 bits para verificar la integridad del firmware de la aplicación durante el proceso de arranque.    

```diff
.word RTC_Alarm_IRQHandler
.word USBWakeUp_IRQHandler
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word 0
.word BootRAM          /* @0x108. This is for boot in RAM mode for
                            STM32F10x Medium Density devices. */
+ .word     0x55AA11EE   /* Reserved for OpenBLT checksum*/                             

/******************************************************************************
```

### **main.c**    
Modifica la configuración de GPIO y periféricos en main.c para que coincida con el diseño de hardware de Bluepill Plus. 

```diff
/* initializes the CPU, AHB and APB busses clocks */
RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
RCC_OscInitStruct.HSEState = RCC_HSE_ON;
RCC_OscInitStruct.HSEPredivValue = RCC_HSE_PREDIV_DIV1;
RCC_OscInitStruct.HSIState = RCC_HSI_ON;
...
#if (BOOT_COM_RS232_ENABLE > 0)
/* Peripheral clock enable. */
-__HAL_RCC_USART2_CLK_ENABLE();
+__HAL_RCC_USART1_CLK_ENABLE();
#endif /* BOOT_COM_RS232_ENABLE > 0 */   
...
/* Configure the LED GPIO pin. */
-GPIO_InitStruct.Pin = GPIO_PIN_5;
+GPIO_InitStruct.Pin = GPIO_PIN_2;
GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
GPIO_InitStruct.Pull = GPIO_NOPULL;
GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
-HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);
+HAL_GPIO_Init(GPIOB, &GPIO_InitStruct);
-HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_RESET);     
+HAL_GPIO_WritePin(GPIOB, GPIO_PIN_2, GPIO_PIN_RESET);  

#if (BOOT_COM_RS232_ENABLE > 0)
/* UART TX and RX GPIO pin configuration. */
-GPIO_InitStruct.Pin = GPIO_PIN_2;
+GPIO_InitStruct.Pin = GPIO_PIN_9;
GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
HAL_GPIO_Init(GPIOA, &GPIO_InitStruct);
-GPIO_InitStruct.Pin = GPIO_PIN_3;
+GPIO_InitStruct.Pin = GPIO_PIN_10;
GPIO_InitStruct.Mode = GPIO_MODE_INPUT; 
...
#if (BOOT_COM_RS232_ENABLE > 0)
  /* Reset UART GPIO pin configuration. */
-  HAL_GPIO_DeInit(GPIOA, GPIO_PIN_2|GPIO_PIN_3);
+  HAL_GPIO_DeInit(GPIOA, GPIO_PIN_9|GPIO_PIN_10);
#endif /* BOOT_COM_RS232_ENABLE > 0 */
  /* Deconfigure GPIO pin for the LED. */
-  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_RESET);
+  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_2, GPIO_PIN_RESET);
-  HAL_GPIO_DeInit(GPIOA, GPIO_PIN_5);
+  HAL_GPIO_DeInit(GPIOB, GPIO_PIN_2);

#if (BOOT_COM_CAN_ENABLE > 0)
  /* Peripheral clock enable. */
  __HAL_RCC_CAN1_CLK_DISABLE();
#endif /* BOOT_COM_CAN_ENABLE > 0 */
#if (BOOT_COM_RS232_ENABLE > 0)
  /* Peripheral clock disable. */
-  __HAL_RCC_USART2_CLK_DISABLE();
+  __HAL_RCC_USART1_CLK_DISABLE();
#endif /* BOOT_COM_RS232_ENABLE > 0 */
```

### **led.c**  
Modifica el GPIO al Port B2.    
```diff
  /* Note that the initialization of the LED GPIO pin is done in HAL_MspInit(). All that
  * is left to do here is to make sure the LED is turned off after initialization.
  */
  -  HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_RESET);
  +  HAL_GPIO_WritePin(GPIOB, GPIO_PIN_2, GPIO_PIN_RESET);
  } /*** end of LedInit ***/
  ...
    {
      led_toggle_state = 1;
      /* turn the LED on */
-    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_SET);
+    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_2, GPIO_PIN_SET);
  }
  else
  {
    led_toggle_state = 0;
    /* turn the LED off */
-    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, GPIO_PIN_RESET);
+    HAL_GPIO_WritePin(GPIOB, GPIO_PIN_2, GPIO_PIN_RESET);
}
```  

# Compilar el *bootloader* y la Aplicación
Ahora que se han realizado las modificaciones necesarias, puedes proceder a construir tanto el *bootloader* como el Demo.   
1. Compilar el *bootloader*    
Navega al directorio Boot/ y ejecuta: 
    ```bash 
    cd ~/openBLT_bluepill/Boot/
    make clean all    
    ```
   Esto debería compilar el código del *bootloader* y generar el archivo binario o .srec necesario (por ejemplo, BootDemo.srec) para flashear.    
   **Si la compilación se completa con éxito**, encontrarás el binario del *bootloader* dentro del directorio Bin/.

1. Compilar el demo   
Navega al directorio Prog/ y ejecuta:
    ```bash
    cd ~/openBLT_bluepill/Prog/
    make clean all
    ```
¡Todo listo con el firmware para flashear la  tarjeta Bluepill Plus!

**Nota:** Los pasos siguientes, incluyendo instrucciones detalladas para usar el *bootloader*, realizar actualizaciones de firmware y trabajar con MicroBoot, están completamente explicados en la documentación del proyecto disponible en mi respositorio: [razielgdn GitHub ](https://github.com/razielgdn/black-and-blue-pill-plus-with-openBLT).

# Flashear el *bootloader* y la Aplicación       
Una vez que tanto el *bootloader* como la aplicación se hayan construido con éxito, puedes flashearlos en la tarjeta Bluepill Plus usando tu programador preferido (por ejemplo, ST-Link, J-Link o un adaptador USB-to-serial con una herramienta DFU). Sigue estos pasos:    
   - Paso 1: Flashear el *bootloader*.
    Usa tu herramienta de programador para flashear el binario del *bootloader* generado (`Boot/Bin/openblt_stm32f103.elf` o **openblt_stm32f103.srec**) en el dispositivo. Asegúrate de que se escriba comenzando en la dirección 0x08000000. 

   - Paso 2: Reiniciar la tarjeta    
    Después de flashear, reinicia o apaga y enciende la tarjeta. El *bootloader* se ejecutará primero y esperará una imagen de firmware válida a través de UART o CAN (dependiendo de tu configuración).    

## Cargar la Aplicación a través de OpenBLT   
Para cargar la aplicación compilada (Prog/bin/demoprog_stm32f103.srec) en la tarjeta Bluepill Plus, usa la utilidad de línea de comandos BootCommander.    
Asegúrate de que la interfaz y la configuración de velocidad de baudios en MicroBoot coincidan con las de la tarjeta y la configuración del *bootloader*. Puedes seguir el ejemplo de OpenBLT con [STM32F4 Nucleo Board](https://razielgdn.github.io/risingembeddedmx/projects/en/1-openblt/openblt-results). O la documentación en [openBLT to bluepill](https://github.com/razielgdn/black-and-blue-pill-plus-with-openBLT). 

### UART 
Ejecuta BootCommander con parámetros RS232:
```bash
BootCommander/BootCommander -s=xcp -t=xcp_rs232 -d=/dev/ttyUSB0 -b=57600  Prog/bin/demoprog_stm32f103.srec 
```

### CAN
Una vez que el hardware esté correctamente conectado, puedes usar **BootCommander** con **SocketCAN** para flashear la aplicación en el microcontrolador a través del *bootloader* OpenBLT.
  1. Configura la velocidad de baudios como en **blt_conf.h** en el sistema.   
```bash 
sudo ip link set can0 type can bitrate 500000
```      
```bash 
sudo ip link set up can0 
```      
  2. Flashea con BootCommander.   
     - Para flashear la **GPIO demo**:
```bash 
  BootCommander/BootCommander -s=xcp -t=xcp_can -d=can0 -b=500000 Prog/bin/demoprog_stm32f103.srec 
```    

# Próximos Pasos 
## Desarrollar una Aplicación Basada en CAN    
Con el *bootloader* OpenBLT y los demos  ejecutándose con éxito en la tarjeta Bluepill Plus, el próximo paso es desarrollar una aplicación significativa que aproveche la interfaz CAN.

Esto podría incluir:
- Un nodo de sensor que capture ̣̣señales y datos (por ejemplo, temperatura, voltaje o nivel de agua) a través de CAN.
- Un controlador de motor o nodo de actuador que reciba comandos de control a través de CAN y responda en consecuencia.
- Una herramienta de diagnóstico basada en CAN que informe el estado del sistema o códigos de error.
- Un sistema distribuido (por ejemplo, controlador de acuaponía o nodos de automatización del hogar) donde varias tarjetas se comuniquen a través de un bus CAN compartido.    
Aprovechar CAN permite una comunicación robusta y en tiempo real entre dispositivos en entornos embebidos e industriales. Con OpenBLT manejando las actualizaciones de firmware, puedes implementar de manera segura y remota nuevas funciones o parches.

# Repositorio de Código Fuente

El código fuente completo para el *bootloader* y los demos está disponible en el repositorio de GitHub: [https://github.com/razielgdn](https://github.com/razielgdn/black-and-blue-pill-plus-with-openBLT).    

También está disponible un tutorial en video que muestra cómo usar el *bootloader* y flashear las demostraciones en YouTube:    

<div>{%- include extensions/youtube.html id='3xEar9Rzbeg' -%}</div>
