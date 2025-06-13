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
1. ¿Qué es una **keyword**?
  Una keyword (palabra clave o palabra reservada) **es una palabra que tiene un significado especial predefinido en el lenguaje de programación C** y no puede ser utilizada como identificador (nombre de variable, función, etc.). Estas palabras están reservadas por el compilador para realizar funciones específicas del lenguaje.
  Ejemplos de keywords en C:
  - Tipos de datos: **int**, **char**, **float**, **double**, **void**
  - Modificadores: **static**, **const**, **volatile**, **extern**
  - Control de flujo: **if**, **else**, **for**, **while**, **switch**, **case**
  - Otros: **struct**, **union**, **enum**, **typedef**, **sizeof**

2. ¿Qué es el keyword **volatile** y donde/ para qué se utiliza?   

  La palabra clave **volatile** en C indica al compilador que el valor de una variable puede cambiar de forma inesperada, evitando optimizaciones que asumen que el valor es estable. Se usa en sistemas embebidos para variables accedidas por hardware, interrupciones o múltiples hilos. Por ejemplo, una variable mapeada a un registro de hardware (como el registro de estado UART en STM32) se declara `volatile` para garantizar que el compilador lea su valor cada vez en lugar de almacenarlo en caché. Uso: `volatile uint32_t *reg = (uint32_t *)0x40021000;`.

3. ¿Para que se usa la palabra reservada **static**? ¿que pasa si se le pone a una variable? ¿qué pasa si la lleva una función?
  La palabra reservada **static** en C define la duración de almacenamiento y el enlace.  
    - **Variable**: Una variable `static` conserva su valor entre llamadas a funciones (ámbito local) o restringe su visibilidad al archivo (ámbito global). Una variable local `static` se inicializa una vez y persiste durante la vida del programa. Una variable global `static` solo es visible dentro del archivo. Ejemplo: `static int counter = 0;` en una función mantiene su valor entre llamadas.  
    - **Función**: Una función `static` solo es visible dentro del archivo, evitando el enlace externo. Esto es útil para funciones auxiliares en proyectos embebidos, como en mi firmware para AVR. Ejemplo: `static void update_led(void);`.

4. ¿Cuál es el tamaño del dato **int**? (spoiler depende de la **arquitectura**)
  El tamaño de un `int` en C depende de la arquitectura y el compilador. Típicamente:  
  - Microcontroladores de 8 bits (e.g., AVR): `int` es de 16 bits (2 bytes).  
  - Microcontroladores de 32 bits (e.g., STM32): `int` es de 32 bits (4 bytes).  
  - Sistemas de 16 o 64 bits: `int` puede variar (2 o 4 bytes).  
5. ¿Para qué se usa la keyword **typedef**?
   La palabra clave **typedef** en C crea un alias para un tipo de dato existente, mejorando la legibilidad y portabilidad del código. Se usa comúnmente para simplificar tipos complejos, como estructuras o apuntadores. Por ejemplo:
```c
 typedef struct { 
    uint32_t id; 
    uint8_t status; 
 } Device_t;
```  
  Facilita declarar variables como `Device_t sensor;`.
  Otro ejemplo seria: `typedef big_int_data`

6. ¿Qué hace el modificador **const**?
   El modificador **const** en C indica que el valor de una variable no puede modificarse después de su inicialización. Se usa para garantizar la integridad de los datos, especialmente para constantes o datos de solo lectura. Por ejemplo, `const int MAX_VALUE = 100;` evita cambios en `MAX_VALUE`. En sistemas embebidos, uso `const` para tablas de consulta o datos de configuración almacenados en memoria flash para evitar escrituras accidentales.

7. ¿Qué es un **apuntador** en **C**?
   Un apuntador en C es una variable que almacena la dirección de memoria de otra variable. Permite el acceso y manipulación directa de la memoria, esencial en sistemas embebidos para acceder a registros de hardware o memoria dinámica. Por ejemplo, en mis proyectos con STM32, uso apuntadores como     
```c
uint32_t *reg = (uint32_t *)0x40021000;
``` 
   para acceder a registros de periféricos.

