---
title: Fundamentos de Dockerfile
permalink: /notes/es/docker-dockerfile-es
key: docker-es
lang: es 
date: 2025-06-20
modify_date: 2025-06-24
---

Un Dockerfile es un archivo de texto que contiene una serie de instrucciones para construir una imagen de Docker de manera automática. Funciona como un plano para crear entornos de contenedores consistentes y reproducibles.

## ¿Qué es un Dockerfile?

Un Dockerfile es básicamente un script que define:
- El sistema operativo base o entorno de ejecución
- Dependencias y bibliotecas de la aplicación
- Configuraciones
- Archivos a copiar dentro del contenedor
- Comandos a ejecutar durante el proceso de construcción
- Cómo debe comportarse el contenedor al iniciarse

## Estructura y Sintaxis Básica

Cada Dockerfile sigue un patrón simple: cada línea contiene una **instrucción** seguida de **argumentos**.

```dockerfile
INSTRUCCIÓN argumentos
```

### Ejemplo de un Dockerfile Simple

```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3
COPY app.py /app/
WORKDIR /app
CMD ["python3", "app.py"]
```

## Instrucciones Esenciales de Dockerfile

### FROM - Imagen Base
La instrucción `FROM` especifica la imagen base para tu contenedor. Debe ser la primera instrucción en tu Dockerfile.

```dockerfile
# Usando una imagen base oficial
FROM node:18-alpine

# Usando una versión específica
FROM python:3.11-slim

# Usando la última versión (no recomendado para producción)
FROM ubuntu:latest
```

**Buena Práctica**: Siempre especifica versiones exactas para builds reproducibles.

### RUN - Ejecutar Comandos
La instrucción `RUN` ejecuta comandos durante el proceso de construcción de la imagen. Cada instrucción `RUN` crea una nueva capa en la imagen.

```dockerfile
# Comando único
RUN apt-get update

# Múltiples comandos (preferido - crea menos capas)
RUN apt-get update && \
    apt-get install -y \
    curl \
    git \
    vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
```

### COPY vs ADD - Agregar Archivos
Ambas instrucciones copian archivos desde tu sistema local al contenedor.

```dockerfile
# COPY - copia simple de archivos (preferido)
COPY source.txt /app/destination.txt
COPY ./src /app/src

# ADD - tiene funciones adicionales (extracción automática, soporte de URLs)
ADD archive.tar.gz /app/  # Se extrae automáticamente
ADD https://example.com/file.txt /app/  # Descarga desde URL
```

**Buena Práctica**: Usa `COPY` a menos que necesites las funciones adicionales de `ADD`.

### WORKDIR - Establecer Directorio de Trabajo
Establece el directorio de trabajo para las instrucciones posteriores.

```dockerfile
WORKDIR /app
COPY . .  # Ahora copia a /app
RUN npm install  # Se ejecuta en el directorio /app
```

### ENV - Variables de Entorno
Establece variables de entorno que persisten en el contenedor en ejecución.

```dockerfile
ENV NODE_ENV=production
ENV APP_PORT=3000
ENV DATABASE_URL=postgresql://localhost:5432/mydb

# Múltiples variables en una instrucción
ENV NODE_ENV=production \
    APP_PORT=3000 \
    DEBUG=false
```

### EXPOSE - Documentar Puertos
Documenta qué puertos usa la aplicación (no los publica realmente).

```dockerfile
EXPOSE 3000
EXPOSE 8080 8443
```

### USER - Establecer Contexto de Usuario
Especifica qué usuario debe ejecutar el contenedor (buena práctica de seguridad).

```dockerfile
# Crear un usuario no root
RUN addgroup --system appgroup && \
    adduser --system --ingroup appgroup appuser

USER appuser
```

### CMD vs ENTRYPOINT - Inicio del Contenedor

#### CMD - Comando Predeterminado
Proporciona el comando de ejecución predeterminado para el contenedor. Puede ser sobrescrito.

```dockerfile
# Forma ejecutable (preferida)
CMD ["python3", "app.py"]

# Forma shell
CMD python3 app.py

# Como parámetros para ENTRYPOINT
CMD ["--config", "production.conf"]
```

#### ENTRYPOINT - Punto de Entrada Fijo
Define el comando que siempre se ejecuta. Se pueden agregar argumentos.

```dockerfile
ENTRYPOINT ["python3", "app.py"]

# Combinado con CMD para argumentos predeterminados
ENTRYPOINT ["python3", "app.py"]
CMD ["--mode", "development"]
```

### ARG - Argumentos de Construcción
Define variables que se pueden pasar durante el tiempo de construcción.

```dockerfile
ARG VERSION=latest
ARG BUILD_DATE
FROM node:${VERSION}
LABEL build-date=${BUILD_DATE}
```

Construir con argumentos:
```bash
docker build --build-arg VERSION=18-alpine --build-arg BUILD_DATE=2025-06-20 .
```

### LABEL - Metadatos
Agrega metadatos a las imágenes para documentación y organización.

