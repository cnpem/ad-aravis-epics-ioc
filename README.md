# EPICS IOC for GenICam cameras based on ADAravis

This repository contains the EPICS Input/Output Controller (IOC) used at LNLS
based on [ADAravis](https://github.com/areaDetector/ADAravis) support module.

## Running the IOC

You can use the following command to run it in the background using the default
start-up script from
[epics-in-docker](https://github.com/cnpem/epics-in-docker).

```
docker compose up -d
```

## Building the IOC image

You can build the IOC with the following command:

```bash
docker compose build
```
