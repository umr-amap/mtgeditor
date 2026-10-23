import 'package:backend_mtg/backend_mtg.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/organic_card.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/plant_search_bar.dart';

class ListPlantesScreen extends StatefulWidget {
  const ListPlantesScreen({super.key});

  @override
  State<ListPlantesScreen> createState() => _ListPlantesScreenState();
}

class _ListPlantesScreenState extends State<ListPlantesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Organic> _plantes = [
    Organic(tag: 'Plante 1'),
    Organic(tag: 'Plante 2'),
  ];
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterPlants(String query) {
    setState(() {
      _searchQuery = query.trim().toLowerCase();
    });
  }

  List<Organic> get _filteredPlants {
    if (_searchQuery.isEmpty) {
      return _plantes;
    }

    return _plantes
        .where((plant) => plant.tag.toLowerCase().contains(_searchQuery))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlants = _filteredPlants;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Symbols.psychiatry, size: 24, color: Color(0xFF1F1F1F)),
            label: 'Plantes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 24, color: Color(0xFF1F1F1F)),
            label: 'Création',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.settings, size: 24, color: Color(0xFF1F1F1F)),
            label: 'Paramètres',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: PlantSearchBar(
                controller: _searchController,
                onChanged: _filterPlants,
              ),
            ),
            Expanded(
              child: filteredPlants.isEmpty
                  ? const Center(
                      child: Text('Aucune plante trouvée'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filteredPlants.length,
                      itemBuilder: (context, index) {
                        return OrganicCard(organic: filteredPlants[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


