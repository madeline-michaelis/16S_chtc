#!/bin/bash

set -e

tar xzf emp-single-end-sequences.tar.gz
echo "Unpacking input files"

echo "Running QIIMe tools import"
qiime tools import \
  --type 'EMPSingleEndSequences' \
  --input-path emp-single-end-sequences \
  --output-path emp-single-end-sequences.qza

echo "Running QIIME demux..."
qiime demux emp-single \
  --i-seqs emp-single-end-sequences.qza \
  --m-barcodes-file sample-metadata.tsv \
  --m-barcodes-column barcode-sequence \
  --o-per-sample-sequences demux.qza \
  --o-error-correction-details demux-details.qza \
  --p-rev-comp-mapping-barcodes

echo "Running QIIME summarize..."
qiime demux summarize \
  --i-data demux.qza \
  --o-visualization demux.qzv

 # --i-seqs /home/mmichaelis/emp-single-end-sequences.qza \
 # --m-barcodes-file /home/mmichaelis/qiime-amp-pipeline/sample-metadata.tsv \
 # --m-barcodes-column BarcodeSequence \
 # --o-per-sample-sequences /home/mmichaelis/demux.qza \
 # --p-rev-comp-mapping-barcodes


