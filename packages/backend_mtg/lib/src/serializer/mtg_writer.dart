import 'dart:io';

import '../models/mtg_attribute.dart';
import '../models/mtg_description.dart';
import '../models/mtg_node.dart';
import '../models/mtg_scale.dart';
import '../models/mtg_tree.dart';

Future<void> write(MTGTree tree,nomfichier) async{
  // mise en place des headers statiques
  String classes="CLASSES: \nSYMBOL\tSCALE\tDECOMPOSITION\tINDEXATION\tDEFINITION \n";
  String description="DESCRIPTION: \nLEFT\tRIGHT\tRELTYPE\tMAX \n";
  String features="FEATURES: \nNAME\tTYPE \n";
  String mtg="MTG: \nENTITY-CODE\t";

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
      description += d.getParents()!.join(", ") + "\t" +
        d.getEnfants()!.join(", ") + "\t" +
        d.getOperation().toString() + "\t" +
        d.getLimite().toString() + "\n";
    }
  }

  //écritures des attributs
  final attributes = tree.getRoot()?.getAttributes();
  if(attributes!=null){
    for(MTGAttribute a in attributes.keys){
      if(mtgType(a.getType()).isEmpty==false){
        features+=a.getName()!+"\t"+mtgType(a.getType())+"\n";
        mtg+=a.getName()!+"\t";
      }
    }
  }

  //mise ene place de le contenu du graphe mtg
  final root = tree.getRoot();
  if (root != null) {
    mtg += "\n" + writeContentMtg(0, root);
  }
  final contenu = '$classes\n$description\n$features\n$mtg';
  await File(nomfichier).writeAsString(contenu);
  
}

String writeContentMtg(int tab, MTGNode node) {
  if (tab < 0) {
    throw ArgumentError.value(tab, 'tab', 'Ne peut pas être négatif');
  }

  final id = node.getId();

  if (id == null) {
    throw StateError('Le nœud doit avoir un identifiant.');
  }

  String rulePrefix = '';
  if (node.getConnexion() == '+') {
    tab++;
  }else{
    rulePrefix = '^';
  }

  final indentation = List.filled(tab, '\t').join();

  final connexion = node.getConnexion() ?? '';

  final values = node
          .getAttributes()
          ?.values
          .map((value) => value?.toString() ?? '')
          .join('\t') ??
      '';

  // Écriture du nœud actuel
  String content = '$indentation$rulePrefix$connexion$id\t\t$values\n';

  // Parcours récursif des enfants
  for (final child in node.getDescendants()!) {
    content += writeContentMtg(tab , child);
  }

  return content;
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
