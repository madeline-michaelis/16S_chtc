#!/bin/bash
set -e 
COLUMN="$1"
echo "The group we are using is: ${COLUMN}"

echo "Computing diversity metrics..."

qiime diversity core-metrics-phylogenetic \
  --i-phylogeny rooted-tree.qza \
  --i-table table.qza \
  --p-sampling-depth 1103 \
  --m-metadata-file sample-metadata.tsv \
  --output-dir diversity-core-metrics-phylogenetic

echo  "Testing for differences in alpha diversity between groups of samples..."

qiime diversity alpha-group-significance \
  --i-alpha-diversity diversity-core-metrics-phylogenetic/faith_pd_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization faith-pd-group-significance.qzv

qiime diversity alpha-group-significance \
  --i-alpha-diversity diversity-core-metrics-phylogenetic/evenness_vector.qza \
  --m-metadata-file sample-metadata.tsv \
  --o-visualization evenness-group-significance.qzv

echo  "Testing differences in beta diversity between groups of samples..."

qiime diversity beta-group-significance \
  --i-distance-matrix diversity-core-metrics-phylogenetic/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column ${COLUMN} \
  --p-pairwise \
  --o-visualization unweighted-unifrac-${COLUMN}-group-significance.qzv

echo "Job 05 Complete!"

