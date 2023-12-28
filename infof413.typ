
#import "@preview/ctheorems:1.1.0": *
#import "@preview/cetz:0.1.2"
#show: thmrules
#set heading(numbering: "1.")
#set footnote(numbering: ("i"))
#set footnote.entry(indent: 0em, gap: 0.7em)

#set page(
  margin: 2cm,
  header: [
    #set text(10pt, weight: 100)
    Attilio Discepoli
    #h(1fr) #smallcaps("INFO-F413 - Data Structures and Algorithms")
    #v(-7pt)
    #line(length: 100%, stroke: 0.2pt)
  ],
  number-align: right
)

#set par(
  justify: true,
)

#align(center, 
  text(smallcaps[Notes de cours], 1.8em, weight: 900) 
  + linebreak() 
  + v(1pt) 
  + text("24 Décembre 2023", 1.1em)
  )


#let theorem = thmplain(
  "theorem",
  "Théorème",
  titlefmt: strong,
  fill: rgb("#caf0f8"),
  width: 100%,
  inset: 1.2em,
  radius: 0.3em
)

#let proposition = thmplain(
  "proposition",
  "Proposition",
  titlefmt: strong,
  fill: rgb("#d8f3dc"),
  width: 100%,
  inset: 1.2em,
  radius: 0.3em
)

#let definition = thmplain(
  "definition",
  "Définition",
  titlefmt: strong,
  fill: rgb("#ffe1aaaa"),
  width: 100%,
  inset: 1.2em,
  radius: 0.3em
)

#outline(
  title: "Table des matières",
  target: heading.where(level: 1)
)

= Algorithmes de Monte-Carlo
#v(5pt)
#definition[Un algorithme de Monte-Carlo est un algorithme randomisé dont le *temps d'exécution* est *déterministe* mais le résultat peut être incorrect avec une certaine probabilité $p$ (généralement petite)] 
$arrow.r$ Pas de surprise sur la durée du calcul\ $arrow.r$ Peut-être faux mais c'est très rare\ $arrow.r$ Nous donne des algos rapides avec une faible probabilité d'échec

== Biais
Un algorithme randomisé (eg: Monte-Carlo, Las-Vegas) peut être érroné - il répond `OUI` alors que la réponse aurait dut être `NON` - ce qui n'est pas le cas des algorithmes déterministes. Un algorithme de Monte-Carlo peut toujours renvoyer une réponse exacte si il a un *biais*.\

Un algorithme biaisé vers le faux est toujours correct lorqu'il retourne `FAUX`.\
Un algorithme biaisé vers le vrai est toujours correct lorqu'il retourne `VRAI`.

#definition[Un algorithme est _one-side error_ lorsqu'il est soit baisé vers le faux, soit biaisé vers le vrai]
#definition[Un algorithme est _two-side error_ lorsqu'il est baisé vers le vrai et le faux]

== Classes de Complexités
À l'instar des algorithmes déterministes et des classes de complexités $P$ et $N P$, les algortihmes randomisés ont égalements leurs classes de complexités. 

=== BPP
_Bounded-Error Probabilistic polynomial time_ $arrow.r$ Le problème est résolvable en $"TIME"(P)$ avec un algorithme de Monte-Carlo non biaisé.\
Le théorème d'Adelman énonce que _BPP_ est inclus dans _P/poly_

== RP
_Randomized Polynomial Time_ $arrow.r$ résolvable en $"TIME"(P)$ avec une probabilitée bornée par un algorithme de Monte-Carlo biaisé.

== ZPP
_Zero-Error Probabilistic Polynomial Time_ $arrow.r$ résolvable en $"TIME"(P)$ avec un algorithme de Las-Vegas.

_ZPP_ $eq$ _RP_ $sect$ _coRP_

== PP
_Polynomial Probabilistic_ $arrow.r$ décidable en temps polynomial avec une probabilité d'erreur inférieure à 1/2.


== Algorithme de Las-Vegas
#v(5pt)
#definition[Un algorithme de Las-Vegas est un algorithme randomisé dont l'exécution est *déterministe* mais le temps d'exécution est non-prévisible. Il s'arrête lorsqu'il trouve une réponse exacte]

