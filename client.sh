#!/bin/bash

PORT="2022"

echo "Cliente de Dragon Magia Abuelita Miedo 2022"

echo "1. ENVÍO CABECERA"

echo "DMAM" | nc localhost $PORT

DATA=`nc -l $PORT`

echo "3. COMPRUEBO HEADER"

if [ "$DATA" != "OK_HEADER" ]
then
echo "ERROR 1: Cabecera incorrecta"
exit 1
fi

echo "4. ENVÍO FILE_NAME y HASH"

FILE_NAME="dragon.txt"
FILE_HASH=$(echo -n "$FILE_NAME" | md5sum)

echo "FILE_NAME $FILE_NAME $FILE_HASH" | nc localhost $PORT

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_FILE_NAME" ]
then
echo "ERROR 2: File_Name incorrecto"
exit 2
fi

echo "6. ENVIAMOS CONTENIDO ARCHIVO"

cat client/dragon.txt | nc localhost $PORT

DATA=`nc -l $PORT`

echo "9. COMPROBAR OK O KO"

if [ "$DATA" != "OK_DATA" ]
then
echo "ERROR 3: Archivo vacío"
exit 3
fi

echo "10. ENVÍO MD5 DATOS"

HASH=`cat client/$FILE_NAME | md5sum`

echo "$HASH" | nc localhost $PORT

DATA=`nc -l $PORT`

if [ "$DATA" != "OK_MD5" ]
then
echo "ERROR 4: Contenido incorrecto"
exit 4
fi

echo "CONTENIDO CORRECTO"
