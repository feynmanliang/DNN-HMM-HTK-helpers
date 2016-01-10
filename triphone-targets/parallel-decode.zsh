#!/usr/bin/zsh
zmodload zsh/parameter

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

# test the DNN
for ptwd in 1 0.1; do
  for ftwd in 0.1 0.01 0.001 0.0001 0.00001; do
    xwtriDir=dnntrain-xwtri-ptwd=${ptwd}-ftwd=${ftwd}
    xwbiDir=dnntrain-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}
    for insword in -8.0 -4.0 -2.0 0.0; do
      print "Decoding INSWORD=${insword} on training subset"
      tmp=(./MH0/$xwtriDir/*.finetune/)
      finetune=${${tmp%/*}##*/}
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        -SUBTRAIN \
        `pwd`/MH0/$xwtriDir ${finetune} \
        MH0/decode-${finetune}-trainSub-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &

      tmp=(./MH0/$xwbiDir/*.finetune/)
      finetune=${${tmp%/*}##*/}
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        -SUBTRAIN \
        `pwd`/MH0/$xwbiDir ${finetune} \
        MH0/decode-${finetune}-trainSub-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &

      print "Decoding INSWORD=${insword} on test set"
      tmp=(./MH0/$xwtriDir/*.finetune/)
      finetune=${${tmp%/*}##*/}
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/$xwtriDir\
        ${finetune} \
        MH0/decode-${finetune}-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &

      tmp=(./MH0/$xwbiDir/*.finetune/)
      finetune=${${tmp%/*}##*/}
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/$xwbiDir\
        ${finetune} \
        MH0/decode-${finetune}-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
    done
  done
done

while (( ${#jobstates} )); do
  print "Waiting for ${#jobstates} jobs to finish"
  sleep ${sleepsecs}
done
print "Done all decoding jobs"

