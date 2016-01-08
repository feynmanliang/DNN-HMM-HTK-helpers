#!/usr/bin/zsh

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
alignDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/

# generate pronunciation dictionary from word list
python gen_dict_from_word_list.py word_list.txt lattice-phones.dct

# train (MFCC, 6 context window, 5 layers, PTWD=1e-1, FTWD=1e-5, mono targets) DNN-HMM
../../tools/steps/step-dnntrain \
  -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0 \
  $envDir \
  $alignDir/align-mono-hmm84/align/timit_train.mlf $alignDir/mono/hmm84/MMF \
  $alignDir/mono/hmms.mlist MH0/dnntrain

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
