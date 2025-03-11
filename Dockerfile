# Build Stage: Java & Node.js
FROM node:22 AS node-build

WORKDIR /app

# Copy package.json & package-lock.json first to leverage caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm cache clean --force
RUN rm -rf package-lock.json node_modules && npm install -g npm@latest

# Ensure Tailwind CSS is explicitly installed
RUN npm install tailwindcss@3 postcss autoprefixer

# Copy the full source code
COPY . .

# Ensure Tailwind CLI is installed before running it
RUN ls -al ./node_modules/.bin && npx tailwindcss --help && \
    npx tailwindcss -i ./src/main/webapp/Content/css/tailwind.css -o ./src/main/webapp/Content/css/output.css --minify

# Java Build Stage
FROM eclipse-temurin:17-jdk-jammy AS build

WORKDIR /app

# Copy project files
COPY --from=node-build /app /app

# Build the Java application using Maven with caching
RUN --mount=type=cache,target=/root/.m2 ./mvnw -f pom.xml clean package

# Deployment Stage
FROM ghcr.io/eclipse-ee4j/glassfish

# Copy the built WAR file to the GlassFish autodeploy directory
COPY --from=build /app/target/*.war /opt/glassfish7/glassfish/domains/domain1/autodeploy/web.war