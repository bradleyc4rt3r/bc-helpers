# ### Common variables
region      = "us-east-1" /* AWS region to deploy  */
environment = "" /* Specify the environment as 3 letter code - dev/stg/prd/tst/emg */
project     = "" /* Project name as 4 letter code for which infra is build */ #

# Assume Role variables
account_id  = ""
assume_role = ""
external_id = ""

# EKS
eks_node_instance_type      = "m5.large"
eks_node_disk_size          = "50"
eks_node_capacity_type      = "ON_DEMAND" # SPOT 
eks_node_kubernetes_version = "1.18"
eks_node_desired_size       = "1"
eks_node_max_size           = "1"
eks_node_min_size           = "1"
