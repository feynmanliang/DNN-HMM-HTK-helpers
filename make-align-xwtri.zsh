#!/usr/bin/zsh

feature=MFC_E_D_A_Z
alignDir=`pwd`/${feature}_FlatStart
envDir=../convert/mfc13d/env/environment_E_D_A_Z

# train xwtri from MFC_E_D_A_Z_FlatStart monophones
../tools/steps/step-xwtri \
  -NUMMIXES 8 -ROVAL 200 -TBVAL 800 \
  `pwd`/$alignDir/mono hmm14 $alignDir/xwtri

# align frames
../tools/steps/step-align $alignDir/xwtri hmm84 \
  $alignDir/align-xwtri-hmm84
