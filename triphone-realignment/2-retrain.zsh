#!/usr/bin/zsh


envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
mfcDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
hmmDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
realignDir=`pwd`/MH0/align-dnn7.finetune-train

# re-train the DNN
../../tools/steps/step-dnntrain \
  -DNNTRAINHTE $(dirname `pwd`)/bigram-triphone/HTE.dnntrain -USEGPUID 0 \
  $envDir \
  $realignDir/align/timit_train.mlf $mfcDir/xwtri/hmm84/MMF \
  $hmmDir/xwtri/hmms.mlist MH0/dnntrain
