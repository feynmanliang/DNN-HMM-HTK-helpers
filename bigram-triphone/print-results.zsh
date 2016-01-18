#!/usr/bin/zsh

# final epoch train/cv accuracy
trainAcc=$(cat \
  ./MH0/dnntrain/*.finetune/LOG \
  | tail -n17 \
  | head -n5 \
  | grep -P ".*Accuracy.*" \
  | awk -F '[ =]' '{print $5}')
cvAcc=$(cat \
  ./MH0/dnntrain/*.finetune/LOG \
  | tail -n11 \
  | grep -P ".*Accuracy.*" \
  | awk -F '[ =]' '{print $5}')
print $trainAcc\;$cvAcc

# decode accuracies
for ins in -32.0 -16.0 -8.0 -4.0 -2.0 0.0; do
  for sf in 1.0 2.0 4.0 8.0 16.0 32.0 64.0; do
    decodeAcc=$(cat \
      MH0/decode-dnn*.finetune-trainSub-ins-${ins}-sf-${sf}/test/LOG \
      | tail -n5 \
      | head -n1 \
      | awk -F '[ =]' '{print $5}')
    print $ins\;$sf\;Train.Set\;$decodeAcc

    decodeAcc=$(cat \
      MH0/decode-dnn*.finetune-ins-${ins}-sf-${sf}/test/LOG \
      | tail -n5 \
      | head -n1 \
      | awk -F '[ =]' '{print $5}')
    print $ins\;$sf\;Test.Set\;$decodeAcc
  done
done
