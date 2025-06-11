---
title: Preguntas de entrevistas a puestos de sistemas embebidos
permalink: /projects/es/embedded-topics/embedded-questions
key: embedded
tags: 
 - questions
 - interview 
 - español   
---


Las respuestas a estas preguntas tal vez no sea la mas completa, por experiencia propia se que esto es mejor investigarlo y comprenderlo que memorizarlo y no saber de que va. Pero más adelante se irán contestando en la etapa de teoría y proyectos. No desesperen amigos, la senda del gran viaje es larga. 

# Preguntas relacionadas al Lenguaje C
- ¿Qué es una **keyword**?
- ¿Qué es el keyword **volatile** y donde/ para qué se utiliza?
- ¿Para que se usa la palabra reservada **static**? ¿que pasa si se le pone a una variable? ¿qué pasa si la lleva una función?
- ¿Cuál es el tamaño del dato **int**? (spoiler depende de la **arquitectura**)
- ¿Para qué se usa la keyword **typedef**?
- ¿Qué hace el modificador **const**?
- ¿Qué es un **apuntador** en **C**?
- ¿Se puede hacer un apuntador **const**, **volatile**, **static**...?
- ¿Qué hace la palabra **static** en una variable **global** y en una **local**?
  static es un espeficador de tipo de almacenamiento, lo que tiene distintos significados dependiendo del contexto. En una función la variable conserva su valor entre cada llamada de la función. Fuera de funciones restringe la visibilidad de la variable al archivo donde se utiliza. 

- 
- ¿Para que se utiliza la palabra reservada **struct**?
- ¿Para que se utiliza la palabra reservada **enum**?
- ¿Para que se utiliza la palabra reservada **union**?
- ¿Cuál es la **diferencia** entre **union** y **struct**? 
  ¿Cuál es el tamaño de un **struct** y de **union**?  
- ¿Cual es el tamaño de un apuntador?    
- ¿Qué es una función?
- ¿Cómo se llama una función por apuntador?
- ¿Cuáles son las dos formas de pasar parámetros a una función?
- ¿Cuál es el tamaño de los tipos de variable: int, char, float, etc.?
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

- ¿Cuales son las fases de un proceso de **compilacion**?
- ¿Que hace el **pre-procesador**?    
- ¿Qué se hace en el **compilador**?
- ¿Qué hace el **ensamblador**?
- ¿Qué hace el **linker**?

 1. Pre-Processing

    Pre-processing is the first step in the compilation process in C performed using the pre-processor tool (A pre-written program invoked by the system during the compilation). All the statements starting with the # symbol in a C program are processed by the pre-processor, and it converts our program file into an intermediate file with no # statements. Under following pre-processing tasks are performed :
    
    i. Comments Removal
    Comments in a C Program are used to give a general idea about a particular statement or part of code actually, comments are the part of code that is removed during the compilation process by the pre-processor as they are not of particular use for the machine. The comments in the below program will be removed from the program when the pre-processing phase completes.

    ii. Macros Expansion
    Macros are some constant values or expressions defined using the #define directives in C Language. A macro call leads to the macro expansion. The pre-processor creates an intermediate file where some pre-written assembly level instructions replace the defined expressions or constants (basically matching tokens). To differentiate between the original instructions and the assembly instructions resulting from the macros expansion, a '+' sign is added to every macros expanded statement.
    
    iii. File inclusion
    File inclusion in C language is the addition of another file containing some pre-written code into our C Program during the pre-processing.

    iv. Conditional Compilation
    The preprocessor replaces all the conditional compilation directives with some pre-defined assembly code and passes a newly expanded file to the compiler.

    Now let's see the below figure that shows how a pre-processor converts our source code file into an intermediate file. Intermediate file has an extension of .i, and it is the expanded form of our C program containing all the content of header files, macros expansion, and conditional compilation.

    2. Compiling

    Compiling phase in C uses an inbuilt compiler software to convert the intermediate (.i) file into an Assembly file (.s) having assembly level instructions (low-level code). To boost the performance of the program C compiler translates the intermediate file to make an assembly file.

    3. Assembling

    Assembly level code (.s file) is converted into a machine-understandable code (in binary/hexadecimal form) using an assembler. Assembler is a pre-written program that translates assembly code into machine code. It takes basic instructions from an assembly code file and converts them into binary/hexadecimal code specific to the machine type known as the object code.

    The file generated has the same name as the assembly file and is known as an object file with an extension of .obj in DOS and .o in UNIX OS.

    4. Linking
    
    Linking is a process of including the library files into our program. Library Files are some predefined files that contain the definition of the functions in the machine language and these files have an extension of .lib. Some unknown statements are written in the object (.o/.obj) file that our operating system can't understand. You can understand this as a book having some words that you don't know, and you will use a dictionary to find the meaning of those words. Similarly, we use Library Files to give meaning to some unknown statements from our object file. The linking process generates an executable file with an extension of .exe in DOS and .out in UNIX OS.


