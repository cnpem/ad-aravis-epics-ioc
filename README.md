# Aravis in Docker

This image provides the [Aravis](https://github.com/AravisProject/aravis)
software utilities in a container image. This makes it possible to run latest
versions in machines that do not provide the required libraries.

The default image command is `arv-tool-0.8` (without arguments), which queries
for all cameras in the current subnetwork.

## Additional scripts

### Generating start-up scripts

[ad-aravis-epics-ioc](https://github.com/cnpem/ad-aravis-epics-ioc) provides a
template `st.cmd` which enables to reuse most configuration of the IOC.
Configuration parameters should be filled based on the specific device.

The `lnls-gen-iocsh` script enables to automatically fill most of these
parameters by querying cameras in the current subnetwork. To use it, you can
simply specify the command right after the service name:

```shell
podman-compose run aravis lnls-gen-iocsh -h
```

A volume of the current folder is mounted to the default working directory of
the container. This means all generated files are created in the local
directory outside the container by default.
