---
title: OpenBLT successfully deployed on the Bluepill Plus board!
tags: 
  - STM32F103   
  - ARM Cortex M3
  - blog
  - free software
  - free hardware
---

I’m back at it—programming, writing code, and, well… negotiating time with my girlfriend (she’s not a huge fan of how many hours I spend on this stuff 😅). Anyway, over the past few weeks, I’ve been working on adapting OpenBLT to a Bluepill Plus board.

It wasn’t exactly a walk in the park. I hadn’t touched microcontrollers in over five months, so getting back into the groove took some effort. The bootloader migration itself only took about three or four days to get up and running, but documenting everything? That’s where I really struggled. I felt rusty—and honestly, even remembering how to use Jekyll to write this blog was a small adventure in itself.


After so many hours of programming, testing, and writing, I finally got the bootloader working on my Bluepill Plus board! 🎉

If you’re curious, you can check out the full project on my [Github repo](https://github.com/razielgdn/black-and-blue-pill-plus-with-openBLT).

I also put together a small tutorial on [this site](https://razielgdn.github.io/risingembeddedmx/projects/en/1-openblt/openblt-bluepill), where I walk through the steps I followed to migrate the bootloader.

The goal behind this is to lay the foundation for flashing software via CAN in a network of microcontrollers—managing sensors, actuators, motors, or whatever your project needs. All with low-cost boards and free tools.
I believe that freedom shouldn't only apply to software, but to hardware too.

Because everyone should have access to technology—especially in the kind of solarpunk future where innovation works with nature, not against it.