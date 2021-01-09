[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)  

**OBJECTIF:**

Le tissu dentaire des rongeurs est caractérisé par la présence d'une paire d'incisive à croissance continue. Bien que cette caractéristique a longtemps été décrite, peu d'études se sont interessée à la population cellulaire responsable de ce phénomene. Cette étude vise à réaliser un atlas qui englobe l'hétérogénité cellulaires présente dans les incisives de souris. Cette charactérisation se base sur les différénces d'expression des gènes au sein des population cellulaire. In fine cette étude contribura à la charactérisation des cellules souches dentaires ce qui permetra une envetuelle application médicale afin de remplacer le dentition humaine. 

**VUE GENERALE DES MANIPULATIONS:**
#Inserer image non encore faite 

**ETAPE 1 : récupération des donnés cellulaires**
Les données cellulaires sont récupérés  à partir de la basse de données   [Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA609340&f=organism_s%3An%3Amus%2520musculus%3Bphenotype_sam_ss%3An%3Ahealthy%3Bplatform_sam_s%3An%3Asmart-seq2%3Bsource_name_sam_ss%3An%3Aincisor%3Ac&o=acc_s%3Aa) suite à l'application du filtre : Mus musculus specie, healthy, Smart-Seq, incisor. Ceci permet d'obtenir 2555 cellules. Les données récupérées sont en format .txt file. 
Suite à cela on réalise un `fastq-dump` afin de convertir les fichiers obtenus en format fastq. Voir [fastq_dump.sh](fastq_dump.sh)

**ETAPE 2 : control qualité**
Lors du séquençage à haut débit par la méthode SMART-SEQ2, différents défauts de qualité peuvent survenir. De ce fait, il est nécessaire de réaliser un controle qualité grâce à la fonction `fastqc`. Voir [fast_qc.sh](Test_qualite.sh). 

**ETAPE 3 : amélioration de la qualité des données**
Les résultats de fastqc montre une bonne qualité globale de séquences. Cependant, pour l'ameliorer d'avantage on utilise [trimmomatic.sh](trimmomatic.sh)
Suite à cela, l'étape 2 est réalisée de nouveau afin de re-vérifier la qualité de nos reads. L'image ci-dessous montre une amélioration entre l'étape pré et post trimomatic.


**ETAPE 4 : extraction des données de références**
Suite à cela, on réalise un alignement entre les séquences obtenues et une séquence de référence de mus_musculus prise sur [https://www.ensembl.org/] 
L'extraction de ces données de référence se fait en créant un index. Ce dernier correspond à un codage des séquences de référence en un code compacté (pour notre part un code à 31 lettres). La création de cet index se fait via la commande suivante : 
```
salmon index -t Mus_musculus.GRCm38.cdna.all.fa -i mouse_index -k 31
```
**ETAPE 5 : Mapping des séquences nettoyée**
Suite à cela, on réalise un mapping de nos séquences sur l'indexe obtenu. Voir [mapping.sh](salmon_mapping.sh)


