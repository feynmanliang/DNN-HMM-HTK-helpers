#!/usr/bin/zsh

modelDir=$(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/

contexts=(
  #"0"
  "-1,0,1"
  "-2,-1,0,1,2"
  "-3-2,-1,0,1,2,3"
#  "-4,-3-2,-1,0,1,2,3,4"
  "-5,-4,-3-2,-1,0,1,2,3,4,5"
  "-6,-5,-4,-3-2,-1,0,1,2,3,4,5,6"
  "-7,-6,-5,-4,-3-2,-1,0,1,2,3,4,5,6,7"
  "-8,-7,-6,-5,-4,-3-2,-1,0,1,2,3,4,5,6,7,8"
  "-9,-8,-7,-6,-5,-4,-3-2,-1,0,1,2,3,4,5,6,7,8,9"
  "-10,-9,-8,-7,-6,-5,-4,-3-2,-1,0,1,2,3,4,5,6,7,8,9,10"
)

for context in $contexts; do
  # remove trained dnn dir if present
  if [[ -d ./MH0/dnntrain ]]; then
    rm -rf ./MH0/dnntrain
  fi

  split=("${(@s/,/)context}") # @ modifier splits string into array
  contextLength=${#split}
  inputLayerSize=$(($contextLength*39))

  # set the context length and input layer size
  sed -i "s/set CONTEXTSHIFT=[^ ]*/set CONTEXTSHIFT=$context/" ./HTE.dnntrain
  sed -i "s/set DNNSTRUCTURE=[^X]*/set DNNSTRUCTURE=${inputLayerSize}/" ./HTE.dnntrain

  # train the DNN
  ../../tools/steps/step-dnntrain \
    -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0\
    ../../convert/mfc13d/env/environment_E_D_A_Z \
    $modelDir/align-mono-hmm84/align/timit_train.mlf $modelDir/mono/hmm84/MMF \
    $modelDir/mono/hmms.mlist MH0/dnntrain

  # test the DNN
  ../../tools/steps/step-decode \
    `pwd`/MH0/dnntrain dnn3.finetune MH0/decode-dnn3.finetune-context=$context
done

