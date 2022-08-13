#!/bin/bash

rm -rf docs
rm -rf doc/common && mkdir doc/common

package_prefix="nsaph-"
packages=("platform-deployment" "utils" "core-platform" "gis" "epa" "gridmet" "cms")

for name in "${packages[@]}"
do
  package="../${package_prefix}${name}"

  # pull changes
  pushd "$package" || exit
  git pull
  popd || exit

  # copy the whole repo to compile documentation
  cp -r $package doc/common/$name

  # install library with dependencies
  if [ -a doc/common/$name/setup.py ]
  then
    pip install doc/common/$name
  fi

  # install dependencies if exists
  if [ -a doc/common/$name/requirements.txt ]
  then
    pip install doc/common/$name/requirements.txt
  fi

  # make python sources available for autodoc
  abs_path=`realpath doc/common/$name/src/python`
  if [ -n "$abs_path" ]
  then
    export PATH="$abs_path:$PATH"
  fi

done

# build documentation
sphinx-build doc docs
touch docs/.nojekyll

# remove copied repos
rm -rf doc/common
git add docs
