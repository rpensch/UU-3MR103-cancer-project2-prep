#!/bin/bash

# Make a copy of the phylop bed file for chromosome 21 and rename it
cp /proj/uppstore2017228/KLT.04.200M/200m_MD_PhyloP_scores/scores.PhyloP.dog_v4_mdong_241MAMMALS/chr21.bed.gz .
mv chr21.bed.gz cf4.chr21.phylop.bed.gz

# Create a bed file of positions that are evolutionarily constrained (phylop score >= 1.296)
printf "chrom\tstart\tend\n" \
> cf4.chr21.phylop.constrained_positions.bed

zcat cf4.chr21.phylop.bed.gz | 
awk -v OFS='\t' -v FS='\t' '$5>=1.296' | cut -f 1-3 \
>> cf4.chr21.phylop.constrained_positions.bed

# Select cCREs on chromosome 21 from a hg38 liftover to cf4 bed file
printf "chrom\tstart\tend\tcCRE\n" \
> human_GRCh38_cCREs_regulatory_elements.liftover_to_cf4.chr21.bed 

awk -v OFS='\t' -v FS='\t' '$1=="chr21"' GRCh38-cCREs_V3.excl_accession.liftover_to_cf4.bed \
>> human_GRCh38_cCREs_regulatory_elements.liftover_to_cf4.chr21.bed 

