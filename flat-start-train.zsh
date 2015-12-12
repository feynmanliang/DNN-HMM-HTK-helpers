#!/usr/bin/zsh

modelDir=`pwd`/MFC_E_D_A_Z_FlatStart/

../tools/steps/step-mono -FLATSTART -NUMMIXES 8 \
  ../convert/mfc13d//env/environment_E_D_A_Z $modelDir/mono

# test
#../tools/steps/step-decode `pwd`/FBK_Z_FlatStart/mono hmm84 FBK_Z_FlatStart/decode-hmm84-mono

#for GSF in 2.0 4.0 8.0 16.0 32.0 64.0; do
#  eval ./steps/step-decode \
#    -GRAMMARSCALE $GSF \
#    `pwd`/FBK_Z_FlatStart/mono hmm84 FBK_Z_FlatStart/decode-hmm84-mono-gsf-$GSF
#done

#for INSWORD in -64.0 -32.0 -16.0 -8.0 -4.0 -2.0 0.0 2.0 4.0 8.0; do
#  eval ./steps/step-decode \
#    -INSWORD $INSWORD \
#    `pwd`/FBK_Z_FlatStart/mono hmm84 FBK_Z_FlatStart/decode-hmm84-mono-insword-$INSWORD
#done

