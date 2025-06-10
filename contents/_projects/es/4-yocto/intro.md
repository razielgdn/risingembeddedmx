---
title: Introducción a Yocto
permalink: /projects/es/yocto/intro
key: yocto
---

Este es un tema muy avanzado para sistemas embebidos pero por razones de mercado de valores y estratégia de negocios de la empresa donde trabajaba ahora tengo vacaciones indefinidas.

Ya que en las mentes de los desarrolladores son binarias tienden a tener opciones de dos en dos entonces o me quedo a lamentarme y culparme preguntando ¿por que a mi?, o me pongo a pulir habilidades para y mientras consigo un nuevo empleo. 

# Yocto Project

Yocto es el prefijo del Sistema internacional de unidades para definir la escala más pequeña (hasta 2022 cuando se añadieron un par de ordenes más), un multiplicador por 10^-24^ o sea 0.000....1 con 24 ceros antes del 1. 

En el ámbito que nos incumbe significa que es una unidad muy pequeña, entonces Yocto project es un conjunto de herramientas para crear sistemas operativos basados en Linux de forma totalmente personalizada y que permite manipular cada componente en el proceso. 

El proyecto yocto combina y mantiene varios elementos clave:
- El sistema de compilación OpenEmbedded se compone del core de **OpenEmbedded** y **Bitbake**.
- Una configuración de **Linux embedded** es usada para pruebas (Llamada **Poky**).
- Una amplia infraestructura de pruebas esta disponible a través del constructor automático basado en Builbot.
- Se dispone de herramientas para trabajar con embedded Linux de forma eficiente:
- Herramientas para automatizar la compilación y las pruebas.
- Procesos y estándares para las definiciones e intercambios de apoyo a la junta directiva.
- Herramientas de análisis de seguridad y cumplimiento de licencias, soporte para manifiestos de software (SBoM) en SPDX.

Existen muchos componentes de código abierto bajo Yocto Project.

Poky el "embedded OS" (sistema embebido empotrado) de referencia es en un BUILD EXAMPLE que construirá un pequeño sistema operativo con el sistema de compilación (bitbake, el motor de compilación, OpenEmbedded-Core, y los metadatos del sistema de compilación principal).

El sistema de compilacion se descarga con "archivos" de instrucciones de compilación de Poky llamados "recipes" y "layers". Tu puedes modificar, copiar o utilizar las especificaciones de Poky de la forma que necesites para crear un Sistema Embedded Linux personalizado.   

![](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/yp/YoctoLayers.png)

