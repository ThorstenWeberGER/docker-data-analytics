# Use the official Apache Spark PySpark image
# alternative: docker pull apache/spark:3.5.7-scala2.12-java11-python3-ubuntu
FROM apache/spark-py:latest

USER root

# Set the working directory for the VS Code mount
WORKDIR /projectdata

# Copy the requirements file into the container
# We copy it before installing to leverage Docker's caching if only the requirements change
COPY .devcontainer/requirements.txt .

# Install system dependencies especially git because the standard git is on host, but not in the container
RUN set -ex; \
    apt-get update; \
    apt-get install -y python3-pip wget git; \
    rm -rf /var/lib/apt/lists/*

# Install core Python packages (Jupyter, Pandas, Numpy)
RUN pip install --no-cache-dir  -r requirements.txt

RUN rm requirements.txt

# Define and download the Driver Version and Spark Jars Path
# Spark uses Java Database Connectivity (JDBC)
ENV PG_DRIVER_VERSION=42.7.3 
ENV SPARK_JARS_DIR=/opt/spark/jars/
RUN set -ex; \
    wget https://jdbc.postgresql.org/download/postgresql-${PG_DRIVER_VERSION}.jar -O ${SPARK_JARS_DIR}/postgresql.jar; \
    echo "PostgreSQL driver installed successfully."