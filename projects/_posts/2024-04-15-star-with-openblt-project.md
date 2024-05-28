---
title: Openblt to STM Nucleo-64
key: blog-01
tags:
- projects
#- blog
#- stm32F
#- Nucleo-64
---
### April-15-24
# Starting the Implementation of OpenBlt Project   
I am beginning work on implementing the OpenBLT project on a Nucleo 64 platform with an **STM32-F446RE** microcontroller. 

In my previous job, I implemented this project for a **STM34H53** platform. At that time, I didn't have enough time to fully understand how the software works. I modified the sources to work with CAN bus for a demo, and then another task was assigned to me. However, I believe that OpenBLT has more potential, and I will need to use it for my projects in the future.

### April-17-24  
## Read Documentation   
I was reading  the [OpenBLT](https://www.feaser.com/en) site and checking the [download](https://www.feaser.com/openblt/doku.php?id=download),  [Developer Blog](https://www.feaser.com/en/blog/), and [wiki](https://www.feaser.com/openblt/doku.php) sections. I noticed that **Nucleo-F446RE** board have a demo with Modbus RTU, I didn’t know what it was, so I researched some information.
Once I learned that Modbus RTU is a serial or Ethernet communication protocol based on master/slave architecture, I will try to set it up or modify it to flash applications with at least CAN. If I have time enough I'll try to run another interface for example RS232 or USB.

# Working with a custom OpenBLT
### May-04-24
Recently, I have been studying the architecture of the **OpenBLT** project, and I noticed that it is simple to understand, although it has a good structure and is very complete in resource administration, such as **CAN** and **RS232**. The first steps to add features will be to enable the functions of USART to use a TTL converter to flash an application.

### May-10-24
I publish in this blog [how to import](https://razielgdn.github.io/risingembeddedmx/projects/en/openblt-start) the project to STM32Cube IDE software, This is a tool provided by STM to use the protocol 

### May-14-24
The project is taking longer than I expected. I understand how the resources work, I configured the system, GPIOs, timers, and it still doesn't work. Nevertheless, I am still trying. I am sure that the problem is a minor issue related to my own lack of knowledge.

### May-17-24
Finally, I managed to enable RS232. I had some trouble with the connection because I accidentally defined ports twice. Also, I was trying to flash using the USB-TTL in a resource that is part of a virtual COM embedded with the STLink port. Oh well, now my focus is on setting up CAN.

### May-20-24
While researching an example of CAN bus functionality for the Nucleo-F446RE, I found [Controllerstech](https://controllerstech.com/can-protocol-in-stm32/) tuturial. It was so useful in helping me understand how to manage resources and enable CAN in my custom OpenBLT project.  

I spent a lot of time on this challenge because the STM HAL CAN driver needed to be integrated into the project. My first obstacle was that **CAN** didn't work. I wrote a test code to run only the configuration and transmission of a loop message to check if the baud rate was correctly enabled, but to my surprise, it did nothing. After a good amount of debugging time with **ST-Link**, I noticed that the functions **HAL_CAN_Init()** and **HAL_CAN_Start** didn't work normally because a timer value was not updated by the **HAL_GetTick()** function.

Upon investigating why this happened, I found that **HAL_GetTick()** was defined in **timer.h** and also in **stm32f4xx_hal.h**. I solved this issue by renaming the function to **HAL_GetTick_openblt** in all files of the OpenBLT layer. 

*In Mexico, May 20 is the **Psychologist Day**, and my girlfriend is a psychologist. I forgot about it while dealing with the issue in the CAN bus.* Sometimes I wish I weren't so obsessive. If someday you read these lines, Honey, forgive me. I swear that I love you. But an engineer lost his ground debugging.

### May-21-24
While taking snapshots for the documentation, I noticed that if the **CAN interface is enable but not connected, the bootloader never starts**. This is because, in the initialization routine, it needs to be connected to a CAN bus. If you encounter this issue and don't want to connect a transceiver, **you can cross the pins CAN_Tx and CAN_Rx** to initialize the bootloader. This trick can help rule out software issues. I hope this saves you some time.

### May-22-24
# Challenge complete!
Finally the system is working and the documentation is done. 
If you come here loking for a solution, Enjoy it!
You can see the process here: [OpenBLT in Nucleo-F446RE](https://razielgdn.github.io/risingembeddedmx/projects/en/open-blt).
