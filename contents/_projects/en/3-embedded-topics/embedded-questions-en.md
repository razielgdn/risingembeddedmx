---
title: Questions in an interview to be Embedded Software Developer
permalink: /projects/en/embedded-topics/embedded-questions-en
key: embedded
tags: 
 - questions
 - interview 
---

The answers to these questions may not be the most complete. From personal experience, I know it's better to research and understand this rather than memorize it without knowing what it's about. But later on, they will be answered in the theory and projects stage. Don't despair, friends, the path of the great journey is long.   

# C Language

1. **What is a *keyword*?**    
A keyword (reserved word) **is a word that has a special predefined meaning in the C programming language** and cannot be used as an identifier (variable name, function, etc.). These words are reserved by the compiler to perform specific language functions. 
  Examples of keywords in C:
  - Data types: **int**, **char**, **float**, **double**, **void**
  - Modifiers: **static**, **const**, **volatile**, **extern**
  - Flow control: **if**, **else**, **for**, **while**, **switch**, **case**
  - Others: **struct**, **union**, **enum**, **typedef**, **sizeof** 

2. **What is the *volatile* keyword and where/what is it used for?**         
   The **volatile** keyword in C tells the compiler that a variable's value can change unexpectedly, preventing optimizations that assume the value is stable. It's used in embedded systems for variables accessed by hardware, interrupts, or multiple threads. For example, a variable mapped to a hardware register (like the UART status register in STM32) is declared *volatile* to ensure the compiler reads its value every time instead of caching it. Usage: 
   ```c
   volatile uint32_t *reg = (uint32_t *)0x40021000;
   ```

3. **What is the *static* reserved word used for? What happens if it's applied to a variable? What happens if a function has it?**     
   The **static** reserved word in C defines storage duration and linkage.  
    - **Variable**: A *static* variable retains its value between function calls (local scope) or restricts its visibility to the file (global scope). A local **static* variable is initialized once and persists during the program's lifetime. A global *static* variable is only visible within the file. Example: 
    ```c 
    static int counter = 0;
    ```
    in a function maintains its value between calls.  
    - **Function**: A *static* function is only visible within the file, preventing external linkage. This is useful for auxiliary functions in embedded projects, like in my AVR firmware. Example: 
    ```c
    static void update_led(void);
    ```

4. **What is the size of the *int* data type? (spoiler: it depends on the architecture)**    
  The size of an *int* in C depends on the architecture and compiler. Typically:  
  - 8-bit microcontrollers (e.g., AVR): *int* is 16 bits (2 bytes).  
  - 32-bit microcontrollers (e.g., STM32): *int* is 32 bits (4 bytes).  
  - 16 or 64-bit systems: *int* can vary (2 or 4 bytes).  

5. **What is the *typedef* keyword used for?**    
   The **typedef** keyword in C creates an alias for an existing data type, improving code readability and portability. It's commonly used to simplify complex types, like structures or pointers. For example:
    ```c
     typedef struct { 
        uint32_t id; 
        uint8_t status; 
     } Device_t;
    ```  
  This makes it easy to declare variables like `Device_t sensor;`{:.info}.
  Another example would be: `typedef big_int_data`{:.info}

6. **What does the *const* modifier do?**    
   The **const** modifier in C indicates that a variable's value cannot be modified after initialization. It's used to guarantee data integrity, especially for constants or read-only data. For example, `const int MAX_VALUE = 100;`{:.info} prevents changes to `MAX_VALUE`{:.info}. In embedded systems, I use *const* for lookup tables or configuration data stored in flash memory to prevent accidental writes.

7. **What is a *pointer* in *C*?**    
   A pointer in C is a variable that stores the memory address of another variable. It allows direct access and manipulation of memory, essential in embedded systems for accessing hardware registers or dynamic memory. For example, in my STM32 projects, I use pointers like     
    ```c
    uint32_t *reg = (uint32_t *)0x40021000;
    ``` 
   to access peripheral registers.

8. **Can a pointer be made *const*, *volatile*, *static*...?**      
   Yes, a pointer can be modified with *const*, *volatile*, or `static`{:.info}:  
   - **const**: A *const* pointer can prevent modification of the pointer `int *const ptr`{:.error} or the data it points to `const int *ptr`{:.error}.  
   - **volatile**: A *volatile* pointer ensures the compiler doesn't optimize access to the pointed data, useful for hardware registers (e.g., `volatile int *reg`{:.error}).  
   - **static**: A `static`{:.info} pointer has persistent storage (local) or file scope (global).  

9. **What does the *static* word do in a *global* variable and in a *local* one?**     
   - **Local `static`{:.info} variable**: Retains its value between function calls, is initialized once and persists during the program's lifetime. Example: `static int count = 0;`{:.info} in a function increments between calls.  
   - **Global `static`{:.info} variable**: Restricts visibility to the file where it's declared, preventing external linkage. Example: `static int config = 10;`{:.info} is only accessible within the file.  
 
10. **What is the *struct* reserved word used for?**    
   The **struct** reserved word in C defines a composite data type that groups variables of different types under a single name. It's used to organize related data, like hardware configurations or sensor data. 

11. **What is the *enum* reserved word used for?**    
    The **enum** reserved word in C defines an enumerated type, assigning names to a set of integer constants to improve code readability. It's used for states or options, like error codes or modes. Example: `enum State { OFF, ON, IDLE };`{:.info} in AVR projects defines device states, making code clearer than using raw integers.

12. **What is the *union* reserved word used for?**     
    The **union** reserved word in C defines a data type that allows different variables to share the same memory location, used to save space or reinterpret data. Only one member is valid at a time. 

