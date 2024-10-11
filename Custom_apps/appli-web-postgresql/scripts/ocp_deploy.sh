#!/bin/bash

# Variables
NAMESPACE="appli-web-postgresql"
DB_USER="thibgrev"
DB_PASSWORD="azerty@12345"
STORAGE_CLASS="thin-csi"
FRONTEND_IMAGE="docker.io/thibgrev/frontend-web:latest"
BACKEND_IMAGE="docker.io/thibgrev/backend-postgresql:latest"

# Création du namespace
echo "Création du namespace..."
oc create namespace $NAMESPACE

# Création des secrets
echo "Création des secrets..."
oc create secret generic db-secret --from-literal=username=$DB_USER --from-literal=password=$DB_PASSWORD -n $NAMESPACE

# Création du PVC pour la base de données
echo "Création du Persistent Volume Claim..."
cat <<EOF | oc apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: db-pvc
  namespace: $NAMESPACE
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: $STORAGE_CLASS
EOF

# Déploiement du backend PostgreSQL
echo "Déploiement du backend PostgreSQL..."
cat <<EOF | oc apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: $BACKEND_IMAGE
        env:
        - name: POSTGRES_USER
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: username
        - name: POSTGRES_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: password
        volumeMounts:
        - mountPath: /var/lib/postgresql/data
          name: db-storage
      volumes:
      - name: db-storage
        persistentVolumeClaim:
          claimName: db-pvc
EOF

# Déploiement du frontend web
echo "Déploiement du frontend web..."
cat <<EOF | oc apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: $NAMESPACE
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: $FRONTEND_IMAGE
EOF

echo "Déploiement terminé."
