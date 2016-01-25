#!/usr/bin/zsh

contexts=(
"-3,-2,-1,0,1,2,3"
"-4,-3,-2,-1,0,1,2,3,4"
"-5,-4,-3,-2,-1,0,1,2,3,4,5"
"-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7"
"-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8"
"-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9"
)
widths=(
3
4
5
7
8
9
)

# final epoch train/cv accuracy
for context in $contexts; do
  trainAcc=$(cat \
    ./MH0/dnntrain-$context/*.finetune/LOG \
    | tail -n17 \
    | head -n5 \
    | grep -P ".*Accuracy.*" \
    | awk -F '[ =]' '{print $5}')
  cvAcc=$(cat \
    ./MH0/dnntrain-$context/*.finetune/LOG \
    | tail -n11 \
    | grep -P ".*Accuracy.*" \
    | awk -F '[ =]' '{print $5}')
  print $trainAcc\;$cvAcc
done

# decode accuracies
for i in {1..${#contexts}}; do
  for ins in -16.0 -8.0 -4.0 -2.0 0.0; do
    for sf in 0.0 1.0 2.0 4.0; do
      context=${contexts[i]}
      width=${widths[i]}
      decodeAcc=$(cat \
        MH0/decode-dnn*.finetune-trainSub-context-${context}-ins-${ins}-sf-${sf}/test/LOG \
        | tail -n5 \
        | head -n1 \
        | awk -F '[ =]' '{print $5}')
      print $width\;$ins\;$sf\;Train.Set\;$decodeAcc

      decodeAcc=$(cat \
        MH0/decode-dnn*.finetune-context-${context}-ins-${ins}-sf-${sf}/test/LOG \
        | tail -n5 \
        | head -n1 \
        | awk -F '[ =]' '{print $5}')
      print $width\;$ins\;$sf\;Test.Set\;$decodeAcc
    done
  done
done
