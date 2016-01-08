#!/usr/bin/zsh

features=mfc13d
lib_dir=../../convert/$features/lib

# generate biphone model list
python gen_biphone_mlists.py $lib_dir/mlists/mono+sil.mlist xwbi+sil.mlist

# generate biphne label edit definition for `HLed`
python gen_biphone_led.py $lib_dir/mlists/mono+sil.mlist make_xwbi.led
