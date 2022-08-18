# NSAPH Data Platform: Documentation Home
 **User and Development Documentation**

 [Index](genindex)

```{contents}
---
local:
---
```

## Introduction to Data Platform

### What is Data Platform?  
                                               
This data platform is intended for development and deployment of 
ETL/ELT pipelines that includes complex data processing and data 
cleansing workflows. Complex workflows require a workflow language, 
and we have chosen 
[Common Workflow Language (CWL)](https://www.commonwl.org/).
For deployment, we have selected CWL-Airflow to take advantage of the excellent
user interface allowing for the control of the actual execution process. 
The data is eventually stored in a PostgreSQL DBMS; many processing steps 
in the [included data processing pipelines](#data-ingestion-and-processing-packages-and-pipelines) 
are being run inside the database itself. 

The data platform is based on a combination of an 
[Infrastructure as Code (IaC) approach](https://en.wikipedia.org/wiki/Infrastructure_as_code) 
and CWL. Beside tools written in widely used languages such as 
Python, C/C++ and
Java, the platform also supports tools written in R and PL/pgSQL.
Data platform consists of several [general packages](#general-packages), 
a [package to deploy the platform](#deploying-the-platform)
using [CWL-Airflow](https://cwl-airflow.readthedocs.io/en/latest/)
and a number of data ingestion pipelines. 
[Data ingestion pipelines](#data-ingestion-and-processing-packages-and-pipelines)
process data from external sources and load it into the database.

More details are provided in the following
[discussion](rationale) 
of the platform.

### Using the Database

For a sample to query the database, please look at
[Sample Query](common/core-platform/doc/SampleQuery)

A discussion of querying of health data can be found in 
[this document](common/cms/doc/QueringMedicaid)

### Terms and Acronyms 

Included 
[Glossary](glossary.md) provides some information about
acronyms and other terms used throughout this documentation.
               
## Deploying the Platform

The data platform is deployed as a set of Docker containers orchestrated by
Docker-Compose. Conda (package manager) environment files and Python
requirements are used to build Docker containers satisfying the dependencies.
Specific parameters can be customized via environment files and shell script
callbacks.

See [deployment](#deployment) section.
                                      
## Building Platform documentation

The [documentation](https://github.com/NSAPH-Data-Platform/nsaph-platform-docs)
contains general documentation pages in 
[MarkDown](https://www.markdownguide.org/) 
format and a build script that goes over all other platform 
repositories in the platform
and creates a combined [GitHub Pages](https://pages.github.com/) site.
The script supports links between repositories. 

Documentation utilities are contained in 
[nsaph-utils](https://github.com/NSAPH-Data-Platform/nsaph-utils)
in 
[docutils](https://github.com/NSAPH-Data-Platform/nsaph-utils/tree/master/nsaph_utils/docutils)
package. 

        
## Repositories Overview

### Deployment

[Deployment repository](common/platform-deployment/doc/index) is based on  
CWL-Airflow Docker Deployment developed
by Harvard FAS RC in collaboration with Forome Association. Essentially, this is a fork of: 
[Apache Airflow + CWL in Docker with Optional Conda and R](https://github.com/ForomePlatform/airflow-cwl-docker)
It follows 
[Infrastructure as Code (IaC)](https://en.wikipedia.org/wiki/Infrastructure_as_code) 
approach.

[Harvard FAS RC Superset] repository is a fork of 
[Apache Superset](https://superset.apache.org/) 
customized for Harvard FAS RC environment.


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

[NSAPH Utils Package Description](common/utils/doc/index)


#### Core Platform

<!-- section overview from nsaph -->

The data platform provides generic infrastructure for NSAPH Data Platform
It depends on nsaph_util package, but it augments it
with APIs and command line utilities dependent on the infrastructure 
and the environment. For instance, its components assume presence of PostgreSQL
DBMS (version 13 or later) and CWL runtime environment.

<!-- end of section overview from nsaph -->

[Core Platform Package Description](common/core-platform/doc/index)


#### GIS Utilities

<!-- section overview from gis -->


This library contains several packages, aimed to work with census shape files.

<!-- end of section overview from gis -->

[NSAPH GIS Package Description](common/gis/doc/index)


   
### Data Ingestion and Processing Packages and Pipelines

Pipelines processing data from Environmental Protection Agency and climate data
from gridMET are ready to be used by any interested party. The pipeline to
process claims data from Medicaid which cannot be made publicly available can be
tested only by users who have their own data user agreement with the Centers for
Medicare and Medicaid Services (CMS) and have access to their own Medicaid
claims data from ResDAC. The pipeline we publish processes Medicaid MAX (
Medicaid Analytic Extract) Personal Summary (PS) and The Medicaid MAX (Medicaid
Analytic Extract) Inpatient (IP) files. The following table 
summarizes the included data processing pipelines.

| Pipeline | Documentation                                                                      |
|----------|------------------------------------------------------------------------------------|
| EPA      | [EPA Pipelines](common/epa/doc/index) (AQS and AirNow)                             |
| Census   | [Census Package](common/census/doc/index) (Ingesting demographics data)            |
| Gridmet  | [Gridmet package](common/gridmet/doc/index) (Climate data pipelines and utilities) |
| CMS      | [CMS Piepline](common/cms/doc/index) (Medicare and Medicaid)                       |
