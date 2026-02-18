---
layout: article
title: Octavio Raziel Güendulain Pérez
permalink: /about/about-en
aside:
   toc: true
modify_date: 2024-07-14
lang: en
---
{% comment %}
<!--
    07-13-2025 -> Update abstract to get more impact
    07-05-2025 -> Grammar check and date corrections.
    05-29-2024 -> Update style and add TI part.
    05-28-2024 -> Update About-en.md fixing errors and changing HTML tables to lists.
    05-27-2024 -> First update of this document.
-->
{% endcomment %}

## Sumary

**Electronic Engineer** with embedded software development experience since 2019, including 4 years specializing in the automotive industry. Demonstrated expertise in communication protocols (CAN, LIN, I2C, SPI) and UDS implementation, with comprehensive knowledge of microcontroller and microprocessor architectures including Cortex-A, Cortex-M, and AVR platforms.  
**Technical Proficiency:** Proficient in C programming across multiple MCU families (TI, STM, NXP/Freescale, and Microchip). Skilled in embedded debugging using JTAG interfaces with J-Link, GDB, WinIDEA, and ST-Link tools. Experienced in software version control and integration using Git, GitHub, and IBM IMS, managing team integration workflows and product releases.   
**Leadership & Development:** Proven track record in onboarding and mentoring new team members while managing task assignments, effort estimation, and project timelines. Adept at following SCRUM methodology for embedded software development with project management through Jira.

# Embedded Systems Experience

## Dextra Technologies, a Deloitte Business
*February – March 2024*, **Software Engineer II**   
Worked on two main projects: Automotive Brake Control ECU development and STM32H735 demo platform development. Collaborated with cross-functional teams to address technical challenges and meet project deadlines effectively.   

- **STM32H735G Development Kit project**:    
Implemented OpenBLT bootloader project on STM32H735G platform. The platform required a method to flash binaries from a Raspberry Pi to the STM32H5 microcontroller using CAN, I2C, and UART communication buses.    
To handle this situation, migrated the OpenBLT project from the Nucleo-H563ZI demo to the STM32H53 platform by reconfiguring GPIO, CAN, SPI, and UART interfaces and updating the corresponding STM32 HAL drivers. Git and GitHub were used to manage software version control and track changes.   

- **Brake Control ECU Project**:  
  Automotive Brake Control ECU Project: Developed software for automotive customer focusing on optimizing functionality and ensuring compliance with industry standards. 
  - Database Integration: Integrated a new database into the project to add messages and signals to the system, specifically implementing two new Diagnostic Trouble Codes (**DTCs**) and message gateways. Utilized **Tresos** to import the database and generate system resources including headers and auto-generated C files. Developed the fault control driver in **C language** following **MISRA compliance** standards, implemented failure signal transmission and gateway functionality, conducted unit testing using **SWATT**, and performed integration testing with **CANoe** and **WinIDEA**.
  - Issue Investigation: Utilized debug tools to analyze **CAN Bus** log files with CANoe to replicate issues reported by the testing department. Identified **root causes** and generated tickets with detailed analysis and proposed solutions.  
  - Implemented issue solutions according to management dashboard priorities.
  - Utilized **Jira** for project management and issue tracking.
  - Used **DOORS** for requirements management and integration test documentation.     

Utilized the following tools and technologies:  
- **Languages**: C/C++, Python, Bash.  
- **Platforms and Tools**: STM32CubeIDE, Raspbian, Git, GitHub, Jira.
- **Protocols and Hardware**: CAN, JTAG, STM32H5, STM SPC560Bx MCU. 
- **Documentation**: Markdown. DOORS

## Dextra Technologies
*December 2020 – January 2022*, **Embedded Software Developer Jr**  
- **BCM (Body Control Module)**:       
Project for Lights and Communications ECU, providing comprehensive customer support through requirements analysis and issue resolution to identify optimal implementation approaches for new features and solutions.
- **Requirements Analysis:** Conducted requirements analysis and verified the availability of all hardware components (including GPIOs, timers, CAN ports, sensors, and transceivers), software resources (e.g., Customer Model, APIs, data structures, reserved memory), resources in the DBCs (CAN databases) and LDFs (LIN Description Files) and definitions of Diagnostics trouble codes (DTCs) and Data Identifiers (DIDs) following the UDS protocol. Documented the analysis and defined priority levels and effort estimation.
- **Software Implementations**: Implementations were performed in the project using C language and some vector tools, common task included:
  - Updated CAN Messages and signals in the project using vector Geny to manage the databases (DBC, LDF) and the auto-generated code as headers and automatic gateways. 
  - Developed the logic and implemented code modifications to meet customer requirements following MISRA compliance standards and created unit tests using the SWATT tool. Employed CANdela to add new DTCs and DIDs with their associated services (read, write, diagnostic, etc).