= Arbres de jeux et principe de Yao
Vision "théorie des jeux" des algorithmes randomisés. Cela permet de visualiser des algorithmes probabilistes comme une distribution de probabilités sur des algorithmes déterministes.\
Le *principe de Yao* permet d'établir une borne inférieure sur les performances d'un algorithme randomisé.

== Arbre min-max
Forme la plus basique des algorithmes d'intelligence artificielle permettant de représenter un jeu entre deux joueurs#footnote[On associe à chaque noeud un ensemble d'enfants représentant les options possible pour un des deux joueur].
Arbre où chaque valeur est binaire (l'input étant stocké dans les feuilles). Chaque noeud de l'arbre est soit un _min_ ($and$ booléen) soit un _max_ ($or$ booléen).\
Si le jeu n'était pas binaire, le concept serait le même, chaque feuilles contient une valeur numéraire. Les noeuds à distance paires du sommet serait nommées MAX et les noeuds à une distance impaires MIN. L'évaluation de l'arbre suivrait dont le processus suivant: chaque noeud MAX retourne la valeur maximum parmis ses enfants et chaque noeud MIN la valeur minimum. Le but final étant - pour une certaine entrée - de donner la valeur de la racine.\
On note $T_k$ l'arbre de jeu de hauteur $2k$. La racine est un noeud $and$, il y a donc exactement k noeuds $and$ et k noeuds $or$. L'arbre $T_k$ possède dont $2^2k eq 4^k$ feuilles.\
Évaluer un tel arbre nécessiterait donc, pour un algorithme déterministe, d'évaluer les $4^k$ noeuds. Cela dit, avec un algorithme probabiliste on peut augmenter la borne inférieure. Un exemple de tel algorithme est le suivant:\
On commence par la racine et on évalue récursivement un des deux enfants du noeud courant. Si le noeud courant est un $and$ et que le résultat de l'analyse d'un de ces enfants est $0$, il n'est pas nécessaire d'évaluer l'autre enfant. Selon le même principe, si le noeud courant est un $or$ et qu'un des appel récursif retourne un $1$ il n'est pas nécessaire d'évaluer l'autre enfant. Dans tous les autres cas, il est nécessaire de vérifier les deux enfants pour s'assurer que tout boume.

#theorem[Soit n'importe quelle instance d'un arbre de jeu binaire $T_(2,k)$, le nombre attendu d'étapes pour la stratégie d'évaluation randomisée est au plus $3^k$]
Preuve:
On a 4 cas différents:
- Le noeud courant est un $or$:
  - Retourne 0: On a donc besoin de 2 appels récursifs, ce qui coûte $ 2 times 3^(k-1) $ lectures attendus.
  - Retourne 1: On a, avec une probabilité d'$1/2$, seulement un enfant à évaluer.
$ underbrace(1/2 times 2 times 3^(k-1), "Retourne 0") + underbrace(1/2 times 3^(k-1), "Retourne 1") eq 3/2 times 3^(k-1) $
- Le noeud courant est un $and$:
  - Retourne 0: Alors ses deux enfants retourne soit 0, avec une probabilité $ 2 times 3^(k-1) $; soit qu'un seul des deux retourne 0, avec une probabilité $ 1/2 times 2 times 3^(k-1) + 1/2 times (3/2 times 3^(k-1) + 2 times 3^(k-1)) eq 11/4 times 3 ^(k-1) $
  - Retourne 1: Alors ses deux enfants doivent retourner 1, il est nécessaire de regarder les deux enfants. $ 2 times underbrace(3/2 times 3^(k-1), "Coût de vérification d'un noeud " or) eq 3^k $
Dans tous les cas, on remarque que le nombre attendu d'opération pour évaluer le $and$ racine ne dépasse pas $3^k$. 
#align(right, v(-20pt) + square(width: 7pt, stroke: 0.5pt))

== Théorie des jeux

Un jeu à somme nulle pour deux joueurs est un jeu pouvant être représenté par $M$, une matrice de gain $n times m$ dont les entrées sont encodées par paires de stratégies, une pour chaque joueur. $M_(i j)$ est la quantité payée par le joueur $C$ (colone) au joueur $L$ (ligne) lorsque $L$ choisi la stratégie $i$ et $C$ la stratégie $j$.

== Stratégies mixtes

Dans le cas des stratégies mixtes, la matrice $M$ ne contient plus les gains mais une distribution de probabilité sur l'ensemble des stratégies. Le gain attendu pour un paire de stratégie $p, q$ est : $ E["payoff"] = p^T M q eq sum_(i=1)^(n)sum_(j=1)^(m) p_i M_(i j) q_j $

== Théorème de Minmax
#theorem[$ op("max", limits: #true)_(p)op("min", limits: #true)_(q)p^T M q eq op("min", limits: #true)_(q)op("max", limits: #true)_(p) p^T M q $] <minmaxthm>
Il s'agit d'un principe fondamental de théorie des jeux.\
Si l'on dénote $V_L$ la meilleure borne inférieure sur le gain attendu par le joueur ligne en choisissant une stratégie mixte $p$, et par $V_C$ la meilleure borne supérieure sur le gain payé par le joueur colonne pour une stratégie mixte $q$.\
$ V_R  = op("max", limits: #true)_(p)op("min", limits: #true)_(q)p^T M q $
$ V_C  = op("min", limits: #true)_(q)op("max", limits: #true)_(p)p^T M q $
Par le @minmaxthm, nous savons que $V_R eq V_C$.

== Principe de Yao

Soit un problème computationnel $sect.sq$, on considère une collection finie $cal(A)$ d'algorithmes et un ensemble $cal(I)$ d'entrées, tel que tous les algos dans $cal(A)$ exécutent correctement le probleme $sect.sq$ sur toutes les entrées dans $cal(I)$.\
On écrit $C(I, A)$ le temps d'exécution d'un algorithme $A in cal(A)$ sur l'entrée $I in cal(I)$.\ \
Cela défini un jeu à somme nulle entre deux joueur: un designer d'algorithme et une entrée adverse#footnote[Voir ça comme de vrais adversaires, non pas qu'ils soient méchants entre elleux, mais plus qu'iels veulent remporter ! Il n'est pas question de laisser à l'autre adversaire remporter la partie.\ La théorie des jeux, c'est comme un Monopoly avec la famille, si il faut que ça se finisse dans les larmes et le sang ça se fera.]. L'ensemble $cal(A)$ peut-être vu comme un ensemble de stratégies pour le designer d'algorithme, une stratégie mixte peut alors être vue comme un algorithme randomisé. Dans le cas de l'ensemble $cal(I)$, une stratégie mixte peut être vue comme une distribution sur les entrées possibles. 
\ \
En appliquant le @minmaxthm on remarque que le temps d'exécution attendu pour un algorithme déterministe optimal sur une entrée choisie arbitrairement sur une distribution $p$ est une borne inférieure sur le temps d'exécution de n'importe quel algorithme randomisé exact (Las-Vegas) pour $sect.sq$.
#theorem[Pour toutes les distributions $p$ sur $cal(I)$ et $q$ sur $cal(A)$, nous avons $ op("min", limits: #true)_(A in cal(A)) E[C(I_p, A)] <= op("max", limits: #true)_(I in cal(I)) E[C(I, A_q)] $]
Donc d'une part, nous avons $C(I_p, A)$ le temps d'exécution attendu pour le meilleur algorithme déterministe#footnote[Étant donné que l'algorithme est choisi par l'adversaire, il va clairement pas nous faire de cadeau en nous en donnant un pas top. Non, il prend le meilleur.] sur une entrée choisie aléatoirement. De l'autre côté, nous avons $C(I, A_q)$ le temps d'exécution d'un algorithme randomisé sur la pire entrée possible#footnote[Car choisie par l'adversaire, on oublie pas qu'il est pas là pour nous aider.].\
Donc, pour prouver une borne inférieure sur la complexité d'un algorithme randomisé, il suffit de choisir n'importe quelle distribution d'entrée $p$ et de prouver une borne inférieure sur le temps d'exécution attendu des algorithmes déterministes pour cette distribution $p$.\
La force de cette technique est dans la flexibilité du choix de $p$ et dans la réduction à une borne inférieure des algorithmes déterministes.\
*Attention*, cela donne une borne inférieure sur les performances des algorithmes de Las-Vegas uniquement ! (C'est-à-dire ceux retournant une réponse exacte à tous les coups)

== Principe de Yao pour les évaluation d'arbre de jeux
Si l'on reprend notre arbre de jeu #smallcaps[and-or] et son problème d'évaluation. Un algorithme randomisé peut-être vu comme une distribution de probabilité sur des algorithmes déterministes (car la longueur des calculs aussi bien que de nombre de choix à chaque étape sont toutes deux finies).\
Imaginons un arbre de jeu $T_k$ dont les feuilles se trouvent à une distance $2k$ de la racine, et dont tous les noeuds internes sont des #smallcaps[nor]: Un noeud retourne un $1$ uniquement si les deux entrées (enfants) sont à 0, sinon il retourne 0. L'analyse de cet arbre de #smallcaps[nors] de hauteur $2k$ est la suivante:\
Notons $p = (3- sqrt(5))/2$, chaque feuille de l'arbre contient 1 avec un probabilité $p$. Un noeud #smallcaps[nor] retourne donc 1 avec une probabilité : $ ((sqrt(5) - 1)/2)^2 eq (5 + 1 - 2 sqrt(5))/4 eq (6 + 2 sqrt(5))/4 eq (3-sqrt(5))/2 eq p $ 
La valeur de chaque noeud #smallcaps[nor] est donc 1 avec une probabilité $p$ et est indépendante des valeurs de tous les autres noeuds sur le même niveau.\
Considérons maintenant un algorithme déterministe pour évaluer un tel arbre de jeu. Pour commencer, notons $v$ un noeud de l'arbre dont l'algorithme cherche à obtenir la valeur. Il est simple de voir que l'on va d'abord évaluer un premier enfant de $v$ avant d'aller voir l'autre enfant. On peut donc voir cela comme une _depth-first search_ (recherche en profondeur) qui s'arrêterait d'évaluer les sous-arbre de $v$ lorsque $v$ sera évalué. Nous appelons un tel algorithme *depth-first pruning* (élagage en profondeur), en effet, les sous-arbres ne fournissant pas plus d'informations sur l'évaluation (par exemple, si le premier enfant retourne un 1 on sait qu'il est inutile d'aller évaluer l'autre enfant), on élague donc ce sous-arbre de l'évaluation.\
#proposition[Si l'on prend maintenant un arbre #smallcaps[nor] $T$ dont les feuilles sont indépendamment définies à 1 avec une probabilité $q$ pour une valeur fixée $q in [0, 1]$. Notons $W(T)$ le nombre d'étapes minimum (parmis tous les algorithmes déterministes) néxessaires pour évaluer $T$. Il y a donc un algorithme de _depth-first pruning_ dont le nombre d'étapes attendues pour évaluer $T$ est $W(T)$] <pruningeval>
Cette @pruningeval nous dis que, pour les besion de notre borne inférieure, nous pouvons réduire notre attention aux algorithmes _depth-first pruning_. Nous définisons alors $W(h)$ comme étant le nombre attendu de feuilles inspectées par un tel algorihtme d'élagage lorsqu'il évalue un noeud se trouvant à une distance $h$ des feuilles, quand les feuilles sont définies indépendament avec une probabilité $(3-sqrt(5))/2$. Alors le nombre de feuilles lues lors de l'exécution d'un tel algorithme est : $ W(h) = underbrace(W(h-1), "Nombre d'étapes nécessaires"\ "pour évaluer le premier enfant") + underbrace((1-p) times W(h-1), "Nombre d'étapes nécessaires"\ "pour évaluer le second enfant"\ "Cela n'a lieu que si le premier enfant vaut 0"\ "ce qui arrive avec une probabilité " 1-p) $ étant donné que l'on doit effectuer un deuxième appel récursif uniquement si l'évaluation du premier enfant retourne 0, ce qui arrive avec une probabilité $(1-p)$. On peut alors résoudre la récurrence:
#align(left,$ 
W(h) &= W(h-1) + (1-p) times W(h-1)\
&= (2-p) times W(h-1)\
&= (2-p)^h\
&= (2-p)^(log_2n)\
&= n^(log_2(2-p))\
&tilde.eq n^0.694
$)
Sur base du principe de Yao, nous pouvons donc déduire le théorème suivant:
#theorem[Le temps d'exécution attendu our n'importe quel algorithme randomisé évaluant toujours une instance de $T_k$ correctement est au moins $n^0.694$, où $n = 2^2k$ est le nombre de feuilles de $T_k$]

== Exercices d'examens
=== Exercice 2.2
*Remarque préliminaire*: Il s'agit d'une tentative de réponse il se peut qu'elle soit érronée !\
$arrow.r$ On a un arbre d'hauteur $h$\ 
$arrow.r$ Chaque noeud à 3 enfants\
$arrow.r$ Il y a $n = 3^h$ feuilles contenant des valeurs booléennes\ 
$arrow.r$ Chaque noeud retourne la valeur majoritaire parmis ses enfants (valeur booléenne donc)\

1. Étant donné que l'on a 3 enfants et que les valeurs sont booléennes (0 ou 1), on sait qu'il ne peut y avoir d'égalité parmis la majorité (car nombre impair d'enfants). L'algorithme d'évaluation peut donc être défini comme suit: Pour évaluer un noeud $v$, on prend 2 de ses enfants aléatoirement et on les compare, si ils sont identiques c'est super, on a trouvé la majorité, $v$ est donc évalué à la valeur des deux enfants sélectionnés, il n'est plus nécessaire d'évaluer le troisième étant donné qu'il n'impactera pas la majorité (qu'il soit identique ou différent). Si la valeur des deux enfants est différente, on va alors évaluer le troisième pour trancher sur la majorité (et les trois enfants sont donc évalués).\ Il est facile de remarquer qu'il n'y a que deux cas possibles:
  - Les enfants sont 3 $b$#footnote[$b$ est une valeur booléenne, on se moque de laquelle.]: la majorité est obtenue lorsqu'on évalue 2 enfants. Le nombre d'évaluation est donc de $2$.
  - Les enfants sont 2 $b$ et 1 $not b$: Soit on sélectionne les deux $b$ du premier coup et c'est niquel, soit on sélectionne un $b$ et le $not b$ et dans ce cas là il faut évaluer le dernier enfant pour savoir quelle est la valeur majoritaire. Le nombre d'évaluation est donc de $underbrace(1/3 times 2, "2" b "du premier coup") + underbrace(1/3 times (2+1), "1" b "et 1" not b "puis un" b) = 5/3$ 
  Le pire cas est donc le premier cas $= 2$ donc $T(h) = 2T(h-1) = 2^h$, $n = 3^h => h = log_3n$, $2^(log_3n) =  n^(log_3 2)$
2. On part du principe que chaque feuilles prend la valeur 1 avec une probabilité $p = 1/2$. Notons $W(h)$ le nombre de feuilles lues lorqu'on analyse un noeud se trouvant à une distance $h$ des feuilles. On sait qu'il est nécessaire d'évaluer à minima 2 enfants ($2W(h-1)$) et qu'il y a une probabilité $1/2$ que les deux valeurs soient différentes car:
  - Proba d'avoir 2 valeurs identiques $ast.circle$: $underbrace(1/2 times 1/2, "On a deux 1") + underbrace(1/2 times 1/2, "On a deux 0") = 1/4 + 1/4 = 1/2$
  - Proba d'avoir 2 valeurs différentes : $1-underbrace(1/2, ast.circle) = 1/2$
  On sait alors qu'il est nécessaire d'effectuer $1/2 W(h-1)$ évaluations.

  $
  W(h) &= 2W(h-1) + 1/2 W(h-1)\
  &= 5/2 W(h-1)\
  &= (5/2)^h = (5/2)^(log_3n)\
  &= n^(log_3 5)
  tilde.eq n^1.464
  $

= Inégalités de concentrations
#definition[En probabilité, les *inégalités de concentration* fournissent des bornes sur la probabilité qu'une variable aléatoire dévie d'une certaine valeur (généralement l'espérance de cette variable aléatoire)]
En d'autres termes, ces inégalités nous donnent des bornes sur les variations que peuvent prendre une variable aléatoire. Dans le cas des algorithmes randomisés celles-ci sont intéressantes pour prouver qu'un tel algorithme nous donne une réponse correcte avec une grande probabilité.
== Inégalité de Markov
Il s'agit de l'inégalité la plus simple. On l'utilisera comme base pour d'autres inégalités. Elle utilise l'espérance de la variable aléatoire. 
#definition[Si $X$ est une variable aléatoire et $f(x)$ une fonction réelle. Alors l'*espérance* de $f(x)$ est donnée par $ E[f(X)] = sum_(x in X)f(x)P[X = x] $]
L'inégalité de Markov nous donne la borne la plus serrée possible quand nous savons que $X$ est non-négatif et a une espérance donnée.
#theorem[Si $X$ est une variable aléatoire non-négative et $a>0$ alors $ P[X >= a] <= E[X]/a $]
Et de manière équivalente $ P[X >= k E[X]] <= 1/k $
Preuve: Définissons une fonction $ f(x) = cases(1 "si" x>= a, 0 "sinon") $
Alors $P[X >= a] = E[f(X)]$. Étant donné que $f(x) <= x/a $ pour n'importe quel $x$, on a $ E[f(X)] <= E[X/a] = E[X]/a $
Malheureusement, cette borne est trop faible pour apporter des résultats utiles. Cependant, elle peut être utilisée pour trouver de meilleures bornes sur la probabilité de la queue en utilisant plus d'informations sur la distribution de la variable aléatoire.
== Inégalité de Chebyshev
Cette inégalité est basée sur la conaissance de la variance de la distribution.
#definition[Pour une variable aléatoire $X$ avec une espérance $mu_X$, sa *variance* est définie comme $ sigma^2_X = E[(X-mu_X)^2] $ ]
#definition[L'*écart-type* d'une variable aléatoire $X$, notée $sigma_X$ est la racine carrée positive de la variance de X.]
#theorem[Soit $X$ une variable aléatoire ayant une espérance $mu_X$ et un écart-type $sigma_X$, pour n'importe quel $t in RR^+$, $ P[ |X - mu_X| >= t sigma_X] <= 1/t^2 $]
Preuve: On observe que $ P[ |X - mu_X| >= t sigma_X] = P[(X - mu_X)^2 >= t^2 sigma^2_x] $Définissons une variable aléatoire $Y = (X - mu_X)^2$, son espérance vaut alors $E[Y] = sigma^2_X$, si l'on applique l'inégalité de Markov à cette variable aléatoire avec $a = t^2$, clairement#footnote[Je dis clairement, mais j'avais tellement pas compris la preuve (qui pourtant est super simple) que j'ai passé 1h à la refaire. Oui parfois y'a des trucs débiles sur lesquels on passe une plombe, pour la peine je vais écrire les étapes.]: 
$ &P[Y >= t^2] &<= E[Y]/t^2\ &P[(X-mu)^2 >= t^2] &<= sigma^2/t^2\ &P[(X-mu)^2 >= sigma^2 t^2] &<= 1/t^2 \ &P[(X-mu) >= sigma t] &<= 1/t^2 $

== Borne de Chernoff
Borne sur la queue de la distribution bien plus précises que celles de Markov ou Chebyshev. Ces bornes sont utilisées dans le cas où les variables aléatoires ne peuvent pas être modélisées comme une somme de variables aléatoires indépendantes (par exemple des variables de Bernoulli#footnote[Résultat d'un pile ou face]).
#definition[Soit $X_1, ..., X_n$ des *variables aléatoires indépendantes de Bernoulli* tel que $1 <= i <= n, P[X_i = 1] = p$ et $P[X_i = 0] = (1-p)$. Si l'on défini $X = sum_(i=1)^n X_i$, alors $X$ suit une distribution binomiale.]
#definition[Des essais de *Poisson* font références à des variables aléatoires indépendantes dont les probabilités sont propres aux variables. Il s'agit d'une généralisation de Bernoulli. Soit $X_1, ..., X_n$ des variables de Bernoulli tel que pour $1 <= i <= n, P[X_i = 1] = p_i$ et $P[X_i = 0] = (1 - p_i)$]
Nous nous concentrons sur le cas général (Poisson) mais il fonctionne bien évidemment aussi dans le cas "Bernoulli" où toutes les variables partagent la même probabilité $p$.
On peut se poser des questions sur la déviation de l'espérance $mu$ de $X$, $mu = sum_i=1^n p_i$ telles que "Quelle est la probabilité que $X$ dépasse $(1+delta)mu$ ?". Une réponse à cette question est utile pour analyser un algorithme randomisé, cela montre que les chance que l'algorithme échoue une certaine performances sont faibles. Un autre type de question que l'on peut se poser est "Quelle valeur maximale $delta$ peut prendre de sorte que la probabilité de la queue soit plus petite qu'une valeur $epsilon$ ?"
#theorem[Soit $X_1, ..., X_n$ une collection d'essais de Poissons indépendantes#footnote[Il s'agit donc simplement de variables aléatoires indépendantes de Bernouilli $x_i$ ayant chacunes une probabilité $p_i$] tq pour tout $1 <= i <= n, P[X_i = 1] = p_i$ où $0 < p_i < 1$. Alors, pour un $X = sum_(i=1)^n X_i, mu = E[X] = sum_i^n p_i$ et un $delta > 0$, $ P[X > (1+delta)mu] < [e^delta/((1+delta)^(1+delta))]^mu $*Remarque*: le membre de droite de l'inégalité est une fonction ne dépendant que des paramètres $delta "et" mu$ ]
#let genMomFct = $e^(t X)$
L'idée derrière cette formule est d'appliquer les inégalités de Markov sur les _fonction génératrices des moments_ des variables aléatoires $X$ définies comme $M_X(t) = E[genMomFct]$.\
Preuve:
$ 
& P[X > (1 + delta)mu]  = P[genMomFct > e^(t(1+delta)mu)]\
=> & P[genMomFct > e^(t(1+delta)mu)] < E[genMomFct]/e^(t(1 + delta)mu) &"Inégalité de Markov"\
$
Ici, une petite étape tranformation du numérateur dans le terme de droite s'impose
$ 
E[genMomFct] &= E[e^(t sum_i x_i)]\
&= E[product_i e^(t x_i)] & #h(15pt) "Propriété des exposants"\
&= product_i E[e^(t x_i)] & #h(15pt) "Linéarité de l'espérance"\
$
Ici aussi, une petite transformation est nécessaire pour nous simplifier la vie, elle est pas super triviale pour un étudiant en info qui comprend pas grand chose en proba. En gros, l'idée est quand même simple mais il faut l'avoir: l'espérance représentant la valeur que peut prendre une variable aléatoire et qu'on a des variables de Poissons (c'est à dire dont les valeurs $x_i$ ont chacunes une probabilité $p_i$), on peut observer que $e^(t X_i)$ prend la valeur $e^t$ avec une proba $p_i$ et 1 avec une proba $1-p_i$, en effet: 
- si la proba est $p_i$ alors $X = 1$ et donc $e^(t 1) = e^t$ et,
- si la proba est $1-p_i$ alors $X_i = 0$ et $e^( t 0) = 1$. 
On peut donc effectuer la transformation suivante:
$ E[e^(t X_i)] &= e^t p_i + (1-p_i)\ &= 1 + p_i (e^t - 1) $
Enfin, on va encore faire une ultime transformation, bien moins triviale; elle se base sur l'inégalité bien connue#footnote[Non] : $1+x < e^x$
$
product_i(1 + p_i (e^t - 1)) &< product_i(e^(p_i (e^t - 1)))\
&= e^(sum_i p_i (e^t - 1)) & #h(15pt) "Propriétés des exposants"\
&= e^((e^t - 1)mu)& "car" sum_i p_i = mu
$
\ Remettons toutes ces transformations dans l'équation initiale:
$
P[genMomFct > e^(t(1+delta)mu)] &< product_i (1 + p_i (e^t - 1))/e^(t(1 + delta)mu)\
 &< e^((e^t - 1)mu)/e^(t(1 + delta)mu)\
$
On doit donc maintenant une valeur pour $t$ de sorte à obtenir la meilleure borne possible, pour ça on a juste à prendre, il s'agit d'un problème d'optimisation simple sans contraintes, on prend la valeur obtenue lorsque la dérivée est nulle. Cela donne $ d/(d t) (e^((e^t - 1)mu)/e^(t(1 + delta)mu))  = mu*(e^t-delta-1)*e^(mu*(e^t-1)-(delta+1)*mu*t) = 0 $ 
La valeur obtimale est $e^t = delta + 1 => t = ln(delta + 1)$ pour $delta > 0$, on a donc notre borne.