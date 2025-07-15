#!/bin/bash

set -e
NETID="$1"
echo ${NETID}

echo "Container launched successfully..."

echo "Importing with QIIME tools import..."
<<<<<<< HEAD
qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  /staging/${NETID}/seqs
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux.qza
=======

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' \
  --input-path  /staging/${NETID}/input_outputs/00_pipeline_inputs/seqs \
  --input-format CasavaOneEightSingleLanePerSampleDirFmt \
  --output-path demux.qza

ls -lht
>>>>>>> b797a17 (added correct input paths)

echo "Running QIIME summarize..."
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv

ls -lht
