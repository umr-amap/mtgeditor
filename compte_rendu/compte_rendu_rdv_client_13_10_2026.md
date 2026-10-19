# COMPTE RENDU VISIO 13/10/2026

## Introduction

> Cette seconde visio avait pour but de valider la maquette avant la semaine de projet, ainsi que récupérer d'autres informations importantes.

> Dans ce rapport, nous verrons le déroulé de la visio avec le client. Le rapport ne sera pas présenté dans l'ordre chronologique de la visio mais par section pour raison de simplicité de compréhension.
De plus, on ne retrouve qu'un résumé des échanges et non pas toute la retranscription. Enfin, seulement les parties les plus importantes ont été gardées

## Présentation de la maquette
> Dans cette partie nous avons présenté l'intégralité de la maquette à travers un exemple interactif fourni par Figma. Le client nous a apporté des éléments afin d'améliorer la maquette et notre compréhension du format au passage.

> - Pour la page détail d'une plante, il faut ajouter l'export au format MTG 
> - Pour plus tard, essayer de retravailler le côté topologique du graph car il y a plusieurs échelles à respecter.
> - Quand on crée une plante, l'utilisateur doit créer en premier l'entête du fichier MTG
> - Les champs de propriétés sont présents sur chaque noeud, et en fonction de l'axe dans lequel il se trouve
> - L'utilisateur peut ajouter d'autres champs si besoin
> - Même avec un template, pas de P central part défaut sur le graph topologique, et pas de champs de propriété déjà définis.
> - Ajouter la localisation GPS d'une plante
> - Quand on clique sur un noeud, ses infos sont dans une petite box sur la page (cela évite les allers-retours entre les pages)

## Autres
> A réaliser pour plus tard, faire une fonction de check qui verifie les infos entrées par l'utilisateur par rapport au noeud et au format MTG afin de vérifier que tout est valide.

> Nous avons échangé sur la façon dont nous allons implémenter cette application, c'est-à-dire nos choix de technologie, ect ... Le client nous a parlé d'une de leurs app en Python permettant de faire des calculs en backend pour le format MTG. Cela peut nous être utile, nous choisirons si on souhaite l'utiliser en faisant un lien Flutter -> app python, ou développer nous-même. 

> Pour le moment, le client nous a conseillé de faire abstraction des concepts mathématiques pour le format MTG et graph qui sont assez compliqués. Cela n'est pas notre priorité. 