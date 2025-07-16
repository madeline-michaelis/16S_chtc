# 16S rRNA Sequencing Pipeline

# Introduction to the pipeline
**Program:** This DAGman pipeline is based upon QIIME2 and documentation and utilizes a QIIME2 container. It is meant to be run within HTCondor using a DAGMan workflow manager.

**Purpose:** The purpose of this pipeline is to efficiently analyze long-read sequencing data from 16S rRNA genomic datasets. It contains 8 jobs that build upon one another, and generates outputs that are relevant to research questions (including but not limited to phylogenetic trees, diversity and taxonomic analyses, and differential abundance testing results). These processes are often time-consuming and complicated. By working in HTC Condor, this pipeline allows researchers to streamline their data analysis in a reproducible and effective manner.
 
**Uses:** This pipeline can be utilized in research aiming to parse genomic datasets from bacterial communities and generate visualizations based off of their data. Due to its reproducibility, it can be utilized in parts or whole for other genomic analysis processes as well. It is highly recommended to consult the documentation listed in References below if one is interested in working with this version.

# Workflow
#### Diagram with steps of pipeline
*to add*

## Getting started
#### Instructions on how to implement workflow using CHTC and data

Description of files in this repository:

* README.md: These directions
* /scripts: Contains all .sh/.sub files required for the pipeline.
  * 00_mkdir.sh: Script to create directory in staging that will store outputs of jobs
  * make_dag.sh: DAGman configuration file
  * 00-08: Executable and submit scripts pairs for HTCondor DAGman jobs
* .gitignore: all files to be ignored

# Quick-start guide
## Preparing input files & folder directory

You will first need access to a `/staging/netid` folder. For more information about /staging folders, please visit: https://chtc.cs.wisc.edu/uw-research-computing/file-avail-largedata . The /staging folder will be used for the large genomic input files, and the large genomic output files.

In your request, please consider your input files (how many samples will you have, have the size of all your reads and assembled data, as well as your output files)

## Instructions
1. Log into CHTC
```
ssh netid@ap2002.chtc.wisc.edu
#enter your password
pwd
# this will say something like /home/netid
```
2. Clone this directory into your home directory and make all the script executable with the `chmod` command:
```
git clone https://github.com/patriciatran/16S_chtc
cd 16S_chtc
chmod +x scripts/*.sh
```
3. Create a logs folder in your cloned directory (path: home/username/16S_chtc/scripts) for your CHTC log, err and out files.
```
mkdir -p scripts/logs
```
 
4. Run the helper script `00_mkdir.sh` from your 16S_chtc/scripts directory. 
This will create the directory within your staging folder that is necessary to handle all file inputs and outputs. To run, type: ``` bash 00_mkdir.sh ```
The script takes 2 arguments: your netid, and the name of a folder that will be created. In this example, the folder will be named `test_project`
```
cd scripts
bash 00_mkdir.sh NETID test_project
```


5. Run `make_dag.sh` from your scripts directory to create a DAG workflow. 
Be sure to include the four neccessary arguments (DEMUX = T/F, username, groups to compare, project, filename) for proper function. Example input:
```
bash make_dag.sh FALSE bbadger vegetation test_project test_project_dag
```

    * DEMUX references whether or not your samples need to be demultiplexed. Use TRUE if you have single-end sequences, and FALSE if you have paired-end sequences.
    * Username is your netid username.
    * Group: A column of group you want to use to compare between sites. MUST match a categorical column name in `sample-metadata.tsv`
    * Project is the project name listed under /staging/netid , that you created using the `00_mkdir.sh` script above.
    * Filename is what you wish the dag to be named. If you input microbiome_dag_1, it will be called microbiome_dag_1.dag.
    * Reference template_dag in this repository for an example output.

>[!NOTE]
> 07/15: For now, Group must be a categorical variable without any special characters. For example transect-name will not work because of the dash, but the group vegetation will.
> This will be fixed in future iterations...

>[!NOTE]
> 07/15: We tested this will real data for demux = FALSE, which means that we expect a folder named seqs/ containing forward and reverse reads, already split per sample.
> In the future, we will test this with real data for demux = TRUE.
> For now, please only set DEMUX=FALSE.

```
bash make_dag.sh FALSE bbadger vegetation test_project test_project_dag
```

will create a file named `test_project_dag.dag`

7. Confirm that you have A) the proper staging folder structure (path: `/staging/username/project/input-outputs/all job names 00-08`) and B) a DAG with your desired name in your scripts folder.

8. Import your input data (paired-end fastq files, and sample-metadata.tsv file) into your `/staging/username/input-outputs/00_pipeline_inputs` directory.

