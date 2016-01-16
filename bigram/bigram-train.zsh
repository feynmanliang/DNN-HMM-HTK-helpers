#!/usr/bin/zsh
zmodload zsh/parameter

#envDir="../../convert/fbk25d/env/environment_D_A_Z"
envDir="../../convert/mfc13d/env/environment_E_D_A_Z"
mfcDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"
#hmmDir=$(dirname `pwd`)/"FBK_D_A_Z_FlatStart"
hmmDir=$(dirname `pwd`)/"MFC_E_D_A_Z_FlatStart"

# generate pronunciation dictionary from word list
python gen_dict_from_word_list.py word_list.txt lattice-phones.dct

# train (FBK, 6 context window, 5 layers, PTWD=1e-1, FTWD=1e-5, mono targets) DNN-HMM
../../tools/steps/step-dnntrain \
  -DNNTRAINHTE `pwd`/HTE.dnntrain -USEGPUID 0 \
  $envDir \
  $mfcDir/align-mono-hmm84/align/timit_train.mlf $mfcDir/mono/hmm84/MMF \
  $hmmDir/mono/hmms.mlist MH0/dnntrain
