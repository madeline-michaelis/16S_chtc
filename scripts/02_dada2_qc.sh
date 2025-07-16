#!/bin/bash
set -e 

echo "Unpacking input files..." # if needed

echo "Denoising sequences..." #may take up to 10 minutes
qiime dada2 denoise-single \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left 0 \
  --p-trunc-len 100 \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-denoising-stats stats.qza

echo "Tabulating data..."
qiime metadata tabulate \
  --m-input-file stats.qza \
  --o-visualization stats.qzv

echo "Job 02 Complete!"
