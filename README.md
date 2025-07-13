# 16S rRNA Sequencing Pipeline

## Introduction to the pipeline
**Program:** This pipeline is based upon QIIME2 Moving Pictures Tutorial and documentation and utilizes a QIIME2 container. It is meant to be run within HTCondor using a DAGMan workflow manager.

**Purpose:** The purpose of this pipeline is to efficiently analyze long-read sequencing data from 16S rRNA genomic datasets. It contains 8 jobs that build upon one another, and generates outputs that are relevant to research questions (including but not limited to phylogenetic trees, diversity and taxonomic analyses, and differential abundance testing results). These processes are often time-consuming and complicated. By working in HTC Condor, this pipeline allows researchers to streamline their data analysis in a reproducible and effective manner.
 
**Uses:** This pipeline can be utilized in research aiming to parse genomic datasets from bacterial communities and generate visualizations based off of their data. Due to its reproducibility, it can be utilized in parts or whole for other genomic analysis processes as well. It is highly recommended to consult the documentation listed in References below if one is interested in working with this version.

## Workflow
#### Diagram with steps of pipeline

## Getting started
#### Instructions on how to implement workflow using CHTC and data
Description of directory:
* README.md: These directions
* /scripts: Contains all .sh/.sub files required for the pipeline.
  * 00_mkdir.sh: Script to create directory in staging that will store outputs of jobs
  * make_dag: DAGman configuration file
  * 00-08 .sh/.sub pairs for jobs
* .gitignore: all files to be ignored

## Quick-start guide
### Preparing input files & folder directory
You will first need access to a /staging/netid folder. For more information about /staging folders, please visit: https://chtc.cs.wisc.edu/uw-research-computing/file-avail-largedata . The /staging folder will be used for the large genomic input files, and the large genomic output files.

In your request, please consider your input files (how many samples will you have, have the size of all your reads and assembled data, as well as your output files)

>[!NOTE]
> This version of binning_wf assumes that you have:
> a metadata tsv file
> Either single-end sequences (stored in a tar 'emp-single-end-sequences.tar.gz' containing 'barcodes.fastq.gz' and 'sequences.fastq.gz' files) OR paired-end sequences (stored as 'fq-mainfest.tsv')

# Instructions
1. Log into CHTC
2. Clone this directory into your home directory: 
```
git clone https://github.com/UW-Madison-Bacteriology-Bioinformatics/16S_microbiome_wf.git --branch branch_name
cd 16S_chtc
chmod +x scripts/*.sh
```
3. Create a logs folder in your cloned directory (username/16S_chtc/scripts) for your CHTC log, err and out files.
 
4. Run the helper script 00_mkdir.sh from your 16S_chtc/scripts directory. This will create the directory within your staging folder that is necessary to handle all file inputs and outputs.
   ``` bash 00_mkdir.sh ```

5. Run make_dag.sh from your scripts directory. Input the three neccessary arguments (<DEMUX = T/F>, <username>, <filename>) for proper function.
    * DEMUX references whether or not your samples need to be demultiplexed. Use TRUE if you have single-end sequences, and FALSE if you have paired-end sequences.
    * Username is your netid username.
    * Filename is what you wish the dag to be named. If you input microbiome_dag_1, it will be called microbiome_dag_1.dag.

Reference template_dag in this repository for an example output. Example input:
   ``` bash make_dag.sh TRUE bbadger microbiome_dag_1 ```

6. Confirm that you have A) the proper staging folder structure (input-outputs/all job names 00-08) and B) a DAG with your desired name in your scripts folder.

7. Import your starting data into your staging/username/input-outputs/00_pipeline_inputs directory.

>[!NOTE]
> Your data must include:
> a metadata tsv file
> Either single-end sequences (stored in a tar 'emp-single-end-sequences.tar.gz' containing 'barcodes.fastq.gz' and 'sequences.fastq.gz' files) OR paired-end sequences (stored as 'fq-mainfest.tsv')

7. Navigate back to your home/username/16S_chtc/scripts folder, and from there submit the dag.
  ``` condor_submit_dag microbiome_dag_1.dag ```
8. Check your DAG's status with:
  ``` condor_q ```
9. The result for each job should appear within its respective output file within the staging/username/input_outputs directory.
10. Clean and repeat. Transfer your files from CHTC to your computer once the job is correctly completed. One recommended way to do this is the following:
    1. Log out of CHTC
    2. In terminal, navigate to the location you want the files to go on your device
    3. Copy the files into that location with:
       ``` scp username@hostname:/home/username/file ./ ```

## Special Considerations
* Do not include any personal information in the data input into the pipeline.
* Please set up a staging folder with CHTC before trying this pipeline. It is meant to process large amounts of data that your home directory may not neccessarily be able to manage.
* Make sure to update each sub script with your ideal amount of emory and Disk Requests. Please try to be as accurate as possible, as the more you overshoot, the more runtime and memory is taken up.

## References
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
