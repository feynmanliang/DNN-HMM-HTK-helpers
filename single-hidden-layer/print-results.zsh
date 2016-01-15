#!/usr/bin/zsh
features=(
"MFC_E_Z"
"MFC_E_D_Z"
"MFC_E_D_A_Z"
"FBK_Z"
"FBK_D_Z"
"FBK_D_A_Z"
)
contexts=(
"0"
"-1,0,1"
"-2,-1,0,1,2"
"-3,-2,-1,0,1,2,3"
"-4,-3,-2,-1,0,1,2,3,4"
"-5,-4,-3,-2,-1,0,1,2,3,4,5"
"-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6"
"-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7"
"-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8"
"-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9"
"-10,-9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9,10"
)
inswords=(-32.0 -16.0 -8.0 -4.0 -2.0 0.0 2.0 4.0)

# final epoch train/cv accuracy
for feature in $features; do
  for context in $contexts; do
    trainAcc=$(cat \
      MH0/dnn3.finetune-features=${feature}-context=${context} \
      | tail -n17 \
      | head -n5 \
      | grep -P ".*Accuracy.*" \
      | awk -F '[ =]' '{print $5}')
    cvAcc=$(cat \
      MH0/dnn3.finetune-features=${feature}-context=${context} \
      | tail -n11 \
      | grep -P ".*Accuracy.*" \
      | awk -F '[ =]' '{print $5}')
    print $feature\;$context\;$trainAcc\;$cvAcc
  done
done

# decode accuracies (includes $inswords)
for feature in $features; do
  for context in $contexts; do
    for insword in $inswords; do
      decodeAcc=$(cat \
        MH0/decode-dnn3.finetune-trainSub-features=${feature}-context=${context}-insword=${insword}/test/LOG \
        | tail -n5 \
        | head -n1 \
        | awk -F '[ =]' '{print $5}')
      print $feature\;$context\;$insword\;Train.Subset\;$decodeAcc

      decodeAcc=$(cat \
        MH0/decode-dnn3.finetune-features=${feature}-context=${context}-insword=${insword}/test/LOG \
        | tail -n5 \
        | head -n1 \
        | awk -F '[ =]' '{print $5}')
      print $feature\;$context\;$insword\;Test.Set\;$decodeAcc
    done
  done
done
