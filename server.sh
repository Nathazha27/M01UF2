#!/bin/bash

PORT="2022"

echo "Servidor de Dragon Magia Abuelita Miedo 2022"

echo "0. ESCUCHAMOS"

DATA=`nc -l $PORT`

echo "2. COMPRUEBO CABECERA"

if [ "$DATA" != "DMAM" ]
then
echo "ERROR 1: Cabecera incorrecta"
echo "KO_HEADER" | nc localhost $PORT
exit 1
fi

echo "OK_HEADER" | nc localhost $PORT

DATA=`nc -l $PORT`

echo "5. RECIBO FILE_NAME"

PREFIX=`echo "$DATA" | cut -d " " -f 1`
FILE_NAME=`echo "$DATA" | cut -d " " -f 2`
FILE_NAME_MD5=`echo "$DATA" | cut -d " " -f 3`

if [ "$PREFIX" != "FILE_NAME" ]
then
echo "ERROR 2: Prefijo incorrecto"
echo "KO_PREFIX" | nc localhost $PORT
exit 2
fi

FILE_HASH=$(echo -n "$FILE_NAME" | md5sum)

if [ "$FILE_NAME_MD5" != "$FILE_HASH" ]
then
echo "ERROR 3: Hash incorrecto"
echo "KO_FILE_MD5" | nc localhost $PORT
exit 3
fi

echo "OK_FILE_NAME" | nc localhost $PORT

echo "7. Recibimos contenido archivo"


CONTENIDO=`nc -l $PORT`

echo $CONTENIDO > server/$FILE_NAME

echo "8. Comprobamso si el archivo está vacío"
if [ ! -s server/$FILE_NAME ]
then
echo "ERROR 4: Archivo vacío"
echo "KO_DATA" | nc localhost $PORT
exit 4
fi

echo "OK_DATA" | nc localhost $PORT

DATA=`nc -l $PORT`

Prefix_MD5=`echo -n "$DATA" | cut -d " " -f 1`
FILE_MD5=`echo -n "$DATA" | cut -d " " -f 2`
HASH=`cat client/dragon.txt | md5sum`

echo "11. RECIBE Y COMPRUEBA PREFIJO Y MD5"

if [ "$Prefix_MD5" != "FILE_MD5" ]
then
echo "ERROR 5: Prefijo incorrecto"
echo "KO_FILE_MD5" | nc localhost $PORT
exit 5
fi

if [ "$FILE_MD5" != "$HASH" ]
then
echo "ERROR 6: Contenido incorrecto"
echo "KO_FILE_MD5" | nc localhost $PORT
exit 6
fi

echo "OK_FILE_MD5" | nc localhost $PORT