13. **What is the *difference* between *union* and *struct*? What is the size of a *struct* and a *union*?**    
   - **Difference**: A **struct** allocates memory for all its members, storing them contiguously, while a **union** allocates memory only for its largest member, with all members sharing the same memory.  
   - **Size**: The size of a **struct** is the sum of its members' sizes (plus padding for alignment). 
    The size of a **union** is that of the largest member. 
    Example: For 
    ```c
    struct S { int a; char b; };
    ```
    4 + 1 = 5 bytes, plus padding,
    ```c
    union U { int a; char b; };
    ```
    4 bytes, since **int** is the largest, on a 32-bit system.
     
14. **What is the size of a pointer?**     
    The size of a pointer in C depends on the architecture's address space. Typically:  
    - 8 or 16-bit systems: 2 bytes.  
    - 32-bit systems (e.g., STM32): 4 bytes.  
    - 64-bit systems: 8 bytes.  
    All pointers (e.g., to **int**, **struct**, or functions) have the same size on a given architecture, since they store memory addresses.

15. **What is a function?**    
    A function in C is a block of code that performs a specific task, identified by a name, return type, and parameters. It promotes modularity and reusability. 

16. **How do you call a function by pointer?**    
    A function pointer in C stores the address of a function, allowing it to be called dynamically.    
    Syntax: 
    ```c 
    return_type (*pointer_name)(param_types);
    ```    
     For example:     
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
   
17. **What are the two ways to pass parameters to a function?**      
    In C, parameters are passed to functions in two ways:  
    - **By value**: A copy of the argument is passed, and changes don't affect the original.   
      Example: 
      ```c
      void set_value(int x);
      ```  
    - **By reference**: A pointer to the argument is passed, allowing modification of the original.    
      Example: 
      ```c
      void set_value(int *x); *x = 10;
      ```    

18. **What is the size of variable types: *int*, *char*, *float*, *etc*.?**    
    Variable sizes in C depend on the architecture and compiler:  
    - **char**: 1 byte (8 bits).   
    - **int**: 2 bytes (8/16-bit systems) or 4 bytes (32-bit systems like STM32).  
    - **float**: Typically 4 bytes (IEEE 754 single precision).  
    - **double**: Typically 8 bytes (IEEE 754 double precision).  
    - **short**: 2 bytes.  
    - **long**: 4 or 8 bytes, depending on architecture.  

19. **If I have a pointer to a structure, what is the size difference compared to a pointer to a function or to a variable?**     
    All pointers in C (to structures, functions, or variables) have the same size on a given architecture, since they store memory addresses. For example, on a 32-bit STM32, a `struct S *`{:.info}, `void (*func)(void)`{:.info}, and *int** are all 4 bytes.    
    The difference is in what they point to, not in their size.

20. **What does the size of a memory address depend on? (hint: there are 8, 16, 32, and even 64-bit architectures)**    
    The size of a memory address in C depends on the width of the architecture's address bus:  
    - 8 bits: 1 byte (rare).  
    - 16 bits: 2 bytes (e.g., some AVR microcontrollers).  
    - 32 bits: 4 bytes (e.g., STM32 Cortex-M).  
    - 64 bits: 8 bytes (e.g., modern PCs).  
    This determines the size of pointers. 

21. **How do you do a *cast* (type masking)?**     
    A **cast** in C converts a value from one type to another using **(type)**. It's used to ensure type compatibility or reinterpret data. Example: `int x = (int)3.14;`{:.info} converts a **float** to **int**. In embedded systems, I use casts for pointer conversions, like `(uint32_t *)0x40021000`{:.info} to access hardware registers in STM32 projects.

