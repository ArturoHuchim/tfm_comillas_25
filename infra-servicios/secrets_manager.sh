#Para crear un secreto:
gcloud secrets create {secret-id} --replication-policy="automatic"

#Agregar una versión:
echo -n "text here" | \
    gcloud secrets versions add {secret-id} --data-file=-

#Acceder a la última versión de un secreto
gcloud secrets versions access latest --secret="{secret-id}"
