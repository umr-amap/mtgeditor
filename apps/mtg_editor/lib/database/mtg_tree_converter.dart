import 'dart:collection';
import 'dart:convert';

import 'package:backend_mtg/backend_mtg.dart';
import 'package:drift/drift.dart';

class MtgTreeConverter extends TypeConverter<MTGTree, String> {
  const MtgTreeConverter();

  @override
  MTGTree fromSql(String fromDb) => MtgTreeCodec.decode(fromDb);

  @override
  String toSql(MTGTree value) => MtgTreeCodec.encode(value);
}

class MtgTreeCodec {
  const MtgTreeCodec._();

  static String encode(MTGTree tree) {
    final nodes = _collectNodes(tree);
    final nodeKeys = Map<MTGNode, String>.identity();
    for (var index = 0; index < nodes.length; index++) {
      nodeKeys[nodes[index]] = 'n$index';
    }

    final scales = _collectScales(tree, nodes);
    String? nodeKeyFor(MTGNode? node) => node == null ? null : nodeKeys[node];
    final nodeData = nodes.map((node) {
      final attributes = node.getAttributes()?.entries.map((entry) {
        return {
          'name': entry.key.getName(),
          'type': entry.key.getType()?.name,
          'value': _encodeValue(entry.value),
        };
      }).toList();

      return {
        'key': nodeKeys[node],
        'id': node.getId(),
        'scale': _findScaleIndex(scales, node.getScale()),
        'connection': node.getConnexion(),
        'parent': nodeKeyFor(node.getParent()),
        'children': (node.getDescendants() ?? const <MTGNode>[])
            .map((child) => nodeKeys[child])
            .whereType<String>()
            .toList(),
        'attributes': attributes,
      };
    }).toList();

    return jsonEncode({
      'version': 1,
      'root': nodeKeyFor(tree.getRoot()),
      'scales': scales
          .map(
            (scale) => {
              'symbol': scale.getSymbol(),
              'level': scale.getEchelle(),
            },
          )
          .toList(),
      'descriptions': (tree.getDescriptions() ?? const <MTGDescription>[])
          .map(
            (description) => {
              'parents': _findScaleIndices(scales, description.getParents()),
              'children': _findScaleIndices(scales, description.getEnfants()),
              'operation': description.getOperation(),
              'limit': description.getLimite(),
            },
          )
          .toList(),
      'nodeIndex': (tree.getNodes() ?? const <String, MTGNode>{}).map(
        (id, node) => MapEntry(id, nodeKeys[node]),
      ),
      'nodes': nodeData,
    });
  }

  static MTGTree decode(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! Map<String, dynamic> || decoded['version'] != 1) {
      throw const FormatException('Unsupported MTG tree data format.');
    }

    final scaleData = _asList(decoded['scales'], 'scales');
    final scales = scaleData.map((value) {
      final data = _asMap(value, 'scale');
      return MTGScale(
        symbol: data['symbol'] as String?,
        echelle: data['level'] as int?,
      );
    }).toList();

    final descriptions = _asList(decoded['descriptions'], 'descriptions').map((
      value,
    ) {
      final data = _asMap(value, 'description');
      return MTGDescription(
        parents: _decodeScales(data['parents'], scales),
        enfants: _decodeScales(data['children'], scales),
        operation: data['operation'] as String?,
        limite: data['limit'] as int?,
      );
    }).toList();

    final nodeData = _asList(decoded['nodes'], 'nodes');
    final nodesByKey = <String, MTGNode>{};
    for (final value in nodeData) {
      final data = _asMap(value, 'node');
      final key = data['key'];
      if (key is! String || nodesByKey.containsKey(key)) {
        throw const FormatException('Invalid or duplicate MTG node key.');
      }

      final scaleIndex = data['scale'];
      if (scaleIndex != null &&
          (scaleIndex is! int ||
              scaleIndex < 0 ||
              scaleIndex >= scales.length)) {
        throw const FormatException('Invalid MTG node scale reference.');
      }

      final rawAttributes = data['attributes'];
      Map<MTGAttribute, dynamic>? attributes;
      if (rawAttributes != null) {
        attributes = <MTGAttribute, dynamic>{};
        for (final rawAttribute in _asList(rawAttributes, 'attributes')) {
          final attributeData = _asMap(rawAttribute, 'attribute');
          final name = attributeData['name'];
          final typeName = attributeData['type'];
          if (name != null && name is! String) {
            throw const FormatException('Invalid MTG attribute name.');
          }
          if (typeName != null && typeName is! String) {
            throw const FormatException('Invalid MTG attribute type.');
          }
          attributes[MTGAttribute(
            name: name as String?,
            type: typeName == null
                ? null
                : MTGAttributeType.values.byName(typeName),
          )] = _decodeValue(
            attributeData['value'],
          );
        }
      }

      nodesByKey[key] = MTGNode(
        id: data['id'] as String?,
        scale: scaleIndex == null ? null : scales[scaleIndex as int],
        connexion: data['connection'] as String?,
        attributes: attributes,
      );
    }

