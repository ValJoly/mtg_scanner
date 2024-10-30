import 'package:flutter/material.dart';
import 'package:mtg_scanner/pages/collection.dart';
import 'package:mtg_scanner/pages/detect_edge.dart';
import 'package:mtg_scanner/pages/settings.dart';
import 'package:mtg_scanner/widgets/home_app_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  int curentIndex = 0;
  List<Widget> pages = const [
    Collection(),
    DetectEdge(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const HomeAppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Collection'),
              onTap: () {
                curentIndex = 0;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              title: const Text('Search'),
              onTap: () {
                curentIndex = 1;
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: curentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: curentIndex,
        onTap: (index) {
          curentIndex = index;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.copy),
            label: 'Collection',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
