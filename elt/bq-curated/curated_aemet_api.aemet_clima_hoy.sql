SELECT
  DATE(cd.fint) AS fecha,
  TIME(cd.fint) AS hora,
  cd.idema AS estacion_id,
  est.nombre AS estacion_nombre,
  est.provincia,
  SAFE_CAST(cd.lat AS FLOAT64) AS latitud,
  SAFE_CAST(cd.lon AS FLOAT64) AS longitud,
  est.altitud AS altitud,
  cd.tamin AS temp_min_horaria,
  cd.tamax AS temp_max_horaria,
  cd.ta AS temp_actual,
  cd.hr AS humedad_relativa,
  COALESCE(cd.vv, cd.vvu) AS viento_velocidad,
  COALESCE(cd.dv, cd.dvu) AS viento_direccion,
  cd.tamax - cd.tamin AS rango_termico,
  cd.prec AS precipitacion_horaria,
  -- Categorización de precipitación
  CASE
    WHEN cd.prec IS NULL THEN 'desconocido'
    WHEN cd.prec = 0 THEN 'sin lluvia'
    WHEN cd.prec <= 2 THEN 'ligera'
    WHEN cd.prec <= 10 THEN 'moderada'
    ELSE 'intensa'
  END AS categoria_precipitacion,
    -- Indicador booleano de visibilidad reducida (< 1000 m)
  CASE
    WHEN cd.vis IS NOT NULL AND cd.vis < 1000 THEN TRUE
    ELSE FALSE
  END AS visibilidad_reducida
FROM `proyecto.raw_aemet_api.aemet_clima_diario` cd
LEFT JOIN `proyecto.raw_aemet_api.aemet_estaciones` est
  ON cd.idema = est.indicativo