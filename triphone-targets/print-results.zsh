#!/usr/bin/zsh

# final epoch train/cv accuracy
  for ptwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
    for ftwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
      trainAcc=$(cat \
        ./MH0/dnn*.finetune-xwtri-ptwd=${ptwd}-ftwd=${ftwd} \
        | tail -n17 \
        | head -n5 \
        | grep -P ".*Accuracy.*" \
        | awk -F '[ =]' '{print $5}')
      cvAcc=$(cat \
        ./MH0/dnn*.finetune-xwtri-ptwd=${ptwd}-ftwd=${ftwd} \
        | tail -n11 \
        | grep -P ".*Accuracy.*" \
        | awk -F '[ =]' '{print $5}')
      print xwtri\;$ptwd\;$ftwd\;$trainAcc\;$cvAcc

      trainAcc=$(cat \
        ./MH0/dnn*.finetune-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd} \
        | tail -n17 \
        | head -n5 \
        | grep -P ".*Accuracy.*" \
        | awk -F '[ =]' '{print $5}')
      cvAcc=$(cat \
        ./MH0/dnn*.finetune-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd} \
        | tail -n11 \
        | grep -P ".*Accuracy.*" \
        | awk -F '[ =]' '{print $5}')
      print xwbi-rc\;$ptwd\;$ftwd\;$trainAcc\;$cvAcc
    done
  done

# decode accuracies (includes $inswords)
  for ptwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
    for ftwd in 0.1 0.01 0.001 0.0001 0.00001 0.000001; do
      for insword in -8.0 -4.0 -2.0 0.0; do
        decodeAcc=$(cat \
          MH0/decode-dnn*.finetune-trainSub-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword}/test/LOG \
          | tail -n5 \
          | head -n1 \
          | awk -F '[ =]' '{print $5}')
        print xwtri\;$ptwd\;$ftwd\;$insword\;Train.Set\;$decodeAcc
        decodeAcc=$(cat \
          MH0/decode-dnn*.finetune-xwtri-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword}/test/LOG \
          | tail -n5 \
          | head -n1 \
          | awk -F '[ =]' '{print $5}')
        print xwtri\;$ptwd\;$ftwd\;$insword\;Test.Set\;$decodeAcc

        decodeAcc=$(cat \
          MH0/decode-dnn*.finetune-trainSub-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword}/test/LOG \
          | tail -n5 \
          | head -n1 \
          | awk -F '[ =]' '{print $5}')
        print xwbi-rc\;$ptwd\;$ftwd\;$insword\;Train.Set\;$decodeAcc
        decodeAcc=$(cat \
          MH0/decode-dnn*.finetune-xwbi-rc-ptwd=${ptwd}-ftwd=${ftwd}-insword=${insword}/test/LOG \
          | tail -n5 \
          | head -n1 \
          | awk -F '[ =]' '{print $5}')
        print xwbi-rc\;$ptwd\;$ftwd\;$insword\;Test.Set\;$decodeAcc
      done
    done
  done
