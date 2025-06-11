# 16s rRNA Sequencing Pipeline

# Introduction to the pipeline
**Program:** This pipeline uses x, y and z

**Purpose:** The purpose of this pipeline is to efficiently analyze long-read sequencing data from 16S rRNA genomic datasets in order to (specific purposes here)

**Cyberinfrastructure & Implementation:** These scripts are meant to be run by HTCondor, a workflow manager that takes in an executable file and a submit file. They are meant to be run on the UW-Madison shared campus-computing infrastructure CHTC, but could work on other systems with few modifications. The pipeline takes advantage of the high-throughput scaling abilities of HTCondor to submit multiple jobs at the same time. For example, if we had an experimental design of 3 treatment, 3 replicate and 3 reference genomes and 10 time points, we would have to perform the steps 3 * 3 * 3 * 10 = 270 times. Instead, we write the metadata (information about the sample design) in a comma separated file containing 270 rows, and HTCondor will submit 270 jobs at the same time for us.

**Uses:** In research aiming to parse genomic datasets from bacterial communities. (be more specific later)

# Workflow
#### Diagram with steps of pipeline

# Getting started
#### Instructions on how to implement workflow using CHTC and data

# Special Considerations
#### Special info related to workflow/data, warnings, etc


## References
If you find this pipeline helpful, please cite this GitHub Repository:
1. Tran, P. Q., Michaelis, M. L. (2025). 16S rRNA-seq (Version ???) / put link to github Bioinfo page once its done

This workflow relies on the following softwares, please cite them as well:

1. 
2. 
3. 

## Help and additional information:
Patricia Q. Tran, ptran5@wisc.edu, University of Wisconsin-Madison Get Help:
- For people at UW-Madison, please visit the [departmental bioinformatics research support service main website](https://bioinformatics.bact.wisc.edu/). If you are part of the Department of Bacteriology please make an 1-on-1 individual appointment, others please attend one of my weekly office hours.
- For external people, please submit an issue via the github page.
