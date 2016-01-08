#!/usr/bin/zsh

# final epoch train/cv accuracy
trainAcc=$(cat \
  ./MH0/dnn*.finetune-realign \
  | tail -n17 \
  | head -n5 \
  | grep -P ".*Accuracy.*" \
  | awk -F '[ =]' '{print $5}')
cvAcc=$(cat \
  ./MH0/dnn*.finetune-realign \
  | tail -n11 \
  | grep -P ".*Accuracy.*" \
  | awk -F '[ =]' '{print $5}')
print $trainAcc\;$cvAcc

# decode accuracies (includes $inswords)
for insword in -8.0 -4.0 -2.0 0.0; do
  decodeAcc=$(cat \
    MH0/decode-dnn*.finetune-trainSub-realign-insword=${insword}/test/LOG \
    | tail -n5 \
    | head -n1 \
    | awk -F '[ =]' '{print $5}')
  print $insword\;Train.Set\;$decodeAcc

  decodeAcc=$(cat \
    MH0/decode-dnn*.finetune-realign-insword=${insword}/test/LOG \
    | tail -n5 \
    | head -n1 \
    | awk -F '[ =]' '{print $5}')
  print $insword\;Test.Set\;$decodeAcc
done
