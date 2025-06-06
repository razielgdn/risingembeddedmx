---
title: Preguntas de entrevistas a puestos de sistemas embebidos
permalink: /projects/es/embedded-topics/embedded-questions
key: embedded
---


No se darán respuesta aquí a estas preguntas del todo, por experiencia propia se que esto es mejor investigarlo y comprenderlo que memorizarlo y no saber de que va. Pero más adelante se irán contestando en la etapa de teoría y proyectos. No desesperen amigos, la senda del gran viaje es larga. 

# Preguntas relacionadas al Lenguaje C
- ¿Qué es el keyword **volatile** y donde/ para qué se utiliza?
- ¿Para que se usa la palabra reservada **static**? ¿que pasa si se le pone a una variable? ¿qué pasa si la lleva una función?
- ¿Cuál es el tamaño del dato **int**? (spoiler depende de la **arquitectura**)
- ¿Qué hace el modificador **const**?
- ¿Qué es un apuntador?
- ¿Se puede hacer un apuntador **const**, **volatile**, **static**...?
- ¿Para que se utiliza la palabra reservada **struct**?
- ¿Para que se utiliza la palabra reservada **enum**?
- ¿Para que se utiliza la palabra reservada **union**?
- ¿Cuál es la **diferencia** entre **union** y **struct**? 
- ¿Cómo se llama una función por apuntador?
- ¿Cuáles son las dos formas de pasar parámetros a una función?
- ¿Cuál es el tamaño de un apuntador?
- ¿Si tengo un apuntador a una estructura, cual es la diferencia en tamaño a un apuntador a una función o a una variable?
- ¿De que depende el tamaño de una dirección de memoria? (pista, hay arquitecturas de 8, 16, 32 y hasta 64 bits)
- ¿Cómo se hace un **cast**(enmascarar tipos de dato)?
- Sabes hacer operaciones de bits, dominas el llamado **bitwise**(si no lo haces recomiendo lo investigues). 
- ¿Cómo conviertes rápidamente de decimal a hexadecimal? 
- ¿Cómo conviertes rápidamente de decimal a binario? 
- ¿Que es una variable local? ¿Qué es una variable global? ¿En que se diferencian?
- ¿Para qué se utiliza el modificador **extern**?
- ¿Cuáles son las principales estructuras de datos? (pilas, colas, listas...)
- Conoces las funciones para reservar memoria. ¿Cuáles son?
- Si tengo definido un struct y un union con los mismos componentes, ¿qué me regresará  sizeof en cada una de ellas?
- ¿Cuales son las fases de un **compilador**?
- ¿Qué hace el preprocesador?
- ¿Qué se hace durante el **compilador**/traductor?
- ¿Qué hace el **ensamblador**?
- ¿Qué hace el **linker**?
- ¿Qué es una **macro**?
- ¿Qué es una función **in-line**?
- ¿Cuál es la diferencia entre hacer una rutina por **función** y por **macro**?
- ¿Qué es un **API**?

Como sugerencia, el desarrollador de Sistemas embebidos ya no piensa en un enfoque orientado a  objetos, podría describirse como apegado a la programación estructurada clásica, sin embargo. La definición que en lo personal puedo definir es el control de Hardware por medio de estructuras y algoritmos de Software. El mundo en binario (códificado en hexadecimal) es el pan de cada día para el embedded SW Developer.  

