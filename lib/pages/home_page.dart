import 'package:flutter/material.dart';
import 'package:mtg_scanner/pages/collection.dart';
import 'package:mtg_scanner/pages/detect_edge.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
        ],
      ),
      body: pages[curentIndex],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
