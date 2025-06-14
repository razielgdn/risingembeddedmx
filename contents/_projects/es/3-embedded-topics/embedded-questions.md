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

 

# Lenguaje C

1. ¿Qué es una **keyword**?    
Una keyword (palabra clave o palabra reservada) **es una palabra que tiene un significado especial predefinido en el lenguaje de programación C** y no puede ser utilizada como identificador (nombre de variable, función, etc.). Estas palabras están reservadas por el compilador para realizar funciones específicas del lenguaje. 
  Ejemplos de keywords en C:
  - Tipos de datos: **int**, **char**, **float**, **double**, **void**
  - Modificadores: **static**, **const**, **volatile**, **extern**
  - Control de flujo: **if**, **else**, **for**, **while**, **switch**, **case**
  - Otros: **struct**, **union**, **enum**, **typedef**, **sizeof** 

2. ¿Qué es el keyword **volatile** y donde/ para qué se utiliza?         
   La palabra clave **volatile** en C indica al compilador que el valor de una variable puede cambiar de forma inesperada, evitando optimizaciones que asumen que el valor es estable. Se usa en sistemas embebidos para variables accedidas por hardware, interrupciones o múltiples hilos. Por ejemplo, una variable mapeada a un registro de hardware (como el registro de estado UART en STM32) se declara `volatile`{:.info} para garantizar que el compilador lea su valor cada vez en lugar de almacenarlo en caché. Uso: 
   ```c
   volatile uint32_t *reg = (uint32_t *)0x40021000;
   ```

3. ¿Para que se usa la palabra reservada **static**? ¿que pasa si se le pone a una variable? ¿qué pasa si la lleva una función?     
   La palabra reservada **static** en C define la duración de almacenamiento y el enlace.  
    - **Variable**: Una variable `static`{:.info} conserva su valor entre llamadas a funciones (ámbito local) o restringe su visibilidad al archivo (ámbito global). Una variable local `static`{:.info} se inicializa una vez y persiste durante la vida del programa. Una variable global `static`{:.info} solo es visible dentro del archivo. Ejemplo: 
    ```c 
    static int counter = 0;
    ```
    en una función mantiene su valor entre llamadas.  
    - **Función**: Una función `static`{:.info} solo es visible dentro del archivo, evitando el enlace externo. Esto es útil para funciones auxiliares en proyectos embebidos, como en mi firmware para AVR. Ejemplo: 
    ```c
    static void update_led(void);
    ```

4. ¿Cuál es el tamaño del dato **int**? (spoiler depende de la **arquitectura**)    
  El tamaño de un `int`{:.info} en C depende de la arquitectura y el compilador. Típicamente:  
  - Microcontroladores de 8 bits (e.g., AVR): `int`{:.info} es de 16 bits (2 bytes).  
  - Microcontroladores de 32 bits (e.g., STM32): `int`{:.info} es de 32 bits (4 bytes).  
  - Sistemas de 16 o 64 bits: `int`{:.info} puede variar (2 o 4 bytes).  

5. ¿Para qué se usa la keyword **typedef**?    
   La palabra clave **typedef** en C crea un alias para un tipo de dato existente, mejorando la legibilidad y portabilidad del código. Se usa comúnmente para simplificar tipos complejos, como estructuras o apuntadores. Por ejemplo:
```c
 typedef struct { 
    uint32_t id; 
    uint8_t status; 
 } Device_t;
```  
  Facilita declarar variables como `Device_t sensor;`{:.info}.
  Otro ejemplo seria: `typedef big_int_data`{:.info}

6. ¿Qué hace el modificador **const**?    
   El modificador **const** en C indica que el valor de una variable no puede modificarse después de su inicialización. Se usa para garantizar la integridad de los datos, especialmente para constantes o datos de solo lectura. Por ejemplo, `const int MAX_VALUE = 100;`{:.info} evita cambios en `MAX_VALUE`{:.info}. En sistemas embebidos, uso `const`{:.info} para tablas de consulta o datos de configuración almacenados en memoria flash para evitar escrituras accidentales.

7. ¿Qué es un **apuntador** en **C**?    
   Un apuntador en C es una variable que almacena la dirección de memoria de otra variable. Permite el acceso y manipulación directa de la memoria, esencial en sistemas embebidos para acceder a registros de hardware o memoria dinámica. Por ejemplo, en mis proyectos con STM32, uso apuntadores como     
```c
uint32_t *reg = (uint32_t *)0x40021000;
``` 
   para acceder a registros de periféricos.

8. ¿Se puede hacer un apuntador **const**, **volatile**, **static**...?     
   Sí, un apuntador puede modificarse con `const`{:.info}, `volatile`{:.info} o `static`{:.info}:  
   - **const**: Un apuntador `const`{:.info} puede evitar la modificación del apuntador `int *const ptr`{:.error} o de los datos a los que apunta `const int *ptr`{:.error} .  
   - **volatile**: Un apuntador `volatile`{:.info} asegura que el compilador no optimice el acceso a los datos apuntados, útil para registros de hardware (e.g., `volatile int *reg`{:.error}).  
   - **static**: Un apuntador `static`{:.info} tiene almacenamiento persistente (local) o alcance de archivo (global).  

9. ¿Qué hace la palabra **static** en una variable **global** y en una **local**?     
   - **Variable local `static`{:.info}**: Conserva su valor entre llamadas a funciones, se inicializa una vez y persiste durante la vida del programa. Ejemplo: `static int count = 0;`{:.info} en una función se incrementa entre llamadas.  
   - **Variable global `static`{:.info}**: Restringe la visibilidad al archivo donde se declara, evitando el enlace externo. Ejemplo: `static int config = 10;`{:.info} solo es accesible dentro del archivo.  
 
