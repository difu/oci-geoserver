# oci-geoserver
Testbed to run GeoServer on Oracle Cloud Infrastructure

## Prepare Database

- Run with your admin user ```create_user.sql``` script. Change password!
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

## Database connection

Currently, the database connection is not automatically set up! GeoServer is started with

```-Doracle.net.tns_admin=/home/geoserver/network/admin```

In case you want to connect with an autonomous database service, unzip and upload the content of your wallet in this
directory. In the GeoServer store configuration leave ```host``` and ```port``` blank and insert the description of your service
in the database field.


Autoscaling code based on https://github.com/svilmune/tf-012-autoscaling-events-demo