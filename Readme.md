[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)  

**OBJECTIF:**

Cette étude vise à réaliser un atlas de cellules présentes au niveau des molaires de souris en se focalisant sur les cellules ayant une croissance rapide. Le but étant de comprendre par quoi est régi la régénérescence pour pouvoir espérer réaliser une régénération dentaire par ingénierie. 

**VUE GENERALE DES MANIPULATIONS:**
#Inserer image non encore faite 

**ETAPE 1 : récupération des donnés cellulaires**
Après avoir selectionné les bonnes cellules sur ??? On réalise un `fastq-dump`. Voir [fastq_dump.sh](fastq_dump.sh)

**ETAPE 2 : control qualité**
On réalise ensuite un controle qualité sur ces données crées grace à la fonction `fastqc`. Voir [fast_qc.sh](Test_qualite.sh)

**ETAPE 3 : amélioration de la qualité des données**
Les résultats de fastqc montre une bonne qualité globale de séquences. Cependant, pour l'ameliorer d'avantage on utilise [trimmomatic.sh](trimmomatic.sh)


**ETAPE 4 : extraction des données de références**
Suite à cela, on réalise un alignement entre les séquences obtenues et une séquence de référence de mus_musculus prise sur [https://www.ensembl.org/] 
L'extraction de ces données de référence se fait en créant un index. Ce dernier correspond à un codage des séquences de référence en un code compacté (pour notre part un code à 31 lettres). La création de cet index se fait via la commande suivante : 
```
salmon index -t Mus_musculus.GRCm38.cdna.all.fa -i mouse_index -k 31
```
**ETAPE 5 : Mapping des séquences nettoyée**
Suite à cela, on réalise un mapping de nos séquences sur l'indexe obtenu. Voir [mapping.sh](salmon_mapping.sh)


