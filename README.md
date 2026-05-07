# AMD Pilot Analysis

This repo will assess the best DNA extraction kit for subgingival and salivary metagenomic samples.

Samples: DBT vs PF for both subgingival and salivary samples. n=3 per group (total: n=12)

Analyses (run separately for each sample type):

-   Which kit gives a bigger sequencing depth?

    -   Boxplot with T test

-   Which kit gives higher alpha diversity? (Shannon, Faith's PD, Observed)

    -   Boxplot with T test

-   How different are the kits in terms of beta diversity? (Bray-Curtis, Jaccard, Weighted and Unweighted Unifrac)

    -   PCoA or NMDS plot with PERMANOVA test

-   What is the general bacterial composition of the samples?

    -   Taxonomic bar plot, no statistics

    -   Use facet_wrap (or facet_nested from ggh4x library) to separate the samples by kit and type

Note for analysis: R Scripts can be adapted from the armetcal/MICB_305 repo.
