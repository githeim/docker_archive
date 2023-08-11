#!/bin/bash
error() {                                                                                     
  local parent_lineno="$1"                                                                    
  local message="$2"                                                                          
  local code="${3:-1}"                                                                        
  if [[ -n "$message" ]] ; then                                                               
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"    
  else                                                                                        
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"                
  fi                                                                                          
  exit "${code}"                                                                              
}                                                                                             
trap 'error ${LINENO}' ERR   
export DOCKER_SHARED_DIR=$HOME/docker_share
export DOCKER_IMG_NAME="ubuntu22_base:0.1"