To transfer files from your laptop to CHTC you can do the following:
Open a new terminal window
From your laptop navigate to where the FASTQ files are located
```
cd Downloads
scp -r ~/Downloads/seqs netid@ap2002.chtc.wisc.edu:/staging/netid/project/inputs_ouputs/00_pipeline_inputs
```

Do the same thing to transfer the `sample-metadata.tsv` file to the sample folder:
```
scp -r ~/Downloads/sample-metadata.tsv netid@ap2002.chtc.wisc.edu:/staging/netid/project/inputs_ouputs/00_pipeline_inputs
```

The `scp` command takes two arguments. The first one (`~/Downloads/seqs`) is the folder you want to transfer over, and the second argument takes the form of the `sshaddress:path to where you want to put it`

7. Switch terminal windows and check that the files are transferred correctly.
```
ls /staging/netid/project/inputs_ouputs/00_pipeline_inputs/seqs
ls /staging/netid/project/inputs_outputs/00_pipeline_inputs/
```

you should be able to see all your paired FASTQ files - if not, try to troubleshoot the `scp` command or ask for help.

8. Navigate back to your home/username/16S_chtc/scripts folder, and from there submit the dag.

```
cd ~/16S_chtc/scripts
condor_submit_dag test_project_dag.dag
```

8. Check your DAG's status with:
```
condor_q
```

At this point, you can log out of chtc, the job will still be running.
Just log back in later to see the job progress by typing condor_q again.

9. The result for each job should appear within its respective output file within the `/staging/username/project/input_outputs` directory.

10. Transfer your files from CHTC to your computer once the job is correctly completed. One recommended way to do this is the following:

To do so, open a new Terminal window.

In terminal, navigate to the location you want the files to go on your device:
```
cd ~/Downloads
mkdir -p my_chtc_results
cd my_chtc_results
```

```
sftp netid@ap2002.cthc.wisc.edu
cd /staging/username/project/input_outputs
get *
exit
```

## Special Considerations
* Do not include any personal information in the data input into the pipeline.
* Please set up a staging folder with CHTC before trying this pipeline. It is meant to process large amounts of data that your home directory may not neccessarily be able to manage.

# References
If you find this pipeline helpful, please cite this GitHub Repository:
1. Tran, P. Q., Michaelis, M. L. (2025). 16S rRNA-seq (Version 0.1) (link)

This workflow relies on the following softwares, please cite them as well:
 
1. QIIME2: Bolyen, E., Rideout, J. R., Dillon, M. R., Bokulich, N. A., Abnet, C. C., Al-Ghalith, G. A., ... & Caporaso, J. G. (2019). Reproducible, interactive, scalable and extensible microbiome data science using QIIME 2. Nature Biotechnology, 37(8), 852–857. https://doi.org/10.1038/s41587-019-0209-9
2. DADA2: Callahan, B. J., McMurdie, P. J., Rosen, M. J., Han, A. W., Johnson, A. J. A., & Holmes, S. P. (2016). DADA2: High-resolution sample inference from Illumina amplicon data. Nature Methods, 13(7), 581–583. https://doi.org/10.1038/nmeth.3869
3. MAFFT: Katoh, K., & Standley, D. M. (2013). MAFFT multiple sequence alignment software version 7: Improvements in performance and usability. Molecular Biology and Evolution, 30(4), 772–780. https://doi.org/10.1093/molbev/mst010
4. FastTree: Price, M. N., Dehal, P. S., & Arkin, A. P. (2010). FastTree 2 – approximately maximum-likelihood trees for large alignments. PLoS ONE, 5(3), e9490. https://doi.org/10.1371/journal.pone.0009490
5. Emperor: Vázquez-Baeza, Y., Pirrung, M., Gonzalez, A., & Knight, R. (2013). EMPeror: A tool for visualizing high-throughput microbial community data. GigaScience, 2(1), 16. https://doi.org/10.1186/2047-217X-2-16
6. ANCOM-BC: Lin, H., Peddada, S. D. (2020). Analysis of compositions of microbiomes with bias correction. Nature Communications, 11, 3514. https://doi.org/10.1038/s41467-020-17303-4

# Help and additional information:
Patricia Q. Tran, ptran5@wisc.edu, University of Wisconsin-Madison Get Help:
- For people at UW-Madison, please visit the [departmental bioinformatics research support service main website](https://bioinformatics.bact.wisc.edu/). If you are part of the Department of Bacteriology please make an 1-on-1 individual appointment, others please attend one of my weekly office hours.
- For external people, please submit an issue via the github page.
