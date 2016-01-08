#!/usr/bin/zsh
zmodload zsh/parameter

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
alignDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

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
    print "Decoding INS=$ins, SF=$sf on train"
    ../../tools/steps/step-decode \
      -DECODEHTE `pwd`/HTE.bigram-lm \
      -INSWORD $ins -GRAMMARSCALE $sf\
      -SUBTRAIN \
      `pwd`/MH0/dnntrain \
      dnn7.finetune \
      MH0/decode-dnn7.finetune-trainSub-ins-${ins}-sf-${sf} &

    print "Decoding INS=$ins, SF=$sf on test"
    ../../tools/steps/step-decode \
      -DECODEHTE `pwd`/HTE.bigram-lm \
      -INSWORD $ins -GRAMMARSCALE $sf\
      `pwd`/MH0/dnntrain \
      dnn7.finetune \
      MH0/decode-dnn7.finetune-ins-${ins}-sf-${sf} &
  done
done
while (( ${#jobstates} )); do
  print "Current active jobs: ${#jobstates}"
  print "Sleeping for $sleepsecs seconds"
  sleep ${sleepsecs}
done
print "Done all decoding jobs"
