---
title: Questions in an interview to be Embedded Software Developer
permalink: /projects/en/embedded-topics/embedded-questions-en
key: embedded
tags: 
 - questions
 - interview 
---

- **What is a keyword?**
  A keyword (also called reserved word) is a word that has a special predefined meaning in the C programming language and cannot be used as an identifier (variable name, function name, etc.). These words are reserved by the compiler to perform specific language functions.

  Examples of keywords in C:
    - Data types: `int`, `char`, `float`, `double`, `void`.
    - Modifiers: `static`, `const`, `volatile`, `extern`.
    - Control flow: `if`, `else`, `for`, `while`, `switch`, `case`.
    - Others: `struct`, `union`, `enum`, `typedef`, `sizeof`.

If you try to use a keyword as a variable name, the compiler will generate a syntax error.

1. Pre-Processing    
    Pre-processing is the first step in the compilation process in C performed using the pre-processor tool (A pre-written program invoked by the system during the compilation). All the statements starting with the # symbol in a C program are processed by the pre-processor, and it converts our program file into an intermediate file with no # statements. Under following pre-processing tasks are performed :
    
    i. Comments Removal
    Comments in a C Program are used to give a general idea about a particular statement or part of code actually, comments are the part of code that is removed during the compilation process by the pre-processor as they are not of particular use for the machine. The comments in the below program will be removed from the program when the pre-processing phase completes.

    ii. Macros Expansion
    Macros are some constant values or expressions defined using the #define directives in C Language. A macro call leads to the macro expansion. The pre-processor creates an intermediate file where some pre-written assembly level instructions replace the defined expressions or constants (basically matching tokens). To differentiate between the original instructions and the assembly instructions resulting from the macros expansion, a '+' sign is added to every macros expanded statement.
    
    iii. File inclusion
    File inclusion in C language is the addition of another file containing some pre-written code into our C Program during the pre-processing.

    iv. Conditional Compilation
    The preprocessor replaces all the conditional compilation directives with some pre-defined assembly code and passes a newly expanded file to the compiler.ç

    2. Compiling

    Compiling phase in C uses an inbuilt compiler software to convert the intermediate (.i) file into an Assembly file (.s) having assembly level instructions (low-level code). To boost the performance of the program C compiler translates the intermediate file to make an assembly file.

    3. Assembling

    Assembly level code (.s file) is converted into a machine-understandable code (in binary/hexadecimal form) using an assembler. Assembler is a pre-written program that translates assembly code into machine code. It takes basic instructions from an assembly code file and converts them into binary/hexadecimal code specific to the machine type known as the object code.

    The file generated has the same name as the assembly file and is known as an object file with an extension of .obj in DOS and .o in UNIX OS.

    4. Linking
    
    Linking is a process of including the library files into our program. Library Files are some predefined files that contain the definition of the functions in the machine language and these files have an extension of .lib. Some unknown statements are written in the object (.o/.obj) file that our operating system can't understand. You can understand this as a book having some words that you don't know, and you will use a dictionary to find the meaning of those words. Similarly, we use Library Files to give meaning to some unknown statements from our object file. The linking process generates an executable file with an extension of .exe in DOS and .out in UNIX OS.