10. ¿Para que se utiliza la palabra reservada **struct**?    
   La palabra reservada **struct** en C define un tipo de dato compuesto que agrupa variables de diferentes tipos bajo un solo nombre. Se usa para organizar datos relacionados, como configuraciones de hardware o datos de sensores. 

11. ¿Para que se utiliza la palabra reservada **enum**?    
    La palabra reservada **enum** en C define un tipo enumerado, asignando nombres a un conjunto de constantes enteras para mejorar la legibilidad del código. Se usa para estados u opciones, como códigos de error o modos. Ejemplo: `enum State { OFF, ON, IDLE };`{:.info} en proyectos con AVR define estados del dispositivo, haciendo el código más claro que usar enteros crudos.

12. ¿Para que se utiliza la palabra reservada **union**?    
    La palabra reservada **union** en C define un tipo de dato que permite que diferentes variables compartan la misma ubicación de memoria, usado para ahorrar espacio o reinterpretar datos. Solo un miembro es válido a la vez. Solo un miembro es válido a la vez. 

13. ¿Cuál es la **diferencia** entre **union** y **struct**?  ¿Cuál es el tamaño de un **struct** y de **union**?    
   - **Diferencia**: Un **struct** asigna memoria para todos sus miembros, almacenándolos de forma contigua, mientras que un **union** asigna memoria solo para su miembro más grande, compartiendo todos los miembros la misma memoria.  
   - **Tamaño**: El tamaño de un **struct** es la suma de los tamaños de sus miembros (más relleno por alineación). 
    El tamaño de un **union** es el del miembro más grande. 
    Ejemplo: Para 
    ```c
    struct S { int a; char b; };
    ```
    4 + 1 = 5 bytes, más relleno,
    ```c
    union U { int a; char b; };
    ```
    4 bytes, ya que **int** es el más grande, en un sistema de 32 bits.
     
14. ¿Cual es el tamaño de un apuntador?     
    El tamaño de un apuntador en C depende del espacio de direcciones de la arquitectura. Típicamente:  
    - Sistemas de 8 o 16 bits: 2 bytes.  
    - Sistemas de 32 bits (e.g., STM32): 4 bytes.  
    - Sistemas de 64 bits: 8 bytes.  
    Todos los apuntadores (e.g., a **int**, **struct** o funciones) tienen el mismo tamaño en una arquitectura dada, ya que almacenan direcciones de memoria.

15. ¿Qué es una función?    
    Una función en C es un bloque de código que realiza una tarea específica, identificado por un nombre, tipo de retorno y parámetros. Promueve modularidad y reutilización. 
16. ¿Cómo se llama una función por apuntador?   
    Un apuntador a función en C almacena la dirección de una función, permitiendo llamarla dinámicamente.    
    Sintaxis: 
    ```c 
    return_type (*pointer_name)(param_types);
    ```    
     Por ejemplo:     
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
    - **Por valor**: Se pasa una copia del argumento, y los cambios no afectan al original.   
      Ejemplo: `void set_value(int x);`{:.info}.  
    - **Por referencia**: Se pasa un apuntador al argumento, permitiendo modificar el original.    
      Ejemplo: `void set_value(int *x); *x = 10;`{:.info}.    

18. ¿Cuál es el tamaño de los tipos de variable: int, char, float, etc.?
    Los tamaños de las variables en C dependen de la arquitectura y el compilador:  
    - **char**: 1 byte (8 bits).   
    - **int**: 2 bytes (sistemas de 8/16 bits) o 4 bytes (sistemas de 32 bits como STM32).  
    - **float**: Típicamente 4 bytes (IEEE 754 de precisión simple).  
    - **double**: Típicamente 8 bytes (IEEE 754 de precisión doble).  
    - **short**: 2 bytes.  
    - **long**: 4 u 8 bytes, según la arquitectura.  

19. ¿Si tengo un apuntador a una estructura, cual es la diferencia en tamaño a un apuntador a una función o a una variable?    
    Todos los apuntadores en C (a estructuras, funciones o variables) tienen el mismo tamaño en una arquitectura dada, ya que almacenan direcciones de memoria. Por ejemplo, en un STM32 de 32 bits, un `struct S *`{:.info}, `void (*func)(void)`{:.info} y `int *`{:.info} son todos de 4 bytes.    
    La diferencia está en lo que apuntan, no en su tamaño.

20. ¿De que depende el tamaño de una dirección de memoria? (pista, hay arquitecturas de 8, 16, 32 y hasta 64 bits)    
    El tamaño de una dirección de memoria en C depende del ancho del bus de direcciones de la arquitectura:  
    - 8 bits: 1 byte (raro).  
    - 16 bits: 2 bytes (e.g., algunos microcontroladores AVR).  
    - 32 bits: 4 bytes (e.g., STM32 Cortex-M).  
    - 64 bits: 8 bytes (e.g., PCs modernas).  
    Esto determina el tamaño de los apuntadores. 

21. ¿Cómo se hace un **cast**(enmascarar tipos de dato)?     
    Un **cast** en C convierte un valor de un tipo a otro usando **(tipo)**. Se usa para garantizar compatibilidad de tipos o reinterpretar datos. Ejemplo: `int x = (int)3.14;`{:.info} convierte un **float** a **int**. En sistemas embebidos, uso casts para conversiones de apuntadores, como `(uint32_t *)0x40021000`{:.info} para acceder a registros de hardware en proyectos con STM32.

