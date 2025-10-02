-- Create the Airflow database (use lowercase or quotes for uppercase)
-- no schemea required airflow will work in public schema
CREATE DATABASE "AIRFLOW_DB";

#-- Connect to the newly created database
\c "AIRFLOW_DB"

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE "AIRFLOW_DB" TO postgres;