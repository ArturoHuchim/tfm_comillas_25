with trips_2023 as (
  SELECT fecha, idBike, fleet, trip_minutes, geolocation_unlock, address_unlock,
        unlock_date, locktype, unlocktype, geolocation_lock, address_lock,
        lock_date, dock_unlock, unlock_station_name, station_lock,
        dock_lock, lock_station_name, source_file
  FROM `proyecto.raw_bicimad.2023_trips`
  where idBike is not null
),
trips_2022 as (
  SELECT fecha, idBike, fleet, trip_minutes, geolocation_unlock, address_unlock,
        unlock_date, locktype, unlocktype, geolocation_lock, address_lock,
        lock_date, CAST(dock_unlock AS FLOAT64), unlock_station_name, station_lock,
        dock_lock, lock_station_name, source_file
  FROM `proyecto.raw_bicimad.2022_trips`
  where idBike is not null
),
trips_2021 as (
  SELECT fecha, idBike, fleet, trip_minutes, geolocation_unlock, address_unlock,
        unlock_date, locktype, unlocktype, geolocation_lock, address_lock,
        lock_date, dock_unlock, unlock_station_name, station_lock,
        dock_lock, lock_station_name, source_file
  FROM `proyecto.raw_bicimad.2021_trips`
  where idBike is not null
),
union_all as (
  select * from
    trips_2023
  union all
  select * from
    trips_2022
  union all
  select * from
    trips_2021
)

SELECT
  -- Normalización de fechas
  --PARSE_TIMESTAMP('%F', fecha) AS fecha_viaje,
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

  ---- Validación: viaje válido
  CASE
    WHEN trip_minutes IS NULL OR trip_minutes < 1 THEN 'inválido'
    WHEN TIMESTAMP_DIFF(SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', lock_date), SAFE.PARSE_TIMESTAMP('%Y-%m-%dT%H:%M:%S', unlock_date), MINUTE) < 0 THEN 'inválido'
    ELSE 'válido'
  END AS estatus_viaje,

  -- Clasificación por duración
  CASE
    WHEN trip_minutes < 5 THEN 'muy corto'
    WHEN trip_minutes < 15 THEN 'corto'
    WHEN trip_minutes < 30 THEN 'medio'
    ELSE 'largo'
  END AS tipo_viaje,

FROM union_all