# Preguntas sobre arquitecturas de procesador y memoria
- ¿Qué arquitecturas conoces?
- ¿Cuál es la diferencia entre arquitectura **Hardvard** y **Von Newmann**?
- ¿Qué arquitecturas de procesador has utilizado?
- ¿Qué significa que tengo un microcontrolador/procesador de 32 bits? (referido como maneja la memoria)
- ¿Cuál es la diferencia entre un **ciclo de reloj** y un **ciclo máquina**?
- ¿Que significa que un microcontrolador sea **big endian**?
- ¿Que significa que un procesador sea **little endian**?
- ¿Qué es un **procesador**?
- ¿Qué es un **microcontrolador**?
- ¿Todos los microcontroladores contienen un procesador?
- ¿Qué **módulos** puede tener un microcontrolador?
- ¿Qué es un **DAC**?
- ¿Qué es un **ADC**?
- ¿Qué es la **ALU**?
- ¿Qué es un **timer**/**counter**?
- ¿Qué hace un modulo **PWM**?
- ¿Qué es una **UART**?
- ¿Qué es una fuente de reloj?
- ¿Qué es  un **PLL**, para que se puede usar en un microcontrolador?
- ¿Cómo puedes generar señales de reloj/ osciladores?
- ¿Qué es una **interrupción**?
- ¿Qué es el **pulling**?
- ¿Cómo manejas una interrupción (utilizando lenguaje C)? (spoiler por el ISR usando funciones, para ARM usas el NVIC)
- ¿Que es un watchdog timer? ¿Qué funciones tiene?
- Si yo tengo que hacer un delay, ¿por qué me conviene más implementarlo por medio de una cuenta descendente que por una ascendente?
- ¿Cómo se organiza la memoria de un microcontrolador?
- ¿Qué tipos de memoria existen (de acuerdo con su fabricación)? Flash, eeprom, ram, nand, etc, intenta saber un poco de todas.
- ¿Cuales son las partes de la memoria de un sistema y que se hace en cada una de ellas? Se los dejo en english pero creo que es la forma en que se puede comprender (y muy seguramente su entrevista será en inglés como dijimos más arriba):
- Text segment  (i.e. instructions)
    - **Initialized data segment** 
    - **Uninitialized data segment**  (bss)
    - **Heap** 
    - **Stack**
- ¿Como puedo saber el tamaño de una estructura sin utilizar el operador sizeof? pista, se usan apuntadores y una operación sencilla. En su momento falle al responder.
- ¿Qué es un puerto de entrada- salida/ ¿Qué es el **GPIO**?
- ¿Como se mapea un **GPIO** dentro del microcontrolador (en referencia a lenguaje C)?

# Preguntas relacionadas con Sistema Operativo
- ¿Qué es un **sistema operativo**?
- ¿Qué es un **sistema operativo de tiempo real**?
- ¿Cuál es la diferencia entre sistema monolítico y uno microkernel?
- ¿Qué es un **semáforo**?
- ¿Qué es **mutex**? 
- ¿Qué es **RTOS**?
- ¿Qué es **Embedded Linux**?
- ¿Has utilizado alguna tarjeta de desarrollo que soporte sistema operativo? (Raspberry, beaglebone)
- Utilizando Linux (bash). 
    - ¿Cómo te mueves entre directorios?
    - ¿Cómo obtienes la fecha?
    - Describir algún algoritmo para hacer respaldos. 

# Preguntas acerca de protocolos de comunicación:
- ¿Qué es un protocolo de comunicación **síncrono**?
- ¿Qué es un protocolo de comunicación **asíncrono**?
- ¿Cómo se realiza una **comunicación serial**?
- Explica brevemente como funciona el protocolo **I2C**
- Explica brevemente como funciona el protocolo **SPI**
- ¿Conoces el protocolo **CAN**?
- ¿Conoces el protocolo **LIN**?
- ¿Qué significa que un protocolo sea **Full-Duplex** ó **Half-Duplex**?
- ¿En qué aplicaciones se recomienda utilizar SPI y en cuales I2C?
- ¿Cómo se manejan los errores de comunicación en un protocolo?
- ¿Qué es el bit de inicio?
- ¿Qué es un **checksum**?
- ¿Qué es un **frame**?
- Explica como has usado protocolos de comunicación en los proyectos

# Soft Skills
 Muchas entrevistas se enfocan en como resuelves problemas desde el punto de vista funcional, tanto en cuestiones técnicas como en **interacción humana** por medio del trabajo en equipo. Esto con preguntas del tipo:
- ¿En una situación donde un miembro del equipo genera conflictos contigo como lo resolverías?
- ¿Cuáles son los problemas que has tenido para organizar un equipo de trabajo?
- ¿Cuál ha sido tu mayor reto al trabajar en un equipo?
- ¿En que proyectos has trabajado? ¿A grandes rasgos que se hace en ellos?
En esta parte **puedes describir proyectos personales, y académicos en el caso que no tengas una experiencia previa de trabajo**. Y si ya has tenido un trabajo anteriormente se vale decir con qué tecnología trabajaste, y mas o menos de que va para no violar las clausulas de exclusividad y temas de esa índole.
- Si te toca hacer un ejercicio técnico en conjunto, intenta explicar tu lógica para resolverlo de la mejor manera, nosotros sabemos que no es muy fácil escribir código y que funcione a la primera, pero si tienes el panorama general bien claro desde el principio y planteas la solución de la mejor manera, la codificación será lo  de menos importancia.

Espero que esta información sea de utilidad para alguien, aquí si se necesita un poco de esfuerzo y mucha suerte, sobre todo para conseguir un primer empleo. Un consejo para mover la estadística a favor es tener un buen perfil en linkedIn y agregar a los headhunters/RRHH de empresas de tecnología así como ingenieros que  ya estén desarrollando. Sin temor, y sin vergüenza. 

Por el momento me despido, intentaré actualizar este post cada que pueda. 

# Fuentes
Les dejo una lista de lugares donde podrán encontrar solución a algunas de estas preguntas, y muchas más para prepararse. 

- [Top 18 Embedded Systems Interview Questions and Answers](https://www.guru99.com/embedded-systems-interview-questions.html)
- [Embedded C Interview Questions](https://www.interviewbit.com/embedded-c-interview-questions/)
- [Embedded C interview questions and answers](https://aticleworld.com/embedded-c-interview-questions-2/)