- **Designed integration tests** to ensure software functionality. The tests were performed on customer-provided hardware (test benches) to simulate the vehicle system using CANoe and WinIDEA tools. Additionally, utilized CAPL to automate certain test routines.
- **Issues Resolution:** When an issue was reported by test team or the customer I participated in the analysis of the Issue reproducing the fault/erroneous behavior in the test benches to found the root causes. Using debugging tools (CANoe and WinIDEA) and  and generated reports with proposed solutions.
- **Software Integration:** Managed software integration from team members and coordinated releases using IMS version control system, later transitioning to Git for team integration workflows and product releases.
- **Team Management:** Participated in onboarding and training new team members, including administrative responsibilities such as ticket assignment, effort estimation, and project timeline management.
  
Utilized the following tools and technologies:  
- **Languages**: *C*, *CAPL*.  
- **Platforms and Tools**: *Tresos*, *DOORS*, *Jira*, *Git*, *GitHub*, *WinIdea* (JTAG debugger), *CANoe*, *CANdela*.  
- **Hardware**: STM SPC560B MCU, Freescale MCP5606 MCU, oscilloscope, electronic load. 
  
## CODE Ingeniería
*May 2019 – May 2020*, **Programador Embebido**.     
Research and development of embedded systems, focused on Linux and Android environments. 
Worked with NXP devices including **i.MX8** and **i.MX6** SoCs, utilizing Yocto Project and Android sources to set up and configure embedded systems for diverse applications and customers.

- Role Activities
  - Configured and adapted display and touchpad drivers for Sabre SD board-based hardware.  
  - Calibrated RAM and Flash memory for an i.MX6-based device.  
  - Supported a customer in configuring and optimizing the NXP eCockpit system.  
  - Researched and supported customers in using the System Controller Firmware (SCFW) on NXP i.MX8QM and i.MX8QX development boards.  
- Configured embedded systems for diverse applications using Yocto Project and Android sources.  
- Utilized the following tools and technologies:  
  - **Languages**: C/C++, Bash. 
  - **Platforms and Tools**: Yocto Project, Linux, VirtualBox, Segger J-Link debugger. 
  - **Hardware**: i.MX8, i.MX7, i.MX6 development boards, multimeter, digital analyzer, oscilloscope. 
  
# Experience in IT Support and Maintenance
## Comercializadora de Equipos de Energía Renovables
*December 2018 – April 2019*, Photovoltaic Systems Installer  
- Key responsibilities included:  
  - Conducting technical field studies.  
  - Calculating and balancing electric loads.  
  - Designing solar panel arrangements.  
  - Performing electrical installations (piping, wiring, connections).  
  - Installing photovoltaic panels.

## Autopista Mitla - Tehuantepec
*May 2018 – December 2018*, Electromechanical Technician  
- Key responsibilities included:  
  - Conducting preventive and corrective maintenance on traffic control equipment using ATMEGA microcontrollers.  
  - Performing maintenance on emergency power systems.  
  - Carrying out electrical installations.  
  - Repairing electronic devices.  
  - Installing telecommunications equipment.  
  - Monitoring data servers, video surveillance, and user software systems.

## Industrias OLIN
*May 2017 – April 2018*, Systems Engineer  
- Key responsibilities included:  
  - Repaired and maintained computer equipment and various electronic devices.  
  - Authored and edited a course for programming ATMEL microcontrollers using assembly language and C.  
  - Provided sales and technical consultation on electronic components, primarily modules for Arduino boards.

## LaTeX Editor
*September 2017 – March 2018*, Freelancer on Upwork  
- Edited and digitized academic documents focused on mathematics education using open-source tools such as LaTeX, GeoGebra, and Inkscape.

## Universidad Del Mar, Campus Puerto Escondido
*August 2015 – March 2017*, Computer Network Technician  
- Provided technical support in the area of Networks, with responsibilities including:  
  - Installing operating systems and software.  
  - Installing and maintaining hardware.  
  - Diagnosing and repairing printers, plotters, lighting fixtures, and various electronic devices.  
  - Assisting users on various topics.  
  - Writing manuals and support guides.  
  - Administering Linux and Windows servers for email, cache, databases, IPTables, and performing backups.

