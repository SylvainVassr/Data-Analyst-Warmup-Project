# Réalisation d'une ACP

## Qu'est ce que c'est ? 

L'Analyse en Composantes Principales (ACP) est une méthode statistique de **réduction de dimensionnalité** qui transforme des variables corrélées en un ensemble de variables indépendantes appelées composantes principales.

Son objectif global est de simplifier les données tout en conservant le maximum d'information, facilitant ainsi leur analyse et leur visualisation. 
  
## Quand faire une ACP ?

L’ACP est particulièrement utile lorsque **le nombre de variables quantitatives dépasse un certain seuil** où leur analyse devient difficile, **généralement à partir de 5-10 variables**, mais <u>cela dépend de la corrélation entre elles et de l’objectif d’analyse</u>.

## Comment fonctionne une ACP ? 

L’ACP transforme les variables initiales en un nouvel ensemble de variables appelées **composantes principales**, chacune correspondant à une combinaison linéaire des variables d’origine — autrement dit, chaque composante est construite à partir d’un mélange pondéré des variables de départ, avec des coefficients qui reflètent leur importance.

Ces composantes sont triées par ordre de **variance expliquée** (c’est-à-dire la quantité d’information conservée) : la première composante (PC1) explique le maximum de variance, suivie par la deuxième (PC2), puis la troisième (PC3), etc.



En pratique, on cherche à conserver un nombre de composantes suffisant pour expliquer une part importante de la variance totale. Il n’existe pas de seuil universel, mais voici quelques repères fréquemment utilisés selon le contexte :

| % de variance expliquée | Usage courant                                                             |
| ----------------------- | ------------------------------------------------------------------------- |
| **70 %**                | Minimum acceptable pour des visualisations ou une exploration rapide      |
| **80–90 %**             | Bon compromis entre simplification et fidélité aux données                |
| **> 95 %**              | Rarement nécessaire ; peu utile si l’objectif est de réduire la dimension |

> **⚠️ Avant de lancer une ACP, il est essentiel de centrer et réduire les variables. Sans cette étape, les résultats seront biaisés car les variables avec des échelles plus grandes domineront la variance. La standardisation garantit que toutes les variables contribuent équitablement à l’analyse et que l’ACP reflète correctement la structure des données. Ne jamais l’oublier, c’est la première étape indispensable !**


💡 Une bonne pratique consiste à lancer une ACP sur l’ensemble des données dès le départ, puis à observer le **Scree plot** pour déterminer à partir de **combien de composantes principales on dépasse le seuil de variance expliquée que l’on s’est fixé** (par exemple 80 % ou 90 %). Cela permet de choisir objectivement le nombre de dimensions à conserver pour la suite de l’analyse.

Une fois le nombre de composantes principales retenues, l’ACP fournit une matrice de **loadings**, qui contient les **coefficients associés à chaque variable pour chaque composante**. Ces coefficients indiquent dans **quelle direction chaque variable "pèse"** dans la création de chaque axe.
> **Autrement dit, chaque composante principale (PC1, PC2, etc.) est une sorte de nouvelle variable construite à partir d’un mélange pondéré des variables d’origine.**

Les loadings permettent donc d’interpréter ce que représente chaque composante, en identifiant quelles variables y contribuent fortement (positivement ou négativement).
**Il est d'ailleurs recommandé de nommer nos composantes afin de faciliter leur interprétation et leur communication, en reflétant les variables qui y contribuent le plus.**

Le cercle des corrélations permet d’interpréter l’influence des variables sur les composantes principales. Chaque variable est représentée par un vecteur dont la direction et la longueur indiquent sa contribution à PC1 (axe X) et PC2 (axe Y). En général, on se limite aux deux premières composantes principales (PC1 et PC2), car elles expliquent la majorité de la variance. Cette approche simplifie la visualisation et rend l’interprétation plus claire, tandis que l’ajout de composantes supplémentaires complique inutilement le graphique.

Quelques interprétations possibles :

- **Proximité d’un axe** : Plus un vecteur est proche d’un axe (PC1, PC2), plus la variable est liée à cette composante.
- **Angle de 90°** : Si deux variables sont à 90°, elles sont non corrélées.
- **Angle aigu** : Un petit angle indique une forte corrélation positive : les deux variables évoluent dans le même sens.
- **Angle proche de 180°** : Un angle proche de 180° signifie une corrélation négative : l’augmentation de l’une entraîne la diminution de l’autre.

