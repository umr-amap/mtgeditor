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
      ),
      body: Column(children: [
        Row(children: [
          Column(children: [
            Text('Templates'),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 5.0, color: Colors.white),
                ),
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    child: Container(
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        shape:
                        BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
          ),
        ],
        ),
        ListView(
          controller: _tabController,
          children: const <Widget>[
            TemplateView(),
            ProprietesView(),
            TopologieView(),
          ],
        ),
      ],)
    );
  }
}