import 'package:backend_mtg/backend_mtg.dart';
import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mtg_editor/database/app_database.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/organic_card.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/plant_search_bar.dart';
import 'package:mtg_editor/features/creation/screens/create_plant.dart';
import 'package:mtg_editor/features/parametres/screens/parametre.dart';

class ListPlantesScreen extends StatefulWidget {
  const ListPlantesScreen({
    super.key,
    required this.database,
  });

  final AppDatabase database;

  @override
  State<ListPlantesScreen> createState() => _ListPlantesScreenState();
}

class _ListPlantesScreenState extends State<ListPlantesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final Stream<List<OrganicEntry>> _plantes;
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    _plantes = widget.database.watchOrganics();
  }

  void _showPlantList() {
    setState(() => _selectedIndex = 0);
  }

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
        .where(
          (plant) => plant.tag?.toLowerCase().contains(_searchQuery) ?? false,
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Symbols.psychiatry, size: 24),
            label: 'Plantes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, size: 24),
            label: 'Création',
          ),
          BottomNavigationBarItem(
            icon: Icon(Symbols.settings, size: 24),
            label: 'Paramètres',
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          _buildPlantList(),
          TabBarScreen(onBackToPlants: _showPlantList),
          const EcranSettings(),
        ],
      ),
    );
  }

  Widget _buildPlantList() async {
    List<OrganicEntry> plantes = await _plantes.first;
    return Center(
        child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: plantes.length,
            itemBuilder: (BuildContext context, int index) {
              final OrganicEntry organic = plantes[index];
              return organic.toWidget(context);
            })

    );
  }

    return SafeArea(
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
                ? const Center(child: Text('Aucune plante trouvée'))
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
    );
  }
}
