# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# defecto 1
FROM public.ecr.aws/lambda/nodejs:20 AS builder

# defecto 2
COPY package.json package-lock.json ./

# defecto 3
RUN npm ci
COPY src/ src/
RUN npm run build

FROM public.ecr.aws/lambda/nodejs:20

COPY --from=builder /var/task/dist/ /var/task/dist/

CMD ["dist/handler.handler"]
