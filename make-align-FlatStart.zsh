#!/usr/bin/zsh

alignDirs=(
`pwd`/MFC_E_D_A_Z_FlatStart
`pwd`/MFC_E_Z_FlatStart
`pwd`/MFC_E_D_Z_FlatStart
`pwd`/FBK_Z_FlatStart
`pwd`/FBK_D_Z_FlatStart
`pwd`/FBK_D_A_Z_FlatStart
)
envDirs=(
$(dirname `pwd`)/convert/mfc13d/env/environment_E_D_A_Z
$(dirname `pwd`)/convert/mfc13d/env/environment_E_Z
$(dirname `pwd`)/convert/mfc13d/env/environment_E_D_Z
$(dirname `pwd`)/convert/fbk25d/env/environment_Z
$(dirname `pwd`)/convert/fbk25d/env/environment_D_Z
$(dirname `pwd`)/convert/fbk25d/env/environment_D_A_Z
)

integer i
for i in {1..$#envDirs}; do
  print ${envDirs[i]}
  # train flat start model
  ../tools/steps/step-mono -FLATSTART -NUMMIXES 8 \
    ${envDirs[i]} ${alignDirs[i]}/mono

  # align frames
  ../tools/steps/step-align ${alignDirs[i]}/mono hmm84 \
    ${alignDirs[i]}/align-mono-hmm84
done
