#!/usr/bin/zsh

inswords=(-32.0 -16.0 -8.0 -4.0 -2.0 0.0 2.0 4.0)

# final epoch train/cv accuracy
for numHiddenLayers in {2..8}; do
  for ptwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
    for ftwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
      trainAcc=$(cat \
        ./MH0/dnn*.finetune-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd} \
        | tail -n17 \
        | head -n5 \
        | grep -P ".*Accuracy.*" \
        | awk -F '[ =]' '{print $5}')
      cvAcc=$(cat \
        ./MH0/dnn*.finetune-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd} \
        | tail -n11 \
        | grep -P ".*Accuracy.*" \
        | awk -F '[ =]' '{print $5}')
      print $numHiddenLayers\;$ptwd\;$ftwd\;$trainAcc\;$cvAcc
    done
  done
done

# decode accuracies (includes $inswords)
for numHiddenLayers in {2..8}; do
  for ptwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
    for ftwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
      for insword in -8.0 -4.0 -2.0 0.0; do
        decodeAcc=$(cat \
          MH0/decode-dnn*.finetune-trainSub-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword}/test/LOG \
          | tail -n5 \
          | head -n1 \
          | awk -F '[ =]' '{print $5}')
        print $numHiddenLayers\;$ptwd\;$ftwd\;$insword\;Train.Set\;$decodeAcc

        decodeAcc=$(cat \
          MH0/decode-dnn*.finetune-numHiddenLayers=${numHiddenLayers}-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword}/test/LOG \
          | tail -n5 \
          | head -n1 \
          | awk -F '[ =]' '{print $5}')
        print $numHiddenLayers\;$ptwd\;$ftwd\;$insword\;Test.Set\;$decodeAcc
      done
    done
  done
done
