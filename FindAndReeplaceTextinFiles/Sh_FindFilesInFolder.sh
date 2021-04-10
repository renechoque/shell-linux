#!/bin/sh
#################################################################################################
# Nombre del shell   :   Sh_FindFilesInFolder.sh                                           #
# Creado por         :   RC                                                                     #
# Fecha Creacion     :   30/03/2021                                                             #
# Parametros         :   $1 Path to find                                                        #
#                                                                                               #
# Descripcion        :  Buscar todos los archivos en una carpeta que contiene una lista de textos#
# version            :   1.0                                                                    #
#################################################################################################

#Parametros utilizados
ppath=$1

oldIFS=$IFS # conserva el separador de campo
IFS=$'\n' # nuevo separador de campo, el caracter fin de línea

#Variables
xFecHorLog=`date +"%Y%m%d"_"%H%M%S"`
xFecHorFile=`date +"%Y%m%d"`
xPathresult="/home/risorse/S0006117"
xPathlog="${xPathresult}/log"
xShellFind="${xPathresult}/Sh_find_text_in_files.sh"
xShellReplace="${xPathresult}/Sh_replace_text_in_files.sh"
xNombreShell=`echo $(basename "$0") | awk -F'.' '{print $1}'`
xFileLog="${xPathlog}/${xNombreShell}_${xFecHorLog}.log"
xFileResult="${xPathresult}/result_${xNombreShell}_${xFecHorLog}.txt"
xFileResultDetail="${xPathresult}/result_detail_${xNombreShell}_${xFecHorLog}.txt"

#funcion de muestra log
fLog()
{
  echo "["`date "+ %d/%m/%y - %H:%M:%S"`"] $1"
  echo "["`date "+ %d/%m/%y - %H:%M:%S"`"] $1" >> ${xFileLog}
}

fOrquestador()
{
        for linea in $(cat ${xPathresult}/Equivalencias.txt);
        do
                vtext1=`echo "$linea" | awk -F"\t" '{print $1}'`
                #archivos .*
                vfiletype="."
                fLog " . Ejecutando Shell ${xShellFind} ${ppath} ${vfiletype} ${vtext1}"
                bash ${xShellFind} ${ppath} ${vfiletype} ${vtext1}
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt >> ${xFileResult} 
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt >> ${xFileResultDetail}  
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt 
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt 

        done
 
}

fLog " . =============================================== "
fLog " . EJECUCION DE BÚSQUEDA EN CARPETA"
fLog " . =============================================== "
fLog " . INICIO PROCESO ${xNombreShell}"
fOrquestador
fLog " . FIN PROCESO EN CARPETA"
IFS=$old_IFS # restablece el separador de campo predeterminado
#FIN