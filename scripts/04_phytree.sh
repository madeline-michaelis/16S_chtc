#!/bin/bash
set -e 

echo "Unpacking inputs and generating trees" 

#Note that rep-seqs.qza comes from staging/username/input_outputs/02_dada2_qc
qiime phylogeny align-to-tree-mafft-fasttree \
  --i-sequences rep-seqs.qza \
  --o-alignment aligned-rep-seqs.qza \
  --o-masked-alignment masked-aligned-rep-seqs.qza \
  --o-tree unrooted-tree.qza \
  --o-rooted-tree rooted-tree.qza

echo "Job 04 Complete!"
