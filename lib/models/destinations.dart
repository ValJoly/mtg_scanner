import 'package:flutter/material.dart';

class Destination {
  const Destination({
    required this.label,
    required this.icon,
  });
  final String label;
  final IconData icon;
}

const destinations = [
  Destination(label: 'Collection', icon: Icons.collections_bookmark_rounded),
  Destination(label: 'Search', icon: Icons.search),
  Destination(label: 'Settings', icon: Icons.settings),
];
