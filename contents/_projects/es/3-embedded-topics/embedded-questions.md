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
   - **Variable local `static`**: Conserva su valor entre llamadas a funciones, se inicializa una vez y persiste durante la vida del programa. Ejemplo: `static int count = 0;` en una función se incrementa entre llamadas.  
   - **Variable global `static`**: Restringe la visibilidad al archivo donde se declara, evitando el enlace externo. Ejemplo: `static int config = 10;` solo es accesible dentro del archivo.  
 
10. ¿Para que se utiliza la palabra reservada **struct**?
   La palabra reservada **struct** en C define un tipo de dato compuesto que agrupa variables de diferentes tipos bajo un solo nombre. Se usa para organizar datos relacionados, como configuraciones de hardware o datos de sensores. 

11. ¿Para que se utiliza la palabra reservada **enum**?
    La palabra reservada **enum** en C define un tipo enumerado, asignando nombres a un conjunto de constantes enteras para mejorar la legibilidad del código. Se usa para estados u opciones, como códigos de error o modos. Ejemplo: `enum State { OFF, ON, IDLE };` en mis proyectos con AVR define estados del dispositivo, haciendo el código más claro que usar enteros crudos.

12. ¿Para que se utiliza la palabra reservada **union**? 
    La palabra reservada **union** en C define un tipo de dato que permite que diferentes variables compartan la misma ubicación de memoria, usado para ahorrar espacio o reinterpretar datos. Solo un miembro es válido a la vez. Solo un miembro es válido a la vez. 

13. ¿Cuál es la **diferencia** entre **union** y **struct**?  ¿Cuál es el tamaño de un **struct** y de **union**?   
   - **Diferencia**: Un `struct` asigna memoria para todos sus miembros, almacenándolos de forma contigua, mientras que un `union` asigna memoria solo para su miembro más grande, compartiendo todos los miembros la misma memoria.  
   - **Tamaño**: El tamaño de un `struct` es la suma de los tamaños de sus miembros (más relleno por alineación). El tamaño de un `union` es el del miembro más grande. Ejemplo: Para `struct S { int a; char b; };` (4 + 1 = 5 bytes, más relleno), y `union U { int a; char b; };` (4 bytes, ya que `int` es el más grande), en un sistema de 32 bits.
     
14. ¿Cual es el tamaño de un apuntador?    
    El tamaño de un apuntador en C depende del espacio de direcciones de la arquitectura. Típicamente:  
    - Sistemas de 8 o 16 bits: 2 bytes.  
    - Sistemas de 32 bits (e.g., STM32): 4 bytes.  
    - Sistemas de 64 bits: 8 bytes.  
    Todos los apuntadores (e.g., a `int`, `struct` o funciones) tienen el mismo tamaño en una arquitectura dada, ya que almacenan direcciones de memoria.

15. ¿Qué es una función?
    Una función en C es un bloque de código que realiza una tarea específica, identificado por un nombre, tipo de retorno y parámetros. Promueve modularidad y reutilización. 
16. ¿Cómo se llama una función por apuntador?
    Un apuntador a función en C almacena la dirección de una función, permitiendo llamarla dinámicamente. Sintaxis: `return_type (*pointer_name)(param_types);`.Ejemplo:
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
17. ¿Cuáles son las dos formas de pasar parámetros a una función?
   En C, los parámetros se pasan a funciones de dos formas:  
   - **Por valor**: Se pasa una copia del argumento, y los cambios no afectan al original. Ejemplo: `void set_value(int x);`.  
   - **Por referencia**: Se pasa un apuntador al argumento, permitiendo modificar el original. Ejemplo: `void set_value(int *x); *x = 10;`. 

18. ¿Cuál es el tamaño de los tipos de variable: int, char, float, etc.?
    Los tamaños de las variables en C dependen de la arquitectura y el compilador:  
    - `char`: 1 byte (8 bits).  
    - `int`: 2 bytes (sistemas de 8/16 bits) o 4 bytes (sistemas de 32 bits como STM32).  
    - `float`: Típicamente 4 bytes (IEEE 754 de precisión simple).  
    - `double`: Típicamente 8 bytes (IEEE 754 de precisión doble).  
    - `short`: 2 bytes.  
    - `long`: 4 u 8 bytes, según la arquitectura.  

