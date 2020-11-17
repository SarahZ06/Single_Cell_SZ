#!/bin/bash

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

# Create a directory where the data will be downloaded
mkdir -p fastqc
cd sra_data
head -10 /ifb/data/mydatalocal/SRR_Acc_List.txt > fastqc_partial.txt
# Definir SRR
SRR=`cat fastqc_partial.txt`
# For each SRR accession, download the data :
for srr in $SRR
do 
echo $srr".fastq.gz"
# Analyse des 10 premieres infos.
fastqc $srr".fastq.gz" -o /ifb/data/mydatalocal/data/fastqc
done