- ¿Qué es una **macro**?
- ¿Qué es una función **in-line**?
- ¿Qué hace el preprocesador?
- ¿Qué es una directiva del preprocesador?
  Es un bloque de estados que son procesados antes de compilar, todas las directivas de preprocesador empiezan con un simbolo '#' (hash). El cual indica que cualquiera de las lineas con un **'#'** sera ejecutada en el preprocesador. 
  Tipos de preprocesado:
  - Macros: En lenguaje C  son piezas de codigo que tienen el mismo nombre por tanto el preprocesador las reemplaza en cada lugar donde aparezcan. 
  - Inclusion de archivos: Estas directivas le dicen al compilador que incluya un codigo fuente al programa '#include' es usada pra incluir los *headers* en un programa escrito en C. Existen dos tipos de archivos que pueden ser incluidos:
    1. Standar Header Files (archivos de cabecera estandares, los *.h). Estos necesitan estar encerrados en brackets **'<'** y **'>'** 
 ```c
#include <stdio.h>
#include <string.h>

```   
    2. Archivos de cabecera creados por el usuario. Estos se referencian con comillas dobles: **"** y **"** ejemplo: 
```c
#include "my_definitions.h"
#include "timers.h"
```
  - Directivas Condicionales de C, este tipo de expresiones ayudan a controlar secciones especificas de código que serán incluidas en el proceso de compilación basadas en condiciones. 
  ```c
    #ifdef macro_name
        // Code to be executed if macro_name is defined
    #ifndef macro_name
        // Code to be executed if macro_name is not defined
    #if constant_expr
        // Code to be executed if constant_expression is true
    #elif another_constant_expr
        // Code to be excuted if another_constant_expression is true
    #else
        // Code to be excuted if none of the above conditions are true
    #endif
  ```
  - ¿Que es una optimización de compilación?
  Un compilador con optimización esta diseñado para generar código que esta optimizado en aspectos que permiten minimizar el tiempo de ejecución, uso de memoria, tamaño de la memoria y consumo de energía. En el caso de GCC tiene varios nivles de optimización:
   - **O0**: Optimizacion minima, Se apaga la optimización, se utiliza para el debug para una vista de la estructura generada por el codigo fuente. 
   - **O1**: Optimizacion restringida, solo se realiza la optimización en funcion de la informacion de debug. 
   - **O2**: Alta optimización. 
   - **O3**: Maxima optimización.

- ¿Cuál es la diferencia entre hacer una rutina por **función** y por **macro**?
- ¿Cuál es el uso de **volatile** y **const**  juntos?
- ¿Cuál es la diferencia entre usar una macro y **const**?
- ¿Qué es el concepto de memoria dinámica?
- ¿Cuáles son las funciones para utilizar memoria dinámica? 
    - malloc(): El nombre proviene de **"memory allocation"** es usado para reservar un bloque grande de memoria.
      Syntax of malloc() in C:
```
ptr = (cast-type*) malloc(byte-size)
For Example:
    ptr = (int*) malloc(100 * sizeof(int));   
```    
    - calloc(): De **"contiguos allocation"**,  es un metodo utilizado para almacenar memoria dinámica en un numero especifico de elementos, con la caracteristica que estan inicializados en 0.
