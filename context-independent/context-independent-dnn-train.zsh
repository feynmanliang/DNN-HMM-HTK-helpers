#!/usr/bin/zsh

modelDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/

# train DNN
# nvidia-smi # who's using the GPU?
../../tools/steps/step-dnntrain \
  -USEGPUID 0\
  ../../convert/mfc13d/env/environment_E_D_A_Z \
  $modelDir/align-mono-hmm84/align/timit_train.mlf $modelDir/mono/hmm84/MMF \
  $modelDir/mono/hmms.mlist MH0/dnntrain

# test
../../tools/steps/step-decode \
  -SUBTRAIN \
  `pwd`/MH0/dnntrain dnn7.finetune MH0/decode-dnn7.finetune-trainSub
../../tools/steps/step-decode \
  `pwd`/MH0/dnntrain dnn7.finetune MH0/decode-dnn7.finetune
