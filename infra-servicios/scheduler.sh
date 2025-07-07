#!/bin/bash

# REEMPLAZA esto con tu Service Account autorizada:
SERVICE_ACCOUNT="crunjob-integration@tfm-comillas-25.iam.gserviceaccount.com"

# Región
REGION="us-central1"
PROJECT="tfm-comillas-25"

# Lista de comandos
gcloud scheduler jobs create http tfm-comillas-25-aemet-clima-actual-dly-trigger-2 \
  --schedule="32 0 * * *" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-aemet-clima-actual-dly:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-aemet-estaciones-trigger \
  --schedule="35 0 * * 1" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-aemet-estaciones:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-aemet-predicciones-dly-trigger \
  --schedule="35 0 * * *" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-aemet-predicciones-dly:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-bicimad-estaciones-trigger \
  --schedule="15 * * * *" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-bicimad-estaciones:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-emt-lines-dly-trigger \
  --schedule="40 0 * * *" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-emt-lines-dly:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-emt-paradas-trigger \
  --schedule="45 0 * * 1" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-emt-paradas:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-emt-rutas-lineas-trigger \
  --schedule="50 0 * * 1" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-emt-rutas-lineas:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION

gcloud scheduler jobs create http tfm-comillas-25-emt-viajes-dly-trigger \
  --schedule="45 0 * * *" \
  --time-zone="Etc/UTC" \
  --uri="https://${REGION}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${PROJECT}/jobs/tfm-comillas-25-emt-viajes-dly:run" \
  --http-method=POST \
  --oauth-service-account-email=$SERVICE_ACCOUNT \
  --location=$REGION
