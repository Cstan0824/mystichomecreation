# Build Stage: Java & Node.js
FROM node:22 AS node-build

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm cache clean --force
RUN rm -rf package-lock.json node_modules && npm install -g npm@latest

# Install Tailwind
RUN npm install tailwindcss@3 postcss autoprefixer

# Copy Tailwind config & source code
COPY tailwind.config.js postcss.config.js ./
COPY . .

RUN ls -al ./node_modules/.bin && npx tailwindcss --help && \
    npx tailwindcss -i ./src/main/webapp/Content/css/tailwind.css -o ./src/main/webapp/Content/css/output.css --minify

# Java Build Stage
FROM eclipse-temurin:17-jdk-jammy AS build

# ✅ Install CA certs to fix SSL issues
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=node-build /app /app

# Build with Maven (cached dependencies)
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f pom.xml clean package

# Deployment Stage
FROM ghcr.io/eclipse-ee4j/glassfish

# ✅ Install CA certs to fix Stripe SSL in runtime
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates ca-certificates-java && \
    update-ca-certificates -f && \
    rm -rf /var/lib/apt/lists/*
# Copy WAR to autodeploy
COPY --from=build /app/target/*.war /opt/glassfish7/glassfish/domains/domain1/autodeploy/web.war
