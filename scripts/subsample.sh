#!/bin/bash -l
#SBATCH -p core -n 2
#SBATCH -t 12:00:00
#SBATCH -A naiss2024-5-39
#SBATCH --mail-user raphaela.pensch@imbim.uu.se
#SBATCH --mail-type=END

module load bioinfo-tools samtools/1.20

cd prep_data/bams
for cram in *cram ; do 

    file=$(basename $cram)
    samtools view -b -o ${file%.cram}.chr21.bam $cram chr21
    samtools index ${file%.cram}.chr21.bam

    samtools view --subsample 0.5 -o ${file%.cram}.chr21.subs50.bam ${file%.cram}.chr21.bam
    samtools index ${file%.cram}.chr21.subs50.bam

done