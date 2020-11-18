#!/usr/bin/env bash

# Usage: generateWalletFiles.sh /path/to/destination/dir [ authorization_mode ]

if [ -z "$1" ]
  then
    DEST_DIR="."
  else
    DEST_DIR=$1
fi

if [ -z "$2" ]
  then
    AUTH="instance_principal"
  else
    AUTH=$2
fi

echo "Using ${AUTH} for authorization"

for LINE in $(oci vault secret list --compartment-id "$COMPARTMENT_OCID" --vault-id "$VAULT_ID" --auth security_token | jq -c '.data[]' | jq -s '.[]|select(."secret-name" ==("tnsnames.ora") or ."secret-name" ==("sqlnet.ora") or ."secret-name" ==("truststore.jks") or ."secret-name" ==("ojdbc.properties") or ."secret-name" ==("keystore.jks") or ."secret-name" ==("ewallet.p12") or ."secret-name" ==("cwallet.sso") )|.id,."secret-name"' --raw-output);
  do [[ $LINE == ocid* ]] && OCID=$LINE && continue;[[ $LINE != ocid* ]] && oci secrets secret-bundle get --secret-id "$OCID" --auth security_token | jq '.data."secret-bundle-content".content' --raw-output | base64 -d > "$DEST_DIR"/"$LINE";
done
