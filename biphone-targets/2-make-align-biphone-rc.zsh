#!/usr/bin/zsh

alignDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart

# train biphone model
./step-xwbi \
  -NUMMIXES 8 -ROVAL 200 -TBVAL 800 \
  $alignDir/mono hmm14 $alignDir/xwbi-rc

# align
../tools/steps/step-align $alignDir/xwbi-rc hmm84 \
  xwbi-rc/align-xwbi-rc-hmm84
