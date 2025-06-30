#!/bin/bash
set -e 

echo "Creating feature table with gut samples..." 
qiime feature-table filter-samples \
  --i-table table.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-where '[body-site]="gut"' \
  --o-filtered-table gut-table.qza
 
echo "Comparing abundance across gut samples in features..."
qiime composition ancombc \
  --i-table gut-table.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-formula subject \
  --o-differentials ancombc-subject.qza
qiime composition da-barplot \
  --i-data ancombc-subject.qza \
  --p-significance-threshold 0.001 \
  --o-visualization da-barplot-subject.qzv

echo "Collapsing features at genus level, re-running above..."
qiime taxa collapse \
  --i-table gut-table.qza \
  --i-taxonomy taxonomy.qza \
  --p-level 6 \
  --o-collapsed-table gut-table-l6.qza
qiime composition ancombc \
  --i-table gut-table-l6.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-formula subject \
  --o-differentials l6-ancombc-subject.qza
qiime composition da-barplot \
  --i-data l6-ancombc-subject.qza \
  --p-significance-threshold 0.001 \
  --o-visualization l6-da-barplot-subject.qzv

echo "Job 08 Complete!"
