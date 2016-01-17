#!/usr/bin/zsh
zmodload zsh/parameter

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
mfcDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
#hmmDir=$(dirname `pwd`)/"FBK_D_A_Z_FlatStart"
hmmDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

for numHiddenLayers in {2..8}; do
  subString=507X`repeat $numHiddenLayers printf 500X`3000

  #set the number of layers
  sed -i "s/set DNNSTRUCTURE=[^ #]*/set DNNSTRUCTURE=$subString/" ./HTE.dnntrain

  for ptwd in 0.1 0.01 0.001 0.0001 0.00001; do
    sed -i "s/set PTWEIGHTDECAY=[^ #]*/set PTWEIGHTDECAY=$ptwd/" ./HTE.dnntrain
    for ftwd in 0.1 0.01 0.001 0.0001 0.00001; do
      sed -i "s/set FTWEIGHTDECAY=[^ #]*/set FTWEIGHTDECAY=$ftwd/" ./HTE.dnntrain

      #remove trained dnn dir if present
      if [[ -d ./MH0/dnntrain ]]; then
        rm -rf ./MH0/dnntrain
      fi

      print "Training numHiddenLayers=$numHiddenLayers, ptwd=$ptwd, ftwd=$ftwd"

      #train the DNN
      ../../tools/steps/step-dnntrain \
        -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0\
        $envDir \
        $mfcDir/align-mono-hmm84/align/timit_train.mlf $mfcDir/mono/hmm84/MMF \
        $hmmDir/mono/hmms.mlist MH0/dnntrain

      ##copy fine-tuning log for train/cv frame classification performance
      tmp=(./MH0/dnntrain/*.finetune/)
      finetune=${${tmp%/*}##*/}

      cp ./MH0/dnntrain/$finetune/LOG \
        ./MH0/${finetune}-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd}

      # test the DNN
      for insword in -8.0 -4.0 -2.0 0.0; do
        print "Decoding INSWORD=${insword} on training subset"
        ../../tools/steps/step-decode \
          -INSWORD $insword \
          -SUBTRAIN \
          `pwd`/MH0/dnntrain ${finetune} \
          MH0/decode-${finetune}-trainSub-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &

        print "Decoding INSWORD=${insword} on test set"
        ../../tools/steps/step-decode \
          -INSWORD $insword \
          `pwd`/MH0/dnntrain ${finetune} \
          MH0/decode-${finetune}-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword} &
      done

      while (( ${#jobstates} )); do
        print "Current active jobs: ${#jobstates}"
        print "Sleeping for $sleepsecs seconds"
        sleep ${sleepsecs}
      done
      print "Done all decoding jobs"
    done
  done
done

