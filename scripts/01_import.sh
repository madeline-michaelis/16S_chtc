#!/bin/bash

set -e

echo "Container launched successfully..."

echo "Importing with QIIME tools import..."
qiime tools import \
 --type 'SampleData[PairedEndSequencesWithQuality]' \
 --input-path fq-manifest.tsv \
 --output-path demux.qza \
 --input-format PairedEndFastqManifestPhred33V2

echo "Running QIIME summarize..."
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv

echo "Job 01 Complete!"
