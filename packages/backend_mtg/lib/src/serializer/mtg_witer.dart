import 'dart:io';

import '../models/mtg_attribute.dart';
import '../models/mtg_description.dart';
import '../models/mtg_node.dart';
import '../models/mtg_scale.dart';
import '../models/mtg_tree.dart';

void write(MTGTree tree){
  String classes="CLASSES: \n SYMBOL\tSCALE\tDECOMPOSITION\tINDEXATION\tDEFINITION \n";
  String description="DESCRIPTION: \n LEFT\tRIGHT\tRELTYPE\tMAX \n";
  String features="FEATURES: \n NAME\tTYPE \n";
  String mtg="MTG: \n ENTITY-CODE \n";

  final scales = tree.getScales();
  if (scales != null) {
    for (final classe in scales) {
      classes+=classe.getSymbol()! + "\t" + classe.getEchelle().toString()+ "\t"+ "FREE" +"\t"+ "FREE"+"\t"+ "IMPLICIT"+"\n";
    }
  }
  final descriptions = tree.getDescriptions();
  if (descriptions != null) {
    for (final d in descriptions) {
      description+=d.getParents().toString() + "\t" + d.getEnfants().toString()+ "\t"+ 
      d.getOperation().toString()+"\t"+ d.getLimite().toString()+"\n";
    }
  }

  final attributes = tree.getRoot()?.getAttributes();
  if(attributes!=null){
    for(MTGAttribute a in attributes.keys){
      features+=a.getName()!+"\t"+mtgType(a.getType());
    }
  }
}
String mtgType(MTGAttributeType? t){
  if (t == null) return "" ;
  switch (t) {
    case MTGAttributeType.Bool:
      return "BOOLEAN";
    case MTGAttributeType.Int:
      return "REAL";
    case MTGAttributeType.Date:
      return "DD/MM/YY";
    case MTGAttributeType.String:
      return "STRING";
    case MTGAttributeType.double:
      return "ALPHA";
  }
}
