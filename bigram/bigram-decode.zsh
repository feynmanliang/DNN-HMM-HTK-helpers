#!/usr/bin/zsh
zmodload zsh/parameter

sleepsecs=30

# decode using language model optimizing, insertion penalty and scale factor
for ins in -32.0 -16.0 -8.0 -4.0 -2.0 0.0 2.0 4.0 8.0; do
  #for sf in 0.0 1.0 2.0 4.0 8.0 16.0 32.0 64.0; do
    ../../tools/steps/step-decode \
      -INSWORD $ins \
      -SUBTRAIN \
      `pwd`/MH0/dnntrain \
      dnn7.finetune \
      MH0/decode-dnn7.finetune-trainSub-ins-${ins} &

    print "Decoding INS=$ins, SF=$sf on test"
    ../../tools/steps/step-decode \
      -INSWORD $ins \
      -CORETEST \
      `pwd`/MH0/dnntrain \
      dnn7.finetune \
      MH0/decode-dnn7.finetune-ins-${ins} &
    #print "Decoding INS=$ins, SF=$sf on train"
    #../../tools/steps/step-decode \
      #-DECODEHTE `pwd`/HTE.bigram-lm \
      #-INSWORD $ins -GRAMMARSCALE $sf\
      #-SUBTRAIN \
      #`pwd`/MH0/dnntrain \
      #dnn7.finetune \
      #MH0/decode-dnn7.finetune-trainSub-ins-${ins}-sf-${sf} &

    #print "Decoding INS=$ins, SF=$sf on test"
    #../../tools/steps/step-decode \
      #-DECODEHTE `pwd`/HTE.bigram-lm \
      #-INSWORD $ins -GRAMMARSCALE $sf\
      #-CORETEST \
      #`pwd`/MH0/dnntrain \
      #dnn7.finetune \
      #MH0/decode-dnn7.finetune-ins-${ins}-sf-${sf} &
  #done
done
while (( ${#jobstates} )); do
  print "Current active jobs: ${#jobstates}"
  print "Sleeping for $sleepsecs seconds"
  sleep ${sleepsecs}
done
print "Done all decoding jobs"
