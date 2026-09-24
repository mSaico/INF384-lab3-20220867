# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# --- Etapa 1: Construcción (Builder) ---
# Defecto 1 corregido: Versión fija de Node (20)
FROM public.ecr.aws/lambda/nodejs:20 AS build

# Aplicamos la restricción del profesor: todo el trabajo de esta etapa se hará en /build
WORKDIR /build

# Defecto 2 y 3 corregidos: Copiar manifiestos primero e instalar con npm ci
COPY package.json package-lock.json ./
RUN npm ci

# Copiar el código fuente de la aplicación
COPY src/ src/

### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js

# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]
