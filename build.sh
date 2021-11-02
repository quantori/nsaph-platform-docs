#!/bin/bash

sphinx="/Users/misha/Library/Application Support/JetBrains/IntelliJIdea2021.2/plugins/python/helpers/rest_runners/sphinx_runner.py"

pip install /Users/misha/harvard/gitlab/nsaph_utils
pip install /Users/misha/harvard/gitlab/nsaph

for package in ../../gitlab/nsaph ../../gitlab/tools/*
do
  echo "$package"
  name=$(basename -- "$package")
  case "$name" in 
     nsaph)
       dest=docs/platform
       ;;
     getcensus)
       dest=docs/pipelines/census
       ;;
     *)
       dest=docs/pipelines/$name
     esac
  for md in $package/{**,.}/*.md
  do
     ~/node_modules/.bin/markdown-toc -i "$md"
  done
  if [ ! -d "$package"/doc/members ]
  then
    mkdir -p "$package"/doc/members
  fi
  python -m  nsaph_utils.docutils.collector "$package"/src/python "$package"/doc/members
  if [ -d "$package"/src/cwl ]
  then
    for cwl in "$package"/src/cwl/*.cwl
    do
      python -m  nsaph_utils.docutils.cwl2md "$cwl" html
    done
  fi
  python "$sphinx" -b html "$package" "$dest"
  if [ -d "$package"/src/cwl ]
  then
    for cwl in "$package"/src/cwl/*.cwl
    do
      python -m  nsaph_utils.docutils.cwl2md "$cwl" md
    done
  fi

done

python -u -m nsaph_utils.docutils.copy_section ../../gitlab/nsaph_utils/README.md home.md
python -u -m nsaph_utils.docutils.copy_section ../../gitlab/nsaph/README.md home.md
~/node_modules/.bin/markdown-toc -i home.md
python "$sphinx" -b html . docs



