#!/usr/bin/zsh
zmodload zsh/parameter

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
alignDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

for ptwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
  sed -i "s/set PTWEIGHTDECAY=[^ #]*/set PTWEIGHTDECAY=$ptwd/" ./HTE.dnntrain
  for ftwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
    sed -i "s/set FTWEIGHTDECAY=[^ #]*/set FTWEIGHTDECAY=$ftwd/" ./HTE.dnntrain

    print "Training xwtri, ptwd=$ptwd, ftwd=$ftwd"

    #remove trained dnn dir if present
    if [[ -d ./MH0/dnntrain ]]; then
      rm -rf ./MH0/dnntrain
    fi

    #train the DNN
    ../../tools/steps/step-dnntrain \
      -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0\
      $envDir \
      $alignDir/align-xwtri-hmm84/align/timit_train.mlf $alignDir/xwtri/hmm84/MMF \
      $alignDir/xwtri/hmms.mlist MH0/dnntrain

    #copy fine-tuning log for train/cv frame classification performance
    tmp=(./MH0/dnntrain/*.finetune/)
    finetune=${${tmp%/*}##*/}
    cp ./MH0/dnntrain/$finetune/LOG \
      ./MH0/${finetune}-xwtri-ptwd=${ptwd}-ftwd=${ftwd}

    # test the DNN
    for insword in -8.0 -4.0 -2.0 0.0; do
      print "Decoding INSWORD=${insword} on training subset"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        -SUBTRAIN \
        `pwd`/MH0/dnntrain ${finetune} \
        MH0/decode-${finetune}-trainSub-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
      print "Decoding INSWORD=${insword} on test set"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/dnntrain ${finetune} \
        MH0/decode-${finetune}-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
    done
    while (( ${#jobstates} )); do
      print "Current active jobs: ${#jobstates}"
      print "Sleeping for $sleepsecs seconds"
      sleep ${sleepsecs}
    done
    print "Done all decoding jobs"

    print "Training xwbi-rc, ptwd=$ptwd, ftwd=$ftwd"

    #remove trained dnn dir if present
    if [[ -d ./MH0/dnntrain ]]; then
      rm -rf ./MH0/dnntrain
    fi

    #train the DNN
    ../../tools/steps/step-dnntrain \
      -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0\
      $envDir \
      $alignDir/align-xwbi-rc-hmm84/align/timit_train.mlf $alignDir/xwbi-rc/hmm84/MMF \
      $alignDir/xwbi-rc/hmms.mlist MH0/dnntrain

    ##copy fine-tuning log for train/cv frame classification performance
    tmp=(./MH0/dnntrain/*.finetune/)
    finetune=${${tmp%/*}##*/}

    cp ./MH0/dnntrain/$finetune/LOG \
      ./MH0/${finetune}-xwbi-rc=${ptwd}-ftwd=${ftwd}

    # test the DNN
    for insword in -8.0 -4.0 -2.0 0.0; do
      print "Decoding INSWORD=${insword} on training subset"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        -SUBTRAIN \
        `pwd`/MH0/dnntrain ${finetune} \
        MH0/decode-${finetune}-trainSub-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
      print "Decoding INSWORD=${insword} on test set"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/dnntrain ${finetune} \
        MH0/decode-${finetune}-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
    done
    while (( ${#jobstates} )); do
      print "Current active jobs: ${#jobstates}"
      print "Sleeping for $sleepsecs seconds"
      sleep ${sleepsecs}
    done
    print "Done all decoding jobs"
  done
done
