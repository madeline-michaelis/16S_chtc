#!/bin/bash
set -e

export COLUMN="$1"

echo "The group we are using is: ${COLUMN}"
 
echo "Comparing abundance across samples in features..."

qiime composition ancombc \
  --i-table table.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-formula "${COLUMN}" \
  --o-differentials ancombc-${COLUMN}.qza \
  --verbose

qiime composition da-barplot \
  --i-data ancombc-${COLUMN}.qza \
  --p-significance-threshold 0.001 \
  --o-visualization da-barplot-${COLUMN}.qzv \
  --verbose

echo "Collapsing features at genus level, re-running above..."

qiime taxa collapse \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table table-level-6.qza \
  --verbose

qiime composition ancombc \
  --i-table table-level-6.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-formula "$COLUMN" \
  --o-differentials level-6-ancombc-${COLUMN}.qza \
  --verbose

qiime composition da-barplot \
  --i-data level-6-ancombc-${COLUMN}.qza \
  --p-significance-threshold 0.001 \
  --o-visualization level-6-da-barplot-${COLUMN}.qzv \
  --verbose

ls -lht

echo "Job 08 Complete!"
