[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)  

TP NGS Single Cell Incisor 
==========================

**OBJECTIF:**


Le tissu dentaire des rongeurs est caractérisé par la présence d'une paire d'incisive à croissance continue. Bien que cette caractéristique a longtemps été décrite, peu d'études se sont interessées aux populations cellulaires responsables de ce phénomene. Cette étude vise à réaliser un atlas qui englobe l'hétérogénité cellulaires des incisives de souris. Cette charactérisation se base sur les différénces d'expression des gènes au sein des populations cellulaires. In fine cette étude contribura à la charactérisation des cellules souches dentaires ce qui permetra une envetuelle application médicale afin de remplacer le dentition humaine. 

**VUE GENERALE DES ETAPES:**

Les cellules contenues dans les incisives de souris sont extraites puis les ARNm sont isolés et séquencés par la méthode SMART-SEQ2 (cf. [reference](https://www.nature.com/articles/s41467-020-18512-7#citeas)). Suite à cela nous suivons les étapes résumées dans le flowchart ci-dessous (fait par Melie Talaron). 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Work%20flow.png)


**ETAPE 1 : récupération des donnés cellulaires**

Les données cellulaires sont récupérées  à partir de la basse de données   [Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA609340&f=organism_s%3An%3Amus%2520musculus%3Bphenotype_sam_ss%3An%3Ahealthy%3Bplatform_sam_s%3An%3Asmart-seq2%3Bsource_name_sam_ss%3An%3Aincisor%3Ac&o=acc_s%3Aa) suite à l'application du filtre : Mus musculus specie, healthy, Smart-Seq, incisor. Ceci permet d'obtenir 2555 cellules. Les données récupérées sont en format .txt file. 
Suite à cela on réalise un `fastq-dump` afin de convertir les fichiers obtenus en format fastq. Voir [fastq_dump.sh v.2.10.0](fastq_dump.sh)

**ETAPE 2 : contrôle qualité**

Lors du séquençage à haut débit par la méthode SMART-SEQ2, différentes erreurs/contaminations peuvent survenir. De ce fait, il est nécessaire de réaliser un contrôle qualité grâce à la fonction [fast_qc v.0.11.8](Test_qualite.sh). 

**ETAPE 3 : amélioration de la qualité des données**

Les résultats de `fastqc` montre une bonne qualité globale de séquences. Cependant, pour l'ameliorer d'avantage on utilise [trimmomatic v.0.39](trimmomatic.sh)
Suite à cela, l'étape 2 est réalisée de nouveau afin de re-vérifier la qualité de nos reads. L'image ci-dessous montre une amélioration entre l'étape pré et post trimmomatic.
Pour une cellule selectionnée aléatoirement, le nombre de séquence passe de 536542 à 517896 après nettoyage (figure non insérée). On note aussi une amélioration de la qualité des paires de bases (voir figure ci-dessous). 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Avant_Apr%C3%A8s_nettoyage.png)



**ETAPE 4 : extraction des données de références et mapping des séquences nettoyées**

Suite à cela, on réalise un alignement entre les séquences obtenues et une séquence de référence de mus_musculus prise sur [https://www.ensembl.org/] 
L'extraction de ces données de référence se fait en créant un index. Ce dernier correspond à un codage des séquences de référence en un code compacté (pour notre part un code à 31 lettres). La création de cet index se fait via la commande suivante [Salmon v0.14.1](alignement.sh)
Le mapping de nos séquences  est ensuite réalisé sur l'indexe obtenu. Voir [mapping.sh](salmon_mapping.sh)

**Les commandes des étapes suivantes sont regroupées dans le [R_Script](R_script.Rmd)**

**ETAPE 5 : génération de la matrice de comptage**

Afin d'importer les transcrits, nous utilisons la commande tximport en veillant à modifier la commande {r tximport eval=T echo=T} en {r tximport eval=F echo=T}. 

**ETAPE 6 : séléction des cellules de bonne qualité**

La "qualité" d'une cellule peut être appreciée par : le nombre de gène qu'elle exprime, la quantité de transcrit ainsi que le pourcentage d'ADN mitochondrial. Afin de sélectionner uniquement les cellules en bon état, nous nous basons sur les résultats de plot obtenus sur nos données brutes nettoyées et nous decidons d'appliquer le filtre suivisant : élimination des  cellules exprimant moins de 5% du quartile inférieur. dont le nombre d'ARNs exprimés dépasse 1.000.000. et dont le pourcentage d'ADN mitochondrial dépasse 15%. Suite à cela le plot ci-dessous est obtenu. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/CELLULES%20APRES%20FILTRES.png)

**ETAPE 7 : identification des gènes variables**

Nous réalisons une étape préalable de normalisation de  transcrits cellulaires par rapport aux trancrits totaux en utilisant la commande `normlization` (résultat obtenu en échelle logarithmique). Afin d'identifier les 10 gènes les plus exprimés, la commande `identify_variable_features` est utilisée et les résultats peuvent être visualisés en forme de plot grâce à la commande `plot_variable_genes`. 

**ETAPE 8 : réduction de dimension**

Afin de réaliser une réduction de dimension, une étape de transformation linéaire de "scaling" doit étre préalablement effectuée en utilisant la commande `ScaleData`.  Suite à cela une PCA  (Principal Component Analysis) est réalisée grâce à la commande `dimensional_reduction`. Cette méthode permet d'obtenir 15 axes différents ce qui nous permet de visualiser les axes qui expliquent le mieux la variabilité d'expression des génes. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Axe%20les%20plus%20differents.png)

