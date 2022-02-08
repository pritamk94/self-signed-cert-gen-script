#!/usr/bin/env bash
echo "Provide domain Name: (e.g. www.myDomainCert.com) "
read DOMAIN
if [ -z "$DOMAIN" ]
then
    echo "Please provide domain name for this certificate";
    echo "e.g. www.myDomainCert.com"
    exit;
fi

if [ ! -f ownRootCACert.pem ]; then
    echo 'Please run "root-certificate-gen.sh" first, and try again!'
    exit;
fi
if [ ! -f version3.ext ]; then
    echo 'Please download the "version3.ext" file and try again!'
    exit;
fi

echo "Provide validity days int number: "
read NUM_OF_DAYS
if [ -z "$NUM_OF_DAYS" ]
then
    echo "Please supply a validity date!!";
    echo "e.g. 365"
    exit;
fi

COMMON_NAME=$DOMAIN
openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout myCertificate.key -out myCertificate.csr
echo "Certifaite signin request has been created.."
cat version3.ext | sed s/%%DOMAIN%%/"$COMMON_NAME"/g > /tmp/__v3.ext
openssl x509 -req -in myCertificate.csr -CA ownRootCACert.pem -CAkey ownRootCACert.key -CAcreateserial -out $DOMAIN.crt -days $NUM_OF_DAYS -sha256 -extfile /tmp/__v3.ext
