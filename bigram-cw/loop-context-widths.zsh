#!/usr/bin/zsh
zmodload zsh/parameter

features=(
"MFC_E_D_A_Z"
)
mfcDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
hmmDirs=(
$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
)
envDirs=(
"../../convert/mfc13d/env/environment_E_D_A_Z"
)
featureDims=(
39
)

sleepsecs=30 # seconds to sleep between checking if decoding forks are done

contexts=(
"-3,-2,-1,0,1,2,3"
"-4,-3,-2,-1,0,1,2,3,4"
"-5,-4,-3,-2,-1,0,1,2,3,4,5"
"-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7"
"-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8"
"-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9"
)

integer i
for i in {1..$#features}; do
  feature=$features[i]
  hmmDir=$hmmDirs[i]
  envDir=$envDirs[i]
  featureDim=$featureDims[i]

  for context in $contexts; do
    print "Training feature=$feature,context=$context"

    split=("${(@s/,/)context}") # @ modifier splits string into array
    contextLength=${#split}
    inputLayerSize=$(($featureDim*$contextLength))

    #set the context length and input layer size
    sed -i "s/set CONTEXTSHIFT=[^ ]*/set CONTEXTSHIFT=$context/" ./HTE.dnntrain
    sed -i "s/set DNNSTRUCTURE=[^X]*/set DNNSTRUCTURE=${inputLayerSize}/" ./HTE.dnntrain

    #train the DNN
    ../../tools/steps/step-dnntrain \
      -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0\
      $envDir \
      $mfcDir/align-mono-hmm84/align/timit_train.mlf $mfcDir/mono/hmm84/MMF \
      $hmmDir/mono/hmms.mlist MH0/dnntrain-$context &

    sleep 3
  done
done

while (( ${#jobstates} )); do
  print "Current active jobs: ${#jobstates}"
  print "Sleeping for $sleepsecs seconds"
  sleep ${sleepsecs}
done
print "Done all decoding jobs"

for i in {1..$#features}; do
  feature=$features[i]
  hmmDir=$hmmDirs[i]
  envDir=$envDirs[i]
  featureDim=$featureDims[i]

  for context in $contexts; do
    #copy fine-tuning log for train/cv frame classification performance
    cp ./MH0/dnntrain-$context/dnn7.finetune/LOG \
      ./MH0/dnn7.finetune-features=${feature}-context=${context}
  done
done
