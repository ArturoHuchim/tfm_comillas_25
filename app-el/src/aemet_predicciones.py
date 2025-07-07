from googleapiclient.discovery import build

import push
import os
from el import get_aemet_login, get_prediction

ID_CD = os.environ['ID_CD']

def main():
    querystring, headers = get_aemet_login()
    print("Generando")

    df, file_name = get_prediction(querystring, headers, ID_CD)

    print("Guardando")
    df.to_csv(file_name, index=False, encoding="utf-8")
    push.upload_to_bucket('AEMET_PREDICCIONES', file_name, file_name)
    print("Archivo procesado")

if __name__ == '__main__':
    main()
