import 'package:flutter/material.dart';

import '../database/database.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  String? dbPath;

  @override
  void initState() {
    super.initState();

    CardDB.instance.db.then((value) {
      setState(() {
        dbPath = value.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('MTG Scanner'),
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