## Construir un sistema operativo a la medida
La [documentacion oficial](https://docs.yoctoproject.org/overview-manual/yp-intro.html#introducing-the-yocto-project) de yocto refiere al por que es una muy buena alternativa para la creacion de productos basados en sistemas embebidos. 

- Se ha adoptado muy bien en la industria muchos fabricantes de semiconductores, sistemas operativos, software y vendedores de servicio han adoptado y dan soporte para **Yocto Project**.
- Es compatible con varios tipos de arquitectura, por ejemplo Intel, AMD, MIPS, ARM y varias otras. 
- Es compatible con una gama amplia de dispositivos emulados por **QEMU** (Quick emulator).
- Es relativamente fácil portar las imágenes y el código sin tener que pasar a nuevos entornos de desarrollo.
- Tiene mucha flexibilidad, por ejemplo una corporación puede crear una distribución a la medida y después de eso crear varios productos a la medida.
- Es ideal para dispositivos del internet de las cosas (IoT por sus siglas en inglés) utilizando justamente lo que se necesita en un nuevo dispositivo.
- Se pueden utilizar toolchains de terceros y es compatible con la mayoría de las arquitecturas más comunes. 
- Utiliza un sistema de modelo de capas, se pueden agregar paquetes de forma separada y de manera incremental, lo que reduce la redundancia y la complejidad.
- Soporta compilaciones parciales por lo tanto es posible crear y reconstruir paquetes individuales según se necesiten.
- Yocto project permite ser muy específico con las dependencias y logra porcentajes muy altos de reproducibilidad binaria,  cuando las distribuciones no son específicas otros paquetes se pueden incluir arbitrariamente.
- Existe un gran ecosistema de individuos y organizaciones con una comunidad muy valiosa, también foros de soporte y desarrolladores activos.
- Manifiesto de licencia, el proyecto proporciona un manifiesto de licencia para que lo revisen las personas que necesitan realizar un seguimiento del uso de licencias de código.

## Dificultades de uso
Algunas dificultades que se pueden encontrar al usar Yocto project son los siguientes:
- Las curvas de aprendizaje son muy grandes además de que una tarea puede tener varias formas de realizar una sola tarea. 
- Comprender que cambios necesitan realizarse para un nuevo diseño implica una gran cantidad de investigación.
- El flujo de trabajo puede ser confuso si eres un usuario de escritorios tradicionales o servidores, En un entorno de desarrollo existen mecanismos para extraer e instalar nuevos paquetes que generalmente estan pre-compilados desde servidores en internet, al utilizar Yocto project se debe modificar la configuración y reconstruir para agregar paquetes adicionales.
- El trabajar en un entorno de compilación cruzada (**Cross-Build**) puede resultar desconocido. Cuando se desarrolla un código para determinada tarjeta la compilación, ejecución y pruebas todos los procesos podrían ser mas rápidos si se ejecutaran en la la tarjeta que con bitbake dado que se tendrían que cargar después en la tarjeta para realizar pruebas. Yocto soporta un enfoque donde los cambios se pueden realizar con bitbake y luego solo implementar los paquetes actualizados en la tarjeta destino.
- El sistema de compilación de Open embedded produce paquetes en formato estándar (por ejemplo rpm, deb o ipk).  Tu puedes implementar estos paquetes en un sistema que ya se encuentre corriendo mediante paquetes como rpm.
- Los tiempos de compilación iniciales pueden ser muy grandes, esto debido a que son muchos los paquetes que se deben crear desde cero para tener un sistema Linux. La ventaja es que se tiene un cache  para que en sucesivas compilaciones solamente cambien los paquetes que han sido modificados. 

## Cosas que desearía haber sabido

La documentación oficial tiene una sección con ["Cosas que desearía haber sabido de Yocto"](https://docs.yoctoproject.org/what-i-wish-id-known.html#what-i-wish-i-d-known-about-yocto-project), su traducción más o menos quedaría así.

Usar yocto es fácil hasta que algo sale mal. Sin un buen entendimiento de como funciona el proceso de compilación puede suceder que se vuelva una caja negra. Algunos elementos que se deben saber antes de empezar a usar yocto son los siguientes:

1. Se debe utilizar **Git** y no archivos de paquetes, con esto nos aseguramos que el software se actualizará cuando exista algún error. Si algún archivo "tarball"es utilizado, el usuario debe hacerse responsable de sus propias actualizaciones.
2. Debe conocer el "layer index" (índice de capas) todas la capas pueden ser encontradas en el índice de capas. Aquellas que han solicitado el estado compatible con el Yocto project se pueden encontrar en la página ["Project compatible layers"](https://www.yoctoproject.org/development/yocto-project-compatible-layers/).
3. Cuando sea posible se deben utilizar "BSP layers"  de fabricantes como Intel, NxP, raspberry-pi y demás, debemos tratar de no crear layers desde cero, incluso con algún componente "custom" se debe usar una layer preexistente como plantilla.
4. No pongas todo en un solo "layer", se deben usar diferentes capas separando lógicamente la información de una compilación. Por ejemplo podría tener una capa BSP, una de GUI, otra de configuración de distro, otra de aplicación, etc. A su vez aislar la información ayuda a simplificar futuras personalizaciones y reutilizado de código. 
5. Nunca, nunca, nunca jamás modificar la "poky layer" cuando se actualice el siguiente "release" se perderán todos los cambios. Absolutamente todo.
6. La documentación oficial se encuentra en ["All in one Mega Manual"](https://docs.yoctoproject.org/singleindex.html#document-kernel-dev/4.0.16/4.3.999/index) las búsquedas en google aunque son buenas, probablemente arrojarán resultados desactualizados. 
7. Entender los conceptos básicos de como el sistema se construye: "the workflow": es muy importante debido a que puede ayudar en caso de que ocurran errores en una etapa diferente de compilación.
   1. **Fetch** – (busca) obtiene el código fuente.   
   2. **Extract** –(extraer) descomprime el código fuente.   
   3. **Patch** – (parchar) Aplica parches para soluciona de errores y nuevas prestaciones.   
   4. **Configure** (configura)– configura los parámetros del ambiente.   
   5. **Build** (compila)– compila y realiza el mapeo/vinculado.   
   6. **Install** (instala) – copia los archivos a los lugares indicados.   
   7. **Package** (empaqueta) – agrupa los archivos para la instalación.    
 Durante el proceso **fetch** probablemente no encontremos código, cuando sucede "extract" es posible que exista un archivo .zip no valido o algún problema similar. En otras palabras, la función de un punto particular del proceso te dan una idea de que es lo que podría estar fallando.   
  ![](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/site/assets/images/yp/yp-hiw.png)

8. Es posible generar un gráfico de dependencias que muestra las relaciones entre recipes, tasks and targets. Se puede utilizar la opción '-g' para generar el gráfico. Esto es muy útil cuando una compilación no se efectúa correctamente, dado que permite visualizar que paquetes causan problemas. Para mejor información ver la sección del Manual de bitbake. 
9. Para decodificar los nombres "magic" de las carpetas en tmp/work: El proceso de compilación hace la búsqueda de paquetes, descomprime, preprocesa y
compila. Si algo sale mal el sistema reporta directamente en donde se encuentran los archivos y paquetes temporales (build/tmp) que resultan de la compilación. 
Cuando se realiza una compilación se puede usar "-u"  en la instucción bitbake para especificar un visor de interfaces de usuario en la gráfica de dependencias (por ejemplo knotty, ncurses, o taskexp).
10. Se puede compilar mas que solo imágenes: Es posible correr tareas específicas para un paquete o incluso un solo "recipe". También se pueden utilizar un "Development Shell".
11. Una definición ambigua: Package vs Recipe: una receta "Recipe" contiene instrucciones para la construcción de un "Package" paquete. 
12. Se deben conocer que esta empaquetado en el sistema de archivos raiz (root filesystem).
13. Crear una receta con imágenes propias:  Es recomendable crear recetas personalizadas. 
14. A continuación hay una lista de las habilidades necesarias en un desarrollador de embedded systems el cual debería poder:
   - Saber negociar con proxies empresariales.
   - Añadir un paquete a una imagen. 
   - Comprender la diferencia entre una receta y un paquete. 
   - Compilar un paquete por si mismo y saber por que es útil.
   - Descubrir que paquetes son creados por una receta.
   - Descubrir que archivos hay en un paquete.
   - Descubrir que archivos hay en una imagen.
   - Añadir un servidor ssh a una imagen habilitando la transferencia de archivos.
   - Conocer la anatomía de una receta.
   - Saber como crear y usar "layers".
   - Encontrar recetas (en el OpenEmbedded index).
   - Comprender las diferencias de configuración entre la máquina y la distribución
   - Encontrar y utilizar la BSP(de la máquina) para tu hardware.
   - Encuentra ejemplos de funciones  de distribución y saber donde Configurarlas. 
   - Comprender el proceso de tareas y ejecutarlas individualmente. 
   - Comprander el devtool (herramientas de desarrollo) y como simplifica el trabajo.
   - Mejorar las velocidades de compilación con descargas compartidas y caché de estado de trabajo.
   - Generar y comprender una gráfica de dependencia.
   - Generar y comprender el entorno Bitbake.
   - Compilar una extensión SDK para el desarrollo de aplicaciones. 

15. Dependiendo de cuales son los intereses del usuario con Yocto Project, se podría considerar cualquiera de las siguientes:
  - Consulte el manual de tareas de desarrollo de Yocto project.
  -  Consulte el manual de desarrollo de aplicaciones y el quit de desarrollo de software extensible (eSDK).
  -  Obtenga información sobre el desarrollo del Kernel: puede consultal el manual de desarrollo de kernel. 
  -  Obtenga información sobre los Board Support Pages (BSPs): hay una guia disponible. 
  -  Aprender acerca del "Toaster": Es una interfaz web para el sistema de compilación de Yocto también tiene un manual. 
  -  Obtenga información sobre los plugins para Visual Studio Code o Eclipse.
  -  Ten a la mano el Yocto Project Reference Manual. A diferencia del resto del conjunto de manuales del Proyecto Yocto, este manual se compone de material adecuado para referencia en lugar de procedimientos.

