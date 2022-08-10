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

export PYTHONPATH=${base}"/nsaph-utils"

rm -rf docs
rm -rf common && mkdir common

packages=("utils" "census" "cms" "epa" "gridmet" "gis" "core-platform")

for name in "${packages[@]}"
do
  echo "$name"

  case "$name" in
     core-platform)
       dest=docs/core-platform
       package="${base}/${package_prefix}core-platform"
       ;;
     utils|gis)
       dest=docs/${name}
       package="${base}/${package_prefix}${name}"
       ;;
     *)
       dest=docs/pipelines/$name
       package="${base}/${package_prefix}${name}"
     esac

  pushd "$package" || exit
  git pull
  popd || exit

  for md in $(find $package -name "*.md")
  do
     md_toc --in-place --skip-lines 1 cmark --header-levels 6 $md
  done

  cp -r $package common/$name

  if [ ! -d common/$name/doc/members ]
  then
    mkdir -p common/$name/doc/members
  fi
done

for md in $(find ../nsaph-platform-deployment -name "*.md" -maxdepth 2)
  do
     md_toc --in-place --skip-lines 1 cmark --header-levels 6 $md
  done

mkdir common/deployment
cp -r ../nsaph-platform-deployment/*.md common/deployment/
cp -r ../nsaph-platform-deployment/docs common/deployment/
cp -r ../nsaph-platform-deployment/*.rst common/deployment/
cp -r ../nsaph-platform-deployment/project/*.yml common/deployment/
cp -r ../nsaph-platform-deployment/*.txt common/deployment/
cat ../nsaph-platform-deployment/install_conda.sh > common/deployment/install_conda.txt
cat ../nsaph-platform-deployment/install_projects.sh > common/deployment/install_projects.txt
cp -r ../nsaph-platform-deployment/docker-compose.yaml common/deployment/


python -u -m nsaph_utils.docutils.copy_section ${base}/nsaph-utils/README.md home.md nsaph_utils
python -u -m nsaph_utils.docutils.copy_section ${base}/nsaph-core-platform/README.md home.md nsaph
python -u -m nsaph_utils.docutils.copy_section ${base}/nsaph-gis/README.md home.md gis

python -m nsaph_utils.docutils.collector common/epa/src/python common/epa/doc/members
python -m nsaph_utils.docutils.collector common/census/src/python common/census/doc/members
python -m nsaph_utils.docutils.collector common/cms/src/python common/cms/doc/members
python -m nsaph_utils.docutils.collector common/gridmet/src/python common/gridmet/doc/members

sphinx-build -b html . docs

touch docs/.nojekyll
git add docs