19. ¿Si tengo un apuntador a una estructura, cual es la diferencia en tamaño a un apuntador a una función o a una variable?    
    Todos los apuntadores en C (a estructuras, funciones o variables) tienen el mismo tamaño en una arquitectura dada, ya que almacenan direcciones de memoria. Por ejemplo, en un STM32 de 32 bits, un `struct S *`, `void (*func)(void)` y `int *` son todos de 4 bytes. La diferencia está en lo que apuntan, no en su tamaño.

20. ¿De que depende el tamaño de una dirección de memoria? (pista, hay arquitecturas de 8, 16, 32 y hasta 64 bits)
    El tamaño de una dirección de memoria en C depende del ancho del bus de direcciones de la arquitectura:  
    - 8 bits: 1 byte (raro).  
    - 16 bits: 2 bytes (e.g., algunos microcontroladores AVR).  
    - 32 bits: 4 bytes (e.g., STM32 Cortex-M).  
    - 64 bits: 8 bytes (e.g., PCs modernas).  
    Esto determina el tamaño de los apuntadores. 

21. ¿Cómo se hace un **cast**(enmascarar tipos de dato)?
    Un **cast** en C convierte un valor de un tipo a otro usando `(tipo)`. Se usa para garantizar compatibilidad de tipos o reinterpretar datos. Ejemplo: `int x = (int)3.14;` convierte un `float` a `int`. En sistemas embebidos, uso casts para conversiones de apuntadores, como `(uint32_t *)0x40021000` para acceder a registros de hardware en proyectos con STM32.
22. Sabes hacer operaciones de bits, dominas el llamado **bitwise**(si no lo haces recomiendo lo investigues). 
    Las operaciones de bits manipulan bits individuales usando operadores: `&` (AND), `|` (OR), `^` (XOR), `~` (NOT), `<<` (desplazamiento izquierda), `>>` (desplazamiento derecha). Son cruciales en sistemas embebidos para configurar registros. 

23. ¿Cómo conviertes rápidamente de decimal a hexadecimal? 
    Para convertir de decimal a hexadecimal:  
    1. Divide el número decimal entre 16, anota el cociente y el resto.  
    2. Convierte los restos (0-15) a dígitos hex (0-9, A-F).  
    3. Repite hasta que el cociente sea 0, luego lee los restos en orden inverso.  
    Ejemplo: 255 ÷ 16 = 15 (cociente), 15 (resto = F); 15 ÷ 16 = 0, 15 (F). Resultado: 0xFF. 
    **Nota:** un hack es mandar a imprimir el dato directamente en hexadecimal. En los concursos funciona bien. 

24. ¿Cómo conviertes rápidamente de decimal a binario? 
    Para convertir de decimal a binario:  
    1. Divide el número decimal entre 2, anota el cociente y el resto (0 o 1).  
    2. Repite hasta que el cociente sea 0, luego lee los restos en orden inverso.  
    Ejemplo: 13 ÷ 2 = 6, resto 1; 6 ÷ 2 = 3, 0; 3 ÷ 2 = 1, 1; 1 ÷ 2 = 0, 1. 


25. ¿Que es una variable local? ¿Qué es una variable global? ¿En que se diferencian?
    - **Variable local**: Declarada dentro de una función, con ámbito limitado a esa función y vida hasta que la función termina. Ejemplo: `int x;` en una función.  
    - **Variable global**: Declarada fuera de funciones, accesible en todo el programa, con vida durante la ejecución del programa. Ejemplo: `int x;` en el ámbito del archivo.  
    - **Diferencia**: Las variables locales son temporales y específicas de la función; las globales son persistentes y de alcance global. En mis proyectos con AVR, uso globales para configuraciones y locales para cálculos temporales.

26. ¿Para qué se utiliza el modificador **extern**?
    El modificador **extern** en C declara una variable o función definida en otro archivo, permitiendo su acceso sin redefinirla. Extiende la visibilidad de la variable o función entre archivos. Ejemplo: En mis proyectos con STM32, `extern uint32_t config;` en un archivo de cabecera permite a múltiples archivos fuente acceder a una variable de configuración global.

27. ¿Cuáles son las principales estructuras de datos? (pilas, colas, listas...)
    Las principales estructuras de datos en C incluyen:  
    - **Pila**: Estructura LIFO (Last In, First Out), usada para gestionar llamadas a funciones.  
    - **Cola**: Estructura FIFO (First In, First Out), usada para programación de tareas en RTOS.  
    - **Lista enlazada**: Nodos conectados por apuntadores, usados para datos dinámicos.  
    - **Arreglo**: Colección de tamaño fijo, usada para tablas de consulta.  
    - **Árbol**: Estructura jerárquica, menos común en sistemas embebidos.  
