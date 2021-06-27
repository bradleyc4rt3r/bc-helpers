#!/bin/bash

helm upgrade --install jenkins -n jenkins --recreate-pods ../jenkins/
