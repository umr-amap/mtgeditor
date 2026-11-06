import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:mtg_editor/features/parametres/screens/archive.dart';
import 'package:mtg_editor/database/app_database.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/organic_card.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/plant_search_bar.dart';
import 'package:mtg_editor/features/creation/screens/create_plant.dart';
import 'package:mtg_editor/features/parametres/screens/parametre.dart';

class ListPlantesScreen extends StatefulWidget {
  const ListPlantesScreen({super.key, required this.database});

  final AppDatabase database;

  @override
  State<ListPlantesScreen> createState() => _ListPlantesScreenState();
}

class _ListPlantesScreenState extends State<ListPlantesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
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

  Widget _buildPlantList() {
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
            child: StreamBuilder<List<OrganicEntry>>(
              stream: widget.database.watchOrganics(searchQuery: _searchQuery),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Impossible de charger les plantes : ${snapshot.error}',
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final plants = snapshot.data!;
                if (plants.isEmpty) {
                  return const Center(child: Text('Aucune plante trouvée'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.redAccent,
                        child: const Icon(Icons.delete),
                      ),
                      child: plants[index].toWidget(context),
                      onDismissed: (DismissDirection direction) {
                        widget.database.deleteOrganic(plants[index].id);
                        ArchiveApp.add(plants[index]);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
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
          EcranSettings(database: widget.database),
        ],
      ),
    );
  }
}
