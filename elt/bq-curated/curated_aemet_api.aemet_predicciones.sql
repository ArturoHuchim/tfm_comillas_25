  SELECT
  est.nombre AS estacion_nombre,
  est.provincia,
  p.ciudad,
  est.altitud AS altitud,
  DATE(p.fecha) AS fecha,
  TIME(p.fecha) AS hora,
  SAFE_CAST(p.temp_max AS FLOAT64) AS temperatura_maxima,
  SAFE_CAST(p.temp_min AS FLOAT64) AS temperatura_minima,
  SAFE_CAST(p.sens_max AS FLOAT64) AS sensasion_maxima,
  SAFE_CAST(p.sens_min AS STRING) AS sensacion_minima,
  SAFE_CAST(p.hum_max AS FLOAT64) AS humedad_maxima,
  SAFE_CAST(p.hum_min AS STRING) AS humedad_minima,
  SAFE_CAST(est.altitud AS FLOAT64) AS altitud,
  est.latitud,
  est.longitud,
  -- Campo derivado: diferencia de temperaturas
  SAFE_CAST(p.temp_max AS FLOAT64) - SAFE_CAST(p.temp_min AS FLOAT64) AS rango_temperatura,
  -- Clasificación simple según precipitación esperada
  CASE
    WHEN SAFE_CAST(p.precipitacion AS FLOAT64) IS NULL THEN 'SIN DATO'
    WHEN SAFE_CAST(p.precipitacion AS FLOAT64) = 0 THEN 'SECO'
    WHEN SAFE_CAST(p.precipitacion AS FLOAT64) < 5 THEN 'LLUVIA LIGERA'
    WHEN SAFE_CAST(p.precipitacion AS FLOAT64) < 20 THEN 'LLUVIA MODERADA'
    ELSE 'LLUVIOSO'
  END AS condicion_lluvia,
    -- Categorización del riesgo UV
  CASE
    WHEN p.uv_max IS NULL THEN 'desconocido'
    WHEN p.uv_max <= 2 THEN 'bajo'
    WHEN p.uv_max <= 5 THEN 'moderado'
    WHEN p.uv_max <= 7 THEN 'alto'
    WHEN p.uv_max <= 10 THEN 'muy alto'
    ELSE 'extremo'
  END AS riesgo_uv,
    -- Clasificación de intensidad del viento
  CASE
    WHEN p.viento_velocidad IS NULL THEN 'desconocido'
    WHEN p.viento_velocidad < 10 THEN 'suave'
    WHEN p.viento_velocidad < 30 THEN 'moderado'
    WHEN p.viento_velocidad < 50 THEN 'fuerte'
    ELSE 'muy fuerte'
  END AS intensidad_viento,
    -- Clasificación de riesgo climático (combinación de condiciones)
  CASE
    WHEN p.uv_max >= 8 OR p.precipitacion >= 10 THEN 'riesgo alto'
    WHEN p.uv_max BETWEEN 5 AND 7 OR p.precipitacion BETWEEN 2 AND 10 THEN 'riesgo medio'
    ELSE 'riesgo bajo'
  END AS riesgo_climatico,
  p.estado_cielo,
  p.viento_direccion
FROM
  `proyecto.raw_aemet_api.aemet_predicciones_diario` p
LEFT JOIN
  `proyecto.raw_aemet_api.aemet_estaciones` est
on 
  lower(p.provincia) = lower(est.provincia)
