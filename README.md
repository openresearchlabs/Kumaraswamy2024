# Kumaraswamy2024


Indian gut microbiome study on fermented foods with HITChip.

This data set contains experimental data for the study by Kumaraswamy
et al. (forthcoming).

Contact: Jeyaram Kumaraswamy <jeyaram.ibsd -at-here- nic.in>

License: MIT


### Code

Code used to create figures and analyses in the manuscript:

- Bimodality_densityplot (Fig. 8, Fig. S14, and Fig. S15)
- DiversityBoxplot (Fig. 1E, Fig. 5C, Fig. 5B)
- PCoA (Fig. 3)
- InteractionNetwork_plot (Fig. 4, and Fig. S16)
- Heatmap (Fig. 1B)
- Random_forest	(Fig. S2, and Fig. S10)
- Wilcoxon_padjust_bonferroni (Table S2)


Some of these were done by manually selecting the necessary data from
the full Excel, and then just running the script for that subset. See
the code for details.


### Data sets

The data files in the data/ folder include:

Details on data used in the figures:
- Figures_Source Data.txt

HITChip taxonomic abundance profiles at different levels of resolution:
- Oligo_hitchip.xlsx
- Genus_hitchip.xlsx
- Phylum_hitchip.xlsx

Sample metadata:
- Metadata.xlsx

European sample data as RData file
- L2_europe.RData

Manually extracted subsets for specific analyses (see R scripts):
- Bimodality/
- MILK.csv

Other data:
- AbsoluteloadTaxaspecificqPCRdata.xlsx
- 'SCFA data-HPLC.xlsx'
- 'Fecal metabolite profile_LC-HRMS Data.xlsx'
- Longterm-diet and lifestyle.xlsx

### TreeSummarizedExperiment

Running R/data.R in R organizes the data into TreeSummarizedExperiment
structure (file data/tse.Rds).

Other scripts include
- PCoA.R