22. Sabes hacer operaciones de bits, dominas el llamado **bitwise**(si no lo haces recomiendo lo investigues).     
    Las operaciones de bits manipulan bits individuales usando operadores: 
     - **&** AND 
     - `|` OR
     - **^** XOR 
     - **~** NOT 
     - **<<** desplazamiento izquierda. 
     - **>>** desplazamiento derecha.     
   Son cruciales en sistemas embebidos para configurar registros. 

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
    - **Variable local**: Declarada dentro de una función, con ámbito limitado a esa función y vida hasta que la función termina. Ejemplo: **int x;** en una función.  
    - **Variable global**: Declarada fuera de funciones, accesible en todo el programa, con vida durante la ejecución del programa. Ejemplo: **int x;** en el ámbito del archivo.  
    - **Diferencia**: Las variables locales son temporales y específicas de la función; las globales son persistentes y de alcance global. En mis proyectos con AVR, uso globales para configuraciones y locales para cálculos temporales.

26. ¿Para qué se utiliza el modificador **extern**?
    El modificador **extern** en C declara una variable o función definida en otro archivo, permitiendo su acceso sin redefinirla. Extiende la visibilidad de la variable o función entre archivos. 

27. ¿Cuáles son las principales estructuras de datos? (pilas, colas, listas...)
    Las principales estructuras de datos en C incluyen:  
    - **Pila**: Estructura LIFO (Last In, First Out), usada para gestionar llamadas a funciones.  
    - **Cola**: Estructura FIFO (First In, First Out), usada para programación de tareas en RTOS.  
    - **Lista enlazada**: Nodos conectados por apuntadores, usados para datos dinámicos.  
    - **Arreglo**: Colección de tamaño fijo, usada para tablas de consulta.  
    - **Árbol**: Estructura jerárquica, menos común en sistemas embebidos.  

28. Si tengo definido un struct y un union con los mismos componentes, ¿qué me regresará  sizeof en cada una de ellas?
    Para un **struct** y un **union** con los mismos miembros:  
    - **sizeof(struct)**: Suma de los tamaños de todos los miembros, más relleno por alineación  es 8 bytes en sistemas de 32 bits por el relleno.  
    ```c
    struct Data { 
        int id; 
        char name; 
    }
    ```    
    - **sizeof(union)**: Tamaño del miembro más grandees 4 bytes, ya que **int** es el más grande.  
    ```c
    union U { 
        int a; 
        char b; 
    }
    ```
29. ¿Cuales son las fases de un proceso de **compilacion**?
30. ¿Que hace el **pre-procesador**?    
31. ¿Qué se hace en el **compilador**?
32. ¿Qué hace el **ensamblador**?
33. ¿Qué hace el **linker**?    
    Las preguntas anteriores tienen respuesta en lo siguiente:
    1. **Pre-procesado**
       El preprocesado es el primer paso en una compilación, en Lenguaje C es realizado por la herramienta del pre-procesador (un programa preescrito, invocado por el sistema durante la compilación) todas las sentencias que comienzan con el simbolo '#' son procesados y se crea un archivo intermedcio sin estas sentencias, las tares del preprocesado son las siguiente:
        - Eliminación los comentarios.
           Los comentarios son usados en el codigo para dar una idea particulas acerca de las sentencias en la parte del código particular o de una seccion completa. Los comentarios se eliminan por el preprocesador porque no son de uso para la máquina. 
        - Expansión de Macros.
           Las macros son algunos valores constatnes o expresiones definidas usando las directivas **#define** en lenguaje C. Una llamada a macro consduce a la expansión de la macro. El preprocesador crea un archivo intermedio donde algunas instrucciones pre-escritas a nivel de ensamblador reemplanan las expresiones constantes definidas.  Para diferenciar entre las instrucciones originales y las de ensamblador resultante de la expansión de macros se añade un signo '+' a cada sentencia expandida de macros.     
        - Inclusion de archivos.
           La inclusión de archivos en lenguaje C es la adición de otro archivo que contiene código preescrito (los headers  que hacen referencia a otros archivos de C, ya sean estándar o personalizaos).
        - Compilación condicional
           El preprocesador reeemplaza todas las directivas de compilacion condicional con algún código ensamblador predefinido y pasa un nuevo archivo expandido al compilador. 
        Al finalizar, se genera un archivo intermedio con extención *.i*
    2. **Compilación:**
       La fase de compilación en C utiliza un sofware compilador incorporado para convertir el Archivo intermedio *.i*  en un archivo ensamblador *.s* con instrucciones de nivel ensamblador (código de bajo nivel), en esta fase se hacen las optimizaciones para que el rendimiento del programa aumente. 
    3. **Ensamblador** (mas o menos la traducción de Assembling) 
       El código de nivel ensamblador se conviere en un código comprensible por la máquina en forma 
       de binaria (hexadecimal/binarios) por medio de un ensamblador, que es un programa preescrito que traduce el codigo intermedio a código máquina. El archivo de salida por lo general tiene un formato de salida *'.obj'* en DOS y *'.o'* en UNIX
    4. **Linking** (Enlace)
       **linking** es el proceso de incluir los archivos de las bibliotecas en el programa, los archivos de biblioteca son archivos predefinidos que contienen la definición de las funciones en el lenguaje de máquina y estos archivos tienen una extención *.lib*, algunas sentencias desconocidas estan escritas en el archivo objeto (.o, .obj) que el sistema operativo no puede entender y se utilizara un diccionario para encontrar el significado de esas palabras. Del mismo modo, utilizamos archivos de biblioteca para dar significado a algunas declaraciones desconocidas de nuestro archivo objeto. Al terminar el proceso de enlazado, se genera un archivo ejecutable, *.exe* en DOS, *.bin*, *.elf*, *.hex* cuando se trata de firmware.

34. ¿Qué es una **macro**?
  Una macro en C es una directiva del preprocesador definida con `#define`{:.info} que reemplaza un token con código o un valor antes de la compilación. Se usa para constantes o fragmentos de código en línea. 

