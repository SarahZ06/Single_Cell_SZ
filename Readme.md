[![forthebadge](http://forthebadge.com/images/badges/built-with-love.svg)](http://forthebadge.com)  

TP NGS Single Cell Incisor 
==========================

**OBJECTIF:**


Le tissu dentaire des rongeurs est caractérisé par la présence d'une paire d'incisive à croissance continue. Bien que cette caractéristique a longtemps été décrite, peu d'études se sont interessées à la population cellulaire responsable de ce phénomene. Cette étude vise à réaliser un atlas qui englobe l'hétérogénité cellulaires des incisives de souris. Cette charactérisation se base sur les différénces d'expression des gènes au sein des population cellulaire. In fine cette étude contribura à la charactérisation des cellules souches dentaires ce qui permetra une envetuelle application médicale afin de remplacer le dentition humaine. 

**VUE GENERALE DES MANIPULATIONS:**
Les cellules contenues dans les incisives de souris sont extraites puis les ARNm sont isolés et séquencés par la méthode de SMART-SEQ2. Suite à cela nous suivons les étapes résumées dans le flowchart ci-dessous. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Work%20flow.png)


**ETAPE 1 : récupération des donnés cellulaires**
Les données cellulaires sont récupérées  à partir de la basse de données   [Run Selector](https://www.ncbi.nlm.nih.gov/Traces/study/?acc=PRJNA609340&f=organism_s%3An%3Amus%2520musculus%3Bphenotype_sam_ss%3An%3Ahealthy%3Bplatform_sam_s%3An%3Asmart-seq2%3Bsource_name_sam_ss%3An%3Aincisor%3Ac&o=acc_s%3Aa) suite à l'application du filtre : Mus musculus specie, healthy, Smart-Seq, incisor. Ceci permet d'obtenir 2555 cellules. Les données récupérées sont en format .txt file. 
Suite à cela on réalise un `fastq-dump` afin de convertir les fichiers obtenus en format fastq. Voir [fastq_dump.sh v.2.10.0](fastq_dump.sh)

**ETAPE 2 : control qualité**
Lors du séquençage à haut débit par la méthode SMART-SEQ2, différents défauts de qualité peuvent survenir. De ce fait, il est nécessaire de réaliser un controle qualité grâce à la fonction [fast_qc v.0.11.8](Test_qualite.sh). 

**ETAPE 3 : amélioration de la qualité des données**
Les résultats de fastqc montre une bonne qualité globale de séquences. Cependant, pour l'ameliorer d'avantage on utilise [trimmomatic v.0.39](trimmomatic.sh)
Suite à cela, l'étape 2 est réalisée de nouveau afin de re-vérifier la qualité de nos reads. L'image ci-dessous montre une amélioration entre l'étape pré et post trimomatic.
Pour une cellule donnée selectionnée aléatoirement, le nombre de séquence passe de 536542 à 517896 après nettoyage (figure non insérée). On note aussi une amélioration de la qualité des paires de bases. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Avant_Apr%C3%A8s_nettoyage.png)



**ETAPE 4 : extraction des données de références et mapping des séquences nettoyées**
Suite à cela, on réalise un alignement entre les séquences obtenues et une séquence de référence de mus_musculus prise sur [https://www.ensembl.org/] 
L'extraction de ces données de référence se fait en créant un index. Ce dernier correspond à un codage des séquences de référence en un code compacté (pour notre part un code à 31 lettres). La création de cet index se fait via la commande suivante [Salmon v0.14.1](alignement.sh)

Suite à cela, on réalise un mapping de nos séquences sur l'indexe obtenu. Voir [mapping.sh](salmon_mapping.sh)

**ETAPE 5 : Générationde la matrice de comptage**
Afin d'importer les transcrits, nous utilisons la commande tximport en veillant à modifier la commande {r tximport eval=T echo=T} en {r tximport eval=F echo=T}. 

**ETAPE 6 : Séléction des cellules de bonne qualité**
La "qualité" d'une cellule peut être appreciée par le nombre de gène qu'elle exprime, la quantité de transcrit ainsi que le pourcentage d'ADN mitochondrial. Afin de sélectionner uniquement les cellules en bon état, nous nous basons sur les résultats de plot obtenus sur nos données bruts nettoyés et nous decidons d'appliquer le filtre suivisant :
Elimination des  cellules exprimant moins de 5% du quartile inférieur. dont le nombre d'ARNs exprimés dépasse 1.000.000. Dont le pourcentage d'ADN mitochondrial dépasse 15%. Suite à cela le plot de droite est obtenu. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/CELLULES%20APRES%20FILTRES.png)
**ETAPE 7 : Identification des gènes variables **
 Tout d'abord une normalisation des transcrits obtenus par rapport aux trancrits totaux est réalisée grâce à la commande "normlization" (résultat obtenu en échelle logarithmique). Afin d'identifier les 10 gènes les plus exprimés, la commande "identify_variable_features" est utilisée et les résultats peuvent être visualisés en forme de plot grâce à la commande "plot_variable_genes". rajouter  truc de 20000 ?? 
**ETAPE 8 : réduction de dimension **
Afin de réaliser une réduction de dimension, un scaling doit être réalisé.  Suite à cela une PCA  (Principal Component Analysis) est réalisée grâce à la commande "dimensional_reduction". Cette méthode permet d'obtenir 15 dimensions différente ce qui nous permet de visualiser quelle dimension expliquent le mieux la variabilité d'expression des génes. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Axe%20les%20plus%20differents.png)
Nous pouvons voir que la dimension 1 explique le plus la variabilité génétique puis cette variabilité en fonction des axes et s'affaisse à l'axe 20. 
**ETAPE 8 : Clusterisation des populations cellulaires  **

Afin de regrouper les populations cellulaires en cluster, la commande UMAP est utilisée, celle-ci correspond à une méthode de réduction de dimension non linéaire Non-linear. Notez que la fonction "reduction de dimension" incluse dans UMAP est, ici non nécessaire étant donné la réduction de dimension réalisée précedement. 
Cette clusterisation se base sur le méthode des k plus proches voisins. 
**ETAPE 9 : Anotation des clusters  **
Afin de relier chaque cluster à une population cellulaire détérminée, il est essentiel d'identifier les gènes spécifique à chaque cluster en comparaison aux autres cluster. Pour ce faire, la commande FindMarkers est utilisée. Nous decidons d'afficher 5 marqueurs par cluster, ceci reste peu pour correctement définir une population cellulaire correspondant à chaque cluster, dans l'idéal 100 marqueurs doivent être définis. 
![](https://github.com/SarahZ06/Single_Cell_SZ/blob/master/Images/Clusters%20annot%C3%A9s.png)
Pour les clusters 5 et 14, nos analyses suggère qu'il s'agit de la même population cellulaire, ce qui semble contradictoire avec leur positionnement différent sur la carte UMAP. Pour savoir ce qui différencie les deux clusters, il est possible d'appliquer la commande ..... 



