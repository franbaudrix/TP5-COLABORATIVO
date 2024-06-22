div_cero() { #Funcion que evita que se ejecute la division por 0, asi no se detiene el programa, y advierte al usuario del error 
	echo ""
	echo "Error! No es posible dividir por 0"
	echo ""
	while true; do
      		read -p "Ingresa x para volver al menu: " volver
      		if [[ $volver == $'x' ]]; then
         		break
      		else
			echo ""
         		echo "Error! Opcion inexistente"
      			echo ""
		fi
	done
}

hacer_cuenta_y_error_handling() { #Funcion que recibe parametros que varian dependiendo de la eleccion del usuario
#Ejemplo: si es una suma, pasamos el simbolo de sumar, etc.
	local operacion="$operacion" #Aca recibimos el simbolo correspondiente a la eleccion del usuario
	local titulo="$titulo" #Y aca recibimos el nombre de la operacion que se eligio para luego mostrarla en los graficos
	clear
        graphics "$titulo" 
	echo ""
        read num1
	echo ""
        clear
        cad="$num1 $operacion "
        graphics "$titulo"
	echo ""
        read -p "$cad" num2
	echo ""
	if [[ $operacion = "/" && $num2 = 0 ]]; then #Si la viarable operacion es division y se elige como segundo numero el 0
	#entonces el usuario esta intentando dividir por 0, por lo que le mostramos un error.	
  		div_cero
	elif [ "$(echo "$num2" | bc)" != "$num2" ]; then #Con "bc" hacemos que se interprete el valor como un numero, si el
 	#usuario ingreso un dato no numerico, entonces esta accion va a dar error y por consiguiente no va a ser igual a si mismo
                zenity --error --no-wrap --text="Ingresaste un valor incorrecto,\nsolo podes ingresar numeros!"
        elif [ "$(echo "$num1" | bc)" != "$num1" ]; then #Mismo proceso que el anterior, pero con el otro numero
		zenity --error --no-wrap --text="Ingresaste un valor incorrecto,\nsolo podes ingresar numeros!"
	else
		clear
        	graphics "$titulo" #Si el input es correcto, mostramos los graficos y hacemos la cuenta
        	total=$(echo "scale=5; $num1 $operacion $num2" | bc)
		echo ""
        	echo "$num1 $operacion $num2 = $total"
		echo ""
        	while true; do #While loop para que el usuario no pueda volver al menu hasta presionar x
                	echo -n "Ingresa x para volver al menu: "
                	read -r -n 2 volver
                	if [[ $volver == $'x' || $volver == $'X' ]]; then
                        	break
                	else
                        	echo "Opcion invalida, para volver al menu ingresa x"
                	fi 
        	done
	fi
}



graphics() { #Funcion que muestra los graficos de las distintas opciones de la calculadora 
	echo "################################"
	tamanio=${#1}
	let tamanio=tamanio/2
	let tamanio=14-tamanio
	tit=""
	for i in $(seq 1 $tamanio)
	do
	tit="$tit "
	done
	echo "#$tit $1 $tit#"
	echo "################################"
}

while true; do #Graficos para mostrar constantemente el menu
clear
graphics "MENU"
echo "#                              #"
echo "# Opcion[1] - Suma             #"
echo "# Opcion[2] - Resta            #"
echo "# Opcion[3] - Multiplicacion   #"
echo "# Opcion[4] - Division         #"
echo "# Opcion[5] - Manual De Uso    #"
echo "# Opcion[0] - Salir            #"
echo "#                              #"
echo "################################"
echo -n "Ingresa tu eleccion: "
read opcion

#Estructura if que deriva al usuario a la funcion para hacer la cuenta con el simbolo y titulo correspondientes a la opcion elegida
if [ "$opcion" -eq 1 ]; then
	clear
	operacion="+"
	titulo="SUMA"
	hacer_cuenta_y_error_handling operacion titulo
elif [ "$opcion" -eq 2 ]; then 
	clear
	operacion="-"
        titulo="RESTA"
        hacer_cuenta_y_error_handling operacion titulo
elif [ "$opcion" -eq 3 ]; then
	clear
	operacion="*"
	titulo="MULTIPLICACION"
        hacer_cuenta_y_error_handling operacion titulo
elif [ "$opcion" -eq 4 ]; then
	clear
	operacion="/"
	titulo="DIVISION"
        hacer_cuenta_y_error_handling operacion titulo
elif [ "$opcion" -eq 5 ]; then
	zenity --info --no-wrap \
               --text="MANUAL DE USO\n\n Luego de seleccionar la operacion deseada, siga estos pasos:\n\n 1. Ingrese el primer numero y presione enter. \n\n 2. Ingrese el segundo numero y presione enter nuevamente. \n\n 3. El resultado de su cuenta se mostrara en pantalla. \n\n 4. Para volver al menu principal, presione la letra X." 
elif [ "$opcion" -eq 0 ]; then
	clear
	break;
fi
done
