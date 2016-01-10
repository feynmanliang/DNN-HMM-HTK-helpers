#!/usr/bin/zsh
zmodload zsh/parameter

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
alignDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

for ptwd in 1 0.1; do
  for ftwd in 0.1 0.01 0.001 0.0001 0.00001; do
    hteFile=HTE.dnntrain
    #hteFile=HTE.dnntrain-ptwd=${ptwd}-ftwd=${ftwd}
    #cp ./HTE.dnntrain $hteFile
    sed -i "s/set PTWEIGHTDECAY=[^ #]*/set PTWEIGHTDECAY=$ptwd/" $hteFile
    sed -i "s/set FTWEIGHTDECAY=[^ #]*/set FTWEIGHTDECAY=$ftwd/" $hteFile

    print "Training xwtri and xwbi-rc, ptwd=$ptwd, ftwd=$ftwd"

    #xwtriDir=dnntrain-xwtri-ptwd=${ptwd}-ftwd=${ftwd}
    xwtriDir=dnntrain-xwtri
    #xwbiDir=dnntrain-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}
    xwbiDir=dnntrain-xwbi

    #remove trained dnn dir if present
    if [[ -d ./MH0/$xwtriDir ]]; then
      rm -rf ./MH0/$xwtriDir
    fi
    if [[ -d ./MH0/$xwbiDir ]]; then
      rm -rf ./MH0/$xwbiDir
    fi

    # fork: train the DNN
    ../../tools/steps/step-dnntrain \
      -DNNTRAINHTE `pwd`/$hteFile -USEGPUID 0 \
      $envDir \
      $alignDir/align-xwtri-hmm84/align/timit_train.mlf $alignDir/xwtri/hmm84/MMF \
      $alignDir/xwtri/hmms.mlist MH0/$xwtriDir &
    ../../tools/steps/step-dnntrain \
      -DNNTRAINHTE `pwd`/$hteFile -USEGPUID 0 \
      $envDir \
      $alignDir/align-xwbi-rc-hmm84/align/timit_train.mlf $alignDir/xwbi-rc/hmm84/MMF \
      $alignDir/xwbi-rc/hmms.mlist MH0/$xwbiDir &

    # join
    while (( ${#jobstates} )); do
      print "Waiting for ${#jobstates} jobs to finish"
      sleep ${sleepsecs}
    done
    print "Done all training jobs"

    tmp=(./MH0/$xwtriDir/*.finetune/)
    finetune=${${tmp%/*}##*/}
    cp ./MH0/$xwtriDir/$finetune/LOG \
      ./MH0/${finetune}-xwtri-ptwd=${ptwd}-ftwd=${ftwd}

    tmp=(./MH0/$xwbiDir/*.finetune/)
    finetune=${${tmp%/*}##*/}
    cp ./MH0/$xwbiDir/$finetune/LOG \
      ./MH0/${finetune}-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}

    # fork: test the DNN
    for insword in -8.0 -4.0 -2.0 0.0; do
      print "Decoding INSWORD=${insword} on training subset"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        -SUBTRAIN \
        `pwd`/MH0/$xwtriDir ${finetune} \
        MH0/decode-${finetune}-trainSub-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        -SUBTRAIN \
        `pwd`/MH0/$xwbiDir ${finetune} \
        MH0/decode-${finetune}-trainSub-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &

      print "Decoding INSWORD=${insword} on test set"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/$xwtriDir ${finetune} \
        MH0/decode-${finetune}-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/$xwbiDir ${finetune} \
        MH0/decode-${finetune}-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
    done
  done

  # join
  while (( ${#jobstates} )); do
    print "Waiting for ${#jobstates} jobs to finish"
    sleep ${sleepsecs}
  done
  print "Done all decoding jobs"
done
