#!/usr/bin/zsh

# final epoch train/cv accuracy
for alignNum in {1..10}; do
  trainAcc=$(cat \
    ./MH0/dnn*.finetune-realign-$alignNum \
    | tail -n17 \
    | head -n5 \
    | grep -P ".*Accuracy.*" \
    | awk -F '[ =]' '{print $5}')
  cvAcc=$(cat \
    ./MH0/dnn*.finetune-realign-$alignNum \
    | tail -n11 \
    | grep -P ".*Accuracy.*" \
    | awk -F '[ =]' '{print $5}')
  print $alignNum\;$trainAcc\;$cvAcc
done

# decode accuracies (includes $inswords)
for alignNum in {1..10}; do
  for insword in -8.0 -4.0 -2.0 0.0; do
    decodeAcc=$(cat \
      MH0/decode-dnn*.finetune-trainSub-realign-${alignNum}-insword=${insword}/test/LOG \
      | tail -n5 \
      | head -n1 \
      | awk -F '[ =]' '{print $5}')
    print $alignNum\;$insword\;Train.Set\;$decodeAcc

    decodeAcc=$(cat \
      MH0/decode-dnn*.finetune-realign-${alignNum}-insword=${insword}/test/LOG \
      | tail -n5 \
      | head -n1 \
      | awk -F '[ =]' '{print $5}')
    print $alignNum\;$insword\;Test.Set\;$decodeAcc
  done
done
