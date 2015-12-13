#!/usr/bin/zsh

dataDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/

# generate pronunciation dictionary from word list
python gen_dict_from_word_list.py word_list.txt lattice-phones.dct

# train DNN-HMM
../../tools/steps/step-dnntrain \
  -USEGPUID 0\
  ../../convert/mfc13d/env/environment_E_D_A_Z \
  $modelDir/align-mono-hmm84/align/timit_train.mlf $modelDir/mono/hmm84/MMF \
  $modelDir/mono/hmms.mlist MH0/dnntrain

# decode using language model
../../tools/steps/step-decode \
  `pwd`/MH0/dnntrain dnn7.finetune MH0/decode-dnn7.finetune


# optimize insertion penalty and scale factor
#for ins in -32.0 -16.0 -8.0 -4.0 -2.0 0.0; do
#  for sf in 1.0 2.0 4.0 8.0 16.0 32.0 64.0; do
#    ../../tools/steps/step-decode \
#      -DECODEHTE /home/fl350/mlsalt2-practical1/exp/bigram-lm/bigram_HTE.config \
#      -INSWORD $ins -GRAMMARSCALE $sf \
#      /home/fl350/mlsalt2-practical1/exp/MFC_D_A_Z_FlatStart/mono \
#      hmm84 \
#      MFC_D_A_Z_FlatStart/decode-hmm84-bigram-lm-ins-${ins}-sf-${sf}
#  done
#done
