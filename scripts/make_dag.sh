#!/bin/bash

#Checking arguments are correct
if [ "$#" -ne 5 ]; then
	echo "Incorrect input. Usage: bash make_dag.sh <demux=T/F> <netid> <output filename>
		- demux=T/F (required): Are samples demultiplexed? Example: TRUE or FALSE
		- netid (required): Your UW Madison netid. Example: bbadger
		- group (required): Group for the diversity plots, must be a column name within the sample-metadata.tsv sheet
		- project (required): The project subfolder name. Example: test_project
		- output filename (required): Desired name for file. Example: water_microbiome"
	echo "Example input: bash make_dag.sh TRUE bbadger water_microbiome"

	exit 1
fi

#Inputs
DEMUX="$1"  #pass TRUE or FALSE
NETID_PLACEHOLDER="$2"  #your netid
GROUP="$3"
PROJECT="$4" #project : e.g /staging/bbadger/test_project, where project=test_project
FILENAME="$5"

rm $FILENAME.dag

echo "Creating DAG based on samples..."
touch $FILENAME.dag
#If seqs need demultiplexing:
if [ "$DEMUX" = "TRUE" ]; then
	echo "DEMUX = TRUE, beginning writing $FILENAME.dag"

	echo "JOB DEMUX 01_demux.sub" >> $FILENAME.dag
	echo "VARS DEMUX netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB QUALC 02_dada2_qc.sub" >> $FILENAME.dag
	echo "VARS QUALC netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB FEATURES 03_features.sub" >> $FILENAME.dag
	echo "VARS FEATURES netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB PHYTREE 04_phytree.sub" >> $FILENAME.dag
	echo "VARS PHYTREE netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB DIVERSITY 05_abdiv.sub" >> $FILENAME.dag
	echo "VARS DIVERSITY netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\" column=\"$GROUP\"" >> $FILENAME.dag
	echo "JOB RAREFACTION 06_rarefact.sub" >> $FILENAME.dag
	echo "VARS RAREFACTION netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB TAXONOMY 07_taxonomy.sub" >> $FILENAME.dag
	echo "VARS TAXONOMY netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB ANCOMBC 08_ancombc.sub" >> $FILENAME.dag
	echo "VARS ANCOMBC netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag

	echo "PARENT DEMUX CHILD QUALC" >> $FILENAME.dag
        echo "PARENT QUALC CHILD FEATURES" >> $FILENAME.dag
	echo "PARENT QUALC CHILD PHYTREE" >> $FILENAME.dag
   	echo "PARENT QUALC PHYTREE CHILD DIVERSITY" >> $FILENAME.dag
	echo "PARENT QUALC PHYTREE CHILD RAREFACTION" >> $FILENAME.dag
   	echo "PARENT QUALC CHILD TAXONOMY" >> $FILENAME.dag
	echo "PARENT QUALC TAXONOMY CHILD ANCOMBC" >> $FILENAME.dag

	echo "Created $FILENAME.dag"
# Use sed to replace the placeholder and write to the new file
#sed -i "s|$NETID_PLACEHOLDER|$NETID|g" $FILENAME.dag

#If seqs do not need demultiplexing:
elif [ "$DEMUX" = "FALSE" ]; then
    echo "DEMUX = FALSE, beginning writing $FILENAME.dag"

    echo "JOB IMPORT 01_import.sub" >> $FILENAME.dag
	echo "VARS IMPORT netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB QUALC 02_dada2_qc.sub" >> $FILENAME.dag
	echo "VARS QUALC netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB FEATURES 03_features.sub" >> $FILENAME.dag
	echo "VARS FEATURES netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB PHYTREE 04_phytree.sub" >> $FILENAME.dag
	echo "VARS PHYTREE netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB DIVERSITY 05_abdiv.sub" >> $FILENAME.dag
	echo "VARS DIVERSITY netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\" column=\"$GROUP\"" >> $FILENAME.dag
	echo "JOB RAREFACTION 06_rarefact.sub" >> $FILENAME.dag
	echo "VARS RAREFACTION netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB TAXONOMY 07_taxonomy.sub" >> $FILENAME.dag
	echo "VARS TAXONOMY netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\"" >> $FILENAME.dag
	echo "JOB ANCOMBC 08_ancombc.sub" >> $FILENAME.dag
	echo "VARS ANCOMBC netid=\"$NETID_PLACEHOLDER\" project=\"$PROJECT\" column=\"$GROUP\"" >> $FILENAME.dag

    echo "PARENT IMPORT CHILD QUALC" >> $FILENAME.dag
    echo "PARENT QUALC CHILD FEATURES" >> $FILENAME.dag
    echo "PARENT QUALC CHILD PHYTREE" >> $FILENAME.dag
    echo "PARENT QUALC PHYTREE CHILD DIVERSITY" >> $FILENAME.dag
    echo "PARENT QUALC PHYTREE CHILD RAREFACTION" >> $FILENAME.dag
    echo "PARENT QUALC CHILD TAXONOMY" >> $FILENAME.dag
    echo "PARENT QUALC TAXONOMY CHILD ANCOMBC" >> $FILENAME.dag
    
    echo "Created $FILENAME.dag"

else
    echo "DEMUX argument should be TRUE or FALSE . Check arguments and try again."

fi

