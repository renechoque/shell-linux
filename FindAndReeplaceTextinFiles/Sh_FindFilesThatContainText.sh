#!/bin/sh
#################################################################################################
# Nombre del shell   :   Sh_FindFilesThatContainText.sh                                         #
# Creado por         :   RC                                                                     #
# Fecha Creacion     :   12/03/2021                                                             #
# Parametros         :   $1 Path to find                                                        #
# Parametros         :   $2 file type to find                                                        #
# Parametros         :   $3 text to find                                                        #
#                                                                                               #
# Descripcion        :  Buscar archivos que contiene una texto                                  #
# version            :   1.0                                                                    #
#################################################################################################

#Parametros utilizados
ppath=$1
pfiletype=$2
ptext=$3
oldIFS=$IFS # conserva el separador de campo
IFS=$'\n' # nuevo separador de campo, el caracter fin de línea

#Variables
xFecHorLog=`date +"%Y%m%d"_"%H%M%S"`
xFecHorFile=`date +"%Y%m%d"`
xPathresult="/home/risorse/S0006117"
xPathlog="${xPathresult}/log"
xNombreShell=`echo $(basename "$0") | awk -F'.' '{print $1}'`
xFileLog="${xPathlog}/${xNombreShell}_${pfiletype}_${ptext}_${xFecHorLog}.log"
xFileResult="${xPathresult}/${xNombreShell}_${pfiletype}_${ptext}_${xFecHorFile}.txt"
xFileResultDetail="${xPathresult}/${xNombreShell}_${pfiletype}_${ptext}_${xFecHorFile}_detail.txt"
xFileTemp1="${xPathresult}/${xNombreShell}_${pfiletype}_${ptext}_1_${xFecHorLog}.tmp"
xFileTemp2="${xPathresult}/${xNombreShell}_${pfiletype}_${ptext}_2_${xFecHorLog}.tmp"

cat /dev/null > ${xFileResult}
cat /dev/null > ${xFileResultDetail}

#funcion de muestra log
fLog()
{
  echo "["`date "+ %d/%m/%y - %H:%M:%S"`"] $1"
  echo "["`date "+ %d/%m/%y - %H:%M:%S"`"] $1" >> ${xFileLog}
}

fFindFiles()
{
        #Si $pfiletype es "." significa que se buscara todas las extensiones
        if [ "$pfiletype" = "." ]; then
                vfiletype="*"
        else
                vfiletype="$pfiletype"
        fi

        for file in $(find $ppath -name "*.$vfiletype" | xargs -I {} grep -il "$ptext" {});
        do
                if [[ -d $file ]];
                then
                        fLog "directorio: $file"
                else
                        fLog " . Buscando en archivo: $file"
                        cat /dev/null > ${xFileTemp1}
                        vlineas=`cat $file | grep $ptext | wc -l`
                        if [[ $vlineas > 0 ]]; then
                                echo "${file}	${ptext}" >> ${xFileResult}
                                for ((i=0; i<$vlineas; i++)); do echo "${file}" >> ${xFileTemp1}; done
                                cat $file | grep $ptext | sed 's/^[ \t]*//' > ${xFileTemp2}
                                paste ${xFileTemp1} ${xFileTemp2} >> ${xFileResultDetail}
                        fi

                fi
        done
        rm ${xFileTemp1}
        rm ${xFileTemp2}
}

fLog " . =============================================== "
fLog " . EJECUCION DEl PROCESO DE BÚSQUEDA DE TEXTO"
fLog " . =============================================== "
fLog " . INICIO PROCESO ${xNombreShell} ${ppath} ${pfiletype} ${ptext}"
fLog " . BUSCANDO ..."
fFindFiles
fLog " . FIN PROCESO DE BÚSQUEDA"
IFS=$old_IFS # restablece el separador de campo predeterminado
#FIN