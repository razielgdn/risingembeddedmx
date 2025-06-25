---
layout: article
title: I get a 3D printer
permalink: /3dprinting/2024/first-steps
key: 3D-Printing   
date: 2024-05-28 
modify_date: 2024-05-28    
#sidebar:
#  nav: navPrinting   
---
A few days ago, I acquired a 3D printer at a very good discount. After assembling it and running some tests, I learned several things about 3D printers and how to work with them.

## Short history of how I get the printer

While looking for deals on Aliexpress, I noticed that this printer was on an unbeatable offer with a very good discount. Besides, it was in a local warehouse, and I could only say, "take my money, Sir Zonestar."   
 - Aliexpress Zonestar Store where I bought the 3D printer: [Aliexpress Zonestar Store](https://zonestar.aliexpress.com/store/1797783?spm=a2g0o.order_list.order_list_main.57.1e761802VmcYS5){:target="_blank"}   
 - This is Zonestar official store: [Zonestar official store](https://www.zonestar3dshop.com/products/zonestar-z8pm4-pro-4-extruder-4-in-1-out-color-mixing-hotend-large-size-fast-assembly-classic-aluminum-frame-3d-printer-diy-kit){:target="_blank"}   

# Zonestar Z8PM4Pro-MK2
Tips and tricks for myself and others who might find them useful with the Zonestar Z8PM4Pro-MK2 3D printer:
- First of all, you need to calibrate the bed very well. According to a couple of maker pages and YouTube channels, they recommend leveling the printer thoroughly. After doing so, bed leveling is an important step to get good results. In the 3D printer interface, follow these steps from the installation guide to level the bed to the lowest position:
   1. Go to **Prepare > Auto Home > Home** All  
   2. Do **Prepare > Bed leveling > Point 1.** The bed and extruder will move to a defined point.    
   3. Move up the bed to the point where the nozzle almost touches the hotbed. I used a piece of paper to get the ideal distance.
   4. Repeat steps 2 and 3 for the remaining 4 points.
   5. Go to **Prepare > Bed Leveling > Catch Z-Offset** to get the parameter.   
   6. Turn on the auto leveling feature in **Control > Configure > Auto Leveling**.
   7. Finally, calibrate the bed with the auto leveling function: **Prepare > Bed Leveling > Auto Leveling**.
In my personal experience, if the values in the matrix are greater than 0.30, I do the manual leveling with the piece of paper and recalibrate using steps 2 to 4.   
- The original rotary encoder of the hardware interface is very delicate; after two days it became useless. Fortunately, Zonestar includes a replacement module. I will fix the damaged module when the encoders arrive and share the procedure on this blog.   
- Check the recommended temperature, speed, and other parameters to manage your filament. I caused a nozzle jam in my first few days.   
- [Zonestar's official](https://github.com/ZONESTAR3D){:target="_blank"} repositories are available on GitHub. It's advisable to check these repositories for any updates or information related to [Z8P-MK2](https://github.com/ZONESTAR3D/Z8P/tree/main/Z8P-MK2){:target="_blank"} to avoid inconveniences.

## Software to operate the printer
 Looking the documentation of Zonestar I noticed that some open sources software are used to operate the printer, I am a defensor and user of Free/Open Software. Last 16 years I used GNU Linux and I want to keep using it to Design and operate the printer. Mi selected softwares to slice were 
 - PrusaSlicer
 - UltiMaker Cura

I had no problems running PrusaSlicer on Ubuntu 22.04. However, Ultimaker Cura required four hours of research and trial-and-error sessions to get it working. I also documented the process in a [post on 3D printing Zone](https://razielgdn.github.io/risingembeddedmx/3dprinting/runingCura){:target="_blank"}.