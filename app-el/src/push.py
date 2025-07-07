from google.cloud import storage
import logging
import os

#BUCKET_NAME_ = os.environ['BUCKET_NAME']
BUCKET_NAME_ ='tfm-comillas-25-rawdata' 


def upload_to_bucket(destination_folder, destination_blob_name, path_to_file):
    try:
        # Inicializamos el cliente
        # client = storage.Client.from_service_account_json(json_credentials_path=PATH_TO_PRIVATE_KEY_)
        client = storage.Client()
        #Seleccionamos el bucket
        print("storage.Bucket")
        bucket = storage.Bucket(client, BUCKET_NAME_)
        # Agregamos el PATH en el bucket
        print("bucket.blob")
        
        blob = bucket.blob(destination_folder + "/" + destination_blob_name)
        # Subimos el archivo al destino
        blob.upload_from_filename(path_to_file)
     
    except Exception as e:
        print(e)