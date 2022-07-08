# NSAPH Data Platform
 **User and Development Documentation**

<!-- toc -->

- [Introduction](#introduction)
  - [Overview](#overview)
  - [Using the Database](#using-the-database)
  - [Glossary](#glossary)
- [Structure](#structure)
  - [Deploying the Platform](#deploying-the-platform)
  - [General Packages](#general-packages)
  - [Data Ingestion and Processing Pipelines](#data-ingestion-and-processing-pipelines)

<!-- tocstop -->

## Introduction

### Overview
                                               
This data platform is intended for development and deployment of 
ETL/ELT pipelines that includes complex data processing and data 
cleansing workflows. Complex workflows require a workflow language, 
and we have chosen 
[Common Workflow Language (CWL)](https://www.commonwl.org/).
For deployment, we have selected CWL-Airflow to take advantage of the excellent
user interface allowing for the control of the actual execution process. 
The
data is eventually stored in a PostgreSQL DBMS; many processing steps 
in the 
[included data processing pipelines](#data-ingestion-and-processing-pipelines) 
are being
run inside the database itself. 

The data platform is based on a combination of an 
[Infrastructure as Code (IaC) approach](https://en.wikipedia.org/wiki/Infrastructure_as_code) 
and CWL. Beside tools written in widely used languages such as 
Python, C/C++ and
Java, the platform also supports tools written in R and PL/pgSQL.
Data platform consists of 
several [general packages](#general-packages), 
a [package to deploy the platform](#deploying-the-platform)
using 
[CWL-Airflow](https://cwl-airflow.readthedocs.io/en/latest/)
and a number of data ingestion pipelines. 
[Data ingestion pipelines](#data-ingestion-and-processing-pipelines)
process data from external sources and load it into the database.

### Using the Database

For a sample to query the database, please look at
[Sample Query](core-platform/doc/SampleQuery.html)

A discussion of querying of health data can be found in 
[this document](pipelines/cms/doc/QueringMedicaid.html)

### Glossary

Included 
[Glossary](glossary.md) provides some information about
acronyms and other terms used throughout this documentation.
                       
## Structure

### Deploying the Platform

The data platform is deployed as a set of Docker containers orchestrated by
Docker-Compose. Conda (package manager) environment files and Python
requirements are used to build Docker containers satisfying the dependencies.
Specific parameters can be customized via environment files and shell script
callbacks.

See [Deployment](deployment)

### General Packages

#### NSAPH Utilities

<!-- section overview from nsaph_utils -->


The nsaph_utils package is intended to hold python 
code that will be useful
across multiple portions of the NSAPH pipelines.

The included utilities are developed to be as independent of
specific infrastructure and execution environment as possible.

Included utilities:

* Interpolation code
* Reading FST files from Python
* various I/O wrappers
* An API and CLI framework
* QC Framework
* Documentation utilities to simplify creation of consistent 
 documentation for NSAPH platform 


<!-- end of section overview from nsaph_utils -->

[Package Description](utils)


#### Core Platform

<!-- section overview from nsaph -->

The data platform provides generic infrastructure for NSAPH Data Platform
It depends on nsaph_util package, but it augments it
with APIs and command line utilities dependent on the infrastructure 
and the environment. For instance, its components assume presence of PostgreSQL
DBMS (version 13 or later) and CWL runtime environment.

The package is under intensive development, therefore its 
development branches contain some obsolete modules and utilities.
The project structure can also be in flux.

<!-- end of section overview from nsaph -->

[Package Description](core-platform)


#### GIS Utilities

<!-- section overview from gis -->


This library contains several packages, aimed to work with census shape files.

<!-- end of section overview from gis -->

[Package Description](gis)


   
### Data Ingestion and Processing Pipelines

| Pipeline | Documentation                                   |
|----------|-------------------------------------------------|
| EPA | [EPA Pipelines](pipelines/epa/index.html)       |
| Census | [Census Package](pipelines/census/index.html)   |
| Gridmet | [Gridmet package](pipelines/gridmet/index.html) |
| CMS | [Medicaid Piepline](pipelines/cms/index.html)  |
