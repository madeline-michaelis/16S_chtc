#!/bin/bash
set -e 

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
  --m-metadata-column body-site \
  --p-pairwise \
  --o-visualization unweighted-unifrac-body-site-group-significance.qzv
qiime diversity beta-group-significance \
  --i-distance-matrix diversity-core-metrics-phylogenetic/unweighted_unifrac_distance_matrix.qza \
  --m-metadata-file sample-metadata.tsv \
  --m-metadata-column subject \
  --p-pairwise \
  --o-visualization unweighted-unifrac-subject-group-significance.qzv

echo  "Generating 3D Emperor plots of beta diversity..."
qiime emperor plot \
  --i-pcoa diversity-core-metrics-phylogenetic/unweighted_unifrac_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axes days-since-experiment-start \
  --o-visualization unweighted-unifrac-emperor-days-since-experiment-start.qzv
qiime emperor plot \
  --i-pcoa diversity-core-metrics-phylogenetic/bray_curtis_pcoa_results.qza \
  --m-metadata-file sample-metadata.tsv \
  --p-custom-axes days-since-experiment-start \
  --o-visualization bray-curtis-emperor-days-since-experiment-start.qzv

echo "Job 05 Complete!"
