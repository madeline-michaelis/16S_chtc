#!/bin/bash

# help function
help_message() {
    echo "HELP PAGE..."
	echo
	echo
    echo "Syntax: bash make_dag.sh -d <TRUE|FALSE> -n <netid> -g <group> -p <project> -o <output filename>"
	echo "These arguments can be provided in any order, but all arguments are required. Options are case-sensitive."
    echo
    echo "Options:"
	echo "  -d    (required) Demux: Whether you need to demultiplex your data. Use TRUE if you want to demultiplex the data, and FALSE if you have already demultipldex data. Example: TRUE"
    echo "  -n    (required) NetID: Your UW Madison netid. Example: bbadger"
    echo "  -g    (required) Group: Group for the diversity plots, must be a column name in sample-metadata.tsv. Example: vegetation"
    echo "  -p    (required) ProjectName: The project subfolder name. Example: test_project"
    echo "  -o    (required) DAG output file name: Desired name for DAG file. Example: test_project"
    
	echo
	echo "Example usage: bash make_dag.sh -d TRUE -n bbadger -g vegetation -p test_project -o test_project_true"
	echo "Example usage: bash make_dag.sh -d FALSE -n bbadger -g vegetation -p test_project -o test_project_false"
	exit 1
}

# Initialize variables
DEMUX=""
NETID=""
GROUP=""
PROJECT=""
FILENAME=""

# Parse flags
while getopts "d:n:g:p:o:" flag; do
    case "${flag}" in
        d) DEMUX=${OPTARG} ;;
		n) NETID=${OPTARG} ;;
        g) GROUP=${OPTARG} ;;
        p) PROJECT=${OPTARG} ;;
        o) FILENAME=${OPTARG} ;;
        *) help_message ;;
    esac
done

# Check that all required inputs are provided
if [[ -z "$DEMUX" || -z "$NETID" || -z "$GROUP" || -z "$PROJECT" || -z "$FILENAME" ]]; then
	echo "Please check that you have provided all required inputs."
	help_message
	exit 1
fi

# Main script
rm -f "$FILENAME.dag"

echo "Creating DAG named $FILENAME.dag"
touch "$FILENAME.dag"

if [ "$DEMUX" = "TRUE" ]; then
	echo "JOB DEMUX 01_demux.sub" >> "$FILENAME.dag"
	echo "VARS DEMUX netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB QUALC 02_dada2_qc.sub" >> "$FILENAME.dag"
	echo "VARS QUALC netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB FEATURES 03_features.sub" >> "$FILENAME.dag"
	echo "VARS FEATURES netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB PHYTREE 04_phytree.sub" >> "$FILENAME.dag"
	echo "VARS PHYTREE netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB DIVERSITY 05_abdiv.sub" >> "$FILENAME.dag"
	echo "VARS DIVERSITY netid=\"$NETID\" project=\"$PROJECT\" column=\"$GROUP\"" >> "$FILENAME.dag"
	echo "JOB RAREFACTION 06_rarefact.sub" >> "$FILENAME.dag"
	echo "VARS RAREFACTION netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB TAXONOMY 07_taxonomy.sub" >> "$FILENAME.dag"
	echo "VARS TAXONOMY netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB ANCOMBC 08_ancombc.sub" >> "$FILENAME.dag"
	echo "VARS ANCOMBC netid=\"$NETID\" project=\"$PROJECT\" column=\"$GROUP\"" >> "$FILENAME.dag"

	echo "PARENT DEMUX CHILD QUALC" >> $FILENAME.dag
    echo "PARENT QUALC CHILD FEATURES" >> $FILENAME.dag
	echo "PARENT QUALC CHILD PHYTREE" >> $FILENAME.dag
   	echo "PARENT QUALC PHYTREE CHILD DIVERSITY" >> $FILENAME.dag
	echo "PARENT QUALC PHYTREE CHILD RAREFACTION" >> $FILENAME.dag
   	echo "PARENT QUALC CHILD TAXONOMY" >> $FILENAME.dag
	echo "PARENT QUALC TAXONOMY CHILD ANCOMBC" >> $FILENAME.dag

elif [ "$DEMUX" = "FALSE" ]; then
	echo "JOB IMPORT 01_import.sub" >> "$FILENAME.dag"
	echo "VARS IMPORT netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB QUALC 02_dada2_qc.sub" >> "$FILENAME.dag"
	echo "VARS QUALC netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB FEATURES 03_features.sub" >> "$FILENAME.dag"
	echo "VARS FEATURES netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB PHYTREE 04_phytree.sub" >> "$FILENAME.dag"
	echo "VARS PHYTREE netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB DIVERSITY 05_abdiv.sub" >> "$FILENAME.dag"
	echo "VARS DIVERSITY netid=\"$NETID\" project=\"$PROJECT\" column=\"$GROUP\"" >> "$FILENAME.dag"
	echo "JOB RAREFACTION 06_rarefact.sub" >> "$FILENAME.dag"
	echo "VARS RAREFACTION netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB TAXONOMY 07_taxonomy.sub" >> "$FILENAME.dag"
	echo "VARS TAXONOMY netid=\"$NETID\" project=\"$PROJECT\"" >> "$FILENAME.dag"
	echo "JOB ANCOMBC 08_ancombc.sub" >> "$FILENAME.dag"
	echo "VARS ANCOMBC netid=\"$NETID\" project=\"$PROJECT\" column=\"$GROUP\"" >> "$FILENAME.dag"

	echo "PARENT IMPORT CHILD QUALC" >> $FILENAME.dag
    echo "PARENT QUALC CHILD FEATURES" >> $FILENAME.dag
	echo "PARENT QUALC CHILD PHYTREE" >> $FILENAME.dag
   	echo "PARENT QUALC PHYTREE CHILD DIVERSITY" >> $FILENAME.dag
	echo "PARENT QUALC PHYTREE CHILD RAREFACTION" >> $FILENAME.dag
   	echo "PARENT QUALC CHILD TAXONOMY" >> $FILENAME.dag
	echo "PARENT QUALC TAXONOMY CHILD ANCOMBC" >> $FILENAME.dag
fi

echo "Created $FILENAME.dag"
