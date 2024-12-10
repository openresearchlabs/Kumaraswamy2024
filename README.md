# Kumaraswamy2024


Indian gut microbiome study on fermented foods with HITChip.

This data set contains experimental data for the study by Kumaraswamy
et al. (forthcoming).

Contact: Jeyaram Kumaraswamy <jeyaram.ibsd -at-here- nic.in>

License: MIT


### Code

Code used to create figures and analyses in the manuscript:

- Bimodality_densityplot.R
- Heatmap.R
- Wilcoxon_padjust_bonferroni.R
- DiversityBoxplot.R
- InteractionNetwork_plot.R
- Random_forest.R

Some of these were done by manually selecting the necessary data from
the full Excel, and then just running the script for that subset. See
the code for details.


### Data sets

The data files include:

HITChip taxonomic abundance profiles at different levels of resolution:
- Oligo_hitchip.xlsx
- Genus_hitchip.xlsx
- Phylum_hitchip.xlsx

Sample metadata:
- Metadata.xlsx

Manually extracted subsets for specific analyses (see R scripts):
- Bimodality/
- MILK.csv

Details on data used in the figures:
- 'Source Data_Figures.xlsx'

Other data:
- AbsoluteloadTaxaspecificqPCRdata.xlsx
- 'SCFA data-HPLC.xlsx'
- 'Fecal metabolite profile_LC-HRMS Data.xlsx'


### TreeSummarizedExperiment

Running R/data.R in R organizes the data into TreeSummarizedExperiment
structure (file data/tse.Rds).

Other scripts include
- PCoA.R
