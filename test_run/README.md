
# Test run commands

Call somatic variants

```
cat data/canineOSA.n10.tumor_normal_pairs.txt | while read tumor normal ; do 

    sbatch somatic_variant_calling.sh data/$tumor.recal.chr21.subs50.bam data/$normal.recal.chr21.subs50.bam

done
```

Filter variants

```
module load bioinfo-tools vcftools/0.1.16

for vcf in *filt.vcf.gz ; do 

    vcftools --gzvcf $vcf --remove-filtered-all \
    --bed cf4.chr21.phylop.constrained_positions.bed \
    --recode --recode-INFO-all --stdout \
    > ${vcf%.vcf.gz}.pass.constraint.vcf

done
```

Annotate

```
module load snpEff/4.3t

for vcf in *.pass.constraint.vcf ; do 

    snpEff ann -noStats canFam4.0 $vcf  > ${vcf%.vcf.gz}.snpeff.vcf

done
```

# Regulatory annotations

```
module load bioinfo-tools vcftools/0.1.16 snpEff/4.3t

for vcf in *filt.vcf.gz ; do 

    vcftools --gzvcf $vcf --remove-filtered-all \
    --bed human_GRCh38_cCREs_regulatory_elements.liftover_to_cf4.chr21.bed  \
    --recode --recode-INFO-all --stdout \
    > ${vcf%.vcf.gz}.pass.cCREs.vcf

    snpEff ann -noStats canFam4.0 ${vcf%.vcf.gz}.pass.cCREs.vcf \
    >${vcf%.vcf.gz}.pass.cCREs.snpeff.vcf

done
```