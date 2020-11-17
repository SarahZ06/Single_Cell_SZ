#!/bin/bash

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

# Create a directory where the data cleaned will be downloaded
mkdir -p sra_data_cleant
cd /ifb/data/mydatalocal/data/sra_data
# Definir SRR
SRR=`ls /ifb/data/mydatalocal/data/sra_data`
# For each SRR accession, download the data :
for srr in $SRR
do 
echo $srr
# Lancer trimmomatic sur l'ensemble des données.
java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar SE $data/sra_data/${srr} $data/sra_data_cleant/${srr} ILLUMINACLIP:/softwares/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done