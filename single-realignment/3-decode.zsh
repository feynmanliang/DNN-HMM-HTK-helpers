#!/usr/bin/zsh
zmodload zsh/parameter

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
alignDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

#copy fine-tuning log for train/cv frame classification performance
tmp=(./MH0/dnntrain/*.finetune/)
finetune=${${tmp%/*}##*/}
cp ./MH0/dnntrain/$finetune/LOG \
  ./MH0/${finetune}-realign

# test the DNN
for insword in -8.0 -4.0 -2.0 0.0; do
  print "Decoding INSWORD=${insword} on training subset"
  ../../tools/steps/step-decode \
    -INSWORD $insword \
    -SUBTRAIN \
    `pwd`/MH0/dnntrain ${finetune} \
    MH0/decode-${finetune}-trainSub-realign-insword=${insword} &
  print "Decoding INSWORD=${insword} on test set"
  ../../tools/steps/step-decode \
    -INSWORD $insword \
    `pwd`/MH0/dnntrain ${finetune} \
    MH0/decode-${finetune}-realign-insword=${insword} &
done
while (( ${#jobstates} )); do
  print "Current active jobs: ${#jobstates}"
  print "Sleeping for $sleepsecs seconds"
  sleep ${sleepsecs}
done
print "Done all decoding jobs"
