#!/bin/sh
#################################################################################################
# Nombre del shell   :   Sh_ReplaceTextInFiles.sh                                               #
# Creado por         :   RC                                                                     #
# Fecha Creacion     :   15/03/2021                                                             #
# Parametros         :   $1 List of files                                                       #
#                                                                                               #
# Descripcion        :  Reemplaza texto en archivos en base a un listado (archivo, texto a reemplazar)#
# version            :   1.0                                                                    #
#################################################################################################

#Parametros utilizados
pfiles=$1
oldIFS=$IFS # conserva el separador de campo
IFS=$'\n' # nuevo separador de campo, el caracter fin de línea

#Variables
xFecHorLog=`date +"%Y%m%d"_"%H%M%S"`
xFecHorFile=`date +"%Y%m%d"`
xPathresult="/home/risorse/S0006117"
xPathlog="${xPathresult}/log"
xNombreShell=`echo $(basename "$0") | awk -F'.' '{print $1}'`
xFileLog="${xPathlog}/${xNombreShell}_${pfile}_${xFecHorLog}.log"
xFileResult="${xPathresult}/result_${xNombreShell}_${xFecHorLog}.txt"
xFileTemp="${xPathresult}/${xNombreShell}_${xFecHorLog}.tmp"

cat /dev/null > ${xFileTemp}

#funcion de muestra log
fLog()
{
  echo "["`date "+ %d/%m/%y - %H:%M:%S"`"] $1"
  echo "["`date "+ %d/%m/%y - %H:%M:%S"`"] $1" >> ${xFileLog}
}

fReplaceText()
{
        fLog " . Realizando backup de archivos"
        for linea in $(cat $pfiles);
        do
                vfile=`echo "$linea" | awk -F"\t" '{print $1}'`
                cat $vfile > ${vfile}.backup634
        done

        fLog " . Aplicando equivalencias..."
        for linea in $(cat $pfiles);
        do
                vfile=`echo "$linea" | awk -F"\t" '{print $1}'`
                vtext1=`echo "$linea" | awk -F"\t" '{print $2}'`
                vtext2=`echo "$linea" | awk -F"\t" '{print $3}'`
                if [[ -f ${vfile}.backup634 ]];
                then
                        fLog " . Inicio para reemplazar $vtext1 por $vtext2 en $vfile "
                        cat $vfile > ${vfile}.tmp
                        if [[ -f ${vfile}.tmp ]];
                        then
                                sed "s/$vtext1/$vtext2/g" ${vfile}.tmp > $vfile
                                if [ $? -ne 0 ]; then
                                        fLog " . No se tiene permisos en el archivo $vfile "
                                        echo "0	No se tiene permisos en el archivo $vfile " >> ${xFileTemp}
                                else
                                        rm ${vfile}.tmp
                                        fLog " . Se reemplazo Ok $vtext1 por $vtext2 en $vfile "
                                        echo "1	Se reemplazo Ok" >> ${xFileTemp}
                                fi
                        else
                                fLog " . No se pudo crear archivo temporal ${vfile}.tmp "
                                echo "0	No se pudo crear archivo temporal ${vfile}.tmp " >> ${xFileTemp}
                        fi
                else 
                        fLog " . No existe backup del archivo a reemplazar ${vfile}.backup634 "
                        echo "0	No existe backup del archivo a reemplazar ${vfile}.backup634 " >> ${xFileTemp}
                fi

        done
        paste ${pfiles} ${xFileTemp} > ${xFileResult}
        rm ${xFileTemp}
}

fLog " . =============================================== "
fLog " . EJECUCION DEl PROCESO DE REEMPLAZO DE TEXTO"
fLog " . =============================================== "
fLog " . INICIO PROCESO ${xNombreShell}"
fLog " . REEMPLAZANDO ..."
fReplaceText
fLog " . FIN PROCESO DE REEMPLAZO DE TEXTO"
IFS=$old_IFS # restablece el separador de campo predeterminado
#FIN
