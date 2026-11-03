import 'dart:ffi';
import 'dart:io';

import '../models/mtg_attribute.dart';
import '../models/mtg_description.dart';
import '../models/mtg_node.dart';
import '../models/mtg_scale.dart';
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
    List<MTGAttribute> attributes= [];
    List<MTGDescription> descriptions= [];
    List<MTGNode> nodes= [];
    List<MTGScale> classes= [];
    final result= parser.parseMtgFile();
    final features = result['features'] as Map<int, dynamic>;
    for (final entry in features.entries) {
      final row = entry.value as Map<String, String>;
      attributes.add(MTGAttribute(name: row['NAME'],type: parseAttributeType(row['TYPE']!)));
    }
    final classe = result['classes'] as Map<int, dynamic>;
    for (final entry in classe.entries) {
      final row = entry.value as Map<String, String>;
      classes.add(MTGScale(symbol: row['SYMBOL'],echelle: int.parse(row['SYMBOL']!)));
    }
    final description = result['description'] as Map<int, dynamic>;
    for (final entry in description.entries) {
      final row = entry.value as Map<String, String>;
        int? lim;
      if(row["MAX"]=="?"){
        lim=null;
      }else{
        lim=int.parse(row["MAX"]!);
      }
      descriptions.add(MTGDescription(parents:parseSymbols(row['LEFT']!, classes) ,enfants: parseSymbols(row['SYMBOL']!, classes), operation: row['RELTYPE'],limite: lim));
    }
    MTGNode? dernier_regle = null; 
    final mtgRow = result['mtg'] as Map<int, dynamic>;
    for (final entry in mtgRow.entries) {
      final row = entry.value as Map<String, String>;
      final node = MTGNode(
        id: IdEntityCode(row['ENTITY-CODE']!)["id"],
        attributes: {},
        connexion: IdEntityCode(row['ENTITY-CODE']!)["connexion"]
      );

      if(IdEntityCode(row['ENTITY-CODE']!)["regle"]!=null && dernier_regle!=null){

        node.setParent(dernier_regle);
        dernier_regle=node;
      }else if(IdEntityCode(row['ENTITY-CODE']!)["regle"]!=null && dernier_regle==null){
        node.setParent(nodes[0]);
        dernier_regle=node;
      }else{
        node.setParent(nodes[-1]);
      }

      for (final attribute in attributes) {
        final name = attribute.getName();
        if (name == null) continue;

        final rawValue = row[name];
        if (rawValue == null || rawValue.isEmpty) continue;

        // À cet endroit, convertis rawValue selon attribute.getType().
        node.getAttributes()![attribute] = rawValue;
      }
      nodes.add(node);
    }
    
    return {
      'nodes': nodes,
      'classes': classes,
      'description': descriptions,
      'features': features,
    };
  }
  MTGAttributeType parseAttributeType(String rawType) {
    switch (rawType.trim().toUpperCase()) {
      case 'ALPHA':
        return MTGAttributeType.String;
      case 'REAL':
        return MTGAttributeType.double;
      case 'BOOLEAN':
        return MTGAttributeType.Bool;
      case 'DD/MM/YY':
        return MTGAttributeType.Date;
      default:
        throw FormatException('Type MTG non pris en charge : $rawType');
    }
  }
  List<MTGScale> parseSymbols(String symbol,List<MTGScale> classes){
    List<MTGScale> result= [];
    for(MTGScale c in classes){ 
      if(symbol.contains(c.getSymbol() as Pattern)){
        result.add(c);
      }
    }
    return result;
  }
  Map<String,String> IdEntityCode(String chaineEntity){
    Iterable<String> lettres = chaineEntity.split('');
    Map<String,String> result={"id":""};
    for(String c in lettres){
      if(c=="+" || c== "/" || c== "<" ){
        result["connexion"]=c;
      }if(c=="^"){
        result["regle"]=c;
      }else{
        result["id"] = result["id"]! + c;
      }
    }
    return result;
  }

}
