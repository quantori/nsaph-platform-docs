#!/bin/bash

set -e
set -x

if [ -z "$1" ]
  then
    deployment="../nsaph-platform-deployment"
    base="${deployment}/project"
    package_prefix=""
  else
    base=$1
    deployment="${base}/nsaph-platform-deployment"
    package_prefix="nsaph-"
fi

# TODO: REMOVE IT
export PYTHONPATH=${base}"/nsaph-utils"

for md in $(find ${deployment}/docs/*.md -name "*.md")
  do
     md_toc --in-place --skip-lines 1 cmark $md
  done

packages=("utils" "census" "cms" "epa" "gridmet" "gis" "data_platform")

for name in "${packages[@]}"
do
  echo "$name"

  case "$name" in
     data_platform)
       dest=docs/core-platform
       package="${base}/${package_prefix}core-platform"
       ;;
     utils)
       dest=docs/utils
       package="${base}/${package_prefix}${name}"
       ;;
     *)
       dest=docs/pipelines/$name
       package="${base}/${package_prefix}${name}"
     esac

  pushd "$package" || exit
  git pull
  popd || exit  

  for md in `find $package -name "*.md"`
  do
     md_toc --in-place --skip-lines 1 cmark $md
  done

  if [ ! -d "$package"/doc/members ]
  then
    mkdir -p "$package"/doc/members
  fi

  python -m  nsaph_utils.docutils.collector "$package"/src/python "$package"/doc/members
  sphinx-build -b html "$package" "$dest"


done

python -u -m nsaph_utils.docutils.copy_section ${base}/nsaph-utils/README.md home.md nsaph_utils
python -u -m nsaph_utils.docutils.copy_section ${base}/nsaph-core-platform/README.md home.md nsaph
md_toc --in-place --skip-lines 1 cmark home.md

sphinx-build -b html . docs
