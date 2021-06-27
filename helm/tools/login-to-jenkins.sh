#!/bin/bash
set -ue

jenkins=$(kubectl get pods -A | grep jenkins | awk '{print $2}')

kubectl -n jenkins exec -it $jenkins bash
