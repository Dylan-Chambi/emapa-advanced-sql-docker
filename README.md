# Database for EMAPA's sales and purchasing control system with MySQL, replication and docker compose.

## About The Project

This project aims to create the database for a sales and purchasing control system for the administrative management of marketing of the company EMAPA. Where the products, purchase and sale details, invoicing data, information for each product and also the movement of products between warehouses.

The database schema present in this project is designed based on the document "#2 Documento Base de Contratacion" of the contract object "Adquisicion De Un Sistema Informatico Para El Control De Productos Y Ventas Para La Gerencia De Comercializacion" with CUSE file "22-0047-34-1210323-1-1", which can be found at [SICOES Official Website](https://www.sicoes.gob.bo/portal/contrataciones/busqueda/convocatorias.php?tipo=convNacional).

### Project Requirements

The current project should satisfy the following functional requirements ddefined on the previous document:
* Sells Module
* Invoices Module
* Purchases and Consignments Module
* Product Management Module
* Inventory and Warehouse Management Module
* Module Function Options
* Module for the Creation of Products with Contract and Agreement
* Support Module
* Reports module

## Requirements

- A machine with 64-bit installation (Windows, Linux, MacOS)
- Internet Acces to pull the images.
- Docker engine and docker compose installe (Linux, Windows with WSL2)
- Docker Desktop installed (MacOS, Windows, Windows with WSL2)

## Pre-steps after set up the enviroment

Go to [docker engine official install page](https://docs.docker.com/engine/install/) or follow the steps below

### Windows

1. Make sure you have WSL 2 or Hyper-V enabled and installed

2. Just download and install the .exe at this [link.](https://docs.docker.com/desktop/install/windows-install/)

### Linux

1. Update the apt package index and install packages to allow apt to use a repository over HTTPS:

```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

2. Add Docker’s official GPG key:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

3. Use the following command to set up the repository:
```bash
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

4. Update the apt package index:

```bash
sudo apt-get update
```

5. Install Docker Engine, containerd, and Docker Compose.

```bash
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```


### MacOS

1. Download and install the .exe at this [link.](https://docs.docker.com/desktop/install/mac-install/)

2. Go to downloads folder

```bash
cd ~/Downloads/
```

2. Install from the command line

```bash
sudo hdiutil attach Docker.dmg
sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
sudo hdiutil detach /Volumes/Docker
```

## Steps to Set Up the Environment

1. Clone this repository to your local machine:

```bash
git clone https://github.com/Dylan-Chambi/ProyectoBDAvanzadas.git
```

2. Navigate to the cloned directory:

```bash
cd ProyectoBDAvanzadas
```

3. Run the following command to start the containers:

```bash
docker compose up -d
```

4. Wait for the containers to start successfully. You can check the status of the containers with the following command:

```bash
docker compose ps
```

5. Once the containers are in an "Up" state, you can access them using the following addresses:

* Docker Network:
    * Subnet: 192.168.20.0/24
    * Gateway: 192.168.20.1

* db-master container:
    * IP address: 192.168.20.21
    * Hostname: db-master
    * Internal Port: 3306
    * External Port: 3306
    * User: root
    * Password: root123

* db-slave-1 container:
    * IP address: 192.168.20.22
    * Hostname: db-slave-1
    * Internal Port: 3306
    * External Port: 3307
    * User: root
    * Password: root123

* db-slave-2 container:
    * IP address: 192.168.20.23
    * Hostname: db-slave-2
    * Internal Port: 3306
    * External Port: 3308
    * User: root
    * Password: root123


6. You can use these network configuration to connect to the MySQL containers or by using **localhost** or **docker container hostnames** from your application or preferred MySQL client.

Tested clients:
    
* MySQL WorkBench
* JetBrains DataGrip
* DBeaver


## Database Schema

## UML Diagram

![UML Diagram](./doc/database_scheme_uml.svg)

This diagram can be downloaded at this [link.](https://drive.google.com/file/d/1eTbLLRmW8CyRixEevjMI6SeHs-z6a7nt/view?usp=sharing)