#! /usr/bin/python3

import soundfile as sf
import tqdm
import numpy as np

from util import *
from prm import *
#exec(open('ramses/util.py').read())
#exec(open('ramses/prm.py').read())

<<<<<<< HEAD
def parametriza(dirPrm, dirSen, *guiSen, funcPrm = lambda x:x):
=======
def parametriza(dirPrm, dirSen, *guiSen, funcprm = lambda x:x):
>>>>>>> be8a7ea1bb03285bf0fe233a8ff69d8de2e88580
    """
    Lee las señales indicadas por 'dirSen', 'guiSen' y 'extSen', y escribe la señal
    parametrizada en el directorio 'dirPrm'.
    
    En la versión trivial, la señal parametrizada es igual a la señal temporal.
    """

    for nomSen in tqdm.tqdm(leeLis(*guiSen)):
        pathSen = pathName(dirSen, nomSen, "wav")
        sen, fm = sf.read(pathSen)

<<<<<<< HEAD
        prm = funcPrm(sen)
=======
        prm = funcprm(sen)
>>>>>>> be8a7ea1bb03285bf0fe233a8ff69d8de2e88580

        pathPrm = pathName(dirPrm, nomSen, ".prm")
        chkPathName(pathPrm)
        escrPrm(pathPrm, prm)

#################################################################################
# Invocación en línea de comandos
#################################################################################

if __name__ == '__main__':
    from docopt import docopt
    import sys

    Sinopsis = f"""
Parametriza una base de datos de señal.

Usage:
    {sys.argv[0]} [options] <guiSen>...
    {sys.argv[0]} -h | --help
    {sys.argv[0]} --version


Opciones:
    -s PATH, --dirSen=PATH  Directorio con las señales temporales [default: .]
    -p PATH, --dirPrm=PATH  Directorio con las señales parametrizadas [default: .]
<<<<<<< HEAD
    -x SCRIPT..., --execPre SCRIPT...  script(s) a ejecutar en python previos
    -f EXP, --funcPrm=EXPR  Expresión Python para parametrización
=======
    -x SCRIPT..., --execPre=SCRIPT...  script(s) Python previos 
    -f EXPR, --funcPrm=EXPR  Expresion Python parametrizacion 
>>>>>>> be8a7ea1bb03285bf0fe233a8ff69d8de2e88580

Argumentos:
    <guiSen>  Nombre del fichero guía con los nombres de las señales a parametrizar.
              Pueden especificarse tantos ficheros guía como sea necesario.

Parametrización trivial:
    En la versión trivial del sistema, la parametrización simplemente copia la señal
    temporal en la salida.
"""

    args = docopt(Sinopsis, version=f'{sys.argv[0]}: Ramses v3.4 (2020)')

    dirSen = args['--dirSen']
    dirPrm = args['--dirPrm']

    guiSen = args['<guiSen>']
    scripts = args['--execPre']
    if scripts:
        for script in scripts.split(','):
            exec(open(script).read())
<<<<<<< HEAD

    funcPrm = eval(args['--funcPrm']) if args['--funcPrm'] else lambda x:x

    parametriza(dirPrm, dirSen, *guiSen, funcPrm=funcPrm)
=======

    funcPrm = eval(args['--funcPrm']) if args['--funcPrm'] else lambda x:x 

    parametriza(dirPrm, dirSen, *guiSen, funcprm=funcPrm)
>>>>>>> be8a7ea1bb03285bf0fe233a8ff69d8de2e88580
