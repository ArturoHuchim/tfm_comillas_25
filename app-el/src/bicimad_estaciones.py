#from googleapiclient.discovery import build
from datetime import datetime


import push
from el import get_emt_login, get_bicimad_stations


def main():
    token = get_emt_login()
    print("Generando")
    
    df, file_name = get_bicimad_stations(token)
    ahora = datetime.now()
    df['timestamp_'] = ahora.strftime("%Y-%m-%d %H:%M:%S")
    print("Guardando")
    df.to_csv(file_name, index=False, encoding="utf-8")
    push.upload_to_bucket('BICIMAD_ESTACIONES', file_name, file_name)
    print("Archivo procesado")

if __name__ == '__main__':
    main()
