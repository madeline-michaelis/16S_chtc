#!/bin/bash
set -e 

echo "Unpacking files and running alpha-rarefaction..."

qiime diversity alpha-rarefaction \
  --i-table table.qza \
  --i-phylogeny rooted-tree.qza \
  --p-max-depth 1400 \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization alpha-rarefaction.qzv

echo "Job 06 Complete!"
