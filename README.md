# NSAPH Data Ingestion Pipelines

This repository contains pipelines for preprocessing data 
to make it available to NSPAH projects.

[Go to Documentation](https://nsaph-data-platform.github.io/nsaph-platform-docs/)
                                       
## Building documentation
        
Building documentation requires Python 3.8 or later.
First, install all requirements by executing command:

    pip install -r < requirements.txt 

To build the documentation, all project repositories should be
cloned to the same root directory. This root directory is given to the
build script as an argument. Run:

    ./build_common.sh

See also [Building documentation](doc/home.md#building-platform-documentation)
section in the main doc.
