# ADAPT IS REQUIRED


### 📂 Final Project Directory Structure
This structure contains your PySpark development environment, the PostgreSQL source/destination, Airflow for orchestration, and all required configuration files.

.<br>
├── .devcontainer/<br>
│   ├── Dockerfile              # PySpark/DBT container build
│   ├── airflow.Dockerfile      # Airflow container build (with providers)
│   ├── docker-compose.yml      # Defines all 5 services (dev, 2xDB, web, sched)
│   ├── devcontainer.json       # VS Code configuration
│   ├── requirements.txt        # Python libraries for dev_env
│   └── environment.txt         # All non-secret ENV variables/paths
├── dags/                       # Airflow DAG files go here
├── README.md                   # Project documentation for developers (NEW!)
└── profiles.yml                # DBT connection configuration


TODO:
- postgresql password needs to be put in .secrets folder



# Data Engineering Dev Stack 🚀

This repository provides a complete, containerized environment for building and orchestrating data pipelines using **PySpark, dbt, PostgreSQL, and Apache Airflow**.

The entire environment is configured via Docker Compose and optimized for development using VS Code Dev Containers.

## Key Components and Services

This table details the core components, their corresponding service names, primary purposes, and the host ports used for access or communication.

| Component | Service Name | Purpose | Host Port |
| :--- | :--- | :--- | :--- |
| **PySpark/DBT CLI** | `dev_env` | Primary VS Code connection; run PySpark code & dbt commands. | N/A |
| **Application DB** | `app_db` | PostgreSQL database for source/staging data. | 5433 |
| **Airflow Webserver** | `airflow-webserver` | Airflow UI for managing DAGs. | 8080 |
| **Airflow Scheduler** | `airflow-scheduler` | Manages DAG scheduling and task execution. | N/A |
| **Airflow DB** | `airflow_db` | PostgreSQL database for Airflow metadata. | 5434 |

## Quick Start Guide

### 1. Prerequisites

* Docker Desktop: Installed and running.
* VS Code: With the Dev Containers extension installed.
* GCP Service Account Key: A JSON key file for BigQuery access (used by both dev_env and Airflow).

### 2. Configuration Setup

Before launching, you MUST update two files with your credentials and paths:

Update *.devcontainer/environment.txt*:

* Set the POSTGRES_PASSWORD (e.g., your_simple_dev_password).
* Set the BIGQUERY_CREDS_HOST_PATH to the absolute path of your local BigQuery JSON key file.

Update *profiles.yml*:

* Replace [YOUR_GCP_PROJECT_ID] with your actual Google Cloud Project ID.

### 3. Launch the Environment (First Time)
This environment requires two steps for the initial Airflow setup:

**Initialize Airflow Database and User**: Run the one-time service to set up Airflow's metadata DB and create the admin user.

`docker compose -f .devcontainer/docker-compose.yml up airflow-init`

**Start All Services**: Once initialization is complete, start the full development stack.

`docker compose -f .devcontainer/docker-compose.yml up -d`

### 4. Access Points

| Component | URL / Access | Credentials (If Required) |
| :--- | :--- | :--- |
| **VS Code Dev** | Reopen VS Code in container mode. | N/A |
| **Airflow UI** | `http://localhost:8080` | Username: `admin`, Password: `admin` |
| **PostgreSQL DB** | Host: `localhost`, Port: `5433` | User: `myuser`, Pass: (from `environment.txt`) |
| **Spark UI** | `http://localhost:8081` | N/A |


## Airflow Connection Management

The Airflow setup automatically creates one source connection via environment variables:
* **Connection ID**	: postgres_source
* **Type**: Postgres
* **Host**: db
* **Purpose**: Connecting to your application data (PostgreSQL).
			
### REQUIRED ACTION: Create BigQuery Connection

You must manually create the BigQuery connection in the Airflow UI after the webserver starts:

1. Go to Admin → Connections.
2. Create a new connection with Connection ID: bigquery_default.
3. Set Connection Type: Google Cloud.
4. Use the Service Account Key File Path option, pointing it to the key file's location inside the Airflow container: /opt/airflow/.dbt/profiles.yml. (Note: This is a simplification; for security, the key should be mounted separately to Airflow and referenced.)
5. Set your Project ID.

### Running DBT Commands
You have two options for running dbt:
1. In dev_env (Recommended for Testing):
    * Connect VS Code to the dev_env container.
    * Run dbt debug or dbt run --target bigquery in the integrated terminal.

2. Via Airflow DAGs (For Orchestration):
    * Use the airflow-dbt-python provider in your Python DAGs located in the ./dags folder.