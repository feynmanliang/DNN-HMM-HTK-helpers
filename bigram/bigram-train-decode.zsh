#!/usr/bin/zsh

dataDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/

# generate pronunciation dictionary from word list
python gen_dict_from_word_list.py word_list.txt lattice-phones.dct

# train default (context-independent 5 hidden layer [-4,4] context window) DNN-HMM
../../tools/steps/step-dnntrain \
  -USEGPUID 0 \
  ../../convert/mfc13d/env/environment_E_D_A_Z \
  $dataDir/align-mono-hmm84/align/timit_train.mlf $dataDir/mono/hmm84/MMF \
  $dataDir/mono/hmms.mlist MH0/dnntrain

# decode using language model optimizing, insertion penalty and scale factor
for ins in -32.0 -16.0 -8.0 -4.0 -2.0 0.0; do
  for sf in 1.0 2.0 4.0 8.0 16.0 32.0 64.0; do
    ../../tools/steps/step-decode \
      -DECODEHTE `pwd`/HTE.bigram-lm \
      `pwd`/MH0/dnntrain \
      dnn7.finetune \
      MH0/decode-dnn7.finetune-ins-${ins}-sf-${sf}
  done
done
