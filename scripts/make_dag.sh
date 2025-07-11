#!/bin/bash

#Checking arguments are correct
if [ "$#" -ne 3 ]; then
	echo "Usage: bash make_dag.sh <demux=true or false> <netid> <output filename>"
	echo "Example: bash make_dag.sh TRUE bbadger water_microbiome"
	echo "Example: bash make_dag.sh FALSE bbadger water_microbiome"
	exit 1
fi

#Inputs
DEMUX="$1"  #pass TRUE or FALSE
NETID_PLACEHOLDER="$2"  #your netid
FILENAME="$3"

echo "Creating DAG based on samples..."
touch FILENAME.dag
#If seqs need demultiplexing:
if [ "$DEMUX" = "TRUE" ]; then

	echo 'JOB DEMUX 01_demux.sub' >> $FILENAME.dag
	echo 'VARS DEMUX netid=$NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'JOB QUALC 02_dada2_qc.sub' >> $FILENAME.dag
	echo 'VARS QUALC netid= $NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'VARS FEATURES netid=$NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'VARS PHYTREE netid=$NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'VARS DIVERSITY netid=$NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'VARS RAREFACTION netid=$NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'VARS TAXONOMY netid=$NETID_PLACEHOLDER' >> $FILENAME.dag
	echo 'VARS ANCOMBC netid=$NETID_PLACEHOLDER' >> $FILENAME.dag

	echo "PARENT DEMUX CHILD QUALC" >> $FILENAME.dag
    	echo "PARENT QUALC CHILD FEATURES" >> $FILENAME.dag
    	echo "PARENT QUALC CHILD PHYTREE" >> $FILENAME.dag
   	echo "PARENT QUALC PHYTREE CHILD DIVERSITY" >> $FILENAME.dag
    	echo "PARENT QUALC PHYTREE CHILD RAREFACTION" >> $FILENAME.dag
   	echo "PARENT QUALC CHILD TAXONOMY" >> $FILENAME.dag
    	echo "PARENT QUALC TAXONOMY CHILD ANCOMBC" >> $FILENAME.dag

# Use sed to replace the placeholder and write to the new file
#sed -i "s|$NETID_PLACEHOLDER|$NETID|g" $FILENAME.dag

#If seqs do not need demultiplexing:
elif [ "$DEMUX" = "FALSE" ]; then

    echo "JOB IMPORT 01_import.sub" >> $FILENAME.dag

    echo "JOB QUALC 02_dada2_qc.sub" >> $FILENAME.dag
    echo "JOB FEATURES 03_features.sub" >> $FILENAME.dag
    echo "JOB PHYTREE 04_phytree.sub" >> $FILENAME.dag
    echo "JOB DIVERSITY 05_abdiv.sub" >> $FILENAME.dag
    echo "JOB RAREFACTION 06_rarefact.sub" >> $FILENAME.dag
    echo "JOB TAXONOMY 07_taxonomy.sub" >> $FILENAME.dag
    echo "JOB ANCOMBC 08_ancombc.sub" >> $FILENAME.dag

    echo "PARENT IMPORT CHILD QUALC" >> $FILENAME.dag
    echo "PARENT QUALC CHILD FEATURES" >> $FILENAME.dag
    echo "PARENT QUALC CHILD PHYTREE" >> $FILENAME.dag
    echo "PARENT QUALC PHYTREE CHILD DIVERSITY" >> $FILENAME.dag
    echo "PARENT QUALC PHYTREE CHILD RAREFACTION" >> $FILENAME.dag
    echo "PARENT QUALC CHILD TAXONOMY" >> $FILENAME.dag
    echo "PARENT QUALC TAXONOMY CHILD ANCOMBC" >> $FILENAME.dag
}

echo "DAG completed. Submitting..."
## use the dag
condor_submit_dag $FILENAME.dag

echo "DAG submitted successfully."