# Education
## [Universidad Tecnológica de la Mixteca](https://www.utm.mx/)
Huajuapan de León, Oaxaca - Electronic Engineer (Bachelor's Degree)  
*Aug 2010 – Jul 2015 *     
- CENEVAL high-performance results: [20163002591](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/personalDocuments/ceneval.png).  
- Cédula profesional: [11876075](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/personalDocuments/cedula.png).

## Courses

### From [edX.org](https://courses.edx.org/)
- UT.6.10x: **Embedded Systems - Shape The World: Microcontroller Input/Output**, The University of Texas System  
  Certificate of Achievement: [2cd21b17d58e454baa5489e40c4d088f](https://courses.edx.org/certificates/2cd21b17d58e454baa5489e40c4d088f)

### From [Udemy](https://www.udemy.com/)
- **Autosar Architecture (Learn from Scratch with Demo)**: [UC-abbb789a-ccd3-450d-8dcd-1593e0b17670](https://www.udemy.com/certificate/UC-abbb789a-ccd3-450d-8dcd-1593e0b17670/)  
- **The Complete Git Guide: Understand and Master Git and GitHub**: [UC-b5f6a7cc-720f-4a28-83f9-deab97227dbf](https://www.udemy.com/certificate/UC-b5f6a7cc-720f-4a28-83f9-deab97227dbf/)  
- **Domina SCRUM con JIRA Agile - Metodologías Ágiles**: [UC-f61ab121-7c1e-437f-88dc-adce85728be5](https://www.udemy.com/certificate/UC-f61ab121-7c1e-437f-88dc-adce85728be5/)  
- **Yocto Zero to Hero - Building Embedded Linux**: [UC-fc6ee01a-2b07-40d9-a0a5-86b67c4535fa](https://www.udemy.com/certificate/UC-fc6ee01a-2b07-40d9-a0a5-86b67c4535fa/)

# Skills

## Programming Languages
Since 2009, I was working with may languages:  
- **C/C++**: 4 years professionally.  
- **Python**: 1 year with personal projects and modifying scripts (e.g., python-can).  
- **Bash**: 3 years automating routines in Linux for technician roles and configuring embedded Linux systems.  
- **Java**: 2 years as a student, creating simple applications for personal projects.  
- **LaTeX**: 5 years for student and personal documentation, and 1 year professionally as a part-time freelancer.  
- **Markdown**: 2 years, used for this site and documenting GitHub projects.

## Automotive Tools
- **Autosar**: 1 year adding ports, managing CAN databases (messages and signals), Diagnostic Trouble Codes (DTCs), and gateways.  
- **Vector Tools**:  
  - **CAN-DB** and **LDF** management: 3 years.  
  - **Geny**: 3 years.  
  - **CANoe**: 3 years.  
  - **CANdela**: 4 years.  
- **Tresos**: 1 year.  
- **Unit Testing** (using SWATT): 3 years.  
- **MISRA**: 4 years.  
- **UDS Diagnostic Services**: 4 years.

## Linux, Distributions, and Tools
- **Linux Distributions**:  
  - **Ubuntu**: 11 years as a user.  
  - **Fedora**: 13 years as a user.  
  - **Mint**: 3 years.  
  - **Debian**: 3 years.  
  - **Raspberry Pi OS/Raspbian**: 1 year.  
- **Linux-Related Software**:  
  - **Docker**: 9 months.  
  - Linux terminal: 10+ years.  
  - **Vi**: 5 years.  
  - **Meld**.  
  - **FileZilla**.  
  - **Nano**.  
  - **TeXmaker**, **TeXstudio**.  
- **Yocto Project**:  
  - Constructed systems for NXP, Texas Instruments, and Raspberry Pi devices.

## Debugging Tools
- **J-link**: 1 year, used with NXP devices.  
- **GDB, GNU Debugger**: 3 years, running in Eclipse environments with STM, TI, and Atmel/Microchip IDEs.  
- **WinIdea**: 3 years, to debug ECU devices.

## Version Control and Administrative Tools
- **Git**: 4 years.  
- **Jira**: 3 years.  
- **SVN**: 1 year.  
- **IBM IMS Tool**: 3 years.

## Integrated Development Environments (IDEs)
- **Eclipse** (IDEAS, STMCubeIDE, Code Composer Studio, Microchip Studio).  
- **Visual Studio Code**.  
- **KDevelop**.

## Network & IT Services
- **Hardware**:  
  - Network architecture wiring (RJ45, RJ11).  
  - Router and switch configuration.  
  - Building and maintaining PCs and laptops:  
    - Checking requirements for PC builds (motherboard, RAM, hard disks, graphics cards).  
    - Laptop hardware maintenance and repair.  
  - Printer installation and maintenance.  
- **Software**:  
  - **Wireshark**.  
  - Mounted **Asterisk** servers.  
  - Secure Shell Protocol (**SSH**).  
  - Mounted **SFTP** servers and clients.  
  - Mounted HTTP servers with **Apache**.  
  - **Jekyll** (used to develop this blog).

## Mechanical and Electrical Tools
- **Electronic/Lab Tools**: Soldering iron, Dremel, microscopes, oscilloscopes, logic analyzers, power sources, electronic loads.  
- **Electric Tools**: Hammer drill, jigsaw, vacuum cleaner, grinder.  
- **Mechanical Tools**: Hammer, screwdrivers, pliers, wrenches, crowbars, machetes, axes, chainsaw, and others.

## Personal Interests

**Technology Enthusiast** with a passion for open-source software and free tools. Self-taught learner who actively explores technologies beyond job requirements, including:
- **Open Source Experience:** GNU/Linux user since 2008, developing personal projects documented in this technical blog posts and repositories.
- **Additional Technical Skills:** Python programming, Docker containerization, 3D printing, and currently expanding expertise in Rust programming, RTOS development, KiCad PCB design, Jekyll static site generation, and Yocto Project for Raspberry Pi and  embedded systems.
- **Continuous Learning:** Committed to staying current with emerging technologies through hands-on experimentation and personal project development, demonstrating adaptability and technical curiosity beyond traditional embedded systems work.
