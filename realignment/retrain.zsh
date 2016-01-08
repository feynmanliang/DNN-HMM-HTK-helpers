#!/usr/bin/zsh

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
alignDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/
realignDir=`pwd`/MH0/align-dnn7-train

# re-train the DNN
../../tools/steps/step-dnntrain \
  -DNNTRAINHTE $(dirname `pwd`)/bigram/HTE.dnntrain -USEGPUID 0 \
  $envDir \
  $realignDir/align/timit_train.mlf $alignDir/mono/hmm84/MMF \
  $alignDir/mono/hmms.mlist MH0/dnntrain-realign
