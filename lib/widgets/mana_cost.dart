import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget ManaCost(String manaCost) {
  List<Widget> manaCostWidgets = [];
  List<String> manaCosts = manaCost.split(RegExp(r'{|}'));
  manaCosts.removeWhere((element) => element.isEmpty);
  for (var element in manaCosts) {
    log(element);
    // change '/' to ':'
    element = element.replaceAll('/', ':');
    log(element);
    // check if elemeent exists in mana_costs folder

    manaCostWidgets.add(
      Container(
        padding: const EdgeInsets.only(top: 2, right: 1),
        child: SvgPicture.asset(
          'assets/icons/mana_costs/${element.toLowerCase()}.svg',
          width: 16,
          height: 16,
        ),
      ),
    );
  }
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: manaCostWidgets,
  );
}