Nous pouvons voir que l'axe 1 explique le plus la variabilité génétique puis cette variabilité diminue en fonction des axes pour s'affaisser à l'axe 20.

**ETAPE 9 : clusterisation des populations cellulaires**

Afin de regrouper les populations cellulaires en cluster, la commande `UMAP` est utilisée, celle-ci correspond à une méthode de réduction de dimension non linéaire. Notez que la fonction "reduction de dimension" incluse dans UMAP est ici non nécessaire étant donné la réduction de dimension réalisée précédemment. 
Cette clusterisation se base sur le méthode des k plus proches voisins. 

**ETAPE 10 : annotation des clusters**

Afin de relier chaque cluster à une population cellulaire détérminée, il est essentiel d'identifier les gènes spécifiques à chaque cluster en comparaison aux autres clusters. Pour ce faire, la commande `FindMarkers` est utilisée. Nous décidons d'afficher 5 marqueurs par cluster, ceci reste insuffisant pour définir une population cellulaire correspondant à chaque cluster. Dans l'idéal 100 marqueurs doivent être définis. Après avoir défini les marqueurs caractérisant chaque cluster, les produits de gènes sont correspondant sont obtenus  grâce à [Uniprot](Uniprot.org) ce qui nous permet de déduire la population cellulaire qui correspond à chaque cluster. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Clusters%20annot%C3%A9s.png)
Pour les clusters 5 et 14, nos analyses suggèrent qu'il s'agit de la même population cellulaire, ce qui semble contradictoire avec leur positionnement sur la carte UMAP. Pour savoir ce qui différencie les deux clusters, il est possible d'appliquer la commande `find all markers` en distinguant spécifiquement le cluster 5 du clusters 14. 
Le cluster 11 quant à lui n'a pas pu être identifié. Dans de telle situation, il est nécessaire d'effectuer des expérimentations supplémentaires tel que l'immunomarquage ou une fusion transcriptionnelle/traductionnelle afin de mieux identifier dans quelle population cellulaire se trouve les transcrits d'intérêt. Il est aussi possible d'avoir recours à l'ontologie génomique. 
Suite à cela la réalisation de la vélocité de l’ARN a permis de déterminer les gènes impliqués dans la régénération cellulaire (Sfrp2, Lef1, Fzd1, Sfrp1, Rspo1, Trabd2b, Gli1, and Wif1). Ces gènes sont le plus exprimés au niveau de la pulpe des incisives ce qui suggére que cette dernière est la niche des cellules souches dentaires (cf. [reference](https://www.nature.com/articles/s41467-020-18512-7#citeas)). 





