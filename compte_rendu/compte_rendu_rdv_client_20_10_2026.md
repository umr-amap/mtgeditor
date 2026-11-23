# COMPTE RENDU VISIO 22/09/2026

## Introduction

> Cette seconde visio avait pour but de valider la maquette avant la semaine de projet, ainsi que récupérer d'autres informations importantes.

> Dans ce rapport, nous verrons le déroulé de la visio avec le client, cette fois-ci c'était le développeur. Le rapport ne sera pas présenté dans l'ordre chronologique de la visio mais par section pour raison de simplicité de compréhension.
De plus, on ne retrouve qu'un résumé des échanges et non pas toute la retranscription. Enfin, seulement les parties les plus importantes ont été gardées

### Présentation de la maquette
    Nous avons présenté la maquette de l'application à Rémi car il ne l'avait jamais vue avec nous. 
    Il nous à donné des informations afin d'améliorer la maquette, notamment avec des exemples concrets.

    - Il faudrait que l'application recadre ce qu'on peut faire avec le format MTG car il est trop libre et donc il y a beaucoup d'erreurs.
    - Les types autorisés sont Date, Bool, Rell, String
    - Les chercheurs savent ce qu'ils vont mesurer avant la prise de mesure.
    - En fonction de l'échelle de mesure, on doit retrouver dans l'app des propriétés par défaut.
    - L'utilisateur peut ajouter son propre attribut.
    - Il faut une page pour définir le MTG

### Quelques explications
    Nous avons expliqué nos choix par rapport aux technologies utilisées pour le projet.
    Ainsi que la raison pour laquelle le Python ne sera pas utilisé.
    Remy nous a expliqué des cas sur le terrain, ce qui nous a permis de comprendre plus de choses. 
    Actuellement ils utilisent des CSV et Excel

### Modele en dart
    Nous avons présenté le modèle afin de vérifier si nous avons choisi la bonne direction. Le choix était globalement pas mal. Nous avons cependant noté quelques améliorations.
    - Le " ^ " ne doit pas être dans le modèle car c'est un symbole qui correspond à une façon de réaliser un fichier MTG pour des raisons de lisibilité.
    - Dans la classe Tree principale, l'attribut pour stocker les noeuds doit être une map et pas list pour pouvoir récupérer un noeud en temps constant.
    - Les symboles dans class ont une liste d'attributs différente chacune

### Format MTG
    - Le parseur doit gérer ^ 
    - Pour les attributs c'est très libre, mais on doit proposer une base d'attribut
    - Voir les fichiers MTG de la doc et qu'on a reçus pour en apprendre plus 
    - Pour les symboles dans class, on peut mettre ce qu'on veut comme nom mais on partira sur une base pour plus de simplicité au début 