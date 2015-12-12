#!/usr/bin/zsh

features=(
"FBK"
"MFC"
)
alignDirs=(
$(dirname `pwd`)/"FBK_D_A_Z_FlatStart"
$(dirname `pwd`)/"MFC_E_D_A_Z"
)
envDirs=(
"../../convert/fbk25d/env/environment_D_A_Z"
"../../convert/mfc13d/env/environment_E_D_A_Z"
)

integer i
for i in {1..$#features}; do
  feature=$features[i]
  alignDir=$alignDirs[i]
  envDir=$envDirs[i]

  contexts=(
  "0"
  "-1,0,1"
  "-2,-1,0,1,2"
  "-3-2,-1,0,1,2,3"
  "-4,-3,-2,-1,0,1,2,3,4"
  "-5,-4,-3,-2,-1,0,1,2,3,4,5"
  "-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6"
  "-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7"
  "-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8"
  "-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9"
  "-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10"
  )

  for context in $contexts; do
    print "Training feature=$feature,context=$context"

    #remove trained dnn dir if present
    if [[ -d ./MH0/dnntrain ]]; then
      rm -rf ./MH0/dnntrain
    fi

    split=("${(@s/,/)context}") # @ modifier splits string into array
    contextLength=${#split}
    inputLayerSize=$(($contextLength*39))

    #set the context length and input layer size
    sed -i "s/set CONTEXTSHIFT=[^ ]*/set CONTEXTSHIFT=$context/" ./HTE.dnntrain
    sed -i "s/set DNNSTRUCTURE=[^X]*/set DNNSTRUCTURE=${inputLayerSize}/" ./HTE.dnntrain

    #train the DNN
    ../../tools/steps/step-dnntrain \
      -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0\
      $envDir \
      $alignDir/align-mono-hmm84/align/timit_train.mlf $alignDir/mono/hmm84/MMF \
      $alignDir/mono/hmms.mlist MH0/dnntrain

    #copy fine-tuning log for train/cv frame classification performance
    cp ./MH0/dnntrain/dnn3.finetune/LOG \
      ./MH0/dnn3.finetune-features=${feature}-context=${context}

    #test the DNN
    for insword in -32.0 -16.0 -8.0 -4.0 -2.0 0.0 2.0 4.0; do
      print "Decoding INSWORD=${insword}"
      ../../tools/steps/step-decode \
        -INSWORD $insword \
        `pwd`/MH0/dnntrain dnn3.finetune \
        MH0/decode-dnn3.finetune-features=${feature}-context=${context}-insword=${insword}
    done
  done
done


