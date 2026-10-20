import 'package:flutter/material.dart';

/// Flutter code sample for [TabBar].

void main() => runApp(const TabBarApp());

class TabBarApp extends StatelessWidget {
  const TabBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: TabBarExample());
  }
}

class TabBarExample extends StatefulWidget {
  const TabBarExample({super.key});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _TabBarExampleState extends State<TabBarExample>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        actions: [Padding(padding: EdgeInsetsGeometry.directional(end:25.0), child: const Icon(Icons.close,))],
        bottom: TabBar(
          dividerColor: Colors.transparent,
          controller: _tabController,
          tabs: const <Widget>[
            Tab(text: 'Templates',),
            Tab(text: 'Propriétés'),
            Tab(text: 'Topologie',),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          TemplateView(),
          ProprietesView(),
          TopologieView(),
        ],
      ),
    );
  }
}