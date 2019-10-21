#!/bin/sh

# Requires Bosh Cli V2, and bosh environments setup as described in bosh-cli/README

# Usage
# ./deploy.sh test 
# ./deploy.sh dev 
# ./deploy.sh stage 
# ./deploy.sh prod 


# env: {test,dev,stage,prod}

set -e

env=$1

cli_error_help() {
  echo "usage: ./deploy.sh <test|dev|stage|prod>"
  echo "usage: all arguments must be provided."
  exit 1
}

if [ "$env" != "test" ] && \
    [ "$env" != "dev" ] && \
    [ "$env" != "stage" ] && \
    [ "$env" != "prod" ] ; then
  cli_error_help
fi

bosh -e ice-$env -d prometheus deploy ../manifests/prometheus.yml \
        -o ../manifests/operators/networks.yml \
        -o ../manifests/operators/enable-cf-route-registrar.yml \
        -o ../manifests/operators/monitor-bosh.yml \
        -o ../manifests/operators/monitor-cf.yml \
        -l $env/vars.yml \
        --no-redact