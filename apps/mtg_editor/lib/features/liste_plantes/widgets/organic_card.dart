import 'package:flutter/material.dart';
import 'package:backend_mtg/backend_mtg.dart';

class OrganicCard extends StatelessWidget {
  const OrganicCard({
    required this.organic,
    super.key,
  });

  final Organic organic;

  @override
  Widget build(BuildContext context) {
    final imageUrl = organic.imagesUrls.isNotEmpty
        ? organic.imagesUrls.first
        : null;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            if (imageUrl != null)
              Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              )
            else
              const SizedBox(
                width: 60,
                height: 60,
                child: Icon(Icons.park),
              ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(organic.tag),
                if (organic.latitude != null && organic.longitude != null)
                  Text(
                    '${organic.latitude}, ${organic.longitude}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}