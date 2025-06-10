---
title: Yocto para Raspberry Pi 4
permalink: /projects/es/yocto/yoctoi
key: yocto
---

Se dice que la mejor manera de aprender a programar es programando, el mismo principio se sigue respetando para cuestiones de sistemas operativos. Así que en
estos capítulos estaremos trabajando con una nueva imagen de Embedded Linux para **Raspberry Pi 4**. La documentación que estoy siguiendo es la correspondiente a la versión 4.0.16 (**kirkstone**) que he elegido arbitrariamente.    

Lo primero que se debe realizar es configurar nuestro sistema operativo como host para compilar y trabajar con Yocto Project.    
Para comenzar debemos trabajar en Linux, ya sea en una máquina virtual o en una PC con una distribución de linux instalada "nativamente". Lo de la máquina virtual no lo recomiendo para nada,  dado que necesitaremos exigir procesador y memoria RAM hasta los límites de nuestros equipos.   

Dice la documentación de Yocto project que recomienda una  distro probada con ellos así que según la lista que mientras esto se escribe (Marzo 2024) debería ser una de las siguientes:
- Ubuntu 20.04 (LTS)
- Ubuntu 22.04 (LTS)
- Fedora 38
- Debian GNU/Linux 11.x (Bullseye)
- AlmaLinux 8   

En mi caso utilicé **Ubuntu 22.04**, aunque también utilicé **Fedora 39** y funcionó. Primero debemos actualizar nuestro sistema e instalar diversos paquetes de software y herramientas para que podamos trabajar. Entonces en nuestra terminal ejecutamos la instalación con el siguiente comando:    
```bash 
sudo apt install gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev python3-subunit mesa-common-dev zstd liblz4-tool file locales libacl1
```   

Para este tutorial supongo que podría llamarse, se realizará para empezar la compilación de un sistema mínimo para Rasperry pi, así que siguiendo los pasos del manual. Y adecuándose a nuestros propósitos:   
1. Crear un directorio donde tengamos los recursos que vamos a trabajar en mi caso escogí tener un directorio para tener yocto y dentro de ese uno donde se tenga el proyecto.
```bash
$ mkdir ~/yocto   
$ cd ~/yocto     
$ mkdir poky-kirkstone    
$ cd poky-kirkstone   
```
2. Procedemos a clonar Yocto project, como se comentó anteriormente usaremos la versión kirkstone. Así que utilizando Git:      
```bash
$ git clone -b kirkstone git://git.yoctoproject.org/poky
```
Este comando descarga los metadatos y herramientas para utilizar la distro poky, esperamos a que termine.    

3. Ahora descargamos el layer de raspberry pi en su versión kirkstone.     
```bash 
$ git clone -b kirkstone git://git.yoctoproject.org/meta-raspberrypi
```

4. Las herramientas de OpenEmbedded que se encuentran en su propia layer.     
```bash 
$ git clone -b kirkstone git://git.openembedded.org/meta-openembedded
```

5. Para realizar una primera compilación podemos hacer el set del entorno de trabajo, que descarga las herramientas y lo necesario para construir  con Yocto Project.     
`source oe-init-build-env <build>`
 - **oe-init-build-env** es un script que inicializa el entorno de trabajo. 
 - ***\<build\>*** es el nombre de la carpeta donde estarán todos los elementos códigos fuente, paquetes, makefiles, bibliotecas, etc y la imagen creada, para el caso de este tutorial:  
```bash
 $ source oe-init-build-env build-RPI 
```
6. Ahora viene la parte donde nos ensuciamos las manos un poco, añadir el layer de raspberrypi4 y configurar los parámetros de compilación.  
 - Agregar el layer de raspberry-pi. Abrir el archivo **conf/bblayers.conf** y añadir la linea: **/home/razielgdn/yocto/poky-kirkstone/meta-raspberrypi \\**
![](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/yp/yocto01.png)   
 - Se configuran los parámetros en conf/local.conf, se busca la arquitectura (machine) sobre la que correra la imagen y se actualiza por: "raspberrypi4-64".   
 ![](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/yp/yocto02.png)   
 - Al final del archivo es posible agregar el número de threads que vamos a utilizar y el número de tareas que se pueden compilar en paralelo.   
  ``` 
  BB_NUMBER_THREADS ?= "8"
  PARALLEL_MAKE ?= "-j 8"
  ```    
  ![](https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/yp/yocto03.png)
7. En mi caso prefiero primero descargar los paquetes y después iniciar la compilación, para hacer las tareas de fetch se ejecuta el siguiente comando.
```bash
$ bitbake --runall fetch core-image-minimal   
```
8. Para finalizar damos paso a la compilación, para un primer ejemplo:
```bash
$ bitbake  core-image-minimal
```
9. Toca esperar el tiempo que necesite el sistema para hacer la compilación.   
10. La parte siguiente es flashear el software en una tarjeta SD para correrla en nuestra Raspberrypi.
  - La imagen se encuentra en **~/yocto/poky-kirkstone/build-RPI/tmp/deploy/images/raspberrypi4-64**
  - Se puede utilizar cualquier flasher como **balenaEtcher** o con el comando **dd**.
```bash
sudo dd if=risingembeddedmx-image-raspberrypi4-64.rpi-sdimg of=/dev/sdc status=progress bs=1M
``` 
