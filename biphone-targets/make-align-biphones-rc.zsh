#!/usr/bin/zsh

alignDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart

# generate biphone model lists and LED
./make_labels_and_mlists.zsh

# train biphone model
./step-xwbi \
  -NUMMIXES 8 -ROVAL 200 -TBVAL 800 \
  $alignDir/mono hmm14 $alignDir/xwbi-rc

# align
../../tools/steps/step-align $alignDir/xwbi-rc hmm84 \
  $alignDir/align-xwbi-rc-hmm84
