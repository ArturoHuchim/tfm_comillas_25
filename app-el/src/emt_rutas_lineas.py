from googleapiclient.discovery import build

import push
from el import get_emt_login, get_emt_lines, get_emt_route_line


def main():
    token = get_emt_login()
    lines = get_emt_lines(token)
    print("Generando")

    df, file_name = get_emt_route_line(token, lines)

    print("Guardando")
    df.to_csv(file_name, index=False, encoding="utf-8")
    push.upload_to_bucket('EMT_RUTAS_LINEAS', file_name, file_name)
    print("Archivo procesado")

if __name__ == '__main__':
    main()
