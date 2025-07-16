#!/bin/bash

set -e
NETID="$1"
PROJECT="$2"
echo ${NETID}
echo ${PROJECT}

echo "Container launched successfully..."

echo "Importing with QIIME tools import..."
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  /staging/${NETID}/${PROJECT}/input_outputs/00_pipeline_inputs/seqs \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux.qza

ls -lht

echo "Running QIIME summarize..."
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv

ls -lht
