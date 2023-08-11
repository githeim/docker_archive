#!/bin/bash
err_report() {
  echo "Error on line $1"
  exit 1 
}
trap 'err_report $LINENO' ERR


curl -fsSL https://get.docker.com -o get-docker.sh

sudo sh get-docker.sh
