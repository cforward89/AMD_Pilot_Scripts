# Make the pilot phyloseq object

library(tidyverse)
library(phyloseq)

meta = readxl::read_xlsx('Data/raw_vs_clean_depths.xlsx') %>% 
  mutate(Sample = str_remove_all(Sample, '_R1_001')) %>%
  column_to_rownames('Sample')

otu = read.delim('Data/pseudo_RPK_taxonomy.txt', skip=1) %>% 
  filter(str_detect(clade_name, 's__') & !str_detect(clade_name, 't__')) %>% 
  column_to_rownames('clade_name') 

tax = otu %>% rownames_to_column('clade_name') %>% 
  separate(col='clade_name', remove=F,
           into=c('Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', 'Species'), sep='[|]') %>% 
  column_to_rownames('clade_name') %>% 
  select(-starts_with('Sub'))

ps = phyloseq(otu_table(otu, taxa_are_rows=T), 
               sample_data(meta), 
               tax_table(as.matrix(tax)))

saveRDS(ps, 'Data/pilot_phyloseq.rds')
