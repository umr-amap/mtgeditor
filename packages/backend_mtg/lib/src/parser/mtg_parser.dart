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
  String code="";
Map<String, dynamic> parseMtgFile() {
  while (index < lines.length) {
    String currentLine = lines[index].trim();
    
    if (!isAnySection(currentLine)) {
      index++;
      continue;
    }
    if (isSection(currentLine, 'CODE')) {
          code = currentLine
          .replaceFirst(
            RegExp(r'^CODE[ \t]*:[ \t]*'),
            '',
          )
          .trim();

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
    'code':code,
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
if (index >= lines.length) {
  throw FormatException('Section introuvable ou fichier incomplet');
}

if (!isAnySection(lines[index])) {
  throw FormatException('Section incorrecte');
}

  final lignes = <int, Map<String, String>>{};

  // Passer à la ligne du header
  final actualHeader = lines[index + 1]
      .split('\t')
      .map((e) => e.trim())
      .toList();

  if (actualHeader.length != header.length) {
    throw FormatException('Header incorrect dans la section $section');
  }

  // Passer à la première ligne de données
  index++;

  int i = 1;

  while (index < lines.length &&
      lines[index].trim().isNotEmpty &&
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

  if (index + 1 >= lines.length) {
    throw const FormatException('Header MTG manquant');
  }
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

    row['ENTITY-CODE'] = values[0].trim();

    for (var column = 1; column < headers.length; column++) {
      final name = headers[column].trim();

      if (name.isEmpty) continue;

      final value = column < values.length
          ? values[column].trim()
          : '';

      row[name] = value.isEmpty ? null : value;
    }

    result[rowNumber] = row;
    rowNumber++;
    index++;
  }

  return (result, index);
}
}