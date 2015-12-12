#!/usr/bin/zsh

modelDir=`pwd`/MFC_E_D_A_Z_FlatStart/

# align frames
../tools/steps/step-align $modelDir/mono hmm84 \
  $modelDir/align-mono-hmm84
