#!/bin/bash
### Run Cell Ranger on 10X Genomics fastqs in the specified folder
### Li Ma
### $1 is the folder to store fastq files, which may have many samples.
### Example Usage1(all samples in dir): nohup ./runCellRanger_count.sh dir_name 2>&1 > trans5.log &
### Example Usage2(specified one sample in dir): nohup ./runCellRanger_count.sh dir_name samplename 2>&1 > trans5.log &

#!/bin/bash
if [ ! -d $1 ]; then
  echo "Error: directory does not exist."
fi

CELLRANGER_ROOT='/data/home/mali/biosoft/cellranger-7.1.0/bin/cellranger'
TOOL='count'

if [ -n "$2" ]; then
  $CELLRANGER_ROOT $TOOL --id="$1_$2" \
  --sample=$2 \
  --transcriptome=/data/home/mali/genome/human/10x/refdata-gex-GRCh38-2020-A \
  --fastqs=/data/home/mali/scRNAseq_child/20230317_scRNA_child_10x_1-4/$1 \
  --expect-cells=8000
  echo "finish $2"
else
  for i in $(ls $1/*_R1_001.fastq.gz)
  do
    i=${i%%_*}
    i=${i##*/}
    echo ${i}
    echo "$1_${i}"
    $CELLRANGER_ROOT $TOOL --id="$1_${i}" \
    --sample=${i} \
    --transcriptome=/data/home/mali/genome/human/10x/refdata-gex-GRCh38-2020-A \
    --fastqs=/data/home/mali/scRNAseq_child/20230317_scRNA_child_10x_1-4/$1 \
    --expect-cells=8000
    echo "finish ${i}"
  done
fi

#--id  A unique run id and output folder name
#--sample Prefix of the filenames of FASTQs to select
#--fastqs Path to input FASTQ data
