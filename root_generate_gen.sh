#!/usr/bin/env bash
openssl genrsa -out ownRootCACert.key 2048
openssl req -x509 -new -nodes -key ownRootCACert.key \
  -sha256 -days 1024 -out ownRootCACert.pem
