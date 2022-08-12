#!/bin/bash

rm -rf docs
rm -rf doc/common && mkdir doc/common

package_prefix="nsaph-"
packages=("core-platform" "platform-deployment")

for name in "${packages[@]}"
do
  package="../${package_prefix}${name}"

  pushd "$package" || exit
  git pull
  popd || exit

  cp -r $package doc/common/$name
done

sphinx-build doc docs
touch docs/.nojekyll

rm -rf doc/common
