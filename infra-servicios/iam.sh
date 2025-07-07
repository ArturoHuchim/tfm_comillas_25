gcloud iam service-accounts create crunjob-integration \
  --display-name="crunjob-integration"

gcloud iam service-accounts create desarrollador \
  --display-name="desarrollador"


gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/run.invoker"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/run.viewer"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/logging.logWriter"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretVersionAdder"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/secretmanager.viewer"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:crunjob-integration@proyecto.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"


gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.admin"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataEditor"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/bigquery.dataOwner"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/bigquery.jobUser"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/dataflow.developer"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/eventarc.admin"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/secretmanager.viewer"

gcloud projects add-iam-policy-binding <ID_PROYECTO> \
  --member="serviceAccount:desarrollador@proyecto.iam.gserviceaccount.com" \
  --role="roles/storage.objectAdmin"
