#Compilar y empaquetar la imagen:
docker build -t $IMAGE_NAME:$VERSION .

#Agregar etiqueta a la imagen como referencia dentro de docker:
docker tag $IMAGE_NAME:$VERSION $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION

#Subir imagen a Artifact Registry 
docker push $REGION-docker.pkg.dev/$PROJECT_ID/$REPO_NAME/$IMAGE_NAME:$VERSION

