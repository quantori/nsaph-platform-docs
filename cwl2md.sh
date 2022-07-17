#!/bin/bash

if [ -d ./src/cwl ]
then
  for cwl in ./src/cwl/*.cwl
  do
    python -m  nsaph_utils.docutils.cwl2md "$cwl" md
  done
fi
