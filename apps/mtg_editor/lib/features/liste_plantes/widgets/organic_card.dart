import 'package:material_ui/material_ui.dart';
import 'package:mtg_editor/database/app_database.dart';

class OrganicCard extends StatelessWidget {
  const OrganicCard({required this.organic, super.key});

  final OrganicEntry organic;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const SizedBox(width: 60, height: 60, child: Icon(Icons.park)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(organic.name),
                if (organic.species != null) Text(organic.species!),
                Text('${organic.nodeCount} nœuds'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension OrganicEntryWidget on OrganicEntry {
  Widget toWidget(BuildContext _) => OrganicCard(organic: this);
}
