import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ListPlantesScreen extends StatelessWidget {
  const ListPlantesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            const Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Image(
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        image: NetworkImage("https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg"),
                      ),
                      SizedBox(width: 16,),
                      Column(
                        children: [
                          Text("Plante 1"),
                          Text("20/10/2026"),
                          Text("Montpellier"),
                        ],
                      )
                    ],
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }



}



