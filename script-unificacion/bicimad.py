import os
import pandas as pd

base_folder = '.'
years = ['2021', '2022', '2023']

# Inicializar listas para DataFrames
cols_a_usar = ['fecha', 'idBike', 'fleet', 'trip_minutes', 'geolocation_unlock', 'address_unlock', 'unlock_date', 'locktype', 'unlocktype', 'geolocation_lock', 'address_lock', 'lock_date', 'station_unlock', 'dock_unlock', 'unlock_station_name', 'station_lock', 'dock_lock', 'lock_station_name']
df_movements_all = []
df_aggregated_all = []

#iteramos por año
for year in years:
    folder_path = os.path.join(base_folder, f'bicimad_{year}', f'bicimad_{year}')
    
    for filename in os.listdir(folder_path):
        #validamos extensión de archivo
        if filename.endswith(('.csv', '.json')):
            full_path = os.path.join(folder_path, filename)
            print_str = ""
            print(f"{filename} {print_str}")
            try:
            #validamos si se trata un archivo de viajes ya que puede contener en el nombre del archivo "trips" o "movements"
              if 'trips' in filename or '_movements' in filename: 
                  if filename.endswith('.csv'):
                      df = pd.read_csv(full_path, sep=";", usecols=cols_a_usar, dtype=str)
                      print_str = "trips"
                  else:
                      df = pd.read_json(full_path, lines=True)
                      print_str = "_movements"
                    #se agrega el df a una lista para al final, concatenar
                  df_movements_all.append(df)
              else:
                  #si se trata de un archivo de movimientos, se agrega el df a una lista para al final, concatenar
                  df = pd.read_json(full_path, lines=True)
                  df_aggregated_all.append(df)
                  print_str = "_"
            except Exception as e:
              print(f"Problemas con el siguiente archivo: {filename}")
            df['source_file'] = filename


    # Unir todos los DataFrames
    if len(df_movements_all) > 0:
      df_movements = pd.concat(df_movements_all, ignore_index=True)
      df_movements.to_csv(os.path.join(folder_path, "df_trips.csv"), index=False)
    if len(df_aggregated_all) > 0:
      df_aggregated = pd.concat(df_aggregated_all, ignore_index=True)
      df_aggregated.to_csv(os.path.join(folder_path, "df_status_stations.csv"), index=False)