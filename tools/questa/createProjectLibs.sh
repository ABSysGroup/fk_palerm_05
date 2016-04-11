#!/bin/bash
#------------------------------------------------------------------------------
# Este script define las librerias del proyecto tal y como estan
# definidas en el proyecto HDL.
# Deben coincidir con la definicion de las librerias en modelsim.ini. El archi-
# vo modelsim.ini esta definido en el directorio tools/questa
#------------------------------------------------------------------------------
libraryList="common correction estimation gain kalman_filter prediction update tb_common tb_correction tb_update"

#------------------------------------------------------------------------------
# Go to working directoty
#------------------------------------------------------------------------------
cd ${HOME_PROJECT}/work/compilation


#------------------------------------------------------------------------------
# Compiling libraries
#------------------------------------------------------------------------------
for lib in $libraryList
do
   echo "Creating lib" $lib "..."
   vlib $lib
   vmap $lib $lib
done

rm modelsim.ini
