#!/bin/zsh
TOOLS_DIR=../../tools/

bigramCountTh=3

# phone-level backoff bigram language model
cp ../MFC_E_D_A_Z_FlatStart/mono/hmms.mlist word_list.txt
$TOOLS_DIR/htkbin/HLStats -A -D -V -T 1 -b back_off_bigram_${bigramCountTh} \
   -t $bigramCountTh -u 1.0 \
  -o word_list.txt ../../convert/mfc13d/lib/mlabs/train.mlf > HLStats.log

# build bigram network
sed -i -e '1i!ENTER\' word_list.txt
sed -i -e '2i!EXIT\' word_list.txt
$TOOLS_DIR/htkbin/HBuild -A -D -V -T 1 -s "!ENTER" "!EXIT" \
  -n back_off_bigram_${bigramCountTh} \
  word_list.txt \
  bigram_lm_lattice_${bigramCountTh} > HBuild.log
