##### Microeco - Exploration of the River _mcrA_ amplicon data from QIIME2 #####
# Author: Stephania L. Tsola
# Date: March 2024
# R version 4.3.1 (2023-06-16)
# R Studio version 2023.09.1

library(file2meco)
library(microeco)
library(qiime2R)
library(phyloseq)
library(ggplot2)
library(seqinr)
library(magrittr)

#If unable to install qiime2R:
#download.file("https://github.com/jbisanz/qiime2R/Methhive/master.zip", "source.zip")
#unzip("source.zip")
#install.packages("qiime2R-master", repos = NULL, type="source")

# Covert the qiime2 files to phyloseq objects
mcrAphyseq<-qza_to_phyloseq(
  features="mcrA-table-dn-85.qza",
  taxonomy="mcrA-merged-taxonomy-85.qza",
  metadata = "mcrA-metadata.tsv"
)
mcrAphyseq

# Insert phyloseq object to microeco
mcrA_meco_dataset <- phyloseq2meco(mcrAphyseq)
mcrA_meco_dataset


# Analysis starts here
mcrA_meco_dataset$cal_abund() # Abundance of mcrA although for the paper I used excel for the relative abundance graphs due to inexperience
# save abundance to a directory
mcrA_meco_dataset$save_abund(dirpath = "mcrA_taxa_abund")
mcrA_meco_dataset$cal_alphadiv(measure = "Shannon") #Calculate alpha diversity using the Shannon index
# save alpha diversity to a directory
mcrA_meco_dataset$save_alphadiv(dirpath = "mcrA_alpha_diversity")
# unifrac = FALSE means do not calculate unifrac metric - requires GUniFrac package installed
mcrA_meco_dataset$cal_betadiv(unifrac = FALSE)
# save beta diversity to a directory
mcrA_meco_dataset$save_betadiv(dirpath = "mcrA_beta_diversity")


Location_mcrA_beta_bray <- trans_beta$new(dataset = mcrA_meco_dataset, group = "Location", measure = "bray")
Location_mcrA_beta_bray$cal_manova(manova_all = TRUE) #Grouped by Location
Location_mcrA_beta_bray$res_manova #0.05

Location_mcrA_beta_bray$cal_manova(manova_all = FALSE) #manova_all = FALSE can be used to calculate significance for each paired group
Location_mcrA_beta_bray$res_manova
#Groups measure        F         R2 p.value p.adjusted Significance
#1      Pant vs Rib    bray 4.542850 0.15915894   0.015     0.0900             
#2   Pant vs Medway    bray 2.432339 0.09202134   0.109     0.2232             
#3   Pant vs Nadder    bray 1.607392 0.06277062   0.186     0.2232             
#4    Rib vs Medway    bray 2.143632 0.08199444   0.140     0.2232             
#5    Rib vs Nadder    bray 1.968759 0.07581258   0.179     0.2232             
#6 Medway vs Nadder    bray 0.555124 0.02260726   0.595     0.5950 

# for the whole comparison and for each paired groups
Location_mcrA_beta_bray$cal_betadisper()
Location_mcrA_beta_bray$res_betadisper #not significant

Treatment_mcrA_beta_bray <- trans_beta$new(dataset = mcrA_meco_dataset, group = "Treatment", measure = "bray") #Grouped by treatment
Treatment_mcrA_beta_bray$cal_manova(manova_all = TRUE)
Treatment_mcrA_beta_bray$res_manova 
#Permutation test for adonis under reduced model
#Terms added sequentially (first to last)
#Permutation: free
#Number of permutations: 999
#
#adonis2(formula = use_formula, data = metadata)
#Df SumOfSqs      R2      F Pr(>F)    
#Treatment  2   8.3197 0.67445 50.758  0.001 ***
#  Residual  49   4.0158 0.32555                  
#Total     51  12.3355 1.00000                  
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Treatment_mcrA_beta_bray$cal_manova(manova_all = FALSE)
Treatment_mcrA_beta_bray$res_manova 
#Groups measure         F        R2 p.value p.adjusted Significance
#1 Control vs Original    bray  3.992695 0.1174574   0.004     0.0040           **
#2      Control vs DMS    bray 80.709324 0.7035986   0.001     0.0015           **
#3     Original vs DMS    bray 79.213740 0.6996831   0.001     0.0015           **


Treatment_mcrA_beta_bray$cal_betadisper()
Treatment_mcrA_beta_bray$res_betadisper 
#Permutation test for homogeneity of multivariate dispersions
#Permutation: free
#Number of permutations: 999
#
#Response: Distances
#Df  Sum Sq  Mean Sq      F N.Perm Pr(>F)   
#Groups     2 0.11284 0.056421 4.8482    999  0.007 **
#  Residuals 49 0.57024 0.011638                        
#---
#  Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
#Pairwise comparisons:
#  (Observed p-value below diagonal, permuted p-value above diagonal)
#Control        DMS Original
#Control             0.12400000    0.247
#DMS      0.13309463               0.001
#Original 0.24761853 0.00020988  



# PCoA plot showing the treatment as colours and the location as the point shape

Treatment_mcrA_beta_bray$cal_ordination(ordination = "PCoA")

# The code below exports the PCo-axes scores into a txt file that I can then import into the program PAST to run the Spearman correlation
# PAST: https://palaeo-electronica.org/2001_1/past/issue1_01.htm

mcra_PCoA_scores <- Treatment_mcrA_beta_bray$res_ordination$scores
mcra_PCoA_scores

write.table(mcra_PCoA_scores, file = "mcrA_PCoA_Scores_treatment.txt", sep = "\t",
            row.names = TRUE, col.names = NA)

mcrA_Treatment_coordinates <- Treatment_mcrA_beta_bray$plot_ordination(plot_color = "Treatment", 
                                                   plot_shape = "Location", 
                                                   plot_type = c("point", "ellipse"), justDF = TRUE)

mcrA_Treatment_PCoA <- Treatment_mcrA_beta_bray$plot_ordination(plot_color = "Treatment", 
                                                   plot_shape = "Location", 
                                                   plot_type = c("point", "ellipse"))
mcrA_Treatment_PCoA + theme_bw() + 
  theme(text = element_text(size = 21, face="bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"), 
        axis.text.y = element_text(face="bold", colour = "black"))+ 
  geom_point(size = 4)


