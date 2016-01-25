#!/usr/bin/zsh
zmodload zsh/parameter

sleepsecs=30

contexts=(
"-4,-3,-2,-1,0,1,2,3,4"
"-5,-4,-3,-2,-1,0,1,2,3,4,5"
"-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7"
"-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8"
"-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9"
)

# decode using language model optimizing, insertion penalty and scale factor
for context in $contexts; do
  for ins in -16.0 -8.0 -4.0 -2.0 0.0; do
    for sf in 0.0 1.0 2.0 4.0; do
      print "Decoding INS=$ins, SF=$sf on train"
      ../../tools/steps/step-decode \
        -DECODEHTE `pwd`/HTE.bigram-lm \
        -INSWORD $ins -GRAMMARSCALE $sf\
        -SUBTRAIN \
        `pwd`/MH0/dnntrain-$context \
        dnn7.finetune \
        MH0/decode-dnn7.finetune-trainSub-context-${context}-ins-${ins}-sf-${sf} &

      print "Decoding INS=$ins, SF=$sf on test"
      ../../tools/steps/step-decode \
        -DECODEHTE `pwd`/HTE.bigram-lm \
        -INSWORD $ins -GRAMMARSCALE $sf\
        -CORETEST\
        `pwd`/MH0/dnntrain-$context \
        dnn7.finetune \
        MH0/decode-dnn7.finetune-context-${context}-ins-${ins}-sf-${sf} &
    done
  done
done

while (( ${#jobstates} )); do
  print "Current active jobs: ${#jobstates}"
  print "Sleeping for $sleepsecs seconds"
  sleep ${sleepsecs}
done
print "Done all decoding jobs"
