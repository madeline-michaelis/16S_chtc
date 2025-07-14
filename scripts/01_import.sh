#!/bin/bash

set -e
NETID="$1"
echo ${NETID}

echo "Container launched successfully..."

echo "Importing with QIIME tools import..."
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  /staging/${NETID}/seqs
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux.qza

echo "Running QIIME summarize..."
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv

echo "Job 01 Complete!"
