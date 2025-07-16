#!/bin/bash
#To run script, simply type bash 00_mkdir.sh into the terminal


# arguments
NETID="$1"
project="$2"

staging="/staging/${NETID}"

echo $staging
echo $project

mkdir -p $staging/$project/input_outputs/
mkdir -p $staging/$project/input_outputs/00_pipeline_inputs/
mkdir -p $staging/$project/input_outputs/01_import-demux/
mkdir -p $staging/$project/input_outputs/02_dada2_qc/
mkdir -p $staging/$project/input_outputs/03_features/
mkdir -p $staging/$project/input_outputs/04_phytree/
mkdir -p $staging/$project/input_outputs/05_abdiv/
mkdir -p $staging/$project/input_outputs/06_rarefact/
mkdir -p $staging/$project/input_outputs/07_taxonomy/
mkdir -p $staging/$project/input_outputs/08_ancombc/

echo "Created folder structure for 16S rRNA pipeline"
