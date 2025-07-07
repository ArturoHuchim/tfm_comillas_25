SELECT
  -- Normalización de fechas
  SAFE.PARSE_DATE('%Y-%m-%d', fecha) AS fecha,

  SAFE_CAST(idBike AS INT64) AS id_bici,
  SAFE_CAST(fleet AS INT64) AS id_flotilla,

  -- Conversión de timestamps
  DATETIME(SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', unlock_date), 'Europe/Madrid') AS unlock_date,
  DATETIME(SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', lock_date), 'Europe/Madrid') AS lock_date,
  -- Cálculo real de duración en minutos
  TIMESTAMP_DIFF(SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', lock_date), SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', unlock_date), MINUTE) AS duracion_minutos_real,

  -- Duración original
  trip_minutes,

  -- Extracción de coordenadas de geolocation_unlock
  SAFE_CAST(JSON_EXTRACT_SCALAR(geolocation_unlock, '$.coordinates[0]') AS FLOAT64) AS lon_unlock,
  SAFE_CAST(JSON_EXTRACT_SCALAR(geolocation_unlock, '$.coordinates[1]') AS FLOAT64) AS lat_unlock,

  -- Extracción de coordenadas de geolocation_lock
  SAFE_CAST(JSON_EXTRACT_SCALAR(geolocation_lock, '$.coordinates[0]') AS FLOAT64) AS lon_lock,
  SAFE_CAST(JSON_EXTRACT_SCALAR(geolocation_lock, '$.coordinates[1]') AS FLOAT64) AS lat_lock,

  UPPER(locktype) AS locktype,
  UPPER(unlocktype) AS unlocktype,

FROM `proyecto.raw_bicimad.trips_csv`
