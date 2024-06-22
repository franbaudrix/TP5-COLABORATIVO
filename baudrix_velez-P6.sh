#GRAFICOS PARA RECIBIR EL INPUT DE CIUDAD
if CIUDAD=$(zenity --entry \
--title="Ver clima de una ciudad" \
--text="Escriba el nombre de la ciudad:")
  then echo ""
else echo "No ha especifiocado ningún nombre"
fi


API_KEY="bcda1f43e3d340b7b1701001241106"

#convierte los espacios de la ciudad ingresada en %20 para ser utilizados en la url
CIUDAD=$(echo "$CIUDAD" | sed 's/ /%20/g')


URL="https://api.weatherapi.com/v1/current.json?key=$API_KEY&q=$CIUDAD&aqi=yes"

#toma los valores de la api
response=$(curl -s "$URL")


#obtiene la hora actual para luego chequear si este valor es null, si lo es significa que la ciudad
#ingresada no es valida

FECHA=$(echo "$response" | jq '.current.last_updated')

#chequea si hay un error antes de obtener los datos del clima
if [ "$?" -ne 0 ] || [ "$FECHA" = "null" ]; then
	echo "Error"
	exit 1
fi

#obtiene los datos del clima necesarios desde el response
TEMPERATURA=$(echo "$response" | jq '.current.temp_c')
TEXT=$(echo "$response" | jq '.current.condition.text')
HUMEDAD=$(echo "$response" | jq '.current.humidity')
VIENTO_VEL=$(echo "$response" | jq '.current.wind_kph')
VIENTO_DIR=$(echo "$response" | jq '.current.wind_dir')

#traduccion del texto de ingles a espaniol
TEXT=$(trans -b :es "$TEXT")

#reemplaza el %20 del nombre de la ciudad por un espacio y las " por nada
CIUDAD=$(echo "$CIUDAD" | sed 's/%20/ /g')
TEXT=$(echo "$TEXT" | sed 's/"//g')
FECHA=$(echo "$FECHA" | sed 's/"//g')
VIENTO_DIR=$(echo "$VIENTO_DIR" | sed 's/"//g')


clear
#Primero definimos una variable para ser el espacio constante que va a haber entre los datos y asi la segunda variable de espacio se va a adecuar a esta siempre y asi el espacio es el mismo
espacio_entre_datos1=15
espacio_total=$(( 15 + ${#TEMPERATURA} + $espacio_entre_datos1 )) #espacio_entre_datos es el espacio que queremos que haya siempre entre un dato y otro y 15 es el tamano constante de la palabra temperatura y un espacio
 

#for loop usado para definir la distancia entre temperatura y direccion del viento
espacio1=" "
for i in $(seq 1 $espacio_entre_datos1)
do
	espacio1+=" "
done

#for loop usado para definir la distancia entre humedad  y viento basandonos en la distancia predeterminada entre los datos anteriores
espacio_total2=$(( 13 + ${#HUMEDAD} ))

espacio2=" "
for (( i = $espacio_total2; i <= $espacio_total; i++ ))
do
	espacio2+=" "
done

#GRAFICOS PARA MOSTRAR LA INFORMACION DEL CLIMA
zenity --info --no-wrap \
--text="CLIMA $CIUDAD.\n$TEXT \n\nTemperatura: $TEMPERATURA°C$espacio1 Direccion del viento: $VIENTO_DIR\nHumedad del $HUMEDAD%$espacio2 Viento: $VIENTO_VEL km/h\n\n Actualizado al $FECHA"

