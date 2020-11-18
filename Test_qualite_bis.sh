#!/bin/bash

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

# Create a directory where the data will be downloaded
mkdir -p fastqcbis
cd sra_data_cleant
head -10 /ifb/data/mydatalocal/SRR_Acc_List.txt > fastqcbis_partial.txt
# Definir SRR
SRR=`cat fastqcbis_partial.txt`
# For each SRR accession, download the data :
for srr in $SRR
do 
echo $srr".fastq.gz"
# Analyse des 10 premieres infos.
fastqc $srr".fastq.gz" -o /ifb/data/mydatalocal/data/fastqcbis
done