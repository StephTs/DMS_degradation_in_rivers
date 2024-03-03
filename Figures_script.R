##### Graphs - Making the various graphs in the River paper #####
# Author: Stephania L. Tsola
# Date: March 2024
# R version 4.3.1 (2023-06-16)
# R Studio version 2023.09.1

# Note: Figures with multiple panels (e.g. Figure 2AB) were created seperately and then combined into one either in Powerpoint or Microsoft's Paint3D

library("dplyr")
library("ggplot2")
library("forcats")

# Figure 1: Map - The script is in River_grainsize_map.py

# Figure 2A: Graph made in Microsoft Excel using the gas chromatography results

# Figure 2B: Graph that shows the total Methane and CO2 produced and DMS degraded during the incubation experiments per river

##This gives you the average and standard error between the replicates and exports everything into a new csv file
River_sumf_DMSCH4CO2 <- AvgDMSCH4CO2_Rivers %>%
  group_by(Sample) %>%
  summarise(Mean= mean(Measurements, na.rm=T), se = sd(Measurements, na.rm=T)/sqrt(5), 
            Sample, Replicate, Site, SedimentType, Gas)

write.csv(River_sumf_DMSCH4CO2,"River_sumf_DMSCH4CO2.csv", row.names = FALSE)

River_graph_facet_DMSCH4CO2 <- ggplot(River_sumf_DMSCH4CO2, aes(x=Site, y=Mean, fill=Gas)) +
  geom_bar(stat="identity", colour="black", position="dodge")+
  geom_errorbar(aes(ymin=Mean-se, ymax=Mean+se), size=.3, width=.2, position=position_dodge(.9))+ 
  labs (y= "Average gas (µmol/g)", x="") +
  guides(fill=guide_legend(title=""))+
  theme(text=element_text(size=21, face = "bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"), 
        axis.text.y = element_text(face="bold", colour = "black")) + 
  facet_wrap(~ SedimentType, scales = "free_x")

River_graph_facet_DMSCH4CO2


# Figure 2A: Graph made in Microsoft Excel using the mcrA relative abundance results

# Figure 2B: PCoA plot - The script is in mcrA_analysis-microeco.R

# Figure 2C: Graph showing the mcrA qPCR results per River

## First import csv which contains Gene_Copy, Replicate, Treatment, Site, Sediment Type

##This gives you the average and standard error between the replicates and exports everything into a new csv file
River_mcrA_qPCR_sumf <- mcrA_River_qPCR %>%
  group_by(Sample) %>%
  summarise(Sample, Replicate, Sediment_Type, Treatment, Site,Mean= mean(Gene_Copy, na.rm=T), 
            se = sd(Gene_Copy, na.rm=T)/sqrt(sum(Replicate)))

write.csv(River_mcrA_qPCR_sumf,"River_mcrA_qPCR_sumf.csv", row.names = FALSE) #Export summary to csv so can change table if needed 

River_mcrA_qPCR_facet <- ggplot(River_mcrA_qPCR_sumf, aes(x=Site, y=Mean, fill=Treatment)) +
  geom_bar(stat="identity", colour="black", position="dodge")+
  geom_errorbar(aes(ymin=Mean-se, ymax=Mean+se), size=.3, width=.2, position=position_dodge(.9)) +
  labs (y= expression(bold("Mean" ~bolditalic("mcrA")~ "copies/g")), x="") +
  guides(fill=guide_legend(title=""))+
  theme(text=element_text(size=22, face = "bold", colour = "black"),
        axis.text.x = element_text(face="bold", colour = "black"), 
        axis.text.y = element_text(face="bold", colour = "black")) + 
  facet_wrap(~ Sediment_Type, scales = "free_x")
River_mcrA_qPCR_facet


# Figure 3A: Heatmap showing the normalised gene count data of methylotrophic methanogenesis genes (Pant shotgun metagenomics dataset)

heatmap_Pant_methyl <- ggplot(data= Pant_MG_Reduced_noS_methyl, mapping = aes(x=Sample ,y= Genes, fill = Log_CPM)) +
  geom_tile(color="white", size=0.25) +
  labs(x="", y="")+
  scale_y_discrete(expand=c(0,0),limits = rev)+
  theme_grey(base_size=8)+
  theme(legend.text=element_text(size=14),
        legend.title=element_text(size=14, face="bold"),
        axis.ticks=element_line(linewidth =0.2),
        panel.border=element_blank(), 
        axis.text.x = element_text(face="bold", size=14, angle = 90, hjust = 0, vjust = 0.5),
        axis.text.y = element_text(face="bold", size=14))+
  scale_fill_gradient(low = "darkorange", high = "blue3")

heatmap_Pant_methyl

ggsave(heatmap_Pant_methyl, filename="heatmap_Pant_methyl.tiff", height=5, width=2.7, units="in", dpi=300)


# Figure 3B: Bubblegraph showing the normalised gene count data of methylotrophic methanogenesis genes in different genera (Pant shotgun metagenomics dataset)

bubble_Methyl_Genes_AbuntGenera <- ggplot(data= Methyl_Genes_AbuntGenera, aes(x=Genus ,y= fct_rev(Gene))) +
  geom_point(
    aes(size = Log_CPM, color= Genus), shape = 19
  ) + 
  labs(x="Genus", y="Methylotrophic methanogenesis genes") +
  scale_size_continuous(range = c(0, 15)) +
  theme_grey(base_size=8)+
  theme(legend.text=element_text(size=14),
        legend.title=element_text(size=14, face="bold"),
        axis.ticks=element_line(linewidth =0.2),
        panel.border=element_blank(), 
        axis.text.x = element_text(face="bold", size=14, angle = 90, hjust = 0, vjust = 0.5),
        axis.text.y = element_text(face="bold", size=14)) + 
  guides(colour = guide_legend(override.aes = list(size=6)))

bubble_Methyl_Genes_AbuntGenera

ggsave(bubble_Methyl_Genes_AbuntGenera_other, filename="bubble_Methyl_Genes_AbuntGenera-coloured_other_Log-CPM.tiff", height=7, width=5.5, units="in", dpi=300)


