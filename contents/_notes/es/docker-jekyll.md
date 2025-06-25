---
title: "Dockerfile: Ejemplos Prácticos para Espacios de Trabajo de Jekyll y STM32"
permalink: /notes/es/docker-jekyll-es
key: docker-es
modify_date: 2025-06-25
date: 2025-06-23
lang: es-MX
---

## Requisitos Previos
Antes de seguir los ejemplos, asegúrate de tener:
- Docker instalado (consulta la [Guía de instalación de Docker](https://docs.docker.com/get-docker/){:target="_blank"})
- Visual Studio Code con las extensiones **Dev Containers** y **Container Tools**
- Git para clonar repositorios
- Un conocimiento básico de interfaces de línea de comandos

# Conceptos de Jekyll

## ¿Qué es Ruby?
Ruby es un lenguaje de programación de alto nivel y de propósito general conocido por su simplicidad y sintaxis legible. Es amigable para principiantes pero lo suficientemente potente para aplicaciones a gran escala. Ruby impulsa el framework web Ruby on Rails y herramientas como Jekyll. Para usar Jekyll, necesitas tener Ruby instalado para gestionar dependencias y ejecutar comandos.

## ¿Qué es Jekyll?
Jekyll es un generador de sitios estáticos escrito en Ruby. A diferencia de los sistemas de gestión de contenido tradicionales (por ejemplo, WordPress) que dependen de bases de datos, Jekyll transforma archivos de texto plano (Markdown o HTML) en un sitio web estático. Es ideal para blogs y documentación debido a su simplicidad, velocidad e integración con GitHub Pages, que ofrece alojamiento gratuito desde un repositorio de GitHub. Jekyll admite diseños personalizables, temas, complementos y configuraciones.

## ¿Qué es un Tema de Jekyll?
Un tema de Jekyll es una colección prediseñada de plantillas, diseños, hojas de estilo y activos (por ejemplo, imágenes, fuentes) que define la apariencia y estructura de un sitio. Los temas permiten configurar rápidamente sitios web profesionales sin diseñar desde cero. Incluyen plantillas para páginas como la página principal, publicaciones de blog y archivos. Los temas se pueden personalizar mediante el archivo `_config.yml` o modificando sus archivos fuente.

## ¿Cómo Usar un Tema de Jekyll?
Puedes aplicar un tema de Jekyll de dos maneras:
1. **Tema Remoto** (compatible con GitHub Pages):
   Para alojamiento en GitHub Pages, especifica un tema publicado como una gema de Ruby en tu `_config.yml`:
   ```yaml
   theme: minima
   ```
   Jekyll aplica automáticamente el tema durante la construcción del sitio.
2. **Tema Local**:
   Para desarrollo local o personalización extensiva, clona los archivos del tema en el directorio de tu proyecto para modificar directamente los diseños, estilos e includes.


# GitHub Pages

## ¿Qué es GitHub Pages?
GitHub Pages es un servicio de alojamiento gratuito proporcionado por GitHub para publicar sitios web estáticos directamente desde un repositorio de GitHub. Es especialmente popular para alojar sitios de Jekyll, ya que soporta de forma nativa la generación de sitios estáticos de Jekyll. GitHub Pages te permite crear sitios personales, de proyectos u organizacionales, lo que lo hace una excelente opción para blogs, portafolios o documentación.

## ¿Cómo Funciona GitHub Pages con Jekyll?
GitHub Pages construye y sirve automáticamente sitios de Jekyll cuando subes tu repositorio a GitHub. Puedes usar un tema soportado (vía `_config.yml`) o personalizar tu sitio con archivos de temas locales. Los archivos estáticos generados se sirven desde una rama específica (típicamente `gh-pages` o `main`) o una carpeta `/docs` en tu repositorio.

## ¿Por Qué Usar GitHub Pages con Docker?
Usar Docker para el desarrollo local de Jekyll asegura que tu entorno coincida con el proceso de construcción de GitHub Pages, evitando conflictos de dependencias. Puedes probar tu sitio localmente en un contenedor, subir cambios a GitHub y dejar que GitHub Pages maneje el despliegue. Este flujo de trabajo agiliza el desarrollo y garantiza consistencia entre las vistas previas locales y el sitio en vivo.

Este blog usa Jekyll con un [Tema TeXt](https://kitian616.github.io/jekyll-TeXt-theme/docs/en/quick-start){:target="_blank"} personalizado, desarrollado localmente en un contenedor Docker y desplegado vía GitHub Pages.
{:.info}

# Crear un Contenedor con Docker
## Dockerfile para Jekyll

```dockerfile
FROM ubuntu:22.04

# Configurar zona horaria (evita prompts interactivos)
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalar dependencias y herramientas del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline6-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    apt-utils \
    sudo \
    tzdata \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Configurar usuario
ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /home/$USERNAME

# Configurar Ruby con rbenv
ENV RBENV_ROOT="/home/$USERNAME/.rbenv"
ENV RUBY_VERSION="3.4.4"
ENV PATH="${RBENV_ROOT}/bin:${RBENV_ROOT}/shims:$PATH"

# Instalar rbenv y ruby-build
RUN git clone https://github.com/rbenv/rbenv.git ${RBENV_ROOT} \
    && git clone https://github.com/rbenv/ruby-build.git ${RBENV_ROOT}/plugins/ruby-build

# Configurar bash para cargar rbenv e historial persistente
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
    && echo 'eval "$(rbenv init -)"' >> ~/.bashrc \
    && echo 'export HISTFILE=/home/remoteUser/.bash_history_volume/.bash_history' >> ~/.bashrc \
    && echo 'export HISTSIZE=10000' >> ~/.bashrc \
    && echo 'export HISTFILESIZE=10000' >> ~/.bashrc

# Instalar Ruby
RUN rbenv install ${RUBY_VERSION} \
    && rbenv global ${RUBY_VERSION} \
    && rbenv rehash

# Instalar Jekyll y Bundler
RUN gem install bundler jekyll \
    && rbenv rehash

# Crear directorios para volúmenes montados y gemas de Bundler
RUN mkdir -p /home/$USERNAME/.bash_history_volume \
    && mkdir -p /home/$USERNAME/.bashrc.d \
    && mkdir -p /home/$USERNAME/.rbenv/gems \
    && chown -R $USERNAME:$USERNAME /home/$USERNAME/.rbenv/gems

# Configurar directorio de trabajo para proyectos
WORKDIR /workspace

# Exponer el puerto predeterminado de Jekyll
EXPOSE 4000

# Comando predeterminado
CMD ["bash"]
```

## Construir y Ejecutar el Contenedor
1. **Construir la imagen de Docker**:
   ```bash
   docker build -t jekyll-site .
   ```
2. **Ejecutar el contenedor** (monta tu directorio de proyecto en `/workspace`):
   ```bash
   docker run -it -p 4000:4000 -v $(pwd):/workspace jekyll-site
   ```
3. Ejecuta el script `run-once.sh` para configurar el entorno de Jekyll:
   ```bash
   ./run-once.sh
   ```
   *Nota*: Asegúrate de que `run-once.sh` exista en tu proyecto. Este sitio usa el siguiente script:

   ```bash
   #!/bin/bash
   # Mostrar la versión actual de Ruby
   echo "Versión de Ruby"
   ruby -v
   # Mostrar la versión actual de Jekyll
   echo "Versión de Jekyll"
   jekyll -v
   # Actualizar gemas
   echo "bundle install"
   bundle install
   echo "bundle update"
   bundle update
   ```

4. Inicia el servidor de desarrollo de Jekyll con recarga en vivo:
   ```bash
   bundle exec jekyll serve --host 0.0.0.0 --port 4000 --baseurl "/risingembeddedmx" --livereload
   ```

## Usar Docker Compose
Docker Compose es una herramienta para definir y gestionar aplicaciones Docker de múltiples contenedores usando un archivo YAML. Permite configurar servicios, redes y volúmenes en un solo archivo, y luego iniciar o detener la aplicación completa con comandos simples. Cada servicio representa típicamente un contenedor, y Docker Compose simplifica tareas como ejecutar múltiples contenedores (por ejemplo, una aplicación web y una base de datos) con configuraciones predefinidas, asegurando entornos consistentes.

### Archivo YAML
Otra forma de construir y acceder al contenedor para este sitio es usando la herramienta Docker Compose. Se creó un archivo YAML:
```yaml
services:
  jekyll:
    build: .
    container_name: jekyll-site
    ports:
      - "4000:4000"
    volumes:  
      # Montar el directorio actual en /workspace en el contenedor
      # y usar volúmenes nombrados para datos persistentes
      # para rbenv, historial de bash y configuración de bash
      # Esto permite mantener los archivos y configuraciones del sitio Jekyll
      - .:/workspace
      - jekyll-rbenv:/home/remoteUser/.rbenv
      - jekyll-history:/home/remoteUser/.bash_history_volume
      - jekyll-bash-config:/home/remoteUser/.bashrc.d
    environment:
      - TZ=America/Monterrey
      - BUNDLE_PATH=/home/remoteUser/.rbenv/gems
    stdin_open: true
    tty: true
    working_dir: /workspace
    command: /bin/bash

volumes:
  jekyll-rbenv:
    driver: local
  jekyll-history:
    driver: local
  jekyll-bash-config:
    driver: local
```

Con estas configuraciones, el proceso para usar el sitio es el siguiente:

1. La primera vez, construye el contenedor:
   ```bash
   docker-compose up --build -d
   ```
2. Inicia el contenedor:
   ```bash
   docker-compose up -d
   ```

3. Ejecuta un bash dentro del contenedor:
   ```bash
   docker-compose exec jekyll bash
   ```
4. La primera vez en el contenedor, ejecuta el script inicial:
   ```bash
   ./run-once.sh
   ```

5. Compila el sitio con la siguiente línea:
   ```bash
   bundle exec jekyll serve --host 0.0.0.0 --port 4000 --baseurl "/risingembeddedmx" --livereload
   ```

6. El sitio está disponible en: **http://127.0.0.1:4000/risingembeddedmx/notes/es/docker-jekyll-es**.

7. Cuando tus cambios estén listos, presiona <kbd>Ctrl</kbd>+<kbd>C</kbd> para detener el proceso.

8. Sal del contenedor escribiendo:
   ```bash
   exit
   ```

9. Apaga el contenedor:
   ```bash
   docker-compose down
   ```

## Usar Jekyll con VS Code
Este blog usa Docker para compilar el sitio Jekyll localmente y previsualizar el contenido antes de publicarlo. Para integrarlo con VS Code, instala estas extensiones:
- [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers){:target="_blank"}
- [Container Tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-containers){:target="_blank"}

En Visual Studio Code, puedes usar el contenedor directamente desde la interfaz gráfica. Una vez instaladas las extensiones y preparado el Dockerfile, sigue estos pasos para ejecutar tu entorno dentro de un contenedor:

1. Abre VS Code y presiona <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd> para acceder a la paleta de comandos.

2. Selecciona **Dev Containers: Open Folder in Container**.

3. Elige la carpeta de tu proyecto y haz clic en **Abrir**.

4. Cuando se te solicite, selecciona **Add configuration to user data folder**.

5. Elige **From Dockerfile** como fuente de configuración.

6. Acepta las configuraciones predeterminadas en los prompts siguientes.

7. Espera a que el contenedor se construya e inicialice.

8. Ejecuta el script `run-once.sh` para configurar el entorno de Jekyll:
   ```bash
   ./run-once.sh
   ```
9. Inicia el servidor de desarrollo de Jekyll con recarga en vivo:
   ```bash
   bundle exec jekyll serve --livereload
   ```

10. (Opcional) Construye el sitio para producción:
   ```bash
    JEKYLL_ENV=production bundle exec jekyll build
   ```

11. Accede al sitio en `http://localhost:4000` (ajusta la ruta si tu sitio usa una URL base, por ejemplo, `http://localhost:4000/risingembeddedmx`).

# Contenedor para Compilar Proyectos STM32
Esta sección muestra un Dockerfile para compilar proyectos de microcontroladores STM32, basado en el [proyecto openblt para la placa Bluepill](https://github.com/razielgdn/black-and-blue-pill-plus-with-openBLT){:target="_blank"}.

## Dockerfile para STM32

```dockerfile
# Descripción: Dockerfile para un entorno de desarrollo para aplicaciones STM32.
FROM ubuntu:22.04
# Configurar zona horaria (evita prompts interactivos)
ENV TZ="America/Monterrey"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Instalar dependencias
# Esta sección instala paquetes esenciales para construir y depurar aplicaciones STM32.
# Incluye make, cmake, git, gcc, g++ y otras herramientas necesarias.
# También limpia el caché de apt para reducir el tamaño de la imagen.
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    make \
    wget \
    tzdata \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Instalar ARM GNU Toolchain para compilar aplicaciones STM32
# Nota: Esta es una versión específica; puedes actualizarla según sea necesario.
# La toolchain se descarga desde el sitio oficial de ARM Keil.
RUN mkdir -p /opt && \
    wget --no-check-certificate https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu/14.2.rel1/binrel/arm-gnu-toolchain-14.2.rel1-x86_64-arm-none-eabi.tar.xz -O /opt/arm-gnu-toolchain.tar.xz && \
    tar -xf /opt/arm-gnu-toolchain.tar.xz -C /opt && \
    rm /opt/arm-gnu-toolchain.tar.xz

# Configurar usuario
# Esta sección crea un usuario no root con privilegios de sudo.
# Se recomienda ejecutar contenedores como usuarios no root por razones de seguridad.
# Puedes cambiar USERNAME, USER_UID y USER_GID según sea necesario.
ARG USERNAME=remoteUser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME
WORKDIR /workspace

# Comando predeterminado
CMD ["/bin/bash"]
```

### Construir y Ejecutar el Contenedor
1. **Construir la imagen de Docker**:
   ```bash
   docker build -t stm32-dev .
   ```
2. **Ejecutar el contenedor**:
   ```bash
   docker run -it -v $(pwd):/workspace stm32-dev
   ```

## Usar el Contenedor STM32 con VS Code

1. Abre VS Code y presiona <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd>.
2. Selecciona **Dev Containers: Open Folder in Container**.
   <img src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/docker/image01.png"/>
3. Elige la carpeta de tu proyecto (por ejemplo, el repositorio OpenBLT).
   <img src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/docker/image02.png"/>
4. Selecciona **Add configuration to user data folder**.
5. Elige **From Dockerfile**.
6. Acepta las configuraciones predeterminadas.
7. Espera a que el contenedor esté listo.
   <img src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/docker/image02.png"/>
8. Abre una terminal y navega al directorio del proyecto:
   ```bash
   cd openBLT_STM32F103_Bluepill_plus_GCC/
   make clean all
   ```
9. La salida de la compilación generará los binarios necesarios para el proyecto STM32.
   *Ejemplo de salida*
   <img src="https://raw.githubusercontent.com/razielgdn/risingembeddedmx/main/assets/images/docker/image04.png"/>

## Consejos para Solución de Problemas
- **Conflictos de Puertos**: Si el puerto 4000 está en uso, cambia el mapeo de puertos (por ejemplo, `-p 4001:4000`) y accede al sitio en `http://localhost:4001`.
- **Problemas de Permisos**: Asegúrate de que tu usuario tenga acceso al daemon de Docker (`sudo usermod -aG docker $USER`).
- **Falta `run-once.sh`**: Crea el script si no está incluido en tu repositorio.
- **Errores de Toolchain**: Verifica que la URL de la toolchain de ARM sea válida, ya que las versiones pueden cambiar.

## Conclusión
Usar Docker para proyectos de Jekyll y STM32 asegura entornos de desarrollo consistentes y aislados. GitHub Pages simplifica el despliegue de sitios Jekyll, mientras que Docker garantiza que el desarrollo local coincida con el entorno de producción. El contenedor STM32 agiliza la programación embebida. Al integrarlo con Dev Containers de VS Code, puedes mejorar tu flujo de trabajo con una configuración mínima.