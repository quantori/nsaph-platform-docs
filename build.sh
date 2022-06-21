#!/bin/bash

set -e
set -x

# TODO: REMOVE IT
export PYTHONPATH="../nsaph-platform-deployment/project/nsaph_utils"

for md in `find ../nsaph-platform-deployment/docs/*.md -name "*.md"`
  do
     md_toc --in-place --skip-lines 1 cmark $md
  done

packages=("census" "cms" "epa" "gridmet" "gis" "data_platform")

for name in ${packages[@]}
do
  echo $name
  package="../nsaph-platform-deployment/project/$name"

  case "$name" in
     data_platform)
       dest=docs/platform
       ;;
     *)
       dest=docs/pipelines/$name
     esac

  for md in `find $package -name "*.md"`
  do
     md_toc --in-place --skip-lines 1 cmark $md
  done

  if [ ! -d "$package"/doc/members ]
  then
    mkdir -p "$package"/doc/members
  fi

  python -m  nsaph_utils.docutils.collector "$package"/src/python "$package"/doc/members

#  if [ -d "$package"/src/cwl ]
#  then
#    for cwl in "$package"/src/cwl/*.cwl
#    do
#      python -m  nsaph_utils.docutils.cwl2md "$cwl" html
#    done
#  fi

  sphinx-build -b html "$package" "$dest"

#  if [ -d "$package"/src/cwl ]
#  then
#    for cwl in "$package"/src/cwl/*.cwl
#    do
#      python -m  nsaph_utils.docutils.cwl2md "$cwl" md
#    done
#  fi

done

python -u -m nsaph_utils.docutils.copy_section ../nsaph-platform-deployment/project/nsaph_utils/README.md home.md nsaph_utils
python -u -m nsaph_utils.docutils.copy_section ../nsaph-platform-deployment/project/data_platform/README.md home.md nsaph
md_toc --in-place --skip-lines 1 cmark home.md

python "$sphinx" -b html . docs
