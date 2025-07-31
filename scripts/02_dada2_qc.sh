#!/bin/bash
set -e 

echo "Unpacking input files..." # if needed

echo "Denoising sequences..." #may take up to 10 minutes
qiime dada2 denoise-paired \
  --i-demultiplexed-seqs demux.qza \
  --p-trim-left-f 0 \
  --p-trim-left-r 0 \
  --p-trunc-len-f 100 \
  --p-trunc-len-r 100 \
  --o-representative-sequences rep-seqs.qza \
  --o-table table.qza \
  --o-denoising-stats stats.qza

echo "Tabulating data..."
qiime metadata tabulate \
  --m-input-file stats.qza \
  --o-visualization stats.qzv

echo "exporting table.qza as a tab table"
qiime tools export \
  --input-path table.qza \
  --output-path extracted-feature-file

tar cf extracted-feature-file.tar.gz extracted-feature-file

echo "Job 02 Complete!"