35. ¿Qué es una función **in-line**?
  Una función inline en C, declarada con **inline**, sugiere al compilador insertar el código de la función directamente en el lugar de la llamada, reduciendo la sobrecarga de la llamada. Es útil para funciones pequeñas y frecuentes. 

36. ¿Qué es una directiva del preprocesador?
  Es un bloque de estados que son procesados antes de compilar, todas las directivas de preprocesador empiezan con un simbolo '#' (hash). El cual indica que cualquiera de las lineas con un **'#'** sera ejecutada en el preprocesador.    
  Tipos de preprocesado:
     - Macros:   
    En lenguaje C  son piezas de codigo que tienen el mismo nombre por tanto el preprocesador las reemplaza en cada lugar donde aparezcan.    
     - Inclusion de archivos:   
    Estas directivas le dicen al compilador que incluya un codigo fuente al programa '#include' es usada pra incluir los *headers* en un programa escrito en C. Existen dos tipos de archivos que pueden ser incluidos:
       1. Standar Header Files (archivos de cabecera estandares, los *.h). Estos necesitan estar encerrados en brackets **'<'** y **'>'**.
```c
#include <stdio.h> 
#include <string.h>
```  
        2. Archivos de cabecera creados por el usuario. Estos se referencian con comillas dobles: **"** y **"** ejemplo: 
```c
#include "my_definitions.h"
#include "timers.h"
```
        3. Directivas Condicionales de C, este tipo de expresiones ayudan a controlar secciones especificas de código que serán incluidas en el proceso de compilación basadas en condiciones. 
```c++
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
- **Función**: Un bloque de código con tipo de retorno y parámetros, compilado por separado, con sobrecarga de llamada. Ejemplo: 
```c
void toggle_pin(int pin);
```
- **Macro**: Una directiva del preprocesador `#define`{:.info} que se expande en línea, evitando la sobrecarga de llamada pero sin verificación de tipos. Ejemplo: 
```c
#define TOGGLE_PIN(pin) (GPIOA->ODR ^= (1 << pin))
```
Las funciones son más seguras y depurables; las macros son más rápidas pero arriesgadas.

39. ¿Cuál es el uso de **volatile** y **const**  juntos? 
    Usar `volatile`{:.info} y `const`{:.info} juntos declara una variable que el programa no puede modificar pero que puede cambiar externamente (e.g., por hardware). Ejemplo: 
    ```c 
    volatile const uint8_t *reg = (uint8_t *)0x40021000;
    ```
    para un registro de hardware de solo lectura que se actualiza por interrupciones. En mis proyectos con STM32, lo uso para registros de estado actualizados por hardware pero de solo lectura en firmware.

40. ¿Cuál es la diferencia entre usar una macro y **const**?
    - **Macro**: Una directiva `#define` reemplaza código en línea durante el preprocesado, sin seguridad de tipos y con posible efectos secundarios. Ejemplo: `#define SQUARE(x) ((x)*(x))` puede causar errores si los argumentos tienen efectos secundarios.  
    - **const**: Una variable `const` es un valor fijo almacenado en memoria, con verificación de tipos y sin expansión. Ejemplo: `const int MAX = 100;` asegura seguridad. Las macros son más rápidas pero arriesgadas; `const` es más seguro y claro. 
41. ¿Qué es el concepto de memoria dinámica?
    La memoria dinámica en C se asigna en tiempo de ejecución usando funciones como `malloc`, `calloc`, `realloc` y `free`, generalmente en el heap. Permite un uso flexible de la memoria para estructuras como búferes o listas. 

42. ¿Cuáles son las funciones para utilizar memoria dinámica? 
   - **malloc():** El nombre proviene de **"memory allocation"** es usado para reservar un bloque gsrande de memoria.
    Syntax of malloc() in C:
```c
ptr = (cast-type*) malloc(byte-size)
```
    For Example:
```c
    ptr = (int*) malloc(100 * sizeof(int));   
``` 
   - **calloc():** De **"contiguos allocation"**,  es un metodo utilizado para almacenar memoria dinámica en un numero especifico de elementos, con la caracteristica que estan inicializados en 0.    
    Syntax of calloc() in C
 ```c 
  ptr = (cast-type*)calloc(n, element-size); 
 ```
    here, n is the no. of elements and element-size is the size of each element.    
    For Example: 
```c
 ptr = (float*) calloc(25, sizeof(float));
```
    This statement allocates contiguous space in memory for 25 elements each with the size of the float.     
   - **free():** sirve para liberar emmoria en C, se aplica sobre el apuntador que fue utilizado para llegar al primer elemento de la memoria.    
     Syntax of free() in C: 
```c 
  free(ptr);
```
  - **realloc():** De “re-allocation” es utilizado para cambiar dinámicamente memoria previamente reservado, se utiliza muchas veces cuando la memoria previamente reservada no es suficiente. Su modo de uso es el siguiente:      
    Syntax of realloc() in C       
 ```c
  ptr = realloc(ptr, newSize);
 ```
    Where ptr is reallocated with new size **newSize**.

43. ¿Qué es una **API**?
    Una API (Interfaz de Programación de Aplicaciones) es un conjunto de funciones, protocolos o herramientas que permite la comunicación entre componentes de software. En sistemas embebidos, APIs como la HAL de STM32 proporcionan funciones para interactuar con hardware (e.g., **HAL_UART_Transmit** para UART). En mis proyectos, uso APIs para abstraer detalles del hardware y simplificar el desarrollo de firmware.

