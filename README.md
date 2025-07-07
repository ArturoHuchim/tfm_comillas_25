# tfm_comillas_25
Trabajo realizado para defensa de TFM de Máster Universitario en Big Data de la Universidad Pontificia Comillas.
Los scripts se han organizado de la siguiente forma:

```text
app-el/
├── Dockerfile
├── empaquetamiento.sh
├── requirements.txt
├── src/
│   ├── aemet_clima_actual.py
│   ├── aemet_estaciones.py
│   ├── aemet_predicciones.py
│   ├── bicimad_estaciones.py
│   ├── el.py
│   ├── emt_lineas_diario.py
│   ├── emt_paradas.py
│   ├── emt_rutas_lineas.py
│   ├── emt_viajes_diario.py
│   ├── main.py
│   └── push.py
└── variables.sh

elt/
├── bq-curated/
│   ├── curated_aemet_api.aemet_clima_hoy.sql
│   ├── curated_aemet_api.aemet_predicciones.sql
│   ├── curated_bicimad.viajes.sql
│   ├── curated_bicimad.viajes_hourly.sql
│   └── curated_emt_api.emt_lineas.sql
├── bq-raw-schemas/
│   ├── 2020_trips.json
│   ├── 2021_trips.json
│   ├── 2022_trips.json
│   ├── 2023_trips.json
│   └── stations.json
├── bq-rendimiento-formatos/
│   ├── avro.sql
│   ├── csv.sql
│   └── parquet.sql
└── dataflow-schemas/
    ├── error_dataflow.json
    ├── schema_bicimad_2020_trips.json
    ├── schema_bicimad_2021_trips.json
    ├── schema_bicimad_2022_trips.json
    ├── schema_bicimad_2023_trips.json
    └── schema_bicimad_stations.json

infra-servicios/
├── artifact_registry.sh
├── bigquery.sh
├── cloud_run.sh
├── iam.sh
├── scheduler.sh
└── secrets_manager.sh

script-unificacion/
└── bicimad.py
