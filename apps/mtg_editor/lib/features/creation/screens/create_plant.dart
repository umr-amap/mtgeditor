import 'package:material_ui/material_ui.dart';

import '../widgets/template.dart';
import '../widgets/propriete.dart';

void main() => runApp(const PlantCreateApp());

class PlantCreateApp extends StatelessWidget {
  const PlantCreateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarScreen();
  }
}

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key, this.onBackToPlants});

  final void Function()? onBackToPlants;

  @override
  State<TabBarScreen> createState() => _TabBarState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _TabBarState extends State<TabBarScreen> {
  int _selectedTab = 0;

  void _goToNextTab() {
    if (_selectedTab < 2) {
      setState(() {
        _selectedTab++;
      });
    }
  }

  void _goToPreviousTab() {
    if (_selectedTab > 0) {
      setState(() {
        _selectedTab--;
      });
      return;
    } else {
      if (widget.onBackToPlants != null) {
        widget.onBackToPlants!();
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _goToPreviousTab,
        ),
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 25.0),
            child: IconButton(
              onPressed: () {
                if (widget.onBackToPlants != null) {
                  widget.onBackToPlants!();
                } else {
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.close),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: [
                  _buildTab(label: 'Templates', index: 0),
                  _buildTab(label: 'Propriétés', index: 1),
                  _buildTab(label: 'Topologie', index: 2),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: IndexedStack(
                index: _selectedTab,
                children: [
                  TemplateView(onContinue: _goToNextTab),
                  ProprieteView(onContinue: _goToNextTab),
                  Center(
                    child: Text('La topologie sera disponible prochainement.'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required int index}) {
    final isSelected = _selectedTab == index;
    final isActive = index <= _selectedTab;
    final color = isActive ? const Color(0xFF9B75B5) : Colors.grey.shade300;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF8D5DAF) : Colors.grey,
                ),
              ),
              const SizedBox(height: 6.0),
              SizedBox(
                height: 8.0,
                width: double.infinity,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
