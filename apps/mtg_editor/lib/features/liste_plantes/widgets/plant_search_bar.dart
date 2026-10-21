import 'package:flutter/material.dart';

class PlantSearchBar extends StatelessWidget {
  const PlantSearchBar({
    required this.onChanged,
    this.controller,
    this.hintText = 'Rechercher une plante',
    super.key,
  });

  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: controller == null
            ? null
            : AnimatedBuilder(
                animation: controller!,
                builder: (context, child) {
                  if (controller!.text.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return IconButton(
                    onPressed: () {
                      controller!.clear();
                      onChanged('');
                    },
                    tooltip: 'Effacer la recherche',
                    icon: const Icon(Icons.clear),
                  );
                },
              ),
      ),
    );
  }
}
