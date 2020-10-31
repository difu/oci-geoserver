# oci-geoserver
Testbed to run GeoServer on Oracle Cloud Infrastructure

## Prepare Database

- Run with your admin user ```create_user-sql``` script. Change password!
- Log in with user **geoserver** and run ```create_data.sql``` to install a simple test layer.

## Build images

To build the GeoServer images, set all environment variables that start with ```PACKER_VAR_``` and run in the ```packer``` directory: 
```
packer build geoserver_latest.json
packer build geoserver_2.18.0
```

## Terraform

Set all needed environment variables that start with ```TF_VAR```

````
terraform init
terraform plan
````

Review the plan and apply with

```
terraform apply
```



Autoscaling code based on https://github.com/svilmune/tf-012-autoscaling-events-demo