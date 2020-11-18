#!/bin/bash

# Create a working directory:
data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

# Create a directory where the data will be downloaded
mkdir -p sra_data
cd sra_data
# head -3 /ifb/data/mydatalocal/SRR_Acc_List.txt > SRR_partial.txt
# Make a list of SRR accessions:
SRR=`cat /ifb/data/mydatalocal/SRR_Acc_List.txt`

# For each SRR accession, download the data :
for srr in $SRR
do 
echo $srr 
# ZIP Produces one fastq file, single end data.
fastq-dump $srr --gzip

done

