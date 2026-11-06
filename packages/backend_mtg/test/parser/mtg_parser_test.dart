import '../../lib/src/parser/mtg_file_reader.dart';

void main() {
  testParser()async{
  final data = await Reader(
  path: 'test/files/simple_plant.mtg',
  ).read();

  }
  testParser();
}

