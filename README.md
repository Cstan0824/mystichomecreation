# MysticHome Creations

# Introduction
This project is a full-stack application that uses Docker to manage the environment. The application runs GlassFish, PHPMyAdmin, and the main application, all within Docker containers.

### Key Components:
- **GlassFish Manager**: Accessed via localhost on port `4848`.
- **PHPMyAdmin**: Accessed via localhost on port `8081`.
- **Main Application**: Accessed via localhost on port `8080`.

## Setup Instructions

Follow these steps to get the project running locally.

### 1. Clone the Repository

First, clone the repository to your local machine:

```cmd
git clone https://github.com/your-username/your-repo-name.git
```
### 2. Ensure Docker is Installed

Make sure you have Docker installed on your machine. 
If Docker is not installed, you can download and install it from [Docker's official website](https://www.docker.com/get-started).
You can check if Docker is installed by running:
```cmd
docker --version
```
To run Docker:
- Open Start Menu, search for Docker Desktop, Open it, and open the application.


### 3.  Running Docker Containers with `docker-compose`

This project uses Docker Compose to manage multi-container Docker applications. To start the application, follow these steps:

1. Navigate to the project directory (if you haven't already):

   ```cmd
   cd your-repo-directory
   ```
2. Run the following command to start the containers using `docker-compose`:
	```cmd
 	docker-compose up -d
 	```

	 This command will:
	- Build the Docker images (if necessary).
	- Start the GlassFish server, PHPMyAdmin, and the main application in separate Docker containers.
The containers will be started in the background. You can check the logs to monitor the output or confirm that everything is running properly.
 - To ensure the container is started, run:
   	```cmd
    docker ps
    ```
   
   
	The expected output is:
	```cmd
 	CONTAINER ID   IMAGE                   COMMAND                   CREATED         STATUS         PORTS                                                                                                                            NAMES
	79e8d214714e   mystichome:3.0.9.5      "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   3700/tcp, 3820/tcp, 3920/tcp, 6666/tcp, 0.0.0.0:4848->4848/tcp, 7676/tcp, 8181/tcp, 8686/tcp, 9009/tcp, 0.0.0.0:8080->8080/tcp   mystichomecreation-mystichome-1
	e91507e591b9   phpmyadmin/phpmyadmin   "/docker-entrypoint.…"   7 seconds ago   Up 6 seconds   0.0.0.0:8081->80/tcp                                                                                                             mystichomecreation-mysql_admin-1
	a79170afaff1   mysql:latest            "docker-entrypoint.s…"   7 seconds ago   Up 6 seconds   0.0.0.0:3306->3306/tcp, 33060/tcp                                                                                                mystichomecreation-mysql_db-1
 	```
	This command will:
    - Present all running containers
	
	To stop the containers, you can run:
	
	```cmd
	docker-compose down
 	```

 
### 4. Usage

- **GlassFish Manager (Port 4848)**: [http://localhost:4848](http://localhost:4848)
   - After accessing GlassFish Manager, you can manage your main applications, including deployment.
   - Default credentials
     	- username: admin
     	- password: admin

- **PHPMyAdmin (Port 8081)**: [http://localhost:8081](http://localhost:8081)
   - This service provides an intuitive interface for managing your databases. 
   - You can also run SQL queries directly from the PHPMyAdmin interface.
   -  Default credentials (root)
     	- username: root
        - password: root
    - Default credentials (users)
      	- username: user
      	- password: user1234

- **Main Application (Port 8080)**: [http://localhost:8080](http://localhost:8080)
   - The main application is available on this port.

### 5. Troubleshooting

- If you encounter issues starting the containers, ensure that Docker is running correctly and that no port conflicts exist (i.e., ensure ports `4848`, `8081`, and `8080` are not being used by other services).
- To view more detailed error messages and logs, use the following command:

   ```cmd
   docker-compose logs
   ```
- To view specific container error messages and logs, use the following command:
  	- Use this command to view all running container:
	```cmd
 	docker ps
 	```
 	- Use this command to view container error messages and logs
	```cmd
	docker logs <docker_container_id>
 	```
 
- If you need to reset the environment, stop the containers, remove them, and rebuild:
   ```cmd
   docker-compose down
   docker-compose up --build
   ```

### Additional Notes

- Make sure that the system where you're running this setup has Docker and Docker Compose installed. You can verify this by running:

   ```bash
   docker-compose --version
   ```

