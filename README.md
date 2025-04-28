# 🏠 MysticHome Creations

# Introduction
This project is a full-stack application that uses Docker to manage the environment. The application runs GlassFish, PHPMyAdmin, and the main application, all within Docker containers.

---

## Disclaimer

This project is inspired by the design, structure, and content of IKEA.  
It is intended **solely for educational purposes** and **has no affiliation, endorsement, or official connection** with Inter IKEA Systems B.V. or its related companies.

All trademarks, product names, and company names or logos cited herein are the property of their respective owners.

## 🚀 Key Components:
- 🌐 **Main App** — [http://localhost:8080](Web Browser)
- 🔧 **GlassFish Manager** — [http://localhost:4848](Web Browser)
- 🛢️ **PHPMyAdmin** — [http://localhost:8081](Web Browser)
- 🧠 **Redis CLI** — `docker exec -it redis redis-cli` (via Terminal)
---


## ⚙️ Setup Instructions - Execute via terminal

Follow these steps to get the project running locally.

### 1. 🔁 Clone the Repository

First, clone the repository to your local machine:

```cmd
git clone https://github.com/Cstan0824/mystichomecreation.git
```

### 2. 🐳 Ensure Docker is Installed

Make sure you have Docker and Docker-Compose(Normally installed along with the Docker installer) installed on your machine. 
If Docker is not installed, you can download and install it from [Docker's official website](https://www.docker.com/get-started).
You can check if Docker is installed by running:
```cmd
docker --version
```

and to check if Docker-Compose is installed:
```cmd
docker-compose --version
```

To run Docker:
- Open Start Menu, search for Docker Desktop, Open it, and open the application.


### 3. ⚙️ Build & Run Containers

To start the full stack:

```bash
docker-compose down         # Stop any existing containers
docker build -t mystichome .  # Build the Docker image
docker-compose up -d         # Run containers in detached mode
```

To stop all containers:

```bash
docker-compose down
```


### 4. 🌐 Access Services

| Service          | URL                               | Credentials (username / password)               |
|------------------|-----------------------------------|----------------------------|
| 🐬 PHPMyAdmin     | http://localhost:8081             | `root / root` or `user / user1234` |
| 🐳 GlassFish Admin| http://localhost:4848             | `admin / admin`            |
| 🧾 Main App       | http://localhost:8080             | Uses Mock Data: `<ANY_USERNAME> / sa `              |



### 5. 📋 Troubleshooting

Having issues? Here are common problems and how to resolve them:

#### 🐳 Docker isn’t running:

  - Ensure **Docker Desktop** is open and running in the background.
  - Run the following to verify:
    
  ```bash
  docker info
  ```
  
  If it returns an error, restart Docker Desktop or your system.

#### 🛑 Port already in use:

  If you see an error like `port 8080 is already allocated`:
  
  - Another application is using the port. Identify it with:
  
  ```bash
  netstat -ano | findstr :8080
  ```
  
  - Or on PowerShell:
  
  ```bash
  Get-Process -Id (Get-NetTCPConnection -LocalPort 8080).OwningProcess
  ```
  
  - Kill the process or change the port in `docker-compose.yml`.

#### 🐘 Database connection fails:

  - MySQL container may take time to initialize on first boot.
  - Wait a few seconds before accessing PHPMyAdmin or the main app.
  - Check logs for readiness:
  
  ```bash
  docker logs mystichomecreation-mysql_db-1
  ```

#### 🧾 App not responding in browser:

  - Ensure GlassFish is up and WAR is deployed:
  
  ```bash
  docker logs mystichomecreation-mystichome-1
  ```
  
  - If needed, redeploy manually:
  
  ```bash
  docker cp ./target/mystichomecreation.war mystichome:/opt/glassfish7/glassfish/domains/domain1/autodeploy/web.war
  ```

#### 🔁 Docker changes not applying:

  - Try a full rebuild:
  
  ```bash
  docker-compose down --volumes
  docker-compose build --no-cache
  docker-compose up -d
  ```

---

### 🧪 Diagnostic Commands

```bash
docker ps                      # Check running containers
docker-compose logs           # Full logs of all services
docker logs <container>       # Logs for a single container
docker inspect <container>    # Inspect container config
docker exec -it <container> sh  # Open interactive shell in a container
```

---

### ⚙️ Netbeans Users Quick Guide
Easily run Docker Compose commands from within NetBeans using the **Docker Manager** plugin.

### ⚙️ Installation

1. Open **NetBeans** and navigate to `Tools → Plugins`.
2. Go to the **Downloaded** tab and click **Add Plugins...**.
3. Select the `docker-manager.nbm` file located in the `.netbean-25` directory of this repository.
4. Click **Install** and complete the installation steps.


### 🚀 Getting Started

1. Open your project in NetBeans via `File → Open Project`.
2. Locate the **Build** toolbar at the top of the IDE.
3. Click the 🐳 **Execute Docker Compose** button.

This will automatically:
- Stop any running containers (`docker-compose down`)
- Rebuild the Docker image (`docker build`)
- Start the containers (`docker-compose up`)

📝 Output logs will be shown in the **Docker Plugin Output** tab.  
You can open it via `Window → Output` or by pressing `Ctrl + 4`.

This message indicates Success Deployment: 
```
[#|2025-04-28T09:02:06.035339Z|INFO|GF7.0.23|jakarta.enterprise.system.tools.deployment.autodeploy|_ThreadID=82;_ThreadName=AutoDeployer;_LevelValue=800;_MessageID=NCLS-DEPLOYMENT-02035;| [AutoDeploy] Successfully autodeployed : /opt/glassfish7/glassfish/domains/domain1/autodeploy/web.war.|#]
```



### 🛑 Stopping Containers

Click the **Stop Docker Compose** button to shut down all running containers gracefully.

---

### ⚙️ VS Code Users Quick Guide

This project includes custom **VS Code Tasks** defined in `.vscode/tasks.json` for easier container management and hot reload setup.

You can run them via `Terminal → Run Task` or `Ctrl + Shift + P → Tasks: Run Task`.



### 🔁 Java Hot Reload

Rebuilds the application WAR, copies it into the GlassFish container, and recompiles TailwindCSS.

```bash
./mvnw clean package
docker cp ./target/mystichomecreation.war mystichome:/opt/glassfish7/glassfish/domains/domain1/autodeploy/web.war
docker run --rm -v .:/app -w /app node:22 sh -c "
  rm -rf node_modules package-lock.json;
  npm cache clean --force;
  npm install -g npm@latest;
  npm install tailwindcss@3 postcss autoprefixer;
  npx tailwindcss -i ./src/main/webapp/Content/css/tailwind.css -o ./src/main/webapp/Content/css/output.css --minify
"
```

### 🚀 Java Build/Start Containers

Stops any existing containers, rebuilds the Docker image, and starts the full stack using Docker Compose.

```bash
docker-compose down
docker build -t mystichome .
docker-compose up
```

This message indicates Success Deployment: 
```
[#|2025-04-28T09:02:06.035339Z|INFO|GF7.0.23|jakarta.enterprise.system.tools.deployment.autodeploy|_ThreadID=82;_ThreadName=AutoDeployer;_LevelValue=800;_MessageID=NCLS-DEPLOYMENT-02035;| [AutoDeploy] Successfully autodeployed : /opt/glassfish7/glassfish/domains/domain1/autodeploy/web.war.|#]
```

### 🛑 Java Stop Containers

Stops all running containers defined in `docker-compose.yml`.

```bash
docker-compose down
```

---

### 📎Additional Notes
📌 All tasks are executed in PowerShell and configured to display output in a shared terminal panel with automatic clearing enabled.

📌 For more information, kindly refer to `tancs-wm23@student.tarc.edu.my` 