Après avoir réalisé le **scree plot** et le **cercle des corrélations**, qui sont les graphiques de base pour comprendre la structure globale de l’ACP, la **projection des individus** constitue une étape clé pour approfondir l’analyse des résultats. Cette projection permet de visualiser la position des observations dans l’espace défini par les composantes principales.

Même si l’ACP peut produire plus de 4 ou 5 composantes, on se concentre généralement sur les **deux à quatre premières**, car ce sont celles qui expliquent la majorité de la variance, souvent au-dessus de **10 %**. Les composantes avec une faible variance expliquée sont plutôt analysées via des indicateurs numériques, comme les **contributions** ou **corrélations des variables**, plutôt que par une visualisation graphique.

Chaque composante principale correspond à une **dimension**, et il est difficile de représenter graphiquement plus de **trois dimensions** simultanément. Par conséquent, il est courant de produire plusieurs graphes en 3D, par exemple **PC1-PC2-PC3**, puis **PC1-PC2-PC4**, en sélectionnant les composantes les plus pertinentes à chaque fois.

Ces projections visent à mettre en évidence la **structure des données** : regroupements d’individus similaires, observations atypiques, tendances ou différences entre groupes. Les graphiques peuvent se présenter sous forme de **nuages de points**, souvent colorés selon des catégories, ou avec des éléments comme des **ellipses de confiance** pour faciliter l’interprétation. Parfois, des graphiques **interactifs** sont utilisés pour explorer plusieurs dimensions plus facilement.

L’objectif final est de mieux comprendre la **distribution des individus** dans l’espace des composantes principales et d’en tirer des **conclusions pertinentes** pour l’analyse.

Bien que les trois graphiques classiques — scree plot, cercle des corrélations et projection des individus — couvrent généralement l’essentiel de l’analyse en ACP, il est aussi possible d’explorer d’autres représentations, comme les **biplots** (qui combinent variables et individus) ou les **graphes des contributions des variables** (pour identifier précisément leur influence), afin d’approfondir l’interprétation des résultats et mieux visualiser les relations entre variables et observations.


## Mise en pratique
### <u>A. Préparation des données</u>
Afin d’obtenir des résultats fiables, il est d’abord nécessaire de nettoyer les données : cela inclut la suppression ou le traitement des valeurs manquantes (NaN) ainsi que la gestion des valeurs aberrantes (outliers), qui peuvent fortement influencer l’analyse.

Ensuite, il est important de ne conserver que les variables quantitatives, l’ACP ne s’appliquant pas aux données qualitatives.

Enfin, il faut standardiser les variables (centrer-réduire), afin qu’elles soient toutes sur la même échelle et que l’ACP ne soit pas biaisée par des différences d’unités ou de grandeurs.

### <u>B. Application de l'ACP</u>

Nous commencons par déterminer le nombres de PC pour notre analyse.

![Image du Screeplot](screeplot.png)

Nous aurons donc 6 PC ! Voici le pourcentage de variance expliquée par chaque groupe en détail :

![Image des %variance_expliquee](variance_expliquee.png)

Nous pouvons donc avoir notre matrice des **Loadings** avec nos coefficient directeur :

![Image des %variance_expliquee](loadings.png)

Pour mieux interpréter chaque composante principale, nous attribuons un nom reflétant les variables qui y contribuent le plus fortement, en nous basant sur les scores (loadings) obtenus lors de l’ACP. Cela permet de synthétiser l’information et de faciliter la compréhension des relations entre variables.

- PC1 → Concentration Acide
- PC2 → Concentration en SO₂
- PC3 → Équilibre alcool-soufre
- PC4 → Charge minérale
- PC5 → Intensité sucrée


![Image du cercle des correlations](correlation_circle.png)

Nommer les composantes

- PC1 → Concentration Acide
- PC2 → Concentration en SO₂
- PC3 → Équilibre alcool-soufre
- PC4 → Charge minérale
- PC5 → Intensité sucrée

Faire la projection


### <u>C. Analyse des résultats</u>

Faire une courte analyse

Ouvrir sur d'autres graphiques possibles

Faire un bian de l'ACP
