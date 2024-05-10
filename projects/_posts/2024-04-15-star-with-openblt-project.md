---
title: Openblt to STM Nucleo-64
key: blog-01
tags:
- projects
#- blog
#- stm32F
#- Nucleo-64
---

## Starting the Implementation of OpenBlt Project

Today, I am beginning work on implementing the OpenBlt project. In my previous job, I implemented this project for an **STM34H53** platform. However, I will now port the project to a Nucleo 64 platform with an **STM32F446** microcontroller. 


### First update
I was reading  the [OpenBLT](https://www.feaser.com/en) site and checking the [download](https://www.feaser.com/openblt/doku.php?id=download),  [Developer Blog](https://www.feaser.com/en/blog/), and [wiki](https://www.feaser.com/openblt/doku.php) sections. I noticed that Nucleo F446 board have a demo with Modbus RTU, I didn’t know what it was, so I researched some information.
Once I learned that Modbus RTU is a serial or Ethernet communication protocol based on master/slave architecture, I will try to set it up or modify it to flash applications with at least CAN. If I have time enough I'll try to run another interface for example RS232 or USB


{% comment %}
<!--
    Estoy pensando ver como chingados modificar el software para que CAN funcione, primero se va a probar con ModBus, luego con CAN
    y ver si se puede extender a los siguientes modulos 
    Modbus - ya jala
    CAN - vamos a hecharlo a andar
    Serial port- checar si puede funcionar 
    I2C - baja prioridad, pero que jale
    SPI - baja prioridad
--> 
{% endcomment %}
