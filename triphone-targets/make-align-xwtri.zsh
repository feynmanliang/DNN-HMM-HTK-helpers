#!/usr/bin/zsh

# train xwtri from MFC_E_D_A_Z_FlatStart monophones, HMM for generating alignments
../../tools/steps/step-xwtri \
  -NUMMIXES 8 -ROVAL 200 -TBVAL 800 \
  $(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/mono hmm14 $(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/xwtri

# align frames using MFC_E_D_A_Z, best performing GMM-HMM model
../../tools/steps/step-align $(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/xwtri hmm84 \
  $(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/align-xwtri-hmm84

#rm -rf $(dirname `pwd`)/MFC_E_D_A_Z_FlatStart/xwtri

# train xwtri from FBK_D_A_Z monophones, HMM hidden states for use with DNN likelihood
#../../tools/steps/step-xwtri \
#  -NUMMIXES 8 -ROVAL 200 -TBVAL 800 \
#  $(dirname `pwd`)/FBK_D_A_Z_FlatStart/mono hmm14 $(dirname `pwd`)/FBK_D_A_Z_FlatStart/xwtri