8. ¿Se puede hacer un apuntador **const**, **volatile**, **static**...?
   Sí, un apuntador puede modificarse con `const`, `volatile` o `static`:  
   - **const**: Un apuntador `const` puede evitar la modificación del apuntador (`int *const ptr`) o de los datos a los que apunta (`const int *ptr`).  
   - **volatile**: Un apuntador `volatile` asegura que el compilador no optimice el acceso a los datos apuntados, útil para registros de hardware (e.g., `volatile int *reg`).  
   - **static**: Un apuntador `static` tiene almacenamiento persistente (local) o alcance de archivo (global).  
  Ejemplo: En mis proyectos con AVR, uso `volatile const uint8_t *status_reg` para registros de hardware de solo lectura accedidos por interrupciones.

9. ¿Qué hace la palabra **static** en una variable **global** y en una **local**?

 
10. ¿Para que se utiliza la palabra reservada **struct**?
11. ¿Para que se utiliza la palabra reservada **enum**?
12. ¿Para que se utiliza la palabra reservada **union**?
13. ¿Cuál es la **diferencia** entre **union** y **struct**? 
14.  ¿Cuál es el tamaño de un **struct** y de **union**?  
15. ¿Cual es el tamaño de un apuntador?    
16. ¿Qué es una función?
17. ¿Cómo se llama una función por apuntador?
ejemplo:
```c 
#include <stdio.h>
typedef unsigned char byte;
typedef int (*operation)(byte, byte);

int add(byte a, byte b) { return a + b; }
int multiply(byte a, byte b) { return a * b; }

int main() {
    byte x = 5, y = 3;
    operation op = add;
    printf("Add: %d\n", op(x, y)); // Output: Add: 8
    op = multiply;
    printf("Multiply: %d\n", op(x, y)); // Output: Multiply: 15
    return 0;
}

```
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

 1. Pre-procesado
    El preprocesado es el primer paso en una compilación, en Lenguaje C es realizado por la herramienta del pre-procesador (un programa preescrito, invocado por el sistema durante la compilación) todas las sentencias que comienzan con el simbolo '#' son procesados y se crea un archivo intermedcio sin estas sentencias, las tares del preprocesado son las siguiente:
    1. Eliminación los comentarios.
       Los comentarios son usados en el codigo para dar una idea particulas acerca de las sentencias en la parte del código particular o de una seccion completa. Los comentarios se eliminan por el preprocesador porque no son de uso para la máquina. 
    2. Expansión de Macros.
       Las macros son algunos valores constatnes o expresiones definidas usando las directivas #define en lenguaje C. Una llamada a macro consduce a la expansión de la macro. El preprocesador crea un archivo intermedio donde algunas instrucciones pre-escritas a nivel de ensamblador reemplanan las expresiones constantes definidas.  Para diferenciar entre las instrucciones originales y las de ensamblador resultante de la expansión de macros se añade un signo '+' a cada sentencia expandida de macros.     
    3. Inclusion de archivos.
       La inclusión de archivos en lenguaje C es la adición de otro archivo que contiene código preescrito (los headers  que hacen referencia a otros archivos de C, ya sean estándar o personalizaos).
    4. Compilación condicional
       El preprocesador reeemplaza todas las directivas de compilacion condicional con algún código ensamblador predefinido y pasa un nuevo archivo expandido al compilador. 
    Al finalizar, se genera un archivo intermedio con extención *.i*
2. Compilación:
   La fase de compilación en C utiliza un sofware compilador incorporado para convertir el Archivo intermedio *.i*  en un archivo ensamblador *.s* con instrucciones de nivel ensamblador (código de bajo nivel), en esta fase se hacen las optimizaciones para que el rendimiento del programa aumente. 
3. Ensamblador (mas o menos la traducción de Assembling) 
   El código de nivel ensamblador se conviere en un código comprensible por la máquina en forma 
   de binaria (hexadecimal/binarios) por medio de un ensamblador, que es un programa preescrito que traduce el codigo intermedio a código máquina. El archivo de salida por lo general tiene un formato de salida *'.obj'* en DOS y *'.o'* en UNIX
4. Linking (Enlace)
   'linking' es el proceso de incluir los archivos de las bibliotecas en el programa, los archivos de biblioteca son archivos predefinidos que contienen la definición de las funciones en el lenguaje de máquina y estos archivos tienen una extención *.lib*, algunas sentencias desconocidas estan escritas en el archivo objeto (.o, .obj) que el sistema operativo no puede entender y se utilizara un diccionario para encontrar el significado de esas palabras. Del mismo modo, utilizamos archivos de biblioteca para dar significado a algunas declaraciones desconocidas de nuestro archivo objeto. Al terminar el proceso de enlazado, se genera un archivo ejecutable, *.exe* en DOS, *.bin*, *.elf*, *.hex* cuando se trata de firmware.

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