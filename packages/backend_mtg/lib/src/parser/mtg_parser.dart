class MTGParser {
  List<String> lines;
  int index=0;
  MTGParser({
    required this.lines,
  });

  Map<int,dynamic> classes={};
  Map<int,dynamic> descriptions={};
  Map<int,dynamic> features={};
  Map<int,dynamic> mtg={};
Map<String, dynamic> parseMtgFile() {
  while (index < lines.length) {
    String currentLine = lines[index].trim();
    
    // CORRECTION : Utiliser isAnySection au lieu de isSection sans paramètre
    if (!isAnySection(currentLine)) {
      index++;
      continue;
    }
    
    if (isSection(currentLine, "CLASSES")) {
      final (parsedClasses, nextIndex) = parseSection(
        ["SYMBOL", "SCALE", "DECOMPOSITION", "INDEXATION", "DEFINITION"],
        index,
        "CLASSES",
      );

      classes = parsedClasses;
      index = nextIndex;
      continue;
    }
    
    if (isSection(currentLine, 'FEATURES')) {
      final (parsedFeatures, nextIndex) = parseSection(
        ["NAME", "TYPE"],
        index,
        "FEATURES",
      );

      features = parsedFeatures;
      index = nextIndex;
      continue;
    }
    
    if (isSection(currentLine, 'DESCRIPTION')) {
      final (parsedDescription, nextIndex) = parseSection(["LEFT", "RIGHT","RELTYPE","MAX"], index, 'DESCRIPTION');
      descriptions = parsedDescription;
      index = nextIndex; 
      continue; 
    }
    
    if (isSection(currentLine, 'MTG')) {
      final (mtgParsed, nextIndex) = parseMtg(index);
      mtg = mtgParsed;
      index = nextIndex;
      continue;
    }
    
    // Sécurité supplémentaire si une section reconnue par isAnySection n'est pas gérée explicitement
    index++;
  }
  
  return {
    'mtg': mtg,
    'classes': classes,
    'description': descriptions,
    'features': features,
  };
}
  bool isSection(String line, [String? section]) {
    if (section != null) {
      switch (section) {
        case 'CODE':
          return RegExp(r'^CODE[ \t]*:').hasMatch(line);

        case 'CLASSES':
          return RegExp(r'^CLASSES[ \t]*:').hasMatch(line);

        case 'DESCRIPTION':
          return RegExp(r'^DESCRIPTION[ \t]*:').hasMatch(line);

        case 'FEATURES':
          return RegExp(r'^FEATURES[ \t]*:').hasMatch(line);

        case 'MTG':
          return RegExp(r'^MTG[ \t]*:').hasMatch(line);

        default:
          return RegExp(
            '${RegExp.escape(section)}[ \t]*:',
          ).hasMatch(line);
      }
    }
    return false;
  }
  bool isAnySection(String line) {
    const sections = ['CODE', 'CLASSES', 'DESCRIPTION', 'FEATURES', 'MTG'];
    return sections.any((section) => isSection(line.trim(), section));
  }
(Map<int, Map<String, String>>,int) parseSection(
  List<String> header,
  int index,
  [String? section]
) {
  if (index >= lines.length && !isAnySection(lines[index])) {
    throw FormatException('No value or section is not the good one');
  }

  final lignes = <int, Map<String, String>>{};

  // Passer à la ligne du header
  index++;

  if (index >= lines.length) {
    throw FormatException('Missing header');
  }

  // Passer à la première ligne de données
  index++;

  int i = 1;

  while (index < lines.length &&
      lines[index].isNotEmpty &&
      !isAnySection(lines[index])) {

    final values = lines[index].split('\t');

    if (values.length != header.length) {
      throw FormatException(
        'The number of values does not match the header'
      );
    }

    final row = <String, String>{};

    for (var j = 0; j < header.length; j++) {
      row[header[j]] = values[j];
    }

    lignes[i] = row;

    i++;
    index++;
  }

  return (lignes,index);
}
(Map<int, Map<String, String?>>, int) parseMtg(int index) {
  final result = <int, Map<String, String?>>{};

  // L'en-tête se trouve juste après la ligne "MTG:"
  final headers = lines[index + 1].split('\t');
  index += 2; // passer "MTG:" et l'en-tête

  var rowNumber = 1;

  while (index < lines.length &&
      lines[index].trim().isNotEmpty &&
      !isAnySection(lines[index].trim())) {
    final values = lines[index].split('\t');

    if (values.length > headers.length) {
      throw const FormatException(
        'Une ligne MTG contient plus de colonnes que son en-tête',
      );
    }

    final row = <String, String?>{};

    for (var column = 0; column < headers.length; column++) {
      final name = headers[column].trim();

      // La colonne vide de l'en-tête correspond au séparateur MTG,
      // pas à une feature.
      if (name.isEmpty) continue;

      final value = column < values.length ? values[column].trim() : '';
      row[name] = value.isEmpty ? null : value;
    }

    result[rowNumber] = row;
    rowNumber++;
    index++;
  }

  return (result, index);
}
}