Como sugerencia, el desarrollador de Sistemas embebidos ya no piensa en un enfoque orientado a  objetos, podría describirse como apegado a la programación estructurada clásica, sin embargo. La definición que en lo personal puedo definir es el control de Hardware por medio de estructuras y algoritmos de Software. El mundo en binario (códificado en hexadecimal) es el pan de cada día para el **Embedded SW Developer.**  

# Arquitecturas de procesador y memoria
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
    Un módulo PWM (Pulse Width Modulation - Modulación por Ancho de Pulso) es un periférico de hardware que genera señales digitales con un ciclo de trabajo variable para controlar la potencia promedio entregada a una carga.   
    El PWM genera una señal cuadrada con:
    - Frecuencia fija: Determinada por el período total
    - Ciclo de trabajo variable: Porcentaje del tiempo que la señal está en estado alto

16.  ¿Qué es una **UART**?    
    Una UART (Universal Asynchronous Receiver-Transmitter) es un dispositivo de hardware que convierte datos entre formato paralelo y serial para la comunicación asíncrona. La UART permite que un microcontrolador se comunique con otros dispositivos enviando y recibiendo datos de forma serial (bit por bit) a través de solo dos cables, en lugar de necesitar múltiples líneas como en la comunicación paralela.
17.  ¿Qué es una fuente de reloj?    
    Una fuente de reloj es un circuito que genera señales periódicas para sincronizar operaciones en un microcontrolador. Puede ser un oscilador de cristal, RC interno o PLL. En STM32, configuro un cristal externo de 8 MHz como fuente principal para precisión.

18.  ¿Qué es  un **PLL**, para que se puede usar en un microcontrolador?    
    Un PLL (Lazo de Fase Bloqueada) es un circuito que multiplica o divide una frecuencia de reloj para generar señales de mayor o menor frecuencia. En STM32, uso PLL para escalar un reloj de 8 MHz a 72 MHz, optimizando el rendimiento del sistema.

19. ¿Cómo puedes generar señales de reloj/ osciladores?   
    Las señales de reloj se generan con:  
    - **Cristales**: Para alta precisión (e.g., 16 MHz en AVR).  
    - **Osciladores RC**: Internos, menos precisos.  
    - **PLL**: Para multiplicar frecuencias.  
    - **Osciladores internos**: Como el HSI en STM32.  
    En mis proyectos, selecciono cristales externos para aplicaciones críticas en tiempo.

20. ¿Qué es una **interrupción**?     
   Una interrupción es un evento que detiene temporalmente la ejecución del programa principal para ejecutar una rutina de servicio (ISR). Puede ser disparada por hardware (e.g., timers) o software. 
21. ¿Qué es el **polling**?    
    El polling es una técnica donde el programa revisa repetidamente el estado de un periférico para detectar eventos, en lugar de usar interrupciones. 
    El programa ejecuta un bucle que constantemente pregunta "¿ha ocurrido algo?" hasta que detecta el evento esperado.
```c
// Ejemplo básico de polling
while(1) {
   if (sensor_data_ready()) {
       data = read_sensor();
       process_data(data);
   }
   if (button_pressed()) {
       handle_button_press();
   }
   // Continúa verificando otros eventos...
}
```
   Características del polling:
   Verificación activa: El CPU pregunta constantemente por el estado
   Bucle continuo: El programa no "espera", sino que revisa repetidamente
   Control secuencial: Los eventos se verifican en un orden específico
   Respuesta determinística: Tiempo de respuesta predecible
   -  Ventajas:
    Simplicidad: Fácil de implementar y entender
    Control total: El programador decide cuándo y qué verificar
    Determinismo: Comportamiento predecible del sistema
    Sin overhead de interrupciones: No hay cambio de contexto
    Depuración sencilla: Flujo de programa lineal

    - Desventajas:
    Consumo de CPU: Gasta ciclos verificando constantemente
    Consumo de energía: El procesador nunca entra en modo de bajo consumo
    Latencia variable: Depende de cuándo ocurre la verificación en el bucle
    Escalabilidad limitada: Difícil manejar muchos eventos simultáneos

22. ¿Cómo manejas una interrupción (utilizando lenguaje C)? (spoiler por el ISR usando funciones, para ARM usas el NVIC)     
   En C, una interrupción se maneja definiendo una función ISR (Interrupt Service Routine). En STM32 (ARM), uso el NVIC (Nested Vectored Interrupt Controller) para priorizar y habilitar interrupciones. Ejemplo:  
```c
void TIM2_IRQHandler(void) {
  if (TIM2->SR & TIM_SR_UIF) { // Verificar bandera
    TIM2->SR &= ~TIM_SR_UIF;  // Limpiar bandera
    toggle_led();              // Acción
  }
}
```
23. ¿Que es un watchdog timer? ¿Qué funciones tiene?    
    Un Watchdog Timer es un temporizador de hardware diseñado para detectar y recuperarse de fallas del software, reiniciando automáticamente el sistema cuando detecta que el programa principal se ha "colgado" o está ejecutándose incorrectamente.     
    El watchdog funciona como un temporizador descendente que debe ser "alimentado" (reset) periódicamente por el software. Si no se resetea dentro del tiempo límite, asume que el sistema está bloqueado y genera un reset del sistema.  

