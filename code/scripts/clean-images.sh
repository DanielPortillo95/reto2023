!/usr/bin/env bash

RED='\033[0;31m'
YELL='\033[1;33m'
NC='\033[0m' # No Color

## #Estas con las variables. Podrías cambiar a 2, 4 y en el proyecto que se utlizará
IMAGES_TO_KEEP="3"
IMAGE_REPO="gcr.io/xxx"

## #Obtener todas las imágenes en el repositorio de imágenes dado
echo -e "${YELL}Getting all images${NC}"
IMAGELIST=$(gcloud container images list --repository=${IMAGE_REPO} --format='get(name)')
echo "$IMAGELIST"

while IFS= read -r IMAGENAME; do
  IMAGENAME=$(echo $IMAGENAME|tr -d '\r')
  echo -e "${YELL}Checking ${IMAGENAME} for cleanup requirements${NC}"

  ## #Obtenga todos los resúmenes de la etiqueta ordenados por marca de tiempo (los más antiguos primero)
  DIGESTLIST=$(gcloud container images list-tags ${IMAGENAME} --sort-by timestamp --format='get(digest)')
  DIGESTLISTCOUNT=$(echo "${DIGESTLIST}" | wc -l)

  if [ ${IMAGES_TO_KEEP} -ge "${DIGESTLISTCOUNT}" ]; then
    echo -e "${YELL}Found ${DIGESTLISTCOUNT} digests, nothing to delete${NC}"
    continue
  fi

  ## #Filtrar la lista ordenada para filtrar los 3 más recientes
  DIGESTLISTTOREMOVE=$(echo "${DIGESTLIST}" | head -n -${IMAGES_TO_KEEP})
  DIGESTLISTTOREMOVECOUNT=$(echo "${DIGESTLISTTOREMOVE}" | wc -l)

  echo -e "${YELL}Found ${DIGESTLISTCOUNT} digests, ${DIGESTLISTTOREMOVECOUNT} to delete${NC}"

  ## #Eliminar ( Si es que un repo tiene menos de 3 imágenes el script continuará con el otro proyecto)
  if [ "${DIGESTLISTTOREMOVECOUNT}" -gt "0" ]; then
    echo -e "${YELL}Removing ${DIGESTLISTTOREMOVECOUNT} digests${NC}"
    while IFS= read -r LINE; do
      LINE=$(echo $LINE|tr -d '\r')
        gcloud container images delete ${IMAGENAME}@${LINE} --force-delete-tags --quiet
    done <<< "${DIGESTLISTTOREMOVE}"
  else
    echo -e "${YELL}No digests to remove${NC}"
  fi
done <<< "${IMAGELIST}"