    for (final value in nodeData) {
      final data = _asMap(value, 'node');
      final node = nodesByKey[data['key']];
      final children = _asList(data['children'], 'children');
      for (final childKey in children) {
        if (childKey is! String || !nodesByKey.containsKey(childKey)) {
          throw const FormatException('Invalid MTG child reference.');
        }
        node!.addDescendant(
          nodesByKey[childKey]!,
          connexion: nodesByKey[childKey]!.getConnexion(),
        );
      }

      final parentKey = data['parent'];
      if (parentKey != null) {
        if (parentKey is! String || !nodesByKey.containsKey(parentKey)) {
          throw const FormatException('Invalid MTG parent reference.');
        }
        final parent = nodesByKey[parentKey]!;
        if (!identical(node!.getParent(), parent)) {
          parent.addDescendant(node, connexion: node.getConnexion());
        }
      }
    }

    final rawNodeIndex = _asMap(decoded['nodeIndex'], 'nodeIndex');
    final nodeIndex = <String, MTGNode>{};
    for (final entry in rawNodeIndex.entries) {
      final key = entry.value;
      if (key is! String || !nodesByKey.containsKey(key)) {
        throw const FormatException('Invalid MTG node index reference.');
      }
      nodeIndex[entry.key] = nodesByKey[key]!;
    }

    final rootKey = decoded['root'];
    if (rootKey != null &&
        (rootKey is! String || !nodesByKey.containsKey(rootKey))) {
      throw const FormatException('Invalid MTG root reference.');
    }

    return MTGTree(
      scales: scales,
      root: rootKey == null ? null : nodesByKey[rootKey as String],
      nodes: nodeIndex,
      description: descriptions,
    );
  }

  static int countNodes(MTGTree tree) => _collectNodes(tree).length;

  static List<MTGNode> _collectNodes(MTGTree tree) {
    final visited = Set<MTGNode>.identity();
    final queue = Queue<MTGNode>();
    final result = <MTGNode>[];

    final root = tree.getRoot();
    if (root != null) queue.add(root);
    queue.addAll(tree.getNodes()?.values ?? const <MTGNode>[]);

    while (queue.isNotEmpty) {
      final node = queue.removeFirst();
      if (!visited.add(node)) continue;
      result.add(node);
      final parent = node.getParent();
      if (parent != null) queue.add(parent);
      queue.addAll(node.getDescendants() ?? const <MTGNode>[]);
    }
    return result;
  }

  static List<MTGScale> _collectScales(MTGTree tree, List<MTGNode> nodes) {
    final scales = <MTGScale>[];
    void addScale(MTGScale? scale) {
      if (scale == null ||
          scales.any((existing) => identical(existing, scale))) {
        return;
      }
      scales.add(scale);
    }

    for (final scale in tree.getScales() ?? const <MTGScale>[]) {
      addScale(scale);
    }
    for (final node in nodes) {
      addScale(node.getScale());
    }
    for (final description
        in tree.getDescriptions() ?? const <MTGDescription>[]) {
      for (final scale in description.getParents() ?? const <MTGScale>[]) {
        addScale(scale);
      }
      for (final scale in description.getEnfants() ?? const <MTGScale>[]) {
        addScale(scale);
      }
    }
    return scales;
  }

  static int? _findScaleIndex(List<MTGScale> scales, MTGScale? target) {
    if (target == null) return null;
    final identicalIndex = scales.indexWhere(
      (scale) => identical(scale, target),
    );
    if (identicalIndex >= 0) return identicalIndex;
    return scales.indexWhere(
      (scale) =>
          scale.getSymbol() == target.getSymbol() &&
          scale.getEchelle() == target.getEchelle(),
    );
  }

  static List<int> _findScaleIndices(
    List<MTGScale> scales,
    List<MTGScale>? values,
  ) {
    return (values ?? const <MTGScale>[])
        .map((scale) => _findScaleIndex(scales, scale))
        .whereType<int>()
        .toList();
  }

  static List<MTGScale> _decodeScales(Object? value, List<MTGScale> scales) {
    return _asList(value, 'scale references').map((index) {
      if (index is! int || index < 0 || index >= scales.length) {
        throw const FormatException('Invalid MTG description scale reference.');
      }
      return scales[index];
    }).toList();
  }

  static Object? _encodeValue(Object? value) {
    if (value is DateTime) {
      return {'kind': 'dateTime', 'value': value.toIso8601String()};
    }
    if (value == null || value is String || value is num || value is bool) {
      return {'kind': 'json', 'value': value};
    }
    throw FormatException(
      'Unsupported MTG attribute value: ${value.runtimeType}.',
    );
  }

  static Object? _decodeValue(Object? value) {
    final data = _asMap(value, 'attribute value');
    switch (data['kind']) {
      case 'dateTime':
        final date = data['value'];
        if (date is! String) {
          throw const FormatException('Invalid MTG date attribute value.');
        }
        return DateTime.parse(date);
      case 'json':
        return data['value'];
      default:
        throw const FormatException('Unsupported MTG attribute value format.');
    }
  }

  static List<Object?> _asList(Object? value, String field) {
    if (value is List<Object?>) return value;
    throw FormatException('Invalid MTG data: expected a list for "$field".');
  }

  static Map<String, dynamic> _asMap(Object? value, String field) {
    if (value is Map<String, dynamic>) return value;
    throw FormatException('Invalid MTG data: expected an object for "$field".');
  }
}