24. Si tengo que hacer un delay, ¿por qué me conviene más implementarlo por medio de una cuenta descendente que por una ascendente?     
   La implementación de delays con cuenta descendente tiene ventajas significativas sobre la cuenta ascendente, principalmente relacionadas con eficiencia del procesador y optimización del código.
    - **Cuenta descendente (más eficiente):**    

    ```c
    void delay_countdown(uint32_t count) {
        while(count--) {
        // El procesador solo verifica si count == 0
        // Operación: decrementar y comparar con cero en una instrucción
        }
    }
    ```
    - **Cuenta ascendente (menos eficiente):**

    ```c
    void delay_countup(uint32_t target) {
        uint32_t count = 0;
        while(count < target) {
            count++;
            // El procesador debe: incrementar, cargar target, comparar
            // Más operaciones por iteración
        }
    }
    ```
  Cuando el código se analiza en nivel de ensamblador   

    ```
    ; Cuenta descendente (ARM Cortex-M)
    loop:
        subs r0, r0, #1    ; Decrementa y actualiza flags
        bne loop           ; Salta si no es cero (1 comparación implícita)

    ; Cuenta ascendente
    loop:
        adds r0, r0, #1    ; Incrementa contador
        cmp r0, r1         ; Compara con límite
        blt loop           ; Salta si menor
    ```
    Se notan las ventajas de las cuentas descendentes, se utilizan menos instrucciones de CPU, se aprovechan las flags del procesador, hay un menor uo de registros y accesos a memoria RAM. Cuando se trabaja con sistemas muy pequeños como microcontroladores de 8 bits hay que tomar en cuenta que los recursos son limitados y cada instruccion consume recursos.  

25. ¿Cómo se organiza la memoria de un microcontrolador?    
    La memoria de un microcontrolador se organiza en:
    - Flash: Almacena el firmware (instrucciones).
    - RAM: Para datos dinámicos, pila y variables.
    - EEPROM: Para datos no volátiles (e.g., configuraciones).
    - Registros: Para control de periféricos.

26. ¿Qué tipos de memoria existen (de acuerdo con su fabricación)? Flash, eeprom, ram, nand, etc, intenta saber un poco de todas.    
    Los tipos de memoria incluyen:
    - Flash: No volátil, para firmware (e.g., en STM32).
    - EEPROM: No volátil, para configuraciones persistentes.
    - RAM: Volátil, para datos temporales (estática o dinámica).
    - NAND/NOR: Flash para almacenamiento masivo (e.g., SD cards).
    - ROM: Solo lectura, preprogramada.

27. ¿Cuales son las partes de la memoria de un sistema y que se hace en cada una de ellas?     
    Segmentos de Memoria en Sistemas Embebidos        
    La memoria de un sistema embebido se organiza en diferentes segmentos, cada uno con un propósito específico. Comprender estos segmentos es crucial para la programación eficiente y la depuración.    
    Segmentos Principales de Memoria    
    1. Segmento de Código (.text)
       - **Ubicación:** Memoria Flash/ROM  
       - **Propósito:** Contiene el código ejecutable del programa
       - **Contenido:**
          - Instrucciones de máquina compiladas
          - Definiciones de funciones
          - Tablas de vectores de interrupción
          - Código del bootloader   
```c
// Este código se almacena en el segmento .text
void mi_funcion(void) {
    // Instrucciones ejecutables
    GPIO_toggle();
}
```             
       - **Características:**
          - Solo lectura durante la ejecución
          - Persistente (sobrevive a la pérdida de energía)
          - Direcciones fijas determinadas en tiempo de compilación
    2. Segmento de Datos (.data)
       - **Ubicación:** RAM (inicializado desde Flash)  
       - **Propósito:** Almacena variables globales y estáticas inicializadas

       - **Contenido:**
          - Variables globales con valores iniciales
          - Variables estáticas con valores iniciales
```c
// Estas variables van al segmento .data
int contador_global = 100;        // Global inicializada
static char buffer[10] = "Hola";  // Estática inicializada
```          
       - **Proceso de Inicialización:**
          1. Los valores iniciales se almacenan en memoria Flash
          2. Durante el arranque, los valores se copian de Flash a RAM
          3. El programa accede a las variables en RAM durante la ejecución
    3. Segmento BSS (.bss)
       - **Ubicación:** RAM  
       - **Propósito:** Almacena variables globales y estáticas no inicializadas
       - **Contenido:**
          - Variables globales sin valores iniciales
          - Variables estáticas sin valores iniciales
          - Variables explícitamente inicializadas a cero
```c
// Estas variables van al segmento .bss
int arreglo_global[100];           // No inicializada
static int bandera_estado;         // No inicializada
char buffer_recepcion[256] = {0};  // Inicializada a cero
```
       - **Características:**
          - Se inicializa automáticamente a cero durante el arranque
          - No ocupa espacio en Flash (solo RAM)
          - Más eficiente que .data para variables grandes

    4. Heap (Montículo)
       - **Ubicación:** RAM (área dinámica)  
       - **Propósito:** Asignación dinámica de memoria
       - **Contenido:**
          - Bloques de memoria asignados dinámicamente
          - Memoria gestionada por las funciones malloc/free
```c
// Ejemplo de uso del heap
char* buffer_dinamico = malloc(512);  // Asignación dinámica
if (buffer_dinamico != NULL) {
    // Usar el buffer
    strcpy(buffer_dinamico, "Datos dinámicos");
    free(buffer_dinamico);  // Liberar memoria
}
```
       - **Gestión:**
          - Crece hacia direcciones más altas.
          - Posible fragmentación.
          - Requiere gestión manual (malloc/free).
          - A menudo se evita en sistemas embebidos críticos.

    5. Stack (Pila)
       - **Ubicación:** RAM (parte superior del espacio de memoria).  
       - **Propósito:** Llamadas a funciones y variables locales.
       - **Contenido:**
          - Variables locales de funciones.
          - Parámetros de funciones.
          - Direcciones de retorno.
          - Registros guardados durante interrupciones.
            ```c
            void funcion_ejemplo(int parametro) {
                int variable_local = 10;        // En el stack
                char arreglo_local[50];         // En el stack
                
                // Se libera automáticamente cuando la función retorna
            }
            ```
       - **Características:**
          - Gestión automática (LIFO - Last In, First Out).
          - Crece hacia direcciones más bajas.
          - Tamaño limitado (desbordamiento de pila si se excede).    
    6. Diagrama de Distribución de Memoria   
