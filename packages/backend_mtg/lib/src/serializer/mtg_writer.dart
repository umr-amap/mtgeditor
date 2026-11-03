import 'dart:io';

import '../models/mtg_attribute.dart';
import '../models/mtg_description.dart';
import '../models/mtg_node.dart';
import '../models/mtg_scale.dart';
import '../models/mtg_tree.dart';

void write(MTGTree tree){
  // mise en place des headers statiques
  String classes="CLASSES: \n SYMBOL\tSCALE\tDECOMPOSITION\tINDEXATION\tDEFINITION \n";
  String description="DESCRIPTION: \n LEFT\tRIGHT\tRELTYPE\tMAX \n";
  String features="FEATURES: \n NAME\tTYPE \n";
  String mtg="MTG: \n ENTITY-CODE\t";

  //écritures des classes
  final scales = tree.getScales();
  if (scales != null) {
    for (final classe in scales) {
      classes+=classe.getSymbol()! + "\t" + classe.getEchelle().toString()+ "\t"+ "FREE" +"\t"+ "FREE"+"\t"+ "IMPLICIT"+"\n";
    }
  }

  //écritures des descriptions
  final descriptions = tree.getDescriptions();
  if (descriptions != null) {
    for (final d in descriptions) {
      description+=d.getParents().toString() + "\t" + d.getEnfants().toString()+ "\t"+ 
      d.getOperation().toString()+"\t"+ d.getLimite().toString()+"\n";
    }
  }

  //écritures des attributs
  final attributes = tree.getRoot()?.getAttributes();
  if(attributes!=null){
    for(MTGAttribute a in attributes.keys){
      if(mtgType(a.getType()).isEmpty!=false){
        features+=a.getName()!+"\t"+mtgType(a.getType())+"\n";
        mtg+=a.getName()!+"\t";
      }
    }
  }
  //mise en place de la première  
  mtg+="\n"+tree.getRoot()!.getConnexion()!+tree.getRoot()!.getId()!;

  final nodes= tree.getNodes();
  //mise ene place de la tabulation du mtg
  int tab=0;
  if(nodes!=null){
    for(String id in nodes.keys){

    }
  }
}
String writeContentMtg(int tab, MTGNode node) {
  if (tab < 0) {
    throw ArgumentError.value(tab, 'tab', 'Ne peut pas être négatif');
  }

  final id = node.getId();
  if (id == null) {
    throw StateError('Le nœud doit avoir un identifiant.');
  }

  final indentation = List.filled(tab, '\t').join();

  String rulePrefix = '';
  if( node.getConnexion=="+"){
      rulePrefix='^';
  }
  final connexion = node.getConnexion() ?? '';

  final values = node
          .getAttributes()
          ?.values
          .map((value) => value?.toString() ?? '')
          .join('\t') ??
      '';

  return '$indentation$rulePrefix$connexion$id\t\t$values';
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
