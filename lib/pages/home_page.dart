import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtg_scanner/pages/collection.dart';
import 'package:mtg_scanner/pages/detect_edge.dart';
import 'package:mtg_scanner/pages/settings.dart';
import 'package:mtg_scanner/utils/collection_manager.dart';
import 'package:mtg_scanner/widgets/home_app_bar.dart';

class Home extends StatefulWidget {
  final int curentIndex;
  const Home({super.key, this.curentIndex = 0});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  int currentIndex = 0;
  List<Widget> pages = const [
    Collection(),
    DetectEdge(),
    Settings(),
  ];

  final _pageViewController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  @override
  void initState() {
    super.initState();
    currentIndex = widget.curentIndex;
    _pageViewController.addListener(() {
      currentIndex = _pageViewController.page!.round();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: const HomeAppBar(),
      floatingActionButton: FloatingActionButton(onPressed: () {
        bool canPop = context.canPop();
        log('Can pop: $canPop');
      }),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: RichText(
                text: TextSpan(
                  text: 'There are ',
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: '${CollectionManager.instance.collection.length}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const TextSpan(
                      text: ' cards in your collection',
                    ),
                  ],
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Collection'),
              trailing: const Icon(Icons.copy),
              onTap: () {
                currentIndex = 0;
                context.pop();
                context.replace('/collection');
                setState(() {});
              },
            ),
            ListTile(
              title: const Text('Search'),
              trailing: const Icon(Icons.search),
              onTap: () {
                currentIndex = 1;
                context.pop();
                context.replace('/search');
                setState(() {});
              },
            ),
          ],
        ),
      ),
      body: PageView(
        controller: _pageViewController,
        // index: curentIndex,
        children: pages,
        onPageChanged: (index) {
          currentIndex = index;
          setState(() {});
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index) {
          currentIndex = index;
          _pageViewController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          log('collection length: ${CollectionManager.instance.collection.length}');
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