```
Direcciones Altas
┌─────────────────┐
│     Stack       │ ← Crece hacia abajo
│        ↓        │
├─────────────────┤
│ Espacio Libre   │
├─────────────────┤
│        ↑        │
│     Heap        │ ← Crece hacia arriba
├─────────────────┤
│ Segmento .bss   │ ← Variables no inicializadas
├─────────────────┤
│ Segmento .data  │ ← Variables inicializadas
├─────────────────┤
│ Segmento .text  │ ← Código del programa
└─────────────────┘
Direcciones Bajas
```
28. ¿Qué es un puerto de entrada- salida/ ¿Qué es el **GPIO**?    
    - **Un puerto de entrada-salida** es una interfaz física que permite al microcontrolador comunicarse con el mundo exterior. Es el punto de conexión entre el procesador y los dispositivos externos como sensores, actuadores, LEDs, botones, etc. Los puertos pueden funcionar en dos modos principales:   
      - Entrada (Input): Reciben señales del exterior hacia el microcontrolador
      - Salida (Output): Envían señales desde el microcontrolador hacia el exterior
    - ¿Qué es GPIO?
      **GPIO** significa **General Purpose Input/Output** (Entrada/Salida de Propósito General). Son pines del microcontrolador que pueden configurarse como entrada o salida según las necesidades del programa.
      Características principales del GPIO:  
       - Flexibilidad: Cada pin puede configurarse independientemente como entrada o salida.
       - Control por software: La configuración y estado se controla mediante registros.
       - Estados digitales: Manejan señales digitales (HIGH/LOW, 1/0).
       - Voltajes típicos: 3.3V o 5V dependiendo del microcontrolador.

29. ¿Como se mapea un **GPIO** dentro del microcontrolador (en referencia a lenguaje C)?      
    Se realiza por medio de registros que son espacios de memoria dedicados. 
    Se debe revisar la hoda de datos de cada dispositivo para verificar correctamente. por ejemplo en una arquitectura AVR se realiza principalmente mediante los siguientes:
       - **DDR** (Data Direction Register): Define si el pin es entrada (0) o salida (1).
       - **PORT**: Controla el estado de salida del pin.
       - **PIN**: Lee el estado actual del pin.
       - **PULL**: Configura resistencias pull-up/pull-down.

30.  Qué es una fuga de memoria (memory leaking)?      
   Una fuga de memoria (memory leak) ocurre cuando un programa reserva memoria pero no la libera de vuelta al sistema cuando ya no la necesita. Con el tiempo, esto hace que el programa consuma cada vez más memoria, pudiendo causar ralentización del sistema o fallos.    
   Escenarios comunes:
   - Asignar memoria en un bucle sin liberarla
   - Perder punteros a memoria asignada
   - Manejo de excepciones que evita el código de limpieza
   - Referencias circulares en lenguajes con recolección de basura
   - No cerrar adecuadamente archivos o conexiones de base de datos

31. ¿Qué es Stack Overflow and Underflow?    
    1. Stack Overflow: Ocurre cuando el stack crece más allá de su límite asignado, sobrescribiendo memoria adyacente o causando un error del sistema. **Causas principales**:
       - Recursión infinita o muy profunda:
         ```c
         int factorial(int n) 
         {
           return n * factorial(n-1);  // Sin caso base - recursión infinita
         }
         ```
       - Variables locales muy grandes: 
         ```c
         void funcion() {
         int array[10000000];  // Array muy grande en el stack
         // Puede causar overflow
         }
         ``` 
       - Cadenas largas de llamadas a funciones:
         ```c 
         void funcion_a() { funcion_b(); }
         void funcion_b() { funcion_c(); }
         // ... muchas funciones anidadas
         ```
    2. Underflow    
       Ocurre cuando se intenta extraer más elementos de la pila de los que realmente contiene, o cuando se accede a posiciones inválidas por debajo del límite inferior del stack. Causas principales:    
        - Operaciones pop en pila vacía:
        ```c
        Stack* pila = crear_pila();
        // Pila está vacía
        int valor = pop(pila);  // Stack underflow
        ```  
        - Desbalance en operaciones push/pop:
        ```c
        push(pila, 10);
        push(pila, 20);
        pop(pila);  // OK
        pop(pila);  // OK
        pop(pila);  // Stack underflow - pila vacía 
        ```
        - Errores en manejo de punteros de pila:    
        ```c
        // Manipulación incorrecta del stack pointer
        stack_pointer--;  // Sin verificar límites
        ```

32. ¿Como puedo saber el tamaño de una estructura sin utilizar el operador sizeof? pista, se usan apuntadores y una operación sencilla. En su momento falle al responder.    
    La técnica es con apuntadores:
    ```c
    #include <stdio.h>

    struct MiEstructura {
        int a;
        char b;
        double c;
        short d;
    };

    int main() {
        // Crear un puntero a la estructura (sin asignar memoria)
        struct MiEstructura *ptr = 0;  // o NULL
        
        // El truco: sumar 1 al puntero y convertir a entero
        size_t tamaño = (char*)(ptr + 1) - (char*)ptr;
        
        printf("Tamaño de la estructura: %zu bytes\n", tamaño);
        printf("sizeof() para comparar: %zu bytes\n", sizeof(struct MiEstructura));
        
        return 0;
    }
    ```
   Aritmética de apuntadores:    
   Cuando sumas 1 a un apuntador de estructura, el compilador automáticamente avanza el apuntador por el tamaño completo de la estructura (incluyendo padding/alineación).
   El cálculo:    
    - **ptr** apunta a la dirección **0**.
    - **ptr + 1** apunta a la dirección **0 + tamaño_de_estructura**.
    - La diferencia entre ambas direcciones es exactamente el tamaño de la estructura
   Conversión a char: Se convierte a **char*** porque:
      - Un **char** siempre ocupa 1 byte.
      - La diferencia entre dos **char*** nos da el número exacto de bytes.
      - Sin esta conversión, obtendríamos el número de estructuras, no bytes.