28. Si tengo definido un struct y un union con los mismos componentes, ¿qué me regresará  sizeof en cada una de ellas?
    Para un `struct` y un `union` con los mismos miembros:  
    - `sizeof(struct)`: Suma de los tamaños de todos los miembros, más relleno por alineación (e.g., `struct S { int a; char b; }` es 8 bytes en sistemas de 32 bits por el relleno).  
    - `sizeof(union)`: Tamaño del miembro más grande (e.g., `union U { int a; char b; }` es 4 bytes, ya que `int` es el más grande).  
29. ¿Cuales son las fases de un proceso de **compilacion**?
30. ¿Que hace el **pre-procesador**?    
31. ¿Qué se hace en el **compilador**?
32. ¿Qué hace el **ensamblador**?
33. ¿Qué hace el **linker**?
    Las preguntas anteriores tienen respuesta en lo siguiente:
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

34. ¿Qué es una **macro**?
  Una macro en C es una directiva del preprocesador definida con `#define` que reemplaza un token con código o un valor antes de la compilación. Se usa para constantes o fragmentos de código en línea. 

35. ¿Qué es una función **in-line**?
  Una función inline en C, declarada con `inline`, sugiere al compilador insertar el código de la función directamente en el lugar de la llamada, reduciendo la sobrecarga de la llamada. Es útil para funciones pequeñas y frecuentes. 

36. ¿Qué es una directiva del preprocesador?
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
37. ¿Que es una optimización de compilación?
  Un compilador con optimización esta diseñado para generar código que esta optimizado en aspectos que permiten minimizar el tiempo de ejecución, uso de memoria, tamaño de la memoria y consumo de energía. En el caso de GCC tiene varios nivles de optimización:
   - **O0**: Optimizacion minima, Se apaga la optimización, se utiliza para el debug para una vista de la estructura generada por el codigo fuente. 
   - **O1**: Optimizacion restringida, solo se realiza la optimización en funcion de la informacion de debug. 
   - **O2**: Alta optimización. 
   - **O3**: Maxima optimización.

38. ¿Cuál es la diferencia entre hacer una rutina por **función** y por **macro**?
- **Función**: Un bloque de código con tipo de retorno y parámetros, compilado por separado, con sobrecarga de llamada. Ejemplo: `void toggle_pin(int pin);`.  
- **Macro**: Una directiva del preprocesador (`#define`) que se expande en línea, evitando la sobrecarga de llamada pero sin verificación de tipos. Ejemplo: `#define TOGGLE_PIN(pin) (GPIOA->ODR ^= (1 << pin))`.  
Las funciones son más seguras y depurables; las macros son más rápidas pero arriesgadas.

39. ¿Cuál es el uso de **volatile** y **const**  juntos? 
    Usar `volatile` y `const` juntos declara una variable que el programa no puede modificar pero que puede cambiar externamente (e.g., por hardware). Ejemplo: `volatile const uint8_t *reg = (uint8_t *)0x40021000;` para un registro de hardware de solo lectura que se actualiza por interrupciones. En mis proyectos con STM32, lo uso para registros de estado actualizados por hardware pero de solo lectura en firmware.

40. ¿Cuál es la diferencia entre usar una macro y **const**?
    - **Macro**: Una directiva `#define` reemplaza código en línea durante el preprocesado, sin seguridad de tipos y con posible efectos secundarios. Ejemplo: `#define SQUARE(x) ((x)*(x))` puede causar errores si los argumentos tienen efectos secundarios.  
    - **const**: Una variable `const` es un valor fijo almacenado en memoria, con verificación de tipos y sin expansión. Ejemplo: `const int MAX = 100;` asegura seguridad. Las macros son más rápidas pero arriesgadas; `const` es más seguro y claro. 
41. ¿Qué es el concepto de memoria dinámica?
    La memoria dinámica en C se asigna en tiempo de ejecución usando funciones como `malloc`, `calloc`, `realloc` y `free`, generalmente en el heap. Permite un uso flexible de la memoria para estructuras como búferes o listas. 