```
 Syntax of calloc() in C
    ptr = (cast-type*)calloc(n, element-size); 
    here, n is the no. of elements and element-size is the size of each element.

    For Example: 

    ptr = (float*) calloc(25, sizeof(float));
    This statement allocates contiguous space in memory for 25 elements each with the size of the float.

```      
    - free(): sirve para liberar emmoria en C, se aplica sobre el apuntador que fue utilizado para llegar al primer elemento de la memoria.
```
 Syntax of free() in C:    
   free(ptr);
```    
    - realloc(): De “re-allocation” es utilizado para cambiar dinámicamente memoria previamente reservado, se utiliza muchas veces cuando la memoria previamente reservada no es suficiente. Su modo de uso es el siguiente:
```
Syntax of realloc() in C

    ptr = realloc(ptr, newSize);
    where ptr is reallocated with new size 'newSize'.
```    
- ¿Qué es una **API**?


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
  Memory Layout of C Programs consist of the following sections:
    1. Text segment:
    A text segment, also known as a code segment or simply as text, is one of the sections of a program in an object file or in memory, which contains executable instructions.

    2. Initialized Data Segment:
    A data segment is a portion of the virtual addres space of program, which contains the global and static variables that are initialized by the programmer.
    
    3. Uninitialized Data Segment:
    Data in this segment is initialized by the compiler to arithmetic 0 before the program starts executing uninitialized data starts at the end of the data segment and contains all global variables and static variables that are initialized to zero or do not have explicit initialization in source code.

    4. Stack:
    The stack segment follows the LIFO (Last In First Out) structure and grows down to the lower address, but it depends on computer architecture. Stack grows in the direction opposite to heap. Stack segment stores the value of local variables and values of parameters passed to a function along with some additional information like the instruction's return address, which is to be executed after a function call.

    5. Heap
    Heap is used for memory which is allocated during the run time (dynamically allocated memory). Heap generally begins at the end of bss segment and, they grow and shrink in the opposite direction of the Stack. Commands like malloc, calloc, free, realloc, etc are used to manage allocations in the heap segment which internally use sbrk and brk system calls to change memory allocation within the heap segment. Heap data segment is shared among modules loading dynamically and all the shared libraries in a process.
- What is memory leaking?
  A memory leak occurs when programmers create a memory in a heap and forget to delete it. The consequence of the memory leak is that it reduces the performance of the computer by reducing the amount of available memory. Eventually, in the worst case, too much of the available memory may become allocated, all or part of the system or device stops working correctly, the application fails, or the system slows down vastly.
    Causes of Memory Leaks in C:
    1. When dynamically allocated memory is not freed up by calling free then it leads to memory leaks. Always make ensure that for every dynamic memory allocation using malloc or calloc, there is a corresponding free call.    
    2. When track of pointers that references to the allocated memory is lost then it may happen that memory is not freed up. Hence keep the track of all pointers and make ensure that memory is freed.    
    3. When the program terminates abruptly and the allocated memory is not freed or if any part of code prevents the call of free then memory leaks may happen.
- What is Stack Overflow and Underflow?
    1. Overflow:
        A stack overflow is a type of buffer overflow error that occurs when a computer program tries to use more memory space in the call stack than has been allocated to that stack. The call stack, also referred to as the stack segment, is a fixed-sized buffer that stores local function variables and return address data during program execution

        Causes:One of the most common causes of a stack overflow is the recursive function, a type of function that repeatedly calls itself in an attempt to carry out specific logic. Each time the function calls itself, it uses up more of the stack memory. If the function runs too many times, it can eat up all the available memory, resulting in a stack overflow.

        When a stack overflow occurs, the excess data can corrupt other variables and address data, effectively changing variable values and overwriting return addresses.
        
        In some cases, this will cause the program to crash

    2. Underflow
    Underflow happens when we try to pop an item from an empty stack.

    This error can also lead to unexpected behaviour or a program crash.

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