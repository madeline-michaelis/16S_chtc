# 16S rRNA Sequencing Pipeline

## Introduction to the pipeline
**Program:** This pipeline is based upon QIIME2 Moving Pictures Tutorial and documentation and utilizes a QIIME2 container. It is meant to be run within HTCondor using a DAGMan workflow manager.

**Purpose:** The purpose of this pipeline is to efficiently analyze long-read sequencing data from 16S rRNA genomic datasets. It contains 8 jobs that build upon one another, and generates outputs that are relevant to research questions (including but not limited to phylogenetic trees, diversity and taxonomic analyses, and differential abundance testing results). These processes are often time-consuming and complicated. By working in HTC Condor, this pipeline allows researchers to streamline their data analysis in a reproducible and effective manner.
 
**Cyberinfrastructure & Implementation:** These scripts are meant to be run by HTCondor, a workflow manager that takes in an executable file and a submit file. They are meant to be run on the UW-Madison shared campus-computing infrastructure CHTC, but could work on other systems with few modifications. The pipeline takes advantage of the high-throughput scaling abilities of HTCondor to submit multiple jobs at the same time. For example, if we had an experimental design of 3 treatment, 3 replicate and 3 reference genomes and 10 time points, we would have to perform the steps 3 * 3 * 3 * 10 = 270 times. Instead, we write the metadata (information about the sample design) in a comma separated file containing 270 rows, and HTCondor will submit 270 jobs at the same time for us.
 
**Uses:** This pipeline can be utilized in research aiming to parse genomic datasets from bacterial communities and generate visualizations based off of their data. Due to its reproducibility, it can be utilized in parts or whole for other genomic analysis processes as well. It is highly recommended to consult the documentation listed in References below if one is interested in working with this version.

## Workflow
#### Diagram with steps of pipeline

## Getting started
#### Instructions on how to implement workflow using CHTC and data
Description of directory:
* /scripts: Contains all .sh/.sub files required for the pipeline.
*


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
