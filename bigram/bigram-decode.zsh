#!/usr/bin/zsh

# generate pronunciation dictionary from word list
python gen_dict_from_word_list.py word_list.txt lattice-phones.dct

# train DNN-HMM


#../../tools/steps/step-decode -DECODEHTE `pwd`/bigram_HTE.config ${PWD%/*}/MFC_D_A_Z_FlatStart/xwtri hmm84 MFC_D_A_Z_FlatStart/decode-hmm84-bigram-lm

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

for t in 0 1 5 10 25 50 75 100; do
  ins=0.0
  sf=8.0
  sed -i "s/bigram_lm_lattice.*$/bigram_lm_lattice_${t}/" ./bigram_HTE.config
  ../../tools/steps/step-decode \
    -DECODEHTE /home/fl350/mlsalt2-practical1/exp/bigram-lm/bigram_HTE.config \
    -INSWORD $ins -GRAMMARSCALE $sf \
    /home/fl350/mlsalt2-practical1/exp/MFC_D_A_Z_FlatStart/mono \
    hmm84 \
    MFC_D_A_Z_FlatStart/decode-hmm84-bigram-lm-t-${t}-ins-${ins}-sf-${sf}
done

