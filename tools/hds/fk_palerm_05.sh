#!/bin/bash
#------------------------------------------------------------------------------
# Este script arranca HDL Designer con todas las librerias
#------------------------------------------------------------------------------

if [[ -z $HOME_PROJECT ]]
then
   echo
	echo "---------------------------------------------------------------------"
   echo "No estan configuradas las variables de entorno. "
   echo "Ejecucion detenida"
	echo "---------------------------------------------------------------------"
   echo
   exit 1
fi

cd $HOME_PROJECT/tools/hds
if [ "$(uname)" = "CYGWIN_NT-6.1" ]
then
   HDL_EXEC=hdldesigner
elif [ "$(uname)" = "Linux" ]
then
   HDL_EXEC=hds
fi

${HDL_EXEC} -user_home hds_user -team_home hds_team -hdpfile ${NAME_PROJECT}.hdp
