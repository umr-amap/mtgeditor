import 'dart:async';
import 'dart:io';
import 'dart:convert';

class Reader() {
  String? path;


  Read(){
    File(path)
    .openRead()
    .transform(utf8.decoder)
    .transform(LineSplitter())
    .forEach((l) => print('line: $l'));
  }
}