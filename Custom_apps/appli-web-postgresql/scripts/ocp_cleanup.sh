#!/bin/bash

# Variables
NAMESPACE="appli-web-postgresql"

# Suppression du namespace
echo "Suppression du namespace..."
oc delete namespace $NAMESPACE

echo "Toutes les ressources ont été supprimées."
