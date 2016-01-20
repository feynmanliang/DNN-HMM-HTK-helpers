#!/usr/bin/zsh
zmodload zsh/parameter

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
mfcDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
hmmDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

integer i
for i in {2..10}; do
  if ((i == 1)); then
    alignDnnPath=$(dirname `pwd`)/bigram/MH0/dnntrain
  else
    alignDnnPath=`pwd`/MH0/dnntrain-$((i-1))
  fi
  realignDir=`pwd`/MH0/align-${i}-dnn7.finetune-train
  retrainDnnPath=`pwd`/MH0/dnntrain-${i}

  # realign using trained DNN
  # uses DNN for bigram LM, which should be the best so far
  ../../tools/steps/step-align \
    $alignDnnPath \
    dnn7.finetune \
    $realignDir

  ../../tools/steps/step-dnntrain \
    -DNNTRAINHTE $(dirname `pwd`)/bigram/HTE.dnntrain -USEGPUID 0 \
    $envDir \
    $realignDir/align/timit_train.mlf $mfcDir/mono/hmm84/MMF \
    $hmmDir/mono/hmms.mlist $retrainDnnPath

  #copy fine-tuning log for train/cv frame classification performance
  tmp=($retrainDnnPath/*.finetune/)
  finetune=${${tmp%/*}##*/}
  cp $retrainDnnPath/$finetune/LOG \
    ./MH0/${finetune}-realign-${i}

  # test the DNN
  for insword in -8.0 -4.0 -2.0 0.0; do
    print "Decoding INSWORD=${insword} on training subset"
    ../../tools/steps/step-decode \
      -INSWORD $insword \
      -SUBTRAIN \
      $retrainDnnPath $finetune \
      MH0/decode-${finetune}-trainSub-realign-${i}-insword=${insword} &
    print "Decoding INSWORD=${insword} on test set"
    ../../tools/steps/step-decode \
      -INSWORD $insword \
      $retrainDnnPath $finetune \
      MH0/decode-${finetune}-realign-${i}-insword=${insword} &
  done
  while (( ${#jobstates} )); do
    print "Current active jobs: ${#jobstates}"
    print "Sleeping for $sleepsecs seconds"
    sleep ${sleepsecs}
  done
  print "Done all decoding jobs"
done