42. ¿Cuáles son las funciones para utilizar memoria dinámica? 
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
43. ¿Qué es una **API**?
    Una API (Interfaz de Programación de Aplicaciones) es un conjunto de funciones, protocolos o herramientas que permite la comunicación entre componentes de software. En sistemas embebidos, APIs como la HAL de STM32 proporcionan funciones para interactuar con hardware (e.g., `HAL_UART_Transmit` para UART). En mis proyectos, uso APIs para abstraer detalles del hardware y simplificar el desarrollo de firmware.

Como sugerencia, el desarrollador de Sistemas embebidos ya no piensa en un enfoque orientado a  objetos, podría describirse como apegado a la programación estructurada clásica, sin embargo. La definición que en lo personal puedo definir es el control de Hardware por medio de estructuras y algoritmos de Software. El mundo en binario (códificado en hexadecimal) es el pan de cada día para el Embedded SW Developer.  

# Preguntas sobre arquitecturas de procesador y memoria
1. ¿Qué arquitecturas conoces? (En mi caso personal)
   Conozco varias arquitecturas de procesadores usadas en sistemas embebidos, como:
   - ARM: Ampliamente usada en microcontroladores como STM32 (Cortex-M).
   - AVR: Utilizada en microcontroladores de 8 bits de Atmel, como el ATmega328.
   - x86: Común en PCs y algunos sistemas embebidos de alto rendimiento.
   - RISC-V: Arquitectura abierta emergente para aplicaciones embebidas. (No he trabajado directamente con ella)
   - PIC: Usada en microcontroladores de Microchip.
  
2. ¿Cuál es la diferencia entre arquitectura **Hardvard** y **Von Newmann**?
   - Harvard: Usa memorias separadas para instrucciones (programa) y datos, con buses independientes, permitiendo acceso simultáneo. Es común en microcontroladores como AVR y STM32.
   - Von Neumann: Usa una sola memoria y bus para instrucciones y datos, lo que puede limitar el rendimiento. Es típica en PCs. 

3. ¿Qué significa que tengo un microcontrolador/procesador de 32 bits? (referido como maneja la memoria)
   Un microcontrolador/procesador de 32 bits maneja direcciones de memoria y datos en palabras de 32 bits, permitiendo un espacio de direccionamiento de hasta 4 GB (2³² bytes). También procesa operaciones aritméticas y lógicas en registros de 32 bits, mejorando el rendimiento. 

4. ¿Cuál es la diferencia entre un **ciclo de reloj** y un **ciclo máquina**?
   - **Ciclo de reloj**: Es un período de la señal de reloj que sincroniza las operaciones del procesador (e.g., 1 MHz = 1 ciclo por microsegundo).  
   - **Ciclo máquina**: Es el tiempo necesario para completar una instrucción, que puede requerir múltiples ciclos de reloj, dependiendo de la instrucción y la arquitectura.  
   
5. ¿Que significa que un microcontrolador sea **big endian**?
   Un microcontrolador **big endian** almacena los datos en memoria colocando el byte más significativo (MSB) en la dirección más baja. Por ejemplo, el valor 0x1234 se guarda como 12 34. Es común en algunas arquitecturas de red. En mis proyectos, he trabajado con STM32, que es **little endian**, pero entiendo **big endian** para protocolos como CAN.
 
6. ¿Que significa que un procesador sea **little endian**?
   Un procesador **little endian** almacena los datos colocando el byte menos significativo (LSB) en la dirección más baja. Por ejemplo, 0x1234 se guarda como 34 12. Es típico en ARM Cortex-M y x86. En mis proyectos con STM32, uso **little endian** para acceder a registros y datos, asegurando el orden correcto en lecturas/escrituras.
 
7. ¿Qué es un **procesador**?
   Un procesador es un circuito electrónico que ejecuta instrucciones de un programa, realizando operaciones aritméticas, lógicas y de control. En sistemas embebidos, es el núcleo de un microcontrolador.

8. ¿Qué es un **microcontrolador**?
   Un microcontrolador es un chip integrado que contiene un procesador, memoria (RAM, Flash) y periféricos (e.g., GPIO, UART, ADC) para aplicaciones embebidas. Esto es mas fácil de explicar como una analogia diciendo que tenemos una computadora personal miniatura en un solo chip.
 
9.  ¿Todos los microcontroladores contienen un procesador?
    Sí, todos los microcontroladores contienen un procesador (CPU) que ejecuta instrucciones del firmware.

