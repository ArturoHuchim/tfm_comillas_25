

# Creación del dataset curated_emt_api en la región us-central1
bq --location=us-central1 mk --dataset proyecto:curated_emt_api

# Creación del dataset curated_bicimad en la región us-central1
bq --location=us-central1 mk --dataset proyecto:curated_bicimad

# Creación del dataset curated_aemet_api en la región us-central1
bq --location=us-central1 mk --dataset proyecto:curated_aemet_api

# Creación del dataset raw_emt_api en la región us-central1
bq --location=us-central1 mk --dataset proyecto:raw_emt_api

# Creación del dataset raw_bicimad en la región us-central1
bq --location=us-central1 mk --dataset proyecto:raw_bicimad

# Creación del dataset raw_aemet_api en la región us-central1
bq --location=us-central1 mk --dataset proyecto:raw_aemet_api
