from googleapiclient.discovery import build

import push
from el import get_aemet_login, get_current_weather


def main():
    querystring, headers = get_aemet_login()
    print("Generando")

    df, file_name = get_current_weather(querystring, headers)

    print("Guardando")
    df.to_csv(file_name, index=False, encoding="utf-8")
    push.upload_to_bucket('AEMET_CLIMA_ACTUAL', file_name, file_name)
    print("Archivo procesado")

if __name__ == '__main__':
    main()
