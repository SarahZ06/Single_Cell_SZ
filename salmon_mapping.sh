#!/bin/bash

# Creates target files
data="/ifb/data/mydatalocal/data/"
mkdir -p $data
cd $data
mkdir -p salmon_count 

#Works in file index_reference
cd /ifb/data/mydatalocal/data/salmon_count

SRR=`ls /ifb/data/mydatalocal/data/sra_data_cleant`
transcriptome_index="/ifb/data/mydatalocal/data/alignement/mouse_index"
#Quantification
for srr in $SRR
do
echo $srr
salmon quant -i $transcriptome_index -l SR -r $srr --validateMappings -o {$srr}_quant --gcBias
done