#!/bin/sh
#################################################################################################
# Nombre del shell   :   Sh_ReplaceTextInFilesInFolder.sh                                       #
# Creado por         :   RC                                                                     #
# Fecha Creacion     :   30/03/2021                                                             #
# Parametros         :   $1 Path to find                                                        #
#                                                                                               #
# Descripcion        :  Buscar archivos (.sh, .py,.hql) que contiene un texto y los reemplaza   #
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
xFileTemp1="${xPathresult}/${xNombreShell}_1_${xFecHorLog}.tmp"
xFileTemp2="${xPathresult}/${xNombreShell}_2_${xFecHorLog}.tmp"
xFileTemp3="${xPathresult}/${xNombreShell}_3_${xFecHorLog}.tmp"

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
                #archivos .py
                vfiletype="py"
                fLog " . Ejecutando Shell ${xShellFind} ${ppath} ${vfiletype} ${vtext1}"
                bash ${xShellFind} ${ppath} ${vfiletype} ${vtext1}
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt >> ${xFileTemp1} 
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt >> ${xFileResultDetail}  
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt 
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt 


                #archivos .hql
                vfiletype="hql"
                fLog " . Ejecutando Shell ${xShellFind} ${ppath} ${vfiletype} ${vtext1}"
                bash ${xShellFind} ${ppath} ${vfiletype} ${vtext1}
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt >> ${xFileTemp1} 
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt >> ${xFileResultDetail}  
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt 
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt 
                
                #archivos .sh
                vfiletype="sh"
                fLog " . Ejecutando Shell ${xShellFind} ${ppath} ${vfiletype} ${vtext1}"
                bash ${xShellFind} ${ppath} ${vfiletype} ${vtext1}
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt >> ${xFileTemp1} 
                cat ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt >> ${xFileResultDetail}  
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}.txt 
                rm ${xPathresult}/Sh_find_text_in_files_${vfiletype}_${vtext1}_${xFecHorFile}_detail.txt 
        done
        cat ${xFileTemp1} | awk -F"\t" '{print $2}' > ${xFileTemp2} 
        
        fLog " . Aplicando equivalencias al archivo de salida"

        for linea in $(cat ${xPathresult}/Equivalencias.txt);
        do
                vtext1=`echo "$linea" | awk -F"\t" '{print $1}'`
                vtext2=`echo "$linea" | awk -F"\t" '{print $2}'`
                cat ${xFileTemp2} > ${xFileTemp3}
                sed "s/$vtext1/$vtext2/g" ${xFileTemp3} > ${xFileTemp2}
                rm ${xFileTemp3}
        done
    
        paste ${xFileTemp1} ${xFileTemp2} > ${xFileResult}
        rm ${xFileTemp1}
        rm ${xFileTemp2}

        fLog " . Archivo generado: ${xFileResult}"
        
        fLog " . Ejecutando Shell ${xShellReplace} ${xFileResult} "
        bash ${xShellReplace} ${xFileResult}       
}

fLog " . =============================================== "
fLog " . EJECUCION DE BÚSQUEDA EN CARPETA"
fLog " . =============================================== "
fLog " . INICIO PROCESO ${xNombreShell}"
fOrquestador
fLog " . FIN PROCESO EN CARPETA"
IFS=$old_IFS # restablece el separador de campo predeterminado
#FIN