```dockerfile
LABEL maintainer="desarrollador@ejemplo.com"
LABEL version="1.0"
LABEL description="Contenedor de mi aplicación"
```

## Buenas Prácticas
1. Usa Etiquetas Específicas para Imágenes Base    
 ```dockerfile
 # Bueno
 FROM node:18.17-alpine
 # Evita
 FROM node:latest
 ```

2. Minimiza las Capas
 ```dockerfile
 # Bueno - capa única
 RUN apt-get update && \
     apt-get install -y curl git && \
     apt-get clean && \
     rm -rf /var/lib/apt/lists/*
 # Evita - múltiples capas
 RUN apt-get update
 RUN apt-get install -y curl
 RUN apt-get install -y git
 ```

3. Usa .dockerignore
Crea un archivo `.dockerignore` para excluir archivos innecesarios:
   ```
 node_modules
 .git
 .gitignore
 README.md
 Dockerfile
 .dockerignore
 ```

4. Ordena las Instrucciones por Frecuencia de Cambio
Coloca las instrucciones que cambian frecuentemente al final para maximizar el uso del caché.

 ```dockerfile
 FROM node:18-alpine
 # Estos cambian poco - colócalos primero
 WORKDIR /app
 RUN apk add --no-cache git

 # Estos cambian más seguido - colócalos después
 COPY package*.json ./
 RUN npm ci --only=production

 # Esto cambia más frecuentemente - colócalo al final
 COPY . .
 ```

5. Ejecuta como Usuario No Root

 ```dockerfile
 RUN addgroup -g 1001 -S nodejs
 RUN adduser -S nextjs -u 1001
 USER nextjs
 ```

6. Usa Construcción Multi-Etapa para Imágenes Más Pequeñas
Separa las dependencias de construcción de las dependencias de ejecución.

## Patrones Comunes de Dockerfile

### Aplicación Node.js
```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
USER node
CMD ["node", "server.js"]
```

### Aplicación Python
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 8000
CMD ["python", "app.py"]
```

### Sitio Jekyll con Imagen Base de Ruby
```dockerfile
FROM ruby:3.2-alpine

# Instalar dependencias del sistema
RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm \
    tzdata

# Establecer zona horaria
ENV TZ=America/Monterrey

# Crear usuario no root
RUN addgroup -g 1000 jekyll && \
    adduser -D -u 1000 -G jekyll jekyll

# Establecer directorio de trabajo
WORKDIR /app

# Instalar Jekyll y Bundler
RUN gem install bundler jekyll

# Crear directorio del sitio y establecer permisos
RUN mkdir -p /site && chown -R jekyll:jekyll /site

# Cambiar a usuario no root
USER jekyll

# Establecer directorio de trabajo para sitios Jekyll
WORKDIR /site

# Exponer puerto de Jekyll
EXPOSE 4000

# Comando predeterminado para desarrollo
CMD ["jekyll", "serve", "--host", "0.0.0.0", "--watch", "--force_polling"]
```

## Construir y Ejecutar

### Construir una Imagen
```bash
# Construcción básica
docker build -t miapp:latest .

# Construcción con nombre de Dockerfile personalizado
docker build -f Dockerfile.prod -t miapp:prod .

# Construcción con argumentos
docker build --build-arg VERSION=1.0 -t miapp:1.0 .
```

### Ejecutar el Contenedor
```bash
# Ejecución básica
docker run miapp:latest

# Con mapeo de puertos y variables de entorno
docker run -p 3000:3000 -e NODE_ENV=production miapp:latest

# Modo interactivo
docker run -it miapp:latest /bin/bash
```

## Consejos para Solución de Problemas

1. Verifica el Contexto de Construcción
Asegúrate de que el contexto de construcción (usualmente el directorio actual) contenga todos los archivos necesarios.

2. Usa el Caché de Construcción Eficientemente
Docker almacena en caché cada capa. Si una capa no ha cambiado, reutiliza la versión en caché.

3. Depura Construcciones Fallidas
   ```bash
   # Ejecuta un contenedor intermedio para depuración
   docker run -it <id-contenedor-intermedio> /bin/bash
   ```

4. Verifica Permisos de Archivos
Los archivos copiados en los contenedores mantienen sus permisos originales.

## Consideraciones de Seguridad

1. **Usa imágenes base oficiales** de registros confiables
2. **Mantén las imágenes base actualizadas** regularmente
3. **Ejecuta como usuario no root** siempre que sea posible
4. **No incluyas secretos** en el Dockerfile
5. **Usa construcciones multi-etapa** para excluir herramientas de construcción de la imagen final
6. **Escanea las imágenes** en busca de vulnerabilidades regularmente

Comprender estos fundamentos de Dockerfile te ayudará a crear imágenes de contenedores eficientes, seguras y mantenibles para tus aplicaciones.      
{:.info}

Este artículo fue generado con ayuda de IA. El autor no es un experto real en Docker y el texto podría contener errores.
{:.warning}