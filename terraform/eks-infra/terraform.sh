#!/bin/bash
###############################################################################
# Script for terraform - plan / apply / destroy
# Creator: Vimal CS
# Date: 19 May 2021
###############################################################################

# enable bash strict mode
set -euo pipefail

# global constants
EN_NAME=$1
ACTION=$2
TFVAR_FILE="${EN_NAME}.tfvars"

###############################################################################
# Echo all parameters to the log file.
#==============================================================================
# $@ = log message(s)
#------------------------------------------------------------------------------
# $? = 0 if successful
###############################################################################
function log() {
   echo "$(date +"%Y-%m-%d %H:%M:%S")" "$@"
}

###############################################################################
# Terraform initialize
###############################################################################
function terraform_init() {
   log "Terraform initialize"
   terraform init
}

###############################################################################
# Terraform workspace
###############################################################################
function terraform_workspace() {
   log "Select Terraform workspace"

   terraform workspace list
   # Select / Create ${EN_NAME} terraform workspace
   WORK_SPACE=$(terraform workspace list | grep -w "${EN_NAME}" || true)
   if [ -z "$WORK_SPACE" ]; then
      terraform workspace new ${EN_NAME} || true
   else
      log "workspace ${EN_NAME} already exist"
      terraform workspace select ${EN_NAME} || true
   fi

}

###############################################################################
# Terraform destroy
###############################################################################
function terraform_destroy() {
   log "Terraform destroy"

   if [ "$EN_NAME" = "gbl" ] || [ "$EN_NAME" = "prd" ]; then
      log "Automated 'terraform destroy' cannot be performed for $EN_NAME envrionment"
      exit 1
   else
      terraform destroy --var-file ${TFVAR_FILE} -auto-approve
   fi

}

###############################################################################
# Terraform action
###############################################################################
function terraform_action() {
   log "Terraform action - $ACTION"

   if [ "$ACTION" = "plan" ]; then
      terraform plan --var-file ${TFVAR_FILE}
   elif [ "$ACTION" = "apply" ]; then
      terraform apply --var-file ${TFVAR_FILE} -auto-approve
   elif [ "$ACTION" = "destroy" ]; then
      terraform_destroy
   else
      log "Unknown Action. Please select one of the terraform action - plan / apply / destroy "
      exit 1
   fi

}

###############################################################################
# Main
###############################################################################
function main() {
   log "main started"

   if [ ! -f $TFVAR_FILE ]; then
      log "${TFVAR_FILE} file does not exist. Skipping tasks."
      exit 1
   else
      log "${TFVAR_FILE} file exist. Starting tasks."
      terraform_init
      terraform_workspace
      terraform_init
      terraform_action
   fi

}

# Call Main Function
main
