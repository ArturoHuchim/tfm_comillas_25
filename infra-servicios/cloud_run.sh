#VARIABLES
export PROJECT_ID=tfm-comillas-25
export REPO_NAME=tfm-comillas-25-artreg-docker
export REGION=us-central1
export IMAGE_NAME=api-opendata-emt
export SVC_JOB=crunjob-integration
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-crunjob-opendata-emt-dly
export VERSION=14
export VPC_CONNECTOR=tfm-comillas-25-vpc-conn
export BUCKET_NAME='tfm-comillas-25-rawdata' 
export USERNAME=emt-user
export PASSWORD=emt-password
export AEMET_TOKEN=aemet-token
export ID_CD=28079
export URL_EMT="https://openapi.emtmadrid.es/"
export URL_AEMET="https://opendata.aemet.es/"

#EMPAQUETAMIENTO

#Construción de la imagen
docker build -t $IMAGE_NAME:$VERSION .

#Etiquetsamiento de la imagen
docker tag $IMAGE_NAME:$VERSION $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION

#Subida al repositorio
docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION

#Definición del Job: tfm-comillas-25-aemet-clima-actual-dly
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-aemet-clima-actual-dly
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --project $PROJECT_ID \
  --command="python" \
  --args="aemet_clima_actual.py" \
  --task-timeout=2m

#Definición del Job: tfm-comillas-25-aemet-estaciones
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-aemet-estaciones
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --project $PROJECT_ID \
  --command="python" \
  --args="aemet_estaciones.py" \
  --task-timeout=2m

#Definición del Job: tfm-comillas-25-aemet-predicciones-dly
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-aemet-predicciones-dly
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --project $PROJECT_ID \
  --command="python" \
  --args="aemet_predicciones.py" \
  --task-timeout=2m

#Definición del Job: tfm-comillas-25-bicimad-estaciones
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-bicimad-estaciones
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --project $PROJECT_ID \
  --command="python" \
  --args="bicimad_estaciones.py" \
  --task-timeout=2m


#Definición del Job: tfm-comillas-25-emt-lines-dly
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-emt-lines-dly
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --project $PROJECT_ID \
  --command="python" \
  --args="emt_lineas_diario.py" \
  --task-timeout=2m

#Definición del Job: tfm-comillas-25-emt-paradas
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-emt-paradas
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --project $PROJECT_ID \
  --command="python" \
  --args="emt_paradas.py" \
  --task-timeout=2m

#Definición del Job: tfm-comillas-25-emt-rutas-lineas
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-emt-rutas-lineas
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --project $PROJECT_ID \
  --command="python" \
  --args="emt_rutas_lineas.py" \
  --task-timeout=2m

#Definición del Job: tfm-comillas-25-emt-viajes-dly
export CLOUD_RUN_JOB_NAME=tfm-comillas-25-emt-viajes-dly
gcloud beta run jobs create $CLOUD_RUN_JOB_NAME \
  --image $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION \
  --set-env-vars "BUCKET_NAME=$BUCKET_NAME" \
  --set-secrets TOKEN=$AEMET_TOKEN:latest \
  --set-secrets USERNAME=$USERNAME:latest \
  --set-secrets PASSWORD=$PASSWORD:latest \
  --set-env-vars "ID_CD=$ID_CD" \
  --set-env-vars "URL_EMT=$URL_EMT" \
  --set-env-vars "URL_AEMET=$URL_AEMET" \
  --service-account $SVC_JOB@$PROJECT_ID.iam.gserviceaccount.com \
  --region $REGION \
  --max-retries=0 \
  --project $PROJECT_ID \
  --command="python" \
  --args="emt_viajes_diario.py" \
  --task-timeout=2m