10. ¿Qué **módulos** puede tener un microcontrolador?
    Un microcontrolador puede incluir módulos como:  
    - GPIO: Pines de entrada/salida.  
    - UART, SPI, I2C: Para comunicación serial.  
    - ADC/DAC: Conversión analógica-digital y viceversa.  
    - Timers: Para conteo o PWM.  
    - Interrupciones: Para manejar eventos.  
11. ¿Qué es un **DAC**?
    Un DAC (Convertidor Digital-Analógico) es un módulo que convierte señales digitales en analógicas, generando voltajes proporcionales a valores digitales.
12. ¿Qué es un **ADC**?
    Un ADC (Convertidor Analógico-Digital) convierte señales analógicas (e.g., voltajes) en valores digitales.

13. ¿Qué es la **ALU**?
    La ALU (Unidad Aritmética y Lógica) es un componente del procesador que realiza operaciones aritméticas (e.g., suma, resta) y lógicas (e.g., AND, OR). 

14. ¿Qué es un **timer**/**counter**?
    Un timer/counter es un módulo que cuenta pulsos de reloj o eventos externos, usado para medir tiempo, generar PWM o disparar interrupciones.

15. ¿Qué hace un modulo **PWM**?
    Un módulo PWM (Modulación por Ancho de Pulso) genera señales digitales con un ciclo de trabajo variable, usadas para controlar potencia.

16. ¿Qué es una **UART**?
17. ¿Qué es una fuente de reloj?
18. ¿Qué es  un **PLL**, para que se puede usar en un microcontrolador?
19. ¿Cómo puedes generar señales de reloj/ osciladores?
20. ¿Qué es una **interrupción**?
21. ¿Qué es el **pulling**?
22. ¿Cómo manejas una interrupción (utilizando lenguaje C)? (spoiler por el ISR usando funciones, para ARM usas el NVIC)
23. ¿Que es un watchdog timer? ¿Qué funciones tiene?
24. Si yo tengo que hacer un delay, ¿por qué me conviene más implementarlo por medio de una cuenta descendente que por una ascendente?
25. ¿Cómo se organiza la memoria de un microcontrolador?
26. ¿Qué tipos de memoria existen (de acuerdo con su fabricación)? Flash, eeprom, ram, nand, etc, intenta saber un poco de todas.
27. ¿Cuales son las partes de la memoria de un sistema y que se hace en cada una de ellas? 
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
1.  ¿Qué es un puerto de entrada- salida/ ¿Qué es el **GPIO**?

2.  ¿Como se mapea un **GPIO** dentro del microcontrolador (en referencia a lenguaje C)?

3.  What is memory leaking?
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


# Preguntas relacionadas con Sistema Operativo
1. ¿Qué es un **sistema operativo**?
2. ¿Qué es un **sistema operativo de tiempo real**?
3. ¿Cuál es la diferencia entre sistema monolítico y uno microkernel?
4. ¿Qué es un **semáforo**?
5. ¿Qué es **mutex**?
6. ¿Qué es **RTOS**?
7. ¿Qué es **Embedded Linux**?
8. ¿Has utilizado alguna tarjeta de desarrollo que soporte sistema operativo? (Raspberry, beaglebone)
 Utilizando Linux (bash). 
    - ¿Cómo te mueves entre directorios?
    - ¿Cómo obtienes la fecha?
    - Describir algún algoritmo para hacer respaldos. 

# Preguntas acerca de protocolos de comunicación:
1. ¿Qué es un protocolo de comunicación **síncrono**?  
   Un protocolo de comunicación síncrono utiliza una señal de reloj compartida para coordinar la transmisión de datos entre dispositivos, asegurando que emisor y receptor operen en sincronía. Ejemplos incluyen SPI e I2C. En mis proyectos con STM32, uso la señal de reloj de SPI para sincronizar la transferencia de datos con periféricos como sensores, garantizando un tiempo preciso. 

2. ¿Qué es un protocolo de comunicación **asíncrono**?
   Un protocolo de comunicación asíncrono no usa un reloj compartido, sino que depende de bits de inicio y parada para enmarcar los datos. UART es un ejemplo común. En mis proyectos con AVR, uso UART para comunicación serial con una PC, configurando tasas de baudios para garantizar una transferencia de datos confiable sin una línea de reloj.

3. ¿Cómo se realiza una **comunicación serial**?
   La comunicación serial transmite datos secuencialmente a través de un solo canal, bit por bit, usando protocolos como UART, SPI o I2C. Implica configurar parámetros (e.g., tasa de baudios para UART, polaridad del reloj para SPI) y manejar tramas de datos. En mis proyectos con STM32, configuro UART para enviar datos de sensores a una terminal, usando bits de inicio/parada para enmarcar. 
4. Explica brevemente como funciona el protocolo **I2C**.
   I2C (Inter-Integrated Circuit) es un protocolo síncrono de dos cables que usa SDA (datos) y SCL (reloj). Un dispositivo maestro controla el reloj y se comunica con múltiples dispositivos esclavos usando direcciones de 7 o 10 bits. Los datos se envían en tramas de 8 bits con bits ACK/NACK. En mis proyectos con STM32, uso I2C para interactuar con sensores como módulos de temperatura, configurando el STM32 como maestro.

6. Explica brevemente como funciona el protocolo **SPI**.
   SPI (Serial Peripheral Interface) es un protocolo síncrono de dúplex completo que usa cuatro líneas: MOSI (salida del maestro, entrada del esclavo), MISO (entrada del maestro, salida del esclavo), SCLK (reloj) y SS (selección de esclavo). El maestro inicia la comunicación, seleccionando un esclavo mediante SS y sincronizando datos con SCLK. En mis proyectos con AVR, uso SPI para comunicarme con una tarjeta SD, configurando el AVR como maestro para transferencias de datos de alta velocidad.
   
7. ¿Conoces el protocolo **CAN**?
   Sí, CAN (Controller Area Network) es un protocolo asíncrono robusto usado en sistemas automotrices e industriales para comunicación confiable entre múltiples nodos. Usa un par diferencial (CAN_H, CAN_L) y soporta comunicación basada en mensajes con arbitraje para evitar colisiones. En mis proyectos con STM32, he usado CAN para conectar microcontroladores en una red vehicular, aprovechando su detección de errores y tolerancia a fallos.

8. ¿Conoces el protocolo **LIN**?
   Sí, LIN (Local Interconnect Network) es un protocolo serial asíncrono de bajo costo usado en sistemas automotrices para aplicaciones no críticas (e.g., control de ventanas). Usa un bus de un solo cable con topología maestro-esclavo, donde el maestro controla la comunicación. No he usado LIN directamente en mis proyectos, pero entiendo su rol como una alternativa más simple a CAN para tareas de bajo ancho de banda.

9. ¿Qué significa que un protocolo sea **Full-Duplex** ó **Half-Duplex**?
   - SPI: Recomendado para comunicación de alta velocidad y corta distancia con pocos dispositivos, como pantallas o tarjetas SD, debido a su dúplex completo y tasas de reloj rápidas. En mis proyectos con AVR, uso SPI para interfaces con tarjetas SD.
   - I2C: Ideal para comunicación de baja velocidad con múltiples dispositivos en un bus compartido, como sensores o EEPROMs, por su simplicidad de dos cables. En mis proyectos con STM32, uso I2C para sensores de temperatura.
  
10. ¿En qué aplicaciones se recomienda utilizar SPI y en cuales I2C?
    Los errores de comunicación se manejan con técnicas como:
    - **Checksums/CRC**: Verifican la integridad de los datos.
    - **ACK/NACK**: Confirman la recepción exitosa (e.g., I2C).
    - **Timeouts**: Detectan comunicaciones estancadas.
    - **Retransmission**: Reenvían datos corruptos (e.g., CAN).

11. ¿Cómo se manejan los errores de comunicación en un protocolo?

12. ¿Qué es el bit de inicio?
    El bit de inicio es una señal en protocolos asíncronos como UART que marca el comienzo de una trama de datos, alertando al receptor para que inicie el muestreo. Típicamente es una señal baja (0) seguida de bits de datos. 
    
13. ¿Qué es un **checksum**?
    Un checksum es un valor calculado a partir de los datos (e.g., sumando bytes) para verificar su integridad durante la transmisión. El receptor lo recalcula y compara para detectar errores. En mis proyectos con STM32, uso checksums en la comunicación UART para asegurar que los datos de sensores no estén corruptos.

14. ¿Qué es un **frame**?
    Una trama es una unidad estructurada de datos en un protocolo de comunicación, que contiene carga útil, cabeceras y bits de control (e.g., bits de inicio/parada, dirección). En UART, una trama incluye un bit de inicio, bits de datos, paridad opcional y bits de parada. En mis proyectos con STM32, configuro tramas UART para transmitir lecturas de sensores de forma confiable.

15. Explica como has usado protocolos de comunicación en los proyectos

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