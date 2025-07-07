#from googleapiclient.discovery import build

import push
from el import get_emt_login, get_emt_stops, get_emt_stops_details


def main():
    token = get_emt_login()
    stops = get_emt_stops(token)
    print("Generando")

    df, file_name = get_emt_stops_details(token, stops)

    print("Guardando")
    df.to_csv(file_name, index=False, encoding="utf-8")
    push.upload_to_bucket('EMT_PARADAS', file_name, file_name)
    print("Archivo procesado")

if __name__ == '__main__':
    main()
