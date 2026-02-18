---
title: Introducción e instalación de Docker
permalink: /notes/es/docker-inst-es
key: docker-es
lang: es-MX 
date: 2025-06-20
modify_date: 2025-06-20
---

Segun Wikipedia,  Docker es un proyecto de código abierto que automatiza el despliegue de aplicaciones dentro de contenedores de software, proporcionando una capa adicional de abstracción y automatización de virtualización de aplicaciones en múltiples sistemas operativos.​ Docker utiliza características de aislamiento de recursos del kernel Linux, tales como cgroups y espacios de nombres (namespaces) para permitir que "contenedores" independientes se ejecuten dentro de una sola instancia de Linux, evitando la sobrecarga de iniciar y mantener máquinas virtuales.

Su historia comienza en 2008 cuando Solomon Hykes inició docker como un projecto dentro de la empresa dotCloud, en marzo de 2013 fue lanzado como codigo abierto y el proyecto a crecido desde entonces al grado de estar incluido de forma nativa en Windows, y es ahora un estándar en la industria. 

# Conceptos de virtualización
A continuacion se presentan algunos conceptos utiles para la comprensión de las tecnologias que utiliza docker. 
## ¿Qué es la virutalización?
La virtualización es una tecnología que crea entornos virtuales para ejecutar múltiples sistemas operativos o aplicaciones en un mismo hardware físico.    
Permite abstraer recursos como CPU, memoria, almacenamiento y red, simulando máquinas independientes (máquinas virtuales o contenedores). Esto mejora la eficiencia, portabilidad y aislamiento.   
En lugar de tener una computadora física dedicada para cada tarea, puedes crear múltiples "computadoras virtuales" que comparten el mismo hardware físico. Es como dividir una casa grande en varios apartamentos independientes.

## ¿Qué es una Máquina Virtual?
Una máquina virtual (VM) es un entorno virtual que emula un computador físico completo, incluyendo su propio sistema operativo, CPU, memoria y almacenamiento. Se crea mediante un hipervisor (como VMware o VirtualBox) que divide los recursos del hardware físico. Las VMs ofrecen un aislamiento fuerte, pero son más pesadas que los contenedores porque incluyen un SO completo.
Características clave:

Sistema operativo completo e independiente.
- Aislamiento total del sistema host
- Consume recursos significativos (varios GB de RAM)
- Arranque lento (debe iniciar todo el SO)
## ¿Qué es un contenedor?
Un contenedor es una unidad ligera y portátil que empaqueta una aplicación junto con todas sus dependencias (bibliotecas, configuraciones, runtime, etc.) para que pueda ejecutarse de manera consistente en cualquier entorno, ya sea tu máquina local, un servidor o la nube.  
A diferencia de las máquinas virtuales, los contenedores comparten el núcleo del sistema operativo del host, lo que los hace más eficientes en términos de recursos.
Se pueden pensar como: Una "caja" que contiene todo lo necesario para que una aplicación funcione.
- Incluye: código, bibliotecas, configuraciones, variables de entorno
- Es portable: funciona igual en cualquier sistema que soporte contenedores

## ¿Qué son los Namespaces?
Los namespaces son una característica del kernel de Linux que proporciona aislamiento para recursos del sistema, permitiendo que los contenedores operen como entornos independientes. Crean vistas separadas de recursos como procesos (PID), red, sistema de archivos (mount), usuarios (UID/GID) y comunicación entre procesos (IPC). Esto asegura que cada contenedor vea solo sus propios recursos, sin interferir con otros contenedores o el host.   
Es como darle a cada inquilino de un edificio su propia "vista" del mundo. Cada uno ve solo su apartamento como si fuera toda la casa, sin saber que hay otros inquilinos.
Tipos principales:    
- PID Namespace: Cada proceso ve solo sus propios procesos
    - Dentro del contenedor: proceso con ID 1
    - En el host: mismo proceso tiene ID 15432
- Network Namespace: Red aislada
    - Cada contenedor tiene su propia interfaz de red, tabla de rutas, firewall
- Mount Namespace: Sistema de archivos separado
    - Cada contenedor ve su propio árbol de directorios (/home, /etc, /var)
- User Namespace: Usuarios diferentes
    - El usuario "root" dentro del contenedor no es el "root" del host

## ¿Qué son los Control Groups?

Los Control Groups (cgroups) son una funcionalidad del kernel de Linux que limita, prioriza y asigna recursos del sistema (como CPU, memoria, disco y red) a grupos de procesos, como los que corren en contenedores. Garantizan que cada contenedor use solo los recursos asignados, evitando que uno acapare el sistema y asegurando un rendimiento predecible y equitativo.    
Es como ser el administrador de un edificio de apartamentos que puede decidir cuánta electricidad, agua y gas puede usar cada apartamento, evitando que uno consuma todo y deje sin recursos a los demás.

# Instalación de Docker en Linux

## Introducción

Docker se ha convertido en una herramienta esencial para el desarrollo y despliegue de aplicaciones modernas. Esta guía detalla el proceso completo para instalar Docker Engine (la parte de software libre de Docker) y Docker Desktop en Ubuntu 24.04, incluyendo la resolución de problemas comunes encontrados durante la instalación.

## Prerrequisitos

Antes de comenzar la instalación, es necesario verificar:

- Tener Ubuntu 24.04 instalado
- Acceso a terminal con permisos de administrador
- Conexión a internet estable
- **Verificar que la virtualización esté habilitada en UEFI/BIOS**

> **Nota:** La virtualización debe estar habilitada en la BIOS/UEFI de tu equipo para que Docker funcione correctamente.

## Instalación de Docker Engine

### Paso 1: Agregar el repositorio oficial de Docker

El proceso sigue la [documentación oficial de Docker](https://docs.docker.com/engine/install/ubuntu/){:target="_blank"} para Ubuntu. Se recomienda usar `apt` ya que facilita las actualizaciones futuras.

```bash
# Agregar la clave GPG oficial de Docker
sudo apt update
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Agregar el repositorio a las fuentes de Apt
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
```

### Paso 2: Instalar Docker Engine

```bash
# Instalar Docker usando el repositorio apt
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

> **Nota:** Es normal que aparezca un warning al final de la instalación similar a:
> ```
> N: Download is performed unsandboxed as root, as file '/home/user/Downloads/docker-desktop.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)
> ```
> Este mensaje es normal y no afecta la instalación.

### Paso 3: Configurar permisos para usar Docker sin sudo

```bash
# Crear el grupo docker y agregar el usuario actual
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker
```

Si se presentan problemas con los permisos, a veces es necesario eliminar la carpeta de configuración de Docker:

```bash
sudo rm -rf ~/.docker
```

### Paso 4: Configurar Docker para iniciarse automáticamente

Para que Docker se inicie automáticamente con el sistema:

```bash
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

Si más adelante se requiere deshabilitar este comportamiento:

```bash
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

## Instalación de Docker Desktop (Opcional)

Docker Desktop no es necesario para trabajar con Docker, pero proporciona una interfaz gráfica útil para monitorear imágenes y contenedores.

### Paso 1: Descargar Docker Desktop

Siguiendo la [documentación oficial](https://docs.docker.com/desktop/setup/install/linux/ubuntu/){:target="_blank"}, es posible descargar directamente desde el navegador o usar `wget`:

```bash
# Ir a la carpeta de descargas
cd Downloads/

# Descargar usando wget
wget -c https://desktop.docker.com/linux/main/amd64/docker-desktop-amd64.deb
```

### Paso 2: Instalar el paquete

```bash
sudo apt update
sudo apt install ./docker-desktop-amd64.deb
```

### Paso 3: Solucionar problemas en Ubuntu 24.04

En Ubuntu 24.04 se han reportado problemas específicos con Docker Desktop. La solución se puede encontrar en [este foro de Docker](https://forums.docker.com/t/docker-desktop-not-working-on-ubuntu-24-04/141054/6).

**Solución temporal (se debe repetir en cada reinicio):**

```bash
# Dar permisos en el kernel
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0

# Reiniciar el servicio
systemctl --user restart docker-desktop
```

**Solución permanente:**

Para evitar realizar este proceso manualmente después de cada reinicio:

```bash
# Editar el archivo de configuración del kernel
sudo nano /etc/sysctl.conf
```

Agregar al final del archivo:

```
kernel.apparmor_restrict_unprivileged_userns=0
```

Aplicar los cambios:

```bash
sudo sysctl -p
```

## Verificación de la instalación

Para verificar que Docker está funcionando correctamente, se pueden ejecutar los siguientes comandos:

```bash
# Verificar versión de Docker
docker --version

# Ejecutar el contenedor de prueba
docker run hello-world
```

Si Docker Desktop está instalado, se puede iniciar desde el menú de aplicaciones o ejecutando:

```bash
systemctl --user start docker-desktop
```
