class MTGParser {
  List<String>? lines;
  String type;
  int index=0;
  MTGParser({
    required this.lines,
    required this.type,
  });

  Map<int,dynamic> classes={};
  Map<int,dynamic> descriptions={};
  Map<int,dynamic> features={};
  Map<int,dynamic> mtg;
  Map<String, dynamic> parseMtgFile() {
    while (index < lines.length) {
      String currentLine = lines[index].trim();

      // Ignorer les lignes vides ou sans section reconnue.
      if (!isSection(currentLine)) {
        index++;
        continue;
      }
      if(isSection(currentLine,"CODE")){
          String code=currentLine.replaceFirst(
            RegExp(r'^CODE[ \t]*:[ \t]*'),
              '').trim();
        index++;
        continue;
      };
      if(isSection(currentLine,"CLASSES")){
          classes=parseSection(["SYMBOL", "SCALE", "DECOMPOSITION", "INDEXATION", "DEFINITION"],index,"CLASSES");
          continue;
      };
      if (isSection(currentLine, 'FEATURES')) {
        features = parseSection(["NAME", "TYPE"],index,'FEATURES');
        continue;
      }
      if (isSection(currentLine, 'DESCRIPTION')) {
        descriptions = parseSection(["LEFT", "RIGHT"],index,'DESCRIPTION');
      }
      if (isSection(currentLine, 'MTG')) {
        mtg = parseMtg(classes, features, type);
        continue;
      }
    }
    return {
      'mtg': mtg,
      'classes': classes,
      'description': descriptions,
      'features': features,
    };
  }
  Map<int,dynamic> parseMtg(
    Map<int, dynamic>? classes,
    Map<int, dynamic>? features,
    String mtgType,
  ) {
    Map<int,dynamic> result={};
    final symbols = classes!.values.map((row) => (row as Map<String, String>)['SYMBOL']!).toList();
    return result;
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
Map<int, Map<String, String>> parseSection(
  List<String> header,
  int index,
  [String? section]
) {
  if (index >= lines.length ||
      lines[index].isEmpty ||
      lines[index] != section) {
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

  return lignes;
}
}
