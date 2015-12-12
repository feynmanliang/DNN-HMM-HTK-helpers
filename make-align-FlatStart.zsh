#!/usr/bin/zsh

features=(
"MFC_E_Z"
"MFC_E_D_Z"
"MFC" # E_D_A_Z
"FBK" # D_A_Z
)
alignDirs=(
"MFC_E_Z_FlatStart"
"MFC_E_D_Z_FlatStart"
"MFC_E_D_A_Z_FlatStart"
"FBK_D_A_Z_FlatStart"
)
envDirs=(
"../convert/mfc13d/env/environment_E_Z"
"../convert/mfc13d/env/environment_E_D_Z"
"../convert/mfc13d/env/environment_E_D_A_Z"
"../convert/fbk25d/env/environment_D_A_Z"
)

integer i
for i in {1..$#features}; do
  print ${envDirs[i]}
  # train flat start model
  ../tools/steps/step-mono -FLATSTART -NUMMIXES 8 \
    ${envDirs[i]} ${alignDirs[i]}/mono

  # align frames
  ../tools/steps/step-align ${alignDirs[i]}/mono hmm84 \
    ${alignDirs[i]}/align-mono-hmm84
done

