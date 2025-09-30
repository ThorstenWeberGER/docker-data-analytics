# A Dockerized Data Analytics Platform

    The repo provides you with a stable and secure playground for typical data analytics, data engineering tasks. 

    Key components: Spark, Python, dbt, PostgreSQL, Airflow. 

    Requirement: Docker Desktop and VS Code 

**Start right away!** Simply pull this repo as a template to your local project folder and start developing. The repo contains all required files for setting up a docker container to be used together with Visual Studio Code. 

### 📂 Directory Structure

.<br>
├── .devcontainer/<br>
│   ├── Dockerfile              # PySpark/DBT container build<br>
│   ├── docker-compose.yml      # Defines all 5 services (dev, db, airflow, web, sched)<br>
│   ├── devcontainer.json       # VS Code configuration<br>
│   ├── requirements.txt        # Python libraries for dev_env<br>
│   └── .env                    # All non-secret ENV variables/paths<br>
├── code/<br>                   # Place your jupyter notebooks or python scripts here
├── data/<br>
│   └── postgres_data           # Place for persisting your docker postgres database
├── dbt_tweber<br>
│   ├── analysis                # Safe one time analysis sql scripts here<br>
│   ├── macros                  # For reusable macros scripts<br>
│   ├── models                  # Place all your transformations scripts here<br>
│   ├── seeds                   # Ingest small datasets manually<br>
│   ├── snapshows               # Safe your snapshots<br>
│   ├── tests                   # Define custom tests for your models here<br>
│   ├── dbt_project.yml         # dbt project spezification<br>
│   ├── packages.yml            # required libraries<br>
│   └── profiles.yml            # dbt connection profiles
├── README.md                   # Project documentation for developers (NEW!)<br>
└── .gitignore                  # Git Ignore file to protect secrets like passwords<br>


# Data Analytics Dev Stack 🚀

This repository provides a complete, containerized environment for building and orchestrating data pipelines using **PySpark, dbt, PostgreSQL, and Apache Airflow**.

The entire environment is configured via Docker Compose and optimized for development using VS Code Dev Containers. With this Docker image you are indipendent of cloud services.

For security reasons database credentaisl or else are placed in a .env file. Separately from any code. dbt will also use the set variables. You can also read them into Python Scripts. 

A template of .env is provided for you, but put it on .gitignore to secure your secrets.

Also dbt has been set up so start right away and connected with the PostgreSQL database where your models will materialize.

## Key Components and Services

This table details the core components, their corresponding service names, primary purposes, and the host ports used for access or communication.

| Component | Service Name | Purpose | External Port |
| :--- | :--- | :--- | :--- |
| **Spark** | `dev_env` | Spark and Python in one container. Primary VS Code. | 4040 |
| **dbt** | `dev_env` | data built tool. postgresql connector already installed. | N/A |
| **Postgres DB** | `postgres_db` | PostgreSQL database for source/staging data. | 5433 |
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

Update *.devcontainer/.env*:

* Update POSTGRES_CREDENTIALS
* UPDATE DBT_SETTINGS

Update *.gitignore*:

* Uncomment parts to protect .env from being published in Git to protect you credentials


### 3. Launch the Environment (First Time)
This environment requires two steps for the initial Airflow setup:

**Initialize Airflow Database and User**: Run the one-time service to set up Airflow's metadata DB and create the admin user. 
`docker compose -f .devcontainer/docker-compose.yml up airflow-init`

**Start All Services**: Once initialization is complete, start the full development stack. `docker compose -f .devcontainer/docker-compose.yml up -d`

**dbt packages**: Install specified packages. Move to dbt folder. `dbt deps`

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
1. In dbt_tweber (For development):
    * Connect VS Code to the dev_env container.
    * Run dbt debug or dbt run --target bigquery in the integrated terminal.

2. Via Airflow DAGs (For orchestration):
    * Use the airflow-dbt-python provider in your Python DAGs located in the ./dags folder.