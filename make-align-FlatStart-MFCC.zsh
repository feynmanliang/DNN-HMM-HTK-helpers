#!/usr/bin/zsh

modelDir=`pwd`/MFC_E_D_A_Z_FlatStart/

# train flat start model
../tools/steps/step-mono -FLATSTART -NUMMIXES 8 \
  ../convert/mfc13d//env/environment_E_D_A_Z $modelDir/mono

# align frames
../tools/steps/step-align $modelDir/mono hmm84 \
  $modelDir/align-mono-hmm84