# Sistema Operativo
1. ¿Qué es un **sistema operativo**?    
   Un sistema operativo es el software fundamental que actúa como intermediario entre el hardware de la computadora y las aplicaciones del usuario. Sus funciones principales incluyen:
   - **Gestión de recursos**: Administra CPU, memoria, dispositivos de entrada/salida y almacenamiento de manera eficiente entre múltiples procesos.
   - **Interfaz de usuario**: Proporciona una forma de interactuar con el sistema, ya sea mediante línea de comandos o interfaz gráfica.
   - **Servicios del sistema**: Ofrece servicios como gestión de archivos, comunicación entre procesos, seguridad y control de acceso.
   - **Abstracción del hardware**: Oculta la complejidad del hardware, permitiendo que las aplicaciones funcionen sin conocer detalles específicos del hardware subyacente.

2. ¿Qué es un **sistema operativo de tiempo real**?    
    Un sistema operativo de tiempo real (RTOS) está diseñado para responder a eventos dentro de límites de tiempo estrictos y predecibles. Características clave:
     - Determinismo: Garantiza que las tareas críticas se ejecuten dentro de plazos específicos (deadlines).
     - Prioridades: Implementa sistemas de prioridades estrictos donde las tareas de mayor prioridad siempre se ejecutan primero.
     - Latencia mínima: Minimiza el tiempo de respuesta a interrupciones y eventos críticos.
     - Tipos:
        - Hard Real-Time: Fallar un deadline puede ser catastrófico (sistemas de control de vuelo)
        - Soft Real-Time: Los deadlines son importantes pero no críticos (sistemas multimedia)

3. ¿Cuál es la diferencia entre sistema monolítico y uno microkernel?
    - Sistema Monolítico:   
      - Todo el kernel ejecuta en un solo espacio de memoria.
      - Servicios del SO (drivers, sistema de archivos, red) están en el kernel.
      - Mayor rendimiento por menos cambios de contexto.
      - Mayor riesgo: un fallo puede colapsar todo el sistema.
      Ejemplos: Linux, Windows
    - Microkernel:
      - Kernel mínimo con servicios básicos (IPC, gestión de memoria básica)
      - Servicios ejecutan como procesos separados en espacio de usuario
      - Mayor estabilidad y seguridad
      - Menor rendimiento por más cambios de contexto
    Ejemplos: QNX, Minix
4. ¿Qué es un **semáforo**?    
   Un semáforo es un mecanismo de sincronización que controla el acceso a recursos compartidos en sistemas concurrentes.
   - Funcionamiento:
      - Mantiene un contador interno
      - Wait (P): Decrementa el contador; si es negativo, bloquea el proceso
      - Signal (V): Incrementa el contador; si hay procesos esperando, despierta uno
   - Tipos:
      - Binario: Contador 0 o 1 (similar a mutex)
      - Contador: Permite múltiples accesos simultáneos
5. ¿Qué es **mutex**?    
   Mutex (Mutual Exclusion) es un mecanismo de sincronización que permite que solo un hilo acceda a un recurso compartido a la vez.
   - Características:
      - Exclusión mutua: Solo un hilo puede "poseer" el mutex
      - Propiedad: Solo el hilo que adquirió el mutex puede liberarlo
      - Bloqueo: Si está ocupado, otros hilos esperan
   - Diferencia con semáforo:
      - Mutex es propiedad de un hilo específico
      - Semáforo puede ser liberado por cualquier proceso

6. ¿Qué es **RTOS**?     
   RTOS (Real-Time Operating System) es la abreviatura de Sistema Operativo de Tiempo Real. Características específicas:  
     - Scheduler determinista: Algoritmos de planificación que garantizan tiempos de respuesta predecibles.
     - Gestión de prioridades: Sistema de prioridades fijas o dinámicas con herencia de prioridad.
     -  Servicios de tiempo real: Temporizadores precisos, manejo de interrupciones con latencia mínima.    
    Ejemplos populares:
       - FreeRTOS (código abierto)
       - VxWorks (comercial)
       - QNX (microkernel)
       - RT-Thread

7. ¿Qué es **Embedded Linux**?     
   Embedded Linux es una versión optimizada del kernel Linux diseñada para sistemas embebidos con recursos limitados.
   - Características:
      - Tamaño reducido: Kernel y sistema de archivos minimizados
      - Tiempo de arranque rápido: Optimizado para iniciar rápidamente
      - Configuración específica: Solo incluye drivers y servicios necesarios
      - Soporte de hardware: Amplia gama de arquitecturas (ARM, MIPS, x86)
   - Distribuciones populares:
      - Yocto Project
      - Buildroot
      - OpenWrt
      - Raspbian (Raspberry Pi OS)
    - Ventajas:
        - Costo reducido (gratuito)
        - Gran comunidad de desarrolladores
        - Flexibilidad y personalización

8. ¿Has utilizado alguna tarjeta de desarrollo que soporte sistema operativo? (Raspberry, beaglebone)
 
9. Utilizando Linux (bash). 
    - ¿Cómo te mueves entre directorios? 

    - ¿Cómo obtienes la fecha? 

    - Describir algún algoritmo para hacer respaldos.  

# Protocolos de comunicación:   
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