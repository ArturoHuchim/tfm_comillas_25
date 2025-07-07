#from googleapiclient.discovery import build
import pandas as pd
import os
import requests
import json
from datetime import datetime
import time

#username = os.environ['USERNAME']
#password = os.environ['PASSWORD']
#token = os.environ['TOKEN']
#URL_EMT = os.environ['URL_EMT']
#URL_AEMET = os.environ['URL_AEMET']

URL_EMT = "https://openapi.emtmadrid.es/"
username = "arturo_leones@hotmail.com"
password = "Leoncitos190#"

URL_AEMET = "https://opendata.aemet.es/"
token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMDE5MTMwOThAYWx1LmNvbWlsbGFzLmVkdSIsImp0aSI6Ijk3YmQyOTg3LTZmOTQtNDY5NC1iYjcyLTU4NzNkMzFkOGFhZCIsImlzcyI6IkFFTUVUIiwiaWF0IjoxNzUwNzA5MzgwLCJ1c2VySWQiOiI5N2JkMjk4Ny02Zjk0LTQ2OTQtYmI3Mi01ODczZDMxZDhhYWQiLCJyb2xlIjoiIn0.j24WTnk73uf7pMNwowvmYXxbzsvAQLUz2yPdEAVQ35Q"


def get_aemet_login():
    querystring = {"api_key":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMDE5MTMwOThAYWx1LmNvbWlsbGFzLmVkdSIsImp0aSI6Ijk3YmQyOTg3LTZmOTQtNDY5NC1iYjcyLTU4NzNkMzFkOGFhZCIsImlzcyI6IkFFTUVUIiwiaWF0IjoxNzUwNzA5MzgwLCJ1c2VySWQiOiI5N2JkMjk4Ny02Zjk0LTQ2OTQtYmI3Mi01ODczZDMxZDhhYWQiLCJyb2xlIjoiIn0.j24WTnk73uf7pMNwowvmYXxbzsvAQLUz2yPdEAVQ35Q"}
    headers = {'cache-control': "no-cache"}
    return querystring, headers
    

def get_emt_login():
    url_ = f"{URL_EMT}/v1/mobilitylabs/user/login/"
    try:
        headers = {"email": username,"password":password}
        response = requests.request("GET", url_, headers = headers)
        response_json = json.loads(response.text)
        accessToken = response_json["data"][0]["accessToken"]
        headers_token = {"accessToken": accessToken}
        return headers_token
    except Exception as e:
        print(f"Error al obtener el token. {e}")
        


def get_request(url, method, headers_token):
    try:
        response_info_grl = requests.request(method, url, headers = headers_token)
        parsed = (json.loads(response_info_grl.text)["data"])
        return parsed
    except Exception as e:
        print(f"Error al realizar la petición. {e}")


def get_emt_lines(headers_token):
    dataref = datetime.today().strftime("%Y%m%d")
    url_ = f"{URL_EMT}/v2/transport/busemtmad/lines/info/" + dataref + "/"

    try:
        parsed = get_request(url_, "GET", headers_token)
        lines = [i['line'] for i in parsed[:3]]
        return lines
    except Exception as e:
        print(f"Error al obtener las lineas. {e}")


def get_emt_stops(headers_token):
    dataref = datetime.today().strftime("%Y%m%d")
    url_ = f"{URL_EMT}/v1/transport/busemtmad/stops/list/"

    try:
        parsed = get_request(url_, "POST", headers_token)
        #print(parsed)
        stops = [i['node'] for i in parsed]
        stops = ['1049', '1221', '1325', '1750', '2111', '2559', '2589', '3539', '3540', '3542', '3689', '4025', '4038', '4039', '4040', '4042', '4058', '4094', '4096', '4108', '4129', '4130', '4131', '4132', '4133', '4134', '4135', '4136', '4137', '4138', '4139', '4140', '4141', '4142', '4143', '4144', '4145', '4816', '4853', '5135', '5137', '5138', '5156', '5453', '5511', '5537', '5620', '5709', '5710', '5726', '51033', '51181']
        return stops
    except Exception as e:
        print(f"Error al obtener las lineas. {e}")
    

def get_emt_lines_info_by_day(headers_token, lines):
    dataref = datetime.today().strftime("%Y%m%d")
    print(f"Iniciando job de extracción de info por linea por dia: {dataref}")
    df_lists = []

    for line_id in lines:
        print(line_id)
        try:
            url_ = f"{URL_EMT}/v1/transport/busemtmad/lines/{line_id}/info/{dataref}/"
            data = get_request(url_, "GET", headers_token)

            rows = []
            for item in data:
                line = item['line']
                nameA = item['nameA']
                nameB = item['nameB']
                dateRef = item['dateRef']

                for tt in item['timeTable']:
                    idDayType = tt['idDayType']

                    for direction_key in ['Direction1', 'Direction2']:
                        direction_data = tt.get(direction_key, {})
                        rows.append({
                            'line': line,
                            'nameA': nameA,
                            'nameB': nameB,
                            'dateRef': dateRef,
                            'idDayType': idDayType,
                            'direction': direction_key,
                            'startTime': direction_data.get('StartTime'),
                            'stopTime': direction_data.get('StopTime'),
                            'minFreq': direction_data.get('MinimunFrequency'),
                            'maxFreq': direction_data.get('MaximumFrequency'),
                            'freqText': direction_data.get('FrequencyText'),
                        })

            df = pd.DataFrame(rows)
            df_lists.append(df)
        except Exception as e:
            print(f"Error al obtener las lineas. {dataref} {e}")
            exit(1)
    if df_lists:
        df = pd.concat(df_lists, ignore_index=True)
        df.to_csv(f"horarios_lineas_diario_{dataref}.csv", index=False, encoding='utf-8')
        return df, f"horarios_lineas_diario_{dataref}.csv"
    print(f"Se ha finalizado el job de extracción de info por linea por dia. {dataref}")
        

def get_emt_route_line(headers_token, lines):
    dataref = datetime.today().strftime("%Y%m%d")
    print(f"Iniciando job de extracción de ruta de linea")
    df_lists = []
    for line_id in lines:
        print(line_id)
        try:
            url_ = f"{URL_EMT}/v1/transport/busemtmad/lines/{line_id}/route/"
            data = get_request(url_, "GET", headers_token)

            line = data["line"]
            label = data["label"]
            sectionA = data["nameSectionA"]
            sectionB = data["nameSectionB"]
            features = data["itinerary"]["toA"]["features"]

            rows = []
            for feature in features:
                props = feature["properties"]
                coords = feature["geometry"]["coordinates"][0][0]  
                row = {
                    "line": line,
                    "label": label,
                    "nameSectionA": sectionA,
                    "nameSectionB": sectionB,
                    "segment_id": props["id"],
                    "segment_name": props["name"],
                    "distance": props["distance"],
                    "longitude": coords[0],
                    "latitude": coords[1],
                }
                rows.append(row)

            df = pd.DataFrame(rows)
            df_lists.append(df)
        except Exception as e:
            print(f"Error al obtener las ruas de linea. {dataref} {e}")
            exit(1)
    if df_lists:
        df = pd.concat(df_lists, ignore_index=True)
        #df.to_csv(f"ruta_lineas_{dataref}.csv", index=False, encoding='utf-8')
        return df, f"ruta_lineas_{dataref}.csv"
    print(f"Iniciando job de extracción de ruta de linea. {dataref}")
        

def get_emt_stops_details(headers_token, stops):
    dataref = datetime.today().strftime("%Y%m%d")
    print(f"Iniciando job de extracción de detalle de paradas")
    df_lists = []

    for stop_id in stops:
        print(stop_id)
        try:
            url_ = f"{URL_EMT}/v1/transport/busemtmad/stops/{stop_id}/detail/"
            data = get_request(url_, "GET", headers_token)

            rows = []
            for entry in data:
                for stop in entry["stops"]:
                    stop_id = stop["stop"]
                    stop_name = stop["name"]
                    postal = stop["postalAddress"]
                    lon, lat = stop["geometry"]["coordinates"]

                    for line in stop["dataLine"]:
                        rows.append({
                            "stop_id": stop_id,
                            "stop_name": stop_name,
                            "postal_address": postal,
                            "longitude": lon,
                            "latitude": lat,
                            "line": line["line"],
                            "label": line["label"],
                            "direction": line["direction"],
                            "headerA": line["headerA"],
                            "headerB": line["headerB"],
                            "startTime": line["startTime"],
                            "stopTime": line["stopTime"],
                            "minFreq": line["minFreq"],
                            "maxFreq": line["maxFreq"],
                            "dayType": line["dayType"]
                        })

            df = pd.DataFrame(rows)
            df.to_csv(f'paradas_emt_{stop_id}.csv', index=False, encoding="utf-8")
            df_lists.append(df)
        except Exception as e:
            print(f"Error al obtener las paradas. {dataref} {e}")
            
    if df_lists:
        df = pd.concat(df_lists, ignore_index=True)
        #df.to_csv(f"paradas_detalle_{dataref}.csv", index=False, encoding='utf-8')
        return df, f"paradas_detalle_{dataref}.csv"
    print(f"Finalizando el job de extracción detalle de paradas. {dataref}")
        

def get_emt_trips_by_line_by_day(headers_token, lines):
    dataref = datetime.today().strftime("%Y%m%d")
    print(f"Iniciando job de extracción de viajes por linea por dia: {dataref}")
    df_lists = []

    for line_id in lines:
        print(line_id)
        try:
            url_ = f"{URL_EMT}/v1/transport/busemtmad/lines/{line_id}/trips/{dataref}/"
            data = get_request(url_, "GET", headers_token)
            df = pd.DataFrame(data)
            df_lists.append(df)
            print(df.head(5))
        except Exception as e:
            print(f"Error al obtener los viajes por linea. {dataref} {e}")
            exit(1)

    if df_lists:
        df = pd.concat(df_lists, ignore_index=True)
        #df.to_csv(f"viajes_lineas_diario_{dataref}.csv", index=False, encoding='utf-8')
        return df, f"viajes_lineas_diario_{dataref}.csv"

    print(f"Finalizando el job de extracción de viajes por linea por dia: {dataref}")

token = get_emt_login()
#lines = get_emt_lines(token)
#stops = get_emt_stops(token)
#
#get_emt_lines_info_by_day(token, lines)
#get_emt_route_line(token, lines)
#get_emt_stops_details(token, stops)
#get_emt_trips_by_line_by_day(token, lines)
#

############################################################################################################################

def get_bicimad_stations(headers_token):
    dataref = datetime.today().strftime("%Y%m%d_%H%M%S")
    url_ = f"{URL_EMT}/v1/transport/bicimad/stations/"
    print(f"Iniciando job de extracción de las estaciones de BiciMAD. {dataref}")
    try:
        data = get_request(url_, "GET", headers_token)

        for d in data:
            d['longitude'] = d['geometry']['coordinates'][0]
            d['latitude'] = d['geometry']['coordinates'][1]
            del d['geometry']  
        df = pd.DataFrame(data)
        #df.to_csv(f"bicimad_stations_{dataref}.csv", index=False, encoding='utf-8')
        return df, f"bicimad_stations_{dataref}.csv"
    except Exception as e:
        print(f"Error al obtener las estaciones de BiciMAD. {e}")
    print(f"Se ha finalizado el job de extracción de las estaciones de BiciMAD. {dataref}")

#get_bicimad_stations(token)

############################################################################################################################

def get_prediction(querystring, headers, id_cd):
    dataref = datetime.today().strftime("%Y%m%d")
    url_ = f"{URL_AEMET}/opendata/api/prediccion/especifica/municipio/diaria/{id_cd}/"
    print(f"Iniciando job de extracción de predicciones de tiempo de :{id_cd}. {dataref}")

    cont = 1
    while True:
        try:
            response = requests.request("GET", url_, headers=headers, params=querystring)
            response = response.json()
            url_datos = response.get("datos")
            response_datos = requests.get(url_datos)
            data = response_datos.json()
            ciudad = data[0]['nombre']
            provincia = data[0]['provincia']
            id_municipio = data[0]['id']
            dias = data[0]['prediccion']['dia']

            rows = []
            for dia in dias:
                fecha = dia.get("fecha")

                periodos = {}
                for periodo in ['00-06', '06-12', '12-18', '18-24', '00-12', '12-24', '00-24']:
                    periodos[periodo] = {
                        "fecha": fecha,
                        "periodo": periodo,
                        "temp_max": dia.get("temperatura", {}).get("maxima", ""),
                        "temp_min": dia.get("temperatura", {}).get("minima", ""),
                        "sens_max": dia.get("sensTermica", {}).get("maxima", ""),
                        "sens_min": dia.get("sensTermica", {}).get("minima", ""),
                        "hum_max": dia.get("humedadRelativa", {}).get("maxima", ""),
                        "hum_min": dia.get("humedadRelativa", {}).get("minima", ""),
                        "uv_max": dia.get("uvMax", ""),
                        "ciudad": ciudad,
                        "provincia": provincia,
                        "id_municipio": id_municipio
                    }

                def asignar_valores(lista, clave, campo='value'):
                    for item in lista:
                        periodo = item.get("periodo", "00-24")
                        if periodo in periodos:
                            periodos[periodo][clave] = item.get(campo)

                asignar_valores(dia.get("probPrecipitacion", []), "precipitacion")
                asignar_valores(dia.get("cotaNieveProv", []), "cota_nieve")
                asignar_valores(dia.get("estadoCielo", []), "estado_cielo", campo='descripcion')
                asignar_valores(dia.get("viento", []), "viento_direccion", campo="direccion")
                asignar_valores(dia.get("viento", []), "viento_velocidad", campo="velocidad")
                asignar_valores(dia.get("rachaMax", []), "racha_max")

                rows.extend(periodos.values())

            df = pd.DataFrame(rows)
            return df, f"prediccion_aemet__daily_{dataref}.csv"
            break
        except Exception as e:
            print(f"Error al obtener predicciones de tiempo de {id_cd}. {e}")
            time.sleep(10)
            if cont > 3:
                break
            else:
                cont = cont + 1
                print(f"Intento {cont} de 3.")

    print(f"Se ha finalizado el job de extracción de predicciones de tiempo de {id_cd}. {dataref}")


def get_current_weather(querystring, headers):
    dataref = datetime.today().strftime("%Y%m%d")
    print(f"Iniciando job de extracción de clima de hoy de todas las estaciones. {dataref}")
    url_ = f"{URL_AEMET}/opendata/api/observacion/convencional/todas"
    cont = 1
    while True:
        try:
            response = requests.request("GET", url_, headers=headers, params=querystring)
            response = response.json()
            url_datos = response.get("datos")
            response_datos = requests.get(url_datos)
            datos = response_datos.json()
            df = pd.DataFrame(datos)
            df['date'] = dataref
            #df.to_csv(f"aemet__daily_{dataref}.csv", index=False, encoding="utf-8")
            return df, f"aemet__daily_{dataref}.csv"
            break
        except Exception as e:
            print(f"Error al obtener predicciones de de extracción de clima de hoy de todas las estaciones. {dataref} {e}")
            time.sleep(10)
            if cont > 3: break
            else:
                cont = cont + 1
                print(f"Intento {cont} de 3.")
    print(f"Se ha finalizado el job de extracción de extracción de clima de hoy de todas las estaciones. {dataref}")


def get_current_stations(querystring, headers):
    dataref = datetime.today().strftime("%Y%m%d")
    print(f"Iniciando job de extracción de información de todas las estaciones {dataref}")
    url_ = f"{URL_AEMET}/opendata/api/valores/climatologicos/inventarioestaciones/todasestaciones/"

    cont = 1
    while True:
        try:
            response = requests.request("GET", url_, headers=headers, params=querystring)
            response = response.json()
            url_datos = response.get("datos")
            response_datos = requests.get(url_datos)
            datos = response_datos.json()
            df = pd.DataFrame(datos)
            #df.to_csv(f"estaciones__daily_{dataref}.csv", index=False, encoding="utf-8")
            return df, f"estaciones__daily_{dataref}.csv"
            break

        except Exception as e:
            print(f"Error al obtener predicciones de de extracción de información de todas las estaciones {dataref} {e}")
            time.sleep(10)
            if cont > 3: break
            else:
                cont = cont + 1
                print(f"Intento {cont} de 3.")
            
    print(f"Se ha finalizado el job de extracción de extracción de información de todas las estaciones {dataref}")



#querystring, headers = get_aemet_login()
##get_prediction(querystring, headers, "28079")
##get_current_weather(querystring, headers)
#get_current_stations(querystring, headers)