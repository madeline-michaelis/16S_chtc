#!/bin/bash
set -e 

echo "Obtaining classifier..."

wget -O 'gg-13-8-99-515-806-nb-classifier.qza' \
  'https://moving-pictures-tutorial.readthedocs.io/en/latest/data/moving-pictures/gg-13-8-99-515-806-nb-classifier.qza'

echo "Classifying data..."

qiime feature-classifier classify-sklearn \
  --i-classifier gg-13-8-99-515-806-nb-classifier.qza \
  --i-reads rep-seqs.qza \
  --o-classification taxonomy.qza
qiime metadata tabulate \
  --m-input-file taxonomy.qza \
  --o-visualization taxonomy.qzv

echo "Generating taxonomic composition barplots..."
qiime taxa barplot \
  --i-table table.qza \
  --i-taxonomy taxonomy.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization taxa-bar-plots.qzv

echo "Job 07 Complete!"
