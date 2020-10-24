# oci-geoserver
Testbed to run GeoServer on Oracle Cloud Infrastructure

## Build image

To build the GeoServer image, set all environment variables that start with ```PACKER_VAR_``` and run in the ```packer``` directory: 
```
packer build geoserver.json
```

Autoscaling code based on https://github.com/svilmune/tf-012-autoscaling-events-demo