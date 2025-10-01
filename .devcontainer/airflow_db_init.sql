-- create database for airflow internal operations
create database if not exists AIRFLOW_DB;
create schema if not exists airflow;
grant all privileges on database AIRFLOW_DB to postgres;