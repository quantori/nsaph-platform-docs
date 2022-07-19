#!/bin/bash

set -e
set -x

deployment="../nsaph-platform-deployment"
base="${deployment}/project"
package_prefix=""

export PYTHONPATH=${base}"/nsaph_utils"

rm -rf docs
rm -rf common && mkdir common

cp -r ${base}/nsaph_utils common/
cp -r ${base}/data_platform common/
cp -r ${base}/epa common/
cp -r ${base}/census common/
cp -r ${base}/cms common/
cp -r ${base}/gridmet common/
cp -r ${base}/gis common/
cp -r ${deployment}/*.md common/
cp -r ${deployment}/*.rst common/

for md in $(find . -name "*.md")
  do
     md_toc --in-place --skip-lines 1 cmark --header-levels 6 $md
  done

python -u -m nsaph_utils.docutils.copy_section ${base}/nsaph_utils/README.md home.md nsaph_utils
python -u -m nsaph_utils.docutils.copy_section ${base}/data_platform/README.md home.md nsaph
python -u -m nsaph_utils.docutils.copy_section ${base}/gis/README.md home.md gis

python -m nsaph_utils.docutils.collector common/epa/src/python common/epa/doc/members
python -m nsaph_utils.docutils.collector common/census/src/python common/census/doc/members
python -m nsaph_utils.docutils.collector common/cms/src/python common/cms/doc/members
python -m nsaph_utils.docutils.collector common/gridmet/src/python common/gridmet/doc/members

sphinx-build -b html . docs
