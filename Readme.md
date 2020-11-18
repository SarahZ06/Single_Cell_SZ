#
**OBJECTIF:**

Cette étude vise à réaliser un atlas des cellules présentes au niveau des molaires de souris en se focalisant sur les cellules ayant une croissance rapide. Le but étant de comprendre par quoi est régi la régénérescence pour pouvoir espérer reconstruire la dentition humaine. 

**VUE GENERALE DES MANIPULATIONS:**
#Inserer image non encore faite 

**ETAPE 1 : récupération des donnés cellulaires**
Après avoir selectionné les bonnes cellules sur ??? On réalise un `fastq-dump` 
```
for srr in $SRR
  do 
echo $srr 
ZIP Produces one fastq file, single end data.
fastq-dump $srr --gzip
done
```
**ETAPE 2 : control qualité**
On réalise ensuite un controle qualité sur ces données crées grace à la fonction `fastqc`
```
for srr in $SRR
do 
echo $srr".fastq.gz"
# Analyse des 10 premieres infos.
fastqc $srr".fastq.gz" -o /ifb/data/mydatalocal/data/fastqc
done
```

**ETAPE 3 : amélioration de la qualité des données**
Les résultats de fastqc montre une bonne qualité de séquences. Cependant, pour l'ameliorer d'avantage on utilise `trimmomatic`
```
for srr in $SRR
do 
echo $srr
# Lancer trimmomatic sur l'ensemble des données.
java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar SE $data/sra_data/${srr} $data/sra_data_cleant/${srr} ILLUMINACLIP:/softwares/Trimmomatic-0.39/adapters/TruSeq3-SE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
done
```
**ETAPE 4 : extraction des données de références**
Suite à cela, on réalise un alignement entre les séquences obtenues et une séquence de référence de mus_musculus prise sur [https://www.ensembl.org/] 
L'extraction de ces données de référence se fait en créant un index. Ce dernier correspond à un codage des séquences de référence en un code compacté (pour notre part un code à 31 lettres). La création de cet index se fait via la commande suivante : 
```
salmon index -t Mus_musculus.GRCm38.cdna.all.fa -i mouse_index -k 31
```
**ETAPE 5 : Mapping des séquences nettoyée**
Suite à cela, on réalise un mapping de nos séquences sur l'indexe obtenu.
```
for srr in $SRR
do
echo $srr
salmon quant -i $transcriptome_index -l SR -r /ifb/data/mydatalocal/data/sra_data_cleant/$srr --validateMappings -o $srr"_quant" --gcBias
done
```

