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

if [ "$PREFIX" != "FILE_NAME" ]
then
echo "ERROR 2: Prefijo incorrecto"
echo "KO_FILE_NAME" | nc localhost $PORT
exit 2
fi

echo "OK_FILE_NAME" | nc localhost $PORT

echo "7. Recibimos contenido archivo"

FILE_NAME=`echo "$DATA" | cut -d " " -f 2`
CONTENIDO=`nc -l $PORT`

echo $CONTENIDO > server/$FILE_NAME

echo "OK_DATA" | nc localhost $PORT

DATA=`nc -l $PORT`
HASH=`cat client/dragon.txt | md5sum`

echo "8. COMPRUEBA SI ESTÁ VACÍO"

echo "11. RECIBE Y COMPRUEBA MD5"

if [ "$DATA" != "$HASH" ]
then
echo "ERROR 4: Contenido incorrecto"
echo "KO_MD5" | nc localhost $PORT
exit 4
fi

echo "OK_MD5" | nc localhost $PORT
