#!/bin/bash -l
#SBATCH -p core -n 8
#SBATCH -J call-mutec2
#SBATCH -t 12:00:00
#SBATCH -A naiss2024-5-39
#SBATCH --mail-user raphaela.pensch@imbim.uu.se
#SBATCH --mail-type=END

module load bioinfo-tools GATK/4.3.0.0

# Somatic variant calling with Mutect2
# -------------------------
# -R reference
# -L region
# --germline-resource germline variants of healthy patients
# --panel-of-normals germline variants of patients sequenced in the same cohort
# --normal-sample normal sample name specified in bam file
# -I bam files
# -O output

# Apply filters FilterMutectCalls 
# !! Applies filters, but PASS variants still need to be extracted

tumor_bam=$1
normal_bam=$2

tumor_bam_file=$(basename $normal_bam)
normal_bam_file=$(basename $normal_bam)
tumor_sample=${tumor_bam_file%%.*}
normal_sample=${normal_bam_file%%.*}

gatk Mutect2 \
--native-pair-hmm-threads 8 \
-R data/genome/cf4.b6.14.fa \
-L chr21 \
--germline-resource data/healthy_dogs.n28.germline_resource.vcf.gz \
--panel-of-normals data/canineOSA.n116.PON.vcf.gz \
--normal-sample $normal_sample \
-I $tumor_bam \
-I $normal_bam \
-O ${tumor_sample}_vs_${normal_bam_file%%.bam}.somatic.vcf.gz

gatk FilterMutectCalls \
-R data/genome/cf4.b6.14.fa \
-L chr21 \
-V ${tumor_sample}_vs_${normal_bam_file%%.bam}.somatic.vcf.gz \
-O ${tumor_sample}_vs_${normal_bam_file%%.bam}.somatic.filt.vcf.gz




