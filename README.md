# DMS degradation in rivers

Code for the paper:
Methanomethylovorans are the dominant dimethylsulfide-degrading methanogens in gravel and sandy riverbed sediments

FIX THIS DOI! <a href="https://zenodo.org/badge/latestdoi/629950360"><img src="https://zenodo.org/badge/629950360.svg" alt="DOI"></a>

This repo contains the code for analysing the amplicon data presented in the paper using QIIME2 as well as code for creating a custom _mcrA_ database. Furthermore, it has R scripts detailing the bioinformatic analysis of the amplicon data and how the various graphs were made using ggplot2. Lastly, program usage information is given for PAST (used for the Spearman correlation analysis).

Any help with improving the scripts or any other comments are greatly appreciated.  


## Content    UPDATE ME
1) mcrAseq_analysis-QIIME2.sh - Script for the qiime2 analysis of _mcrA_ sequences from the River samples
2) mcrA_sample-metadata.tsv - Metadata file of River _mcrA_ samples
3) mcrA_analysis-microeco.R - Script for microeco _mcrA_ analysis
4) Figures_script.R - R script containing information on the creation of all paper figure (avg gases, metaG heatmap/bubblegraph, qPCR, etc)
5) Figure1_River_grainsize_map.py - Python script for teh creation of the Figure 1 map
7) Spearman_correlation-PAST.txt - Step-by-step guide to using PAST for the Spearman's correlation analysis 
8) River_mcrA_PCoA_Scores.csv - csv file imported into PAST  
9) LICENSE.md

## License
This project is licensed under the terms of the MIT License. See the LICENSE.md for further information.

