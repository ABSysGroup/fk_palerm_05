#!/bin/bash

#------------------------------------------------------------------------------
# Script parta compilar las librerias de simulacion de Xilinx
#------------------------------------------------------------------------------

echo "¿Deseas compilar las librerias de simulacion de Xilinx (Yes/[No])?"
select yn in "Yes" "No"; do
   case $REPLY in
      Yes)
         echo "La compilacion tomara 2-3 horas. ¿Estas seguro (Yes/[No])?";
         select sn in "Yes" "No"; do
            case $REPLY in
               Yes)
                  compxlib -s questasim -l vhdl -arch virtex6 -lib unisim -lib xilinxcorelib -lib simprim -w -dir ${HOME_PROJECTS}/${NAME_PROJECT}/work/compilation
                  exit
                  ;;
               No)
                  exit
                  ;;
            esac
         done
         ;;
      No)
         exit
         ;;
    esac
done
