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

All images contain the Oracle ojdbc8 drivers and the GeoServer Oracle plugin.


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

## Database

### Store database connection details in OCI Vault

1. Create a vault and encryption key
2. Download ADB connection wallet and unzip it in a local directory
3. Set environment
    ```shell script
    export COMPARTMENT_OCID=ocid1.compartment.oc1..xxx
    export ENCRYPTION_KEY_OCID=ocid1.key.oc1.xxx
    export VAULT_ID=ocid1.vault.oc1.xxx
    ```
4. Run ```scripts/createWalletSecrets.sh```

    For each wallet file a secret will be generated. The idea is more precisely described in https://www.ateam-oracle.com/how-to-use-vault-to-store-atp-wallet .

### Connection

Currently, the database connection is not completely automatically set up! GeoServer is started with

```-Doracle.net.tns_admin=/home/geoserver/network/admin```

This is also the directory the wallet is deployed to.

In the GeoServer store configuration leave ```host``` and ```port``` blank and insert the description of your service
in the ```database``` field.


Autoscaling code based on https://github.com/svilmune/tf-012-autoscaling-events-demo