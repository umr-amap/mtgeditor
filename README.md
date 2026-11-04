# Application de mesure de plante - CIRAD
## Contributeurs
### IUT Orléans
- Nicolas CAMERA
- Titouan GUERRIER
- Bastien MOINS
- Esteban ROUSSEAU

## Maquette de l'application  
 [Figma](https://www.figma.com/design/dHv55YwCSlYOFtGL53j3P3/CIRAD-ETUdiant?node-id=4-540&t=lvdQ6Yk2dqfYwPox-1)

## LANCER LES TESTS DU BACKEND

    - Commencer par se mettre dans le répertoire mtgeditor/packages/backend_mtg

    - Pour lancer un fichier test précis:
      dart test test/MON_FICHIER.dart

    - Pour lancer tous les tests
      dart test --coverage=coverage test/models


> Une fois les tests effectués, il faut générer le rapport LCOV qui contient les résultats des tests ainsi que le coverage

    - Pour convertir les données du test en rapport LCOV, activez l'outil suivant (une seule activation suffit)
      dart pub global activate coverage

    - Pour générer le rapport .info
      dart pub global run coverage:format_coverage \
        --lcov \
        --in=coverage \
        --out=coverage/lcov.info \
        --packages=.dart_tool/package_config.json \
        --report-on=lib

> Vous avez maintenant dans le répertoire mtgeditor/packages/backend_mtg/coverage un fichier lcov.info qui contient les informations des tests et le coverage

    Voici comment lire le fichier
        - SF: Le fichier testé
        - DA(num_ligne, nb_test): Le nombre de fois ou la ligne num_ligne est testé
        - LF: Nombre de ligne total des fonctions visées par les tests
        - LH: Nombre de ligne total testé des fonctions visées par les tests  
        - end_of_record: fin du rapport pour ce fichier test

    Le fichier est peu compréhensible, vous pouvez donc instaler lcov pour pouvoir transformer le rapport en tableau

        - Installer lcov
          sudo apt install lcov

        - Générer le coverage en mode web (HTML)
          genhtml coverage/lcov.info --output-directory coverage/html

        - Générer le coverage en mode terminal
          lcov --summary coverage/lcov.info