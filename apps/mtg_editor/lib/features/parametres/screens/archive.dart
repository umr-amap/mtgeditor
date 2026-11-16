import 'package:material_ui/material_ui.dart';
import 'package:mtg_editor/database/app_database.dart';
import 'package:mtg_editor/features/liste_plantes/widgets/organic_card.dart';

class ArchiveApp extends StatefulWidget {
  const ArchiveApp({required this.database, super.key});

  final AppDatabase database;

  static final Map<DateTime, OrganicEntry> mapArchive =
      <DateTime, OrganicEntry>{};

  static void add(OrganicEntry organic) {
    mapArchive[DateTime.now()] = organic;
  }

  @override
  State<ArchiveApp> createState() => _ArchiveAppState();
}

class _ArchiveAppState extends State<ArchiveApp> {
  @override
  Widget build(BuildContext context) {
    final archivedPlants = ArchiveApp.mapArchive.entries.toList()
      ..sort((a, b) => b.key.compareTo(a.key));

    return SafeArea(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: archivedPlants.length,
        itemBuilder: (context, index) {
          final entry = archivedPlants[index];
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(_formatDate(entry.key)),
                  subtitle: OrganicCard(organic: entry.value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text('RÉCUPÉRER'),
                      onPressed: () async {
                        await widget.database.restoreOrganic(entry.value);
                        if (!mounted) return;
                        setState(() {
                          ArchiveApp.mapArchive.remove(entry.key);
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      child: const Text('SUPPRIMER'),
                      onPressed: () {
                        setState(() {
                          ArchiveApp.mapArchive.remove(entry.key);
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        '${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
