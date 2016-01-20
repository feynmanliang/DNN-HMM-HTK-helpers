#!/usr/bin/zsh

# realign using trained DNN
# uses triphone DNN for bigram LM, which should be the best so far
../../tools/steps/step-align \
  $(dirname `pwd`)/bigram-triphone/MH0/dnntrain/ \
  dnn7.finetune \
  MH0/align-dnn7.finetune-train
