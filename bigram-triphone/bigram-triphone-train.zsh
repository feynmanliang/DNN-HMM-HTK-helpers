#!/usr/bin/zsh
zmodload zsh/parameter

envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
mfcDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
hmmDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

# generate pronunciation dictionary from word list
python gen_dict_from_word_list.py word_list.txt lattice-phones.dct

# train (FBK, 6 context window, 5 layers, PTWD=1e-1, FTWD=1e-5, triphone targets) DNN-HMM
../../tools/steps/step-dnntrain \
  -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0 \
  $envDir \
  $mfcDir/align-xwtri-hmm84/align/timit_train.mlf $mfcDir/xwtri/hmm84/MMF \
  $hmmDir/xwtri/hmms.mlist MH0/dnntrain
