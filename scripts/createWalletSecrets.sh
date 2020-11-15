#!/bin/sh

echo "Creating secrets from wallet in ${WALLET_PATH}"
echo "Compartment OCID: ${COMPARTMENT_OCID}"
echo "Encryption Key OCID ${ENCRYPTION_KEY_OCID}"

command -v oci >/dev/null 2>&1 || { echo >&2 "ERROR: oci command line tool required, but it's not installed or in the search path.  Aborting."; exit 1; }

[ -z "$WALLET_PATH" ] && { echo "ERROR: WALLET_PATH not set!"; exit 1; }

[ -f "$WALLET_PATH/cwallet.sso" ] || { echo "ERROR: cwallet.sso not found!"; exit 1; }
[ -f "$WALLET_PATH/ewallet.p12" ] || { echo "ERROR: ewallet.p12 not found!"; exit 1; }
[ -f "$WALLET_PATH/keystore.jks" ] || { echo "ERROR: keystore.jks not found!"; exit 1; }
[ -f "$WALLET_PATH/ojdbc.properties" ] || { echo "ERROR: ojdbc.properties not found!"; exit 1; }
[ -f "$WALLET_PATH/sqlnet.ora" ] || { echo "ERROR: sqlnet.ora not found!"; exit 1; }
[ -f "$WALLET_PATH/tnsnames.ora" ] || { echo "ERROR: tnsnames.ora not found!"; exit 1; }
[ -f "$WALLET_PATH/truststore.jks" ] || { echo "ERROR: truststore.jks not found!"; exit 1; }

[ -z "$COMPARTMENT_OCID" ] && { echo "ERROR: COMPARTMENT_OCID not set!"; exit 1; }

[ -z "$ENCRYPTION_KEY_OCID" ] && { echo "ERROR: ENCRYPTION_KEY_OCID not set!"; exit 1; }

[ -z "$VAULT_ID" ] && { echo "ERROR: VAULT_ID not set!"; exit 1; }

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name cwallet.sso --secret-content-content "$(base64 $WALLET_PATH/cwallet.sso)" --auth security_token

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name ewallet.p12 --secret-content-content "$(base64 $WALLET_PATH/ewallet.p12)" --auth security_token

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name keystore.jks --secret-content-content "$(base64 $WALLET_PATH/keystore.jks)" --auth security_token

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name ojdbc.properties --secret-content-content "$(base64 $WALLET_PATH/ojdbc.properties)" --auth security_token

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name sqlnet.ora --secret-content-content "$(base64 $WALLET_PATH/sqlnet.ora)" --auth security_token

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name tnsname.ora --secret-content-content "$(base64 $WALLET_PATH/tnsnames.ora)" --auth security_token

oci vault secret create-base64 --vault-id ${VAULT_ID} \
 --compartment-id ${COMPARTMENT_OCID} \
 --key-id ${ENCRYPTION_KEY_OCID} \
 --secret-name truststore.jks --secret-content-content "$(base64 $WALLET_PATH/truststore.jks)" --auth security_token