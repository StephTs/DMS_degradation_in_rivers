##### QIIME2 - Analysis of River _mcrA_ amplicon sequences #####
# Author: Stephania L. Tsola
# Date: March 2024
# QIIME2 version 2021.11

# Note 1: The mcrA database used is the same I created for the paper: https://doi.org/10.1186/s40168-023-01720-w. Script is available on Github at: https://zenodo.org/badge/latestdoi/629950360
# Note 2: Rivers Pant and Rib were sequenced together: Round 1. Rivers Medway and Nadder were sequenced together at a later time: Round 2. Because of this, analysis was carried out seperately until step 6 when the samples were merged for taxonomic assignment. Overall, if you are trying to analyse data from two different sequence runs you need to run them through DADA2 separately. This ensures all the filtering steps are done correctly for all runs. Also, DADA2 trunk and trim parameters need to be the same for all runs. Pick parameters that work for all runs. Then merge the files together for the rest of the analysis.

conda activate qiime2-2021.11

# 1) Import files to QIIME2
# Makes one single qiime file with all the sequences
qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path home/mcra/Round1 \
--source-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path mcrA_demux-paired-end-Round1.qza

qiime tools import \
--type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path home/mcra/Round2 \
--source-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path mcrA_demux-paired-end-Round2.qza

# 2) Visualise merged file (the file created helps to check quality control and understand where to trim and truncate your samples in the DADA2 step (step 3)
qiime demux summarize \
--i-data mcrA_demux-paired-end-Round1.qza \
--o-visualization mcrA_demux-Round1.qzv

qiime demux summarize \
--i-data mcrA_demux-paired-end-Round2.qza \
--o-visualization mcrA_demux-Round2.qzv

# 3) Sequence quality control
qiime dada2 denoise-paired \
--i-demultiplexed-seqs Round1-primertrimmed.qza \
--o-table table-Round1-trimmed.qza \
--o-denoising-stats den-stats-Round1-trimmed.qza \
--o-representative-sequences rep-seqs-Round1-trimmed.qza \
--p-trim-left-f 33 \
--p-trim-left-r 33 \
--p-trunc-len-f 279 \
--p-trunc-len-r 206 \
--verbose

qiime dada2 denoise-paired \
--i-demultiplexed-seqs Round2-primertrimmed.qza \
--o-table table-Round2-trimmed.qza \
--o-denoising-stats den-stats-Round2-trimmed.qza \
--o-representative-sequences rep-seqs-Round2-trimmed.qza \
--p-trim-left-f 33 \
--p-trim-left-r 33 \
--p-trunc-len-f 279 \
--p-trunc-len-r 206 \
--verbose

# 4) Visualize the denoising stats

qiime metadata tabulate \
--m-input-file mcrA_den-stats-Round1.qza \
--o-visualization mcrA_den-stats-Round1.qzv

qiime metadata tabulate \
--m-input-file mcrA_den-stats-Round2.qza \
--o-visualization mcrA_den-stats-Round2.qzv

# 5) Feature table and feature data visualization
qiime feature-table summarize \
--i-table mcrA_table-Round1.qza \
--o-visualization mcrA_table-Round1.qzv \
--m-sample-metadata-file mcrA-metadata-Round1.tsv

qiime feature-table mcrA_tabulate-seqs \
--i-data mcrA_rep-seqs-Round1.qza \
--o-visualization mcrA_rep-seqs-Round1.qzv

qiime feature-table summarize \
--i-table mcrA_table-Round2.qza \
--o-visualization mcrA_table-Round2.qzv \
--m-sample-metadata-file mcrA-metadata-Round2.tsv

qiime feature-table mcrA_tabulate-seqs \
--i-data mcrA_rep-seqs-Round2.qza \
--o-visualization mcrA_rep-seqs-Round2.qzv


# 6) Merge the rounds
qiime feature-table merge \
 --i-tables table-Round1.qza \
 --i-tables table-Round2.qza \
 --o-merged-table merged_table.qza

qiime feature-table merge-seqs \
 --i-data rep-seqs-Round1.qza \
 --i-data rep-seqs-Round2.qza \
 --o-merged-data merged_rep-seqs.qza


# 7) Train a classifier using the mcrA database (fasta and taxonomy files)
qiime feature-classifier fit-classifier-naive-bayes \
  --i-reference-reads  NoBacUncArc5Env-seqs-cleaned.qza \
  --i-reference-taxonomy NoBacUncArc5Env-tax.qza \
  --o-classifier mcrA-classifier.qza

# 8) Use the classifier and visualize the resulting taxonomic assignments
qiime feature-classifier classify-sklearn \
--i-classifier NoBacUncArc5Env-tax-classifier.qza \
--i-reads merged_rep-seqs.qza \
--o-classification merged-taxonomy.qza
  
qiime metadata tabulate \
--m-input-file merged-taxonomy.qza \
--o-visualization merged-taxonomy.qzv

# 9) View the taxonomic composition of the samples with interactive bar plots
qiime taxa barplot \
--i-table merged_table.qza \
--i-taxonomy merged-taxonomy.qza \
--m-metadata-file mcrA-metadata.tsv \
--o-visualization merged-taxa-bar-plots.qzv
 
