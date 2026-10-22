import 'dart:io';

import 'mtg_parser.dart';

class Reader {
  final String path;


  const Reader({
    required this.path,
  });

  Future<Map<String, dynamic>> read() async {
    final lines = await File(path).readAsLines();

    final parser = MTGParser(
      lines: lines,

    );
    return parser.parseMtgFile();
  }

}
