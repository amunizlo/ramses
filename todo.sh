#! /bin/bash

#eps=10
for eps in $(seq 1.0 0.5 20.0); do
numCoef=20

NOM=cepstrum.$eps.$numCoef

DIR_WRK=$PWD

DIR_LOG=$DIR_WRK/LOG
FIC_LOG=$DIR_LOG/$(basename $0).$NOM.log
[ -d $DIR_LOG ] || mkdir -p $DIR_LOG

exec > >(tee $FIC_LOG) 2>&1

hostname
pwd
date

PAR=true
ENT=true
REC=true
EVA=true

#ficheros guia
DIR_GUI=$DIR_WRK/Gui
GUI_ENT=$DIR_GUI/train.gui
GUI_REC=$DIR_GUI/devel.gui

#directorios del sistema
DIR_SEN=$DIR_WRK/Sen
DIR_MAR=$DIR_WRK/Sen
DIR_PRM=$DIR_WRK/prm/$NOM
DIR_MOD=$DIR_WRK/Mod/$NOM
DIR_REC=$DIR_WRK/Rec/$NOM
LIS_MOD=$DIR_WRK/Lis/vocales.lis
FIC_RES=$DIR_WRK/Res/$NOM.res
[ -d $(dirname $FIC_RES) ] || mkdir -p $(dirname $FIC_RES)

#PARAMETRIZAMOS
FUNCPRM=trivial
EXEC_PRE=$DIR_PRM/$FUNCPRM.py
[ -d $(dirname $EXEC_PRE) ] || mkdir -p $(dirname $EXEC_PRE)
execpre="-x $EXEC_PRE"
funcPrm="-f $FUNCPRM"
echo "def $FUNCPRM (x):" | tee $EXEC_PRE
echo "  return x" | tee -a $EXEC_PRE

FUNCPRM=fft
EXEC_PRE=$DIR_PRM/$FUNCPRM.py
[ -d $(dirname $EXEC_PRE) ] || mkdir -p $(dirname $EXEC_PRE)
execpre="-x $EXEC_PRE"
funcPrm="-f $FUNCPRM"
echo "import numpy as np" | tee $EXEC_PRE
echo "def $FUNCPRM (x):" | tee -a $EXEC_PRE
echo "  return np.fft.fft(x)" | tee -a $EXEC_PRE 

FUNCPRM=pdgm
EXEC_PRE=$DIR_PRM/$FUNCPRM.py
[ -d $(dirname $EXEC_PRE) ] || mkdir -p $(dirname $EXEC_PRE)
execpre="-x $EXEC_PRE"
funcPrm="-f $FUNCPRM"
#eps=10
echo "import numpy as np" | tee $EXEC_PRE
echo "def $FUNCPRM (x):" | tee -a $EXEC_PRE
echo "  return 10 * np.log10($eps+np.abs(np.fft.fft(x)) ** 2)" | tee -a $EXEC_PRE 

FUNCPRM=cepstrum
EXEC_PRE=$DIR_PRM/$FUNCPRM.py
[ -d $(dirname $EXEC_PRE) ] || mkdir -p $(dirname $EXEC_PRE)
execpre="-x $EXEC_PRE"
funcPrm="-f $FUNCPRM"
echo "import numpy as np" | tee $EXEC_PRE
echo "def $FUNCPRM(x):" | tee -a $EXEC_PRE
echo "  logPdgm = 10 * np.log10($eps + np.abs(np.fft.fft(x)) ** 2)" | tee -a $EXEC_PRE
echo "  ceps = np.real(np.fft.ifft(logPdgm))" | tee -a $EXEC_PRE
echo "  return ceps[1:$numCoef + 1]" | tee -a $EXEC_PRE

dirSen="-s $DIR_SEN"
dirPrm="-p $DIR_PRM"

EXEC="parametriza.py $dirSen $dirPrm $execpre $funcPrm $GUI_ENT $GUI_REC"
$PAR && echo $EXEC && $EXEC || exit 1 

dirPrm="-p $DIR_PRM"
dirMar="-a $DIR_MAR"
dirMod="-m $DIR_MOD"

EXEC="entrena.py $dirPrm $dirMar $dirMod $GUI_ENT"
$ENT && echo $EXEC && $EXEC || exit 1

dirRec="-r $DIR_REC"
dirPrm="-p $DIR_PRM"
dirMod="-m $DIR_MOD"
lisMod="-l $LIS_MOD"

EXEC="reconoce.py $dirRec $dirPrm $dirMod $lisMod  $GUI_REC"
$REC && echo $EXEC && $EXEC || exit 1

dirRec="-r $DIR_REC"
dirMar="-a $DIR_MAR"

EXEC="evalua.py $dirRec $dirMar $GUI_REC"
$EVA && echo $EXEC && $EXEC | tee $FIC_RES || exit 1

done