22. **Do you know how to do bit operations, do you master the so-called *bitwise* (if you don't, I recommend you research it).**     
    Bit operations manipulate individual bits using operators: 
     - **&** AND 
     - `|` OR
     - **^** XOR 
     - **~** NOT 
     - **<<** left shift. 
     - **>>** right shift.     
   They are crucial in embedded systems for configuring registers. 

23. **How do you quickly convert from decimal to hexadecimal?**         
    To convert from decimal to hexadecimal:      
    1. Divide the decimal number by 16, note the quotient and remainder.  
    2. Convert remainders (0-15) to hex digits (0-9, A-F).  
    3. Repeat until the quotient is 0, then read the remainders in reverse order.  
    Example: 255 ÷ 16 = 15 (quotient), 15 (remainder = F); 15 ÷ 16 = 0, 15 (F). Result: 0xFF.    
    **Note:** a hack is to directly print the data in hexadecimal format. It works well in contests. 

24. **How do you quickly convert from decimal to binary?**     
    To convert from decimal to binary:   
    1. Divide the decimal number by 2, note the quotient and remainder (0 or 1).  
    2. Repeat until the quotient is 0, then read the remainders in reverse order.     
    Example: 13 ÷ 2 = 6, remainder 1; 6 ÷ 2 = 3, 0; 3 ÷ 2 = 1, 1; 1 ÷ 2 = 0, 1. 

25. **What is a local variable? What is a global variable? How do they differ?**    
    - **Local variable**: Declared inside a function, with scope limited to that function and lifetime until the function ends. Example: **int x;** in a function.  
    - **Global variable**: Declared outside functions, accessible throughout the program, with lifetime during program execution. Example: **int x;** in file scope.  
    - **Difference**: Local variables are temporary and function-specific; global variables are persistent and globally scoped. In my AVR projects, I use globals for configurations and locals for temporary calculations.

26. **What is the *extern* modifier used for?**    
    The **extern** modifier in C declares a variable or function defined in another file, allowing access without redefining it. It extends the visibility of the variable or function between files. 

27. **What are the main data structures? (stacks, queues, lists...)**   
    The main data structures in C include:  
    - **Stack**: LIFO (Last In, First Out) structure, used for managing function calls.  
    - **Queue**: FIFO (First In, First Out) structure, used for task scheduling in RTOS.  
    - **Linked list**: Nodes connected by pointers, used for dynamic data.  
    - **Array**: Fixed-size collection, used for lookup tables.  
    - **Tree**: Hierarchical structure, less common in embedded systems.  

28. **If I have a struct and a union defined with the same components, what will sizeof return for each of them?**
    For a **struct** and a **union** with the same members:  
    - **sizeof(struct)**: Sum of all members' sizes, plus padding for alignment is 8 bytes on 32-bit systems due to padding.  
    ```c
    struct Data { 
        int id; 
        char name; 
    }
    ```    
    - **sizeof(union)**: Size of the largest member is 4 bytes, since **int** is the largest.  
    ```c
    union U { 
        int a; 
        char b; 
    }
    ```

29. **What are the phases of a *compilation* process?**
30. **What does the *pre-processor* do?**    
31. **What is done in the *compiler*?**
32. **What does the *assembler* do?**
33. **What does the *linker* do?**   
    The previous questions are answered in the following:
    1. **Pre-processing**
       Pre-processing is the first step in compilation. In C language, it is performed by the pre-processor tool (a pre-written program, invoked by the system during compilation). All statements that begin with the '#' symbol are processed and an intermediate file is created without these statements. The pre-processing tasks are the following:
        - Comment removal.
           Comments are used in the code to give particular ideas about statements in a particular part of the code or an entire section. Comments are removed by the preprocessor because they are not useful for the machine. 
        - Macro expansion.
           Macros are some constant values or expressions defined using **#define** directives in C language. A macro call leads to macro expansion. The preprocessor creates an intermediate file where some pre-written assembly-level instructions replace the defined constant expressions. To differentiate between the original instructions and the assembly instructions resulting from macro expansion, a '+' sign is added to each expanded macro statement.     
        - File inclusion.
           File inclusion in C language is the addition of another file that contains pre-written code (the headers that reference other C files, whether standard or custom).
        - Conditional compilation
           The preprocessor replaces all conditional compilation directives with some predefined assembly code and passes a new expanded file to the compiler. 
        At the end, an intermediate file with *.i* extension is generated.
    2. **Compilation:**   
       The compilation phase in C uses built-in compiler software to convert the intermediate *.i* file into an assembly *.s* file with assembly-level instructions (low-level code). In this phase, optimizations are made to increase program performance. 
    3. **Assembling**   
       The assembly-level code is converted into machine-understandable code in binary form (hexadecimal/binary) by means of an assembler, which is a pre-written program that translates intermediate code to machine code. The output file usually has an output format of *'.obj'* in DOS and *'.o'* in UNIX.
    4. **Linking**   
       **Linking** is the process of including library files in the program. Library files are predefined files that contain function definitions in machine language and these files have a *.lib* extension. Some unknown statements are written in the object file (.o, .obj) that the operating system cannot understand, and a dictionary will be used to find the meaning of those words. Similarly, we use library files to give meaning to some unknown statements in our object file. After the linking process is completed, an executable file is generated: *.exe* in DOS, *.bin*, *.elf*, *.hex* when dealing with firmware.

34. **What is a *macro*?**   
  A macro in C is a preprocessor directive defined with `#define`{:.info} that replaces a token with code or a value before compilation. It's used for constants or inline code fragments. 

35. **What is an *inline* function?**   
  An inline function in C, declared with **inline**, suggests to the compiler to insert the function code directly at the call site, reducing call overhead. It's useful for small and frequent functions. 

36. **What is a preprocessor directive?**   
  It is a block of statements that are processed before compilation. All preprocessor directives start with a '#' (hash) symbol, which indicates that any lines with a **'#'** will be executed in the preprocessor.    
  Types of preprocessing:
     - Macros:   
    In C language, they are pieces of code that have the same name, so the preprocessor replaces them everywhere they appear.    
     - File inclusion:   
    These directives tell the compiler to include source code in the program. '#include' is used to include *headers* in a C program. There are two types of files that can be included:
       1. Standard Header Files (standard header files, the *.h files). These need to be enclosed in brackets **'<'** and **'>'**.
```c
#include <stdio.h> 
#include <string.h>
```  
        2. User-created header files. These are referenced with double quotes: **"** and **"** example: 
```c
#include "my_definitions.h"
#include "timers.h"
```
        3. C Conditional Directives. This type of expression helps control specific sections of code that will be included in the compilation process based on conditions. 
```c++
// Code to be executed if macro_name is defined
#ifndef macro_name
// Code to be executed if macro_name is not defined
#if constant_expr
// Code to be executed if constant_expression is true
#elif another_constant_expr
// Code to be executed if another_constant_expression is true
#else
// Code to be executed if none of the above conditions are true
#endif
```
37. **What is compilation optimization?**   
  An optimizing compiler is designed to generate code that is optimized in aspects that allow minimizing execution time, memory usage, memory size, and power consumption. In the case of GCC, it has several optimization levels:
   - **O0**: Minimal optimization. Optimization is turned off, used for debugging to get a view of the structure generated by the source code. 
   - **O1**: Restricted optimization. Only optimization based on debug information is performed. 
   - **O2**: High optimization. 
   - **O3**: Maximum optimization.
38. **What is the difference between implementing a routine by *function* and by *macro*?**   
- **Function**: A block of code with return type and parameters, compiled separately, with call overhead. Example: 
```c
void toggle_pin(int pin);
```
- **Macro**: A preprocessor directive `#define`{:.info} that expands inline, avoiding call overhead but without type checking. Example: 
```c
#define TOGGLE_PIN(pin) (GPIOA->ODR ^= (1 << pin))
```
Functions are safer and debuggable; macros are faster but risky.

39. **What is the use of *volatile* and *const* together?**    
    Using *volatile* and *const* together declares a variable that the program cannot modify but that can change externally (e.g., by hardware). Example: 
    ```c 
    volatile const uint8_t *reg = (uint8_t *)0x40021000;
    ```
    for a read-only hardware register that is updated by interrupts. In my STM32 projects, I use it for status registers updated by hardware but read-only in firmware.

40. **What is the difference between using a macro and *const*?**    
    - **Macro**: A *#define* directive replaces code inline during preprocessing, without type safety and with possible side effects. Example: #define `SQUARE(x) ((x)*(x))` can cause errors if arguments have side effects.  
    - **const**: A *const* variable is a fixed value stored in memory, with type checking and no expansion. Example: `const int MAX = 100;` ensures safety. Macros are faster but risky; `const` is safer and clearer. 
41. What is the concept of dynamic memory?    
    Dynamic memory in C is allocated at runtime using functions like `malloc`, `calloc`, `realloc` and `free`, generally in the heap. It allows flexible memory usage for structures like buffers or lists. 

42. **What are the functions for using dynamic memory?**
   - **malloc():** The name comes from **"memory allocation"** and is used to reserve a large block of memory.
    Syntax of malloc() in C:
```c
ptr = (cast-type*) malloc(byte-size)
```
    For Example:
```c
    ptr = (int*) malloc(100 * sizeof(int));   
``` 
   - **calloc():** From **"contiguous allocation"**, it is a method used to allocate dynamic memory for a specific number of elements, with the characteristic that they are initialized to 0.    
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
   - **free():** serves to free memory in C, it is applied to the pointer that was used to reach the first element of the memory.    
     Syntax of free() in C: 
```c 
  free(ptr);
```
  - **realloc():** From "re-allocation" it is used to dynamically change previously reserved memory, it is used many times when previously reserved memory is not sufficient. Its usage is as follows:      
    Syntax of realloc() in C       
 ```c
  ptr = realloc(ptr, newSize);
 ```
    Where ptr is reallocated with new size **newSize**.

43. **What is an *API*?**
    An API (Application Programming Interface) is a set of functions, protocols or tools that enables communication between software components. In embedded systems, APIs like STM32's HAL provide functions to interact with hardware (e.g., **HAL_UART_Transmit** for UART). In my projects, I use APIs to abstract hardware details and simplify firmware development.

As a suggestion, the embedded systems developer no longer thinks in an object-oriented approach, it could be described as adhering to classic structured programming, however. The definition that I can personally define is hardware control through software structures and algorithms. The binary world (encoded in hexadecimal) is the daily bread for the **Embedded SW Developer**.

# Processor and Memory Architectures
1. **What architectures do you know? (In my personal case)**
   I know several processor architectures used in embedded systems, such as:
   - ARM: Widely used in microcontrollers like STM32 (Cortex-M).
   - AVR: Used in Atmel's 8-bit microcontrollers, like the ATmega328.
   - x86: Common in PCs and some high-performance embedded systems.
   - RISC-V: Emerging open architecture for embedded applications. (I haven't worked directly with it)
   - PIC: Used in Microchip microcontrollers.
  
2. **What is the difference between *Harvard* and *Von Neumann* architecture?**
   - Harvard: Uses separate memories for instructions (program) and data, with independent buses, allowing simultaneous access. It's common in microcontrollers like AVR and STM32.
   - Von Neumann: Uses a single memory and bus for both instructions and data, which can limit performance. It's typical in PCs. 

3. **What does it mean to have a 32-bit microcontroller/processor? (referring to how it handles memory)**
   A 32-bit microcontroller/processor handles memory addresses and data in 32-bit words, allowing an addressing space of up to 4 GB (2³² bytes). It also processes arithmetic and logical operations in 32-bit registers, improving performance. 

4. **What is the difference between a *clock cycle* and a *machine cycle*?**
   - **Clock cycle**: It's a period of the clock signal that synchronizes processor operations (e.g., 1 MHz = 1 cycle per microsecond).  
   - **Machine cycle**: It's the time needed to complete an instruction, which may require multiple clock cycles, depending on the instruction and architecture.  
   
5. **What does it mean for a microcontroller to be *big endian*?**
   A **big endian** microcontroller stores data in memory by placing the most significant byte (MSB) at the lowest address. For example, the value 0x1234 is stored as 12 34. It's common in some network architectures. In my projects, I've worked with STM32, which is **little endian**, but I understand **big endian** for protocols like CAN.
 
6. **What does it mean for a processor to be *little endian*?**
   A **little endian** processor stores data by placing the least significant byte (LSB) at the lowest address. For example, 0x1234 is stored as 34 12. It's typical in ARM Cortex-M and x86. In my STM32 projects, I use **little endian** to access registers and data, ensuring correct order in reads/writes.
 
7. **What is a *processor*?**
   A processor is an electronic circuit that executes program instructions, performing arithmetic, logical, and control operations. In embedded systems, it's the core of a microcontroller.

8. **What is a *microcontroller*?**
   A microcontroller is an integrated chip that contains a processor, memory (RAM, Flash), and peripherals (e.g., GPIO, UART, ADC) for embedded applications. This is easier to explain as an analogy saying we have a miniature personal computer on a single chip.
 
9.  **Do all microcontrollers contain a processor?**
    Yes, all microcontrollers contain a processor (CPU) that executes firmware instructions.

10. **What *modules* can a microcontroller have?**    
    A microcontroller can include modules such as:  
    - GPIO: Input/output pins.  
    - UART, SPI, I2C: For serial communication.  
    - ADC/DAC: Analog-to-digital conversion and vice versa.  
    - Timers: For counting or PWM.  
    - Interrupts: For handling events.  
11. **What is a *DAC*?**    
    A DAC (Digital-to-Analog Converter) is a module that converts digital signals to analog, generating voltages proportional to digital values.
12. **What is an *ADC*?**     
    An ADC (Analog-to-Digital Converter) converts analog signals (e.g., voltages) into digital values.

13. **What is the *ALU*?**     
    The ALU (Arithmetic Logic Unit) is a processor component that performs arithmetic operations (e.g., addition, subtraction) and logical operations (e.g., AND, OR). 

14. **What is a *timer/counter*?**    
    A timer/counter is a module that counts clock pulses or external events, used to measure time, generate PWM, or trigger interrupts.

15. **What does a *PWM* module do?**    
    A PWM (Pulse Width Modulation) module is a hardware peripheral that generates digital signals with variable duty cycle to control the average power delivered to a load.   
    PWM generates a square wave with:
    - Fixed frequency: Determined by the total period
    - Variable duty cycle: Percentage of time the signal is in high state

16. **What is a *UART*?**    
    A UART (Universal Asynchronous Receiver-Transmitter) is a hardware device that converts data between parallel and serial format for asynchronous communication. UART allows a microcontroller to communicate with other devices by sending and receiving data serially (bit by bit) through just two wires, instead of needing multiple lines as in parallel communication.
17. **What is a clock source?**    
    A clock source is a circuit that generates periodic signals to synchronize operations in a microcontroller. It can be a crystal oscillator, internal RC, or PLL. In STM32, I configure an external 8 MHz crystal as the main source for precision.

18.  **What is a *PLL*, what can it be used for in a microcontroller?**    
    A PLL (Phase-Locked Loop) is a circuit that multiplies or divides a clock frequency to generate higher or lower frequency signals. In STM32, I use PLL to scale an 8 MHz clock to 72 MHz, optimizing system performance.

19. **How can you generate *clock/oscillator* signals?**   
    Clock signals are generated with:  
    - **Crystals**: For high precision (e.g., 16 MHz in AVR).  
    - **RC Oscillators**: Internal, less precise.  
    - **PLL**: To multiply frequencies.  
    - **Internal Oscillators**: Like HSI in STM32.  
    In my projects, I select external crystals for time-critical applications.

20. **What is an *interrupt*?**     
   An interrupt is an event that temporarily stops main program execution to execute a service routine (ISR). It can be triggered by hardware (e.g., timers) or software. 
21. **What is *polling*?**    
    Polling is a technique where the program repeatedly checks the status of a peripheral to detect events, instead of using interrupts. 
    The program executes a loop that constantly asks "has something happened?" until it detects the expected event.
```c
// Basic polling example
while(1) {
   if (sensor_data_ready()) {
       data = read_sensor();
       process_data(data);
   }
   if (button_pressed()) {
       handle_button_press();
   }
   // Continue checking other events...
}
```
   **Polling characteristics:**
   Active verification: The CPU constantly asks for status
   Continuous loop: The program doesn't "wait", but repeatedly checks
   Sequential control: Events are verified in a specific order
   Deterministic response: Predictable response time
   -  **Advantages**:
    Simplicity: Easy to implement and understand
    Total control: The programmer decides when and what to check
    Determinism: Predictable system behavior
    No interrupt overhead: No context switching
    Simple debugging: Linear program flow

    - **Disadvantages**:
    CPU consumption: Wastes cycles constantly checking
    Power consumption: The processor never enters low-power mode
    Variable latency: Depends on when verification occurs in the loop
    Limited scalability: Difficult to handle many simultaneous events
    22. **How do you handle an interrupt (using C language)? (spoiler: through ISR using functions, for ARM you use NVIC)**     
   In C, an interrupt is handled by defining an ISR (Interrupt Service Routine) function. In STM32 (ARM), I use the NVIC (Nested Vectored Interrupt Controller) to prioritize and enable interrupts. Example:  
```c
void TIM2_IRQHandler(void) {
  if (TIM2->SR & TIM_SR_UIF) { // Check flag
    TIM2->SR &= ~TIM_SR_UIF;  // Clear flag
    toggle_led();              // Action
  }
}
```
23. **What is a watchdog timer? What functions does it have?**    
    A Watchdog Timer is a hardware timer designed to detect and recover from software failures, automatically restarting the system when it detects that the main program has "hung" or is executing incorrectly.     
    The watchdog works as a countdown timer that must be "fed" (reset) periodically by software. If it's not reset within the time limit, it assumes the system is stuck and generates a system reset.  

24. **If I need to implement a delay, why is it better to implement it using a countdown rather than a count-up?**     
   Implementing delays with countdown has significant advantages over count-up, mainly related to processor efficiency and code optimization.
    - **Countdown (more efficient):**    

    ```c
    void delay_countdown(uint32_t count) {
        while(count--) {
        // The processor only checks if count == 0
        // Operation: decrement and compare with zero in one instruction
        }
    }
    ```
    - **Count-up (less efficient):**

    ```c
    void delay_countup(uint32_t target) {
        uint32_t count = 0;
        while(count < target) {
            count++;
            // The processor must: increment, load target, compare
            // More operations per iteration
        }
    }
    ```
  When the code is analyzed at assembly level   

    ```
    ; Countdown (ARM Cortex-M)
    loop:
        subs r0, r0, #1    ; Decrement and update flags
        bne loop           ; Jump if not zero (1 implicit comparison)

    ; Count-up
    loop:
        adds r0, r0, #1    ; Increment counter
        cmp r0, r1         ; Compare with limit
        blt loop           ; Jump if less
    ```
    The advantages of countdown are noticeable: fewer CPU instructions are used, processor flags are leveraged, there's less register usage and RAM memory accesses. When working with very small systems like 8-bit microcontrollers, you must consider that resources are limited and each instruction consumes resources.  

25. **How is microcontroller memory organized?**    
    Microcontroller memory is organized into:
    - Flash: Stores firmware (instructions).
    - RAM: For dynamic data, stack, and variables.
    - EEPROM: For non-volatile data (e.g., configurations).
    - Registers: For peripheral control.

26. **What types of memory exist (according to their manufacturing)? Flash, eeprom, ram, nand, etc, try to know a bit about all.**    
    Memory types include:
    - Flash: Non-volatile, for firmware (e.g., in STM32).
    - EEPROM: Non-volatile, for persistent configurations.
    - RAM: Volatile, for temporary data (static or dynamic).
    - NAND/NOR: Flash for mass storage (e.g., SD cards).
    - ROM: Read-only, preprogrammed.

27. **What are the parts of system memory and what is done in each one?**    
    Memory Segments in Embedded Systems        
    Memory in an embedded system is organized into different segments, each with a specific purpose. Understanding these segments is crucial for efficient programming and debugging.    
    Main Memory Segments    
    1. Code Segment (.text)
       - **Location:** Flash/ROM Memory  
       - **Purpose:** Contains the program's executable code
       - **Content:**
          - Compiled machine instructions
          - Function definitions
          - Interrupt vector tables
          - Bootloader code   
```c
// This code is stored in the .text segment
void my_function(void) {
    // Executable instructions
    GPIO_toggle();
}
```             
       - **Characteristics:**
          - Read-only during execution
          - Persistent (survives power loss)
          - Fixed addresses determined at compile time
    2. Data Segment (.data)
       - **Location:** RAM (initialized from Flash)  
       - **Purpose:** Stores initialized global and static variables

       - **Content:**
          - Global variables with initial values
          - Static variables with initial values
```c
// These variables go to the .data segment
int global_counter = 100;        // Initialized global
static char buffer[10] = "Hello";  // Initialized static
```          
       - **Initialization Process:**
          1. Initial values are stored in Flash memory
          2. During startup, values are copied from Flash to RAM
          3. The program accesses variables in RAM during execution
    3. BSS Segment (.bss)
       - **Location:** RAM  
       - **Purpose:** Stores uninitialized global and static variables
       - **Content:**
          - Global variables without initial values
          - Static variables without initial values
          - Variables explicitly initialized to zero
```c
// These variables go to the .bss segment
int global_array[100];           // Uninitialized
static int status_flag;         // Uninitialized
char reception_buffer[256] = {0};  // Initialized to zero
```
       - **Characteristics:**
          - Automatically initialized to zero during startup
          - Takes no space in Flash (only RAM)
          - More efficient than .data for large variables

    4. Heap
       - **Location:** RAM (dynamic area)  
       - **Purpose:** Dynamic memory allocation
       - **Content:**
          - Dynamically allocated memory blocks
          - Memory managed by malloc/free functions
```c
// Heap usage example
char* dynamic_buffer = malloc(512);  // Dynamic allocation
if (dynamic_buffer != NULL) {
    // Use the buffer
    strcpy(dynamic_buffer, "Dynamic data");
    free(dynamic_buffer);  // Free memory
}
```
       - **Management:**
          - Grows toward higher addresses.
          - Possible fragmentation.
          - Requires manual management (malloc/free).
          - Often avoided in critical embedded systems.

    5. Stack
       - **Location:** RAM (top of memory space).  
       - **Purpose:** Function calls and local variables.
       - **Content:**
          - Function local variables.
          - Function parameters.
          - Return addresses.
          - Saved registers during interrupts.
            ```c
            void example_function(int parameter) {
                int local_variable = 10;        // On the stack
                char local_array[50];         // On the stack
                
                // Automatically freed when function returns
            }
            ```
       - **Characteristics:**
          - Automatic management (LIFO - Last In, First Out).
          - Grows toward lower addresses.
          - Limited size (stack overflow if exceeded).    
    6. Memory Distribution Diagram   
```
High Addresses
┌─────────────────┐
│     Stack       │ ← Grows downward
│        ↓        │
├─────────────────┤
│   Free Space    │
├─────────────────┤
│        ↑        │
│     Heap        │ ← Grows upward
├─────────────────┤
│ .bss Segment    │ ← Uninitialized variables
├─────────────────┤
│ .data Segment   │ ← Initialized variables
├─────────────────┤
│ .text Segment   │ ← Program code
└─────────────────┘
Low Addresses
```
28. **What is an input-output port? What is *GPIO*?**   
    - **An input-output port** is a physical interface that allows the microcontroller to communicate with the outside world. It's the connection point between the processor and external devices like sensors, actuators, LEDs, buttons, etc. Ports can function in two main modes:   
      - Input: Receive signals from the outside to the microcontroller
      - Output: Send signals from the microcontroller to the outside
    - What is GPIO?
      **GPIO** stands for **General Purpose Input/Output**. They are microcontroller pins that can be configured as input or output according to program needs.
      Main GPIO characteristics:  
       - Flexibility: Each pin can be configured independently as input or output.
       - Software control: Configuration and state are controlled through registers.
       - Digital states: Handle digital signals (HIGH/LOW, 1/0).
       - Typical voltages: 3.3V or 5V depending on the microcontroller.

29. **How is a **GPIO** mapped within the microcontroller (in reference to C language)?**      
    It's done through registers which are dedicated memory spaces. 
    The datasheet of each device must be reviewed to verify correctly. For example, in an AVR architecture it's mainly done through the following:
       - **DDR** (Data Direction Register): Defines if the pin is input (0) or output (1).
       - **PORT**: Controls the pin's output state.
       - **PIN**: Reads the pin's current state.
       - **PULL**: Configures pull-up/pull-down resistors.

30.  **What is a memory leak?**      
   A memory leak occurs when a program reserves memory but doesn't release it back to the system when it's no longer needed. Over time, this causes the program to consume more and more memory, potentially causing system slowdown or failures.    
   Common scenarios:
   - Allocating memory in a loop without freeing it
   - Losing pointers to allocated memory
   - Exception handling that prevents cleanup code
   - Circular references in garbage-collected languages
   - Not properly closing files or database connections

31. **What is Stack Overflow and Underflow?**   
    1. Stack Overflow: Occurs when the stack grows beyond its allocated limit, overwriting adjacent memory or causing a system error. **Main causes**:
       - Infinite or very deep recursion:
         ```c
         int factorial(int n) 
         {
           return n * factorial(n-1);  // No base case - infinite recursion
         }
         ```
       - Very large local variables: 
         ```c
         void function() {
         int array[10000000];  // Very large array on the stack
         // May cause overflow
         }
         ``` 
       - Long chains of function calls:
         ```c 
         void function_a() { function_b(); }
         void function_b() { function_c(); }
         // ... many nested functions
         ```
    2. Underflow    
       Occurs when trying to extract more elements from the stack than it actually contains, or when accessing invalid positions below the stack's lower limit. Main causes:    
        - Pop operations on empty stack:
        ```c
        Stack* stack = create_stack();
        // Stack is empty
        int value = pop(stack);  // Stack underflow
        ```  
        - Imbalance in push/pop operations:
        ```c
        push(stack, 10);
        push(stack, 20);
        pop(stack);  // OK
        pop(stack);  // OK
        pop(stack);  // Stack underflow - empty stack 
        ```
        - Errors in stack pointer handling:    
        ```c
        // Incorrect stack pointer manipulation
        stack_pointer--;  // Without checking limits
        ```

32. **How can I know the size of a structure without using the sizeof operator? Hint: use pointers and a simple operation. I failed to answer this at the time.**    
    The technique is with pointers:
    ```c
    #include <stdio.h>

    struct MyStructure {
        int a;
        char b;
        double c;
        short d;
    };

    int main() {
        // Create a pointer to the structure (without allocating memory)
        struct MyStructure *ptr = 0;  // or NULL
        
        // The trick: add 1 to the pointer and convert to integer
        size_t size = (char*)(ptr + 1) - (char*)ptr;
        
        printf("Structure size: %zu bytes\n", size);
        printf("sizeof() for comparison: %zu bytes\n", sizeof(struct MyStructure));
        
        return 0;
    }
    ```
   **Pointer arithmetic**:    
   When you add 1 to a structure pointer, the compiler automatically advances the pointer by the complete size of the structure (including padding/alignment).
   The calculation:    
    - **ptr** points to address **0**.
    - **ptr + 1** points to address **0 + structure_size**.
    - The difference between both addresses is exactly the structure size
   Conversion to char: It's converted to **char*** because:
      - A **char** always occupies 1 byte.
      - The difference between two **char*** gives us the exact number of bytes.
      - Without this conversion, we would get the number of structures, not bytes.
# Operating System
1. **What is an *operating system*?**    
   An operating system is fundamental software that acts as an intermediary between computer hardware and user applications. Its main functions include:
   - **Resource management**: Efficiently manages CPU, memory, input/output devices, and storage among multiple processes.
   - **User interface**: Provides a way to interact with the system, either through command line or graphical interface.
   - **System services**: Offers services such as file management, inter-process communication, security, and access control.
   - **Hardware abstraction**: Hides hardware complexity, allowing applications to function without knowing specific details of the underlying hardware.

2. **What is a *real-time operating system*?**    
    A real-time operating system (RTOS) is designed to respond to events within strict and predictable time limits. Key characteristics:
     - Determinism: Guarantees that critical tasks execute within specific deadlines.
     - Priorities: Implements strict priority systems where higher priority tasks always execute first.
     - Minimal latency: Minimizes response time to interruptions and critical events.
     - Types:
        - Hard Real-Time: Missing a deadline can be catastrophic (flight control systems)
        - Soft Real-Time: Deadlines are important but not critical (multimedia systems)

3. **What is the difference between a monolithic system and a microkernel?**
    - **Monolithic System:**   
      - The entire kernel executes in a single memory space.
      - OS services (drivers, file system, network) are in the kernel.
      - Higher performance due to fewer context switches.
      - Higher risk: a failure can crash the entire system.
      Examples: Linux, Windows
    - **Microkernel:**
      - Minimal kernel with basic services (IPC, basic memory management)
      - Services run as separate processes in user space
      - Greater stability and security
      - Lower performance due to more context switches
    Examples: QNX, Minix

4. **What is a *semaphore*?**   
   A semaphore is a synchronization mechanism that controls access to shared resources in concurrent systems.
   - Operation:
      - Maintains an internal counter
      - Wait (P): Decrements the counter; if negative, blocks the process
      - Signal (V): Increments the counter; if processes are waiting, wakes one up
   - Types:
      - Binary: Counter 0 or 1 (similar to mutex)
      - Counting: Allows multiple simultaneous accesses

5. **What is *mutex*?**   
   Mutex (Mutual Exclusion) is a synchronization mechanism that allows only one thread to access a shared resource at a time.
   - Characteristics:
      - Mutual exclusion: Only one thread can "own" the mutex
      - Ownership: Only the thread that acquired the mutex can release it
      - Blocking: If busy, other threads wait
   - Difference from semaphore:
      - Mutex is owned by a specific thread
      - Semaphore can be released by any process

6. **What is *RTOS*?**     
   RTOS (Real-Time Operating System) is the abbreviation for Real-Time Operating System. Specific characteristics:  
     - Deterministic scheduler: Scheduling algorithms that guarantee predictable response times.
     - Priority management: Fixed or dynamic priority system with priority inheritance.
     - Real-time services: Precise timers, interrupt handling with minimal latency.    
    Popular examples:
       - FreeRTOS (open source)
       - VxWorks (commercial)
       - QNX (microkernel)
       - RT-Thread

7. **What is *Embedded Linux*?**     
   Embedded Linux is an optimized version of the Linux kernel designed for embedded systems with limited resources.
   - Characteristics:
      - Reduced size: Minimized kernel and file system
      - Fast boot time: Optimized to start quickly
      - Specific configuration: Only includes necessary drivers and services
      - Hardware support: Wide range of architectures (ARM, MIPS, x86)
   - Popular distributions:
      - Yocto Project
      - Buildroot
      - OpenWrt
      - Raspbian (Raspberry Pi OS)
    - Advantages:
        - Reduced cost (free)
        - Large developer community
        - Flexibility and customization

8. **Have you used any development board that supports operating systems? (Raspberry, beaglebone)**
 
9. **Using Linux (bash).** 
    - How do you navigate between directories? 

    - How do you get the date? 

    - Describe some algorithm for making backups.  

# Communication protocols:   
1. **What is a *synchronous* communication protocol?**    
   A synchronous communication protocol uses a shared clock signal to coordinate data transmission between devices, ensuring that sender and receiver operate in sync. Examples include SPI and I2C. 

2. **What is an *asynchronous* communication protocol?**   
   An asynchronous communication protocol doesn't use a shared clock, but instead relies on start and stop bits to frame the data. UART is a common example. 

3. **How is *serial communication* performed?**   
   Serial communication transmits data sequentially through a single channel, bit by bit, using protocols like UART, SPI, or I2C. It involves configuring parameters (e.g., baud rate for UART, clock polarity for SPI) and handling data frames. 

4. **Briefly explain how the *I2C* protocol works.**   
   I2C (Inter-Integrated Circuit) is a synchronous two-wire protocol that uses SDA (data) and SCL (clock). A master device controls the clock and communicates with multiple slave devices using 7 or 10-bit addresses. Data is sent in 8-bit frames with ACK/NACK bits. 

6. **Briefly explain how the *SPI* protocol works.**   
   SPI (Serial Peripheral Interface) is a synchronous full-duplex protocol that uses four lines: MOSI (master out, slave in), MISO (master in, slave out), SCLK (clock), and SS (slave select). The master initiates communication, selecting a slave via SS and synchronizing data with SCLK. 
   
7. **Do you know the *CAN* protocol?**   
   Yes, CAN (Controller Area Network) is a robust asynchronous protocol used in automotive and industrial systems for reliable communication between multiple nodes. It uses a differential pair (CAN_H, CAN_L) and supports message-based communication with arbitration to avoid collisions. 

8. **Do you know the *LIN* protocol?**   
   Yes, LIN (Local Interconnect Network) is a low-cost asynchronous serial protocol used in automotive systems for non-critical applications (e.g., window control). It uses a single-wire bus with master-slave topology, where the master controls communication.

9. **What does a **Full-Duplex** or **Half-Duplex** protocol type mean?**  
   **Full-Duplex**
   Definition: Allows simultaneous data transmission in both directions. Both devices can send and receive data at the same time.
   Characteristics: 
     - Simultaneous bidirectional communication
     - Separate channels for transmission and reception
     - Higher efficiency in data transfer
     - Requires more hardware (separate TX and RX lines)
  
10. **In which applications is SPI recommended and in which I2C?**  
     - SPI: Recommended for high-speed, short-distance communication with few devices, such as displays or SD cards, due to its full-duplex and fast clock rates. In my AVR projects, I use SPI for SD card interfaces.
     - I2C: Ideal for low-speed communication with multiple devices on a shared bus, such as sensors or EEPROMs, due to its two-wire simplicity.     

11. **How are communication errors handled in a protocol?**    
     Communication errors are handled with techniques such as:
     - **Checksums/CRC**: Verify data integrity.
     - **ACK/NACK**: Confirm successful reception (e.g., I2C).
     - **Timeouts**: Detect stalled communications.
     - **Retransmission**: Resend corrupted data (e.g., CAN).

12. **What is the start bit?**   
    The start bit is a signal in asynchronous protocols like UART that marks the beginning of a data frame, alerting the receiver to start sampling. It's typically a low signal (0) followed by data bits. 
    
13. **What is a *checksum*?**   
    A checksum is a value calculated from data (e.g., by adding bytes) to verify its integrity during transmission. The receiver recalculates it and compares to detect errors. In my STM32 projects, I use checksums in UART communication to ensure sensor data isn't corrupted.

14. **What is a *frame*?**   
    A frame is a structured unit of data in a communication protocol, containing payload, headers, and control bits (e.g., start/stop bits, address). In UART, a frame includes a start bit, data bits, optional parity, and stop bits. 

15. **Explain how you have used communication protocols in your projects**

# Soft Skills
Many interviews focus on how you solve problems from a functional standpoint, both in technical matters and in **human interaction** through teamwork. This includes questions like:
- In a situation where a team member creates conflicts with you, how would you resolve it?
- What problems have you had organizing a work team?
- What has been your biggest challenge when working in a team?
- What projects have you worked on? What do they generally involve?
In this part **you can describe personal and academic projects if you don't have previous work experience**. And if you've already had a job before, it's okay to mention what technology you worked with and roughly what it was about, without violating exclusivity clauses and similar issues.
{:.info}
If you have to do a technical exercise together, try to explain your logic for solving it in the best way. We know it's not easy to write code that works on the first try, but if you have the general overview clear from the beginning and propose the solution in the best way, the coding will be of lesser importance.
{:.success}
I hope this information is useful to someone. Here you need some effort and a lot of luck, especially to get a first job. One tip to move the statistics in your favor is to have a good LinkedIn profile and add headhunters/HR from tech companies as well as engineers who are already developing. Without fear, and without shame.
For now I say goodbye, I'll try to update this post whenever I can.
# Sources
I'll leave you a list of places where you can find solutions to some of these questions, and many more to prepare.
- [Top 18 Embedded Systems Interview Questions and Answers](https://www.guru99.com/embedded-systems-interview-questions.html)
- [Embedded C Interview Questions](https://www.interviewbit.com/embedded-c-interview-questions/)
- [Embedded C interview questions and answers](https://aticleworld.com/embedded-c-interview-questions-2/)