WITH

-- 1. Normalizar lineas_diario
lineas_norm AS (
  SELECT
    line,
    UPPER(nameA) AS nameA,
    UPPER(nameB) AS nameB,
    dateRef,
    UPPER(idDayType) AS idDayType,
    CASE
      WHEN direction = 'Direction1' THEN 1
      WHEN direction = 'Direccion2' THEN 2
      ELSE 0 
    END AS direction,
    startTime,
    stopTime,
    minFreq,
    maxFreq,
    freqText
  FROM `proyecto.raw_emt_api.emt_lineas_diario`
),

-- 2. Normalizar paradas
paradas_norm AS (
  SELECT
    stop_id,
    stop_name,
    postal_address,
    CAST(longitude AS FLOAT64) AS longitude,
    CAST(latitude AS FLOAT64) AS latitude,
    CAST(line AS INT64) AS line,
    #CAST(label AS INT64) AS label,
    CASE
      WHEN direction = 'A' THEN 1
      WHEN direction = 'B' THEN 2
      ELSE 0 
    END AS direction,
    headerA,
    headerB,
    startTime,
    stopTime,
    minFreq,
    maxFreq,
    UPPER(dayType) AS dayType
  FROM `proyecto.raw_emt_api.emt_paradas`
),

-- 3. Normalizar viajes_diario
viajes_norm AS (
  SELECT
    CAST(line AS INT64) AS line,
    date as dateRef,
    CAST(tripNum AS INT64) AS tripNum,
    CAST(direction AS INT64) AS direction,
    CAST(logicBus AS INT64) AS logicBus,
    TIME(startTimeTrip) AS startTimeTrip,
    TIME(endTimeTrip) AS endTimeTrip,
    UPPER(dayType) AS dayType
  FROM `proyecto.raw_emt_api.emt_viajes_lineas_diario`
),

-- 4. Normalizar rutas_linea
rutas_norm AS (
  SELECT
    CAST(line AS INT64) AS line,
    CAST(label AS INT64) AS label,
    UPPER(nameSectionA) AS nameSectionA,
    UPPER(nameSectionB) AS nameSectionB,
    segment_id,
    segment_name,
    distance,
    longitude,
    latitude
  FROM `proyecto.raw_emt_api.emt_rutas_lineas_diario`
)

-- 5. Unión final
SELECT
  l.line,
  l.nameA,
  l.nameB,
  l.dateRef,
  l.idDayType,
  l.direction AS line_direction,
  l.startTime AS line_startTime,
  l.stopTime AS line_stopTime,
  l.minFreq AS line_minFreq,
  l.maxFreq AS line_maxFreq,
  l.freqText,

  p.stop_id,
  p.stop_name,
  p.postal_address,
  p.longitude AS stop_longitude,
  p.latitude AS stop_latitude,
  p.startTime AS stop_startTime,
  p.stopTime AS stop_stopTime,
  p.minFreq AS stop_minFreq,
  p.maxFreq AS stop_maxFreq,
  
  v.tripNum,
  v.startTimeTrip,
  v.endTimeTrip,
  v.logicBus,
  v.direction AS trip_direction,
  v.dayType AS trip_dayType,

  r.segment_id,
  r.segment_name,
  r.distance AS segment_distance,
  r.longitude AS segment_longitude,
  r.latitude AS segment_latitude


FROM lineas_norm l

LEFT JOIN paradas_norm p
  ON l.line = p.line
  AND l.direction = p.direction
  AND l.idDayType = p.dayType
  AND (lower(p.headerA) = lower(l.nameA) OR lower(p.headerB) = lower(l.nameB)) 

LEFT JOIN viajes_norm v
  ON l.line = v.line
  and l.dateRef = v.dateRef
  AND l.idDayType = v.dayType
  AND l.direction = v.direction

  LEFT JOIN rutas_norm r
  ON l.line = r.line
  AND lower(l.nameA) = lower(r.nameSectionA)
  AND lower(l.nameB) = lower(r.nameSectionB)

;