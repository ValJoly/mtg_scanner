import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/card_prints.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;

class CardDetails extends StatefulWidget {
  final mtg.Card card;
  const CardDetails(this.card, {super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  List<CardPrint> prints = [];
  Map<String, List<CardPrint>> printGroupsLang = {};
  var isBusy = false;

  var groupeValue = 'FR';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.printedName ?? widget.card.name),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(widget.card.imageUris.large),
              ),
            ),
            Text(widget.card.printedName ?? widget.card.name),
            ExpansionTile(
              title: const Text('Card Details'),
              children: [
                ListTile(
                  title: const Text('Type'),
                  subtitle: Text(widget.card.typeLine),
                ),
                ListTile(
                  title: const Text('Rarity'),
                  subtitle: Text(widget.card.rarity),
                ),
                ListTile(
                  title: const Text('Oracle Text'),
                  subtitle: Text(widget.card.oracleText ?? 'No Oracle Text'),
                ),
                ListTile(
                  title: const Text('Flavor Text'),
                  subtitle: Text(widget.card.flavorText ?? 'No Flavor Text'),
                ),
                ListTile(
                  title: const Text('Set'),
                  subtitle: Text(widget.card.setName),
                ),
                ListTile(
                  title: const Text('Collector Number'),
                  subtitle: Text(widget.card.collectorNumber),
                ),
                ListTile(
                  title: const Text('Artist'),
                  subtitle: Text(widget.card.artist),
                ),
              ],
              onExpansionChanged: (value) => HapticFeedback.mediumImpact(),
            ),
            ExpansionTile(
              title: const Text('Prints'),
              children: [
                printGroupsLang.isEmpty
                    ? const SizedBox()
                    : CupertinoSlidingSegmentedControl(
                        groupValue: groupeValue,
                        children: {
                          for (var lang in printGroupsLang.keys)
                            lang: Text(lang),
                        },
                        onValueChanged: (value) {
                          HapticFeedback.mediumImpact();
                          prints = printGroupsLang[value]!;
                          groupeValue = value!;
                          setState(() {});
                        }),
                isBusy == true
                    ? const CircularProgressIndicator()
                    : GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 0.6,
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (var print in prints)
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.mediumImpact();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    (print.imageUris == null ||
                                            print.imageUris!.normal == null)
                                        ? const Text(
                                            '🤷‍♀️',
                                            style: TextStyle(fontSize: 64),
                                          )
                                        : Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.network(
                                                  print.imageUris!.normal!,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: FloatingActionButton(
                                                  // small
                                                  mini: true,
                                                  onPressed: () {
                                                    HapticFeedback
                                                        .mediumImpact();
                                                    // log('Add to collection');
                                                    log(print.id ?? 'No ID');
                                                    searchCardById(print.id);
                                                  },
                                                  child: const Icon(Icons.add),
                                                ),
                                              ),
                                            ],
                                          ),
                                    Text(print.setName ?? 'No Set Name'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ],
              onExpansionChanged: (value) async {
                HapticFeedback.mediumImpact();
                if (value == true && prints.isEmpty) {
                  // get the prints
                  // print url : widget.card.printsSearchUri;
                  prints = await getPrints(widget.card.printsSearchUri);
                  if (printGroupsLang[groupeValue] == null) {
                    log('No prints for this language');
                    setState(() {});
                    return;
                  }
                  prints = printGroupsLang[groupeValue]!;
                  setState(() {});
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<CardPrint>> getPrints(String printsSearchUri) async {
    isBusy = true;
    setState(() {});
    // get the prints from the printsSearchUri
    http.Response response =
        await http.get(Uri.parse('$printsSearchUri&include_multilingual=true'));
    if (response.statusCode == 200) {
      isBusy = false;
      // log(response.body);
      List<CardPrint> tmp = CardPrints.fromRawJson(response.body).data;

      log('Grouping prints by language');
      log('Number of prints: ${tmp.length}');

      printGroupsLang = {};
      for (var print in tmp) {
        if (printGroupsLang[print.lang?.toUpperCase() ?? 'no lang'] == null) {
          printGroupsLang[print.lang?.toUpperCase() ?? 'no lang'] = [];
        }
        printGroupsLang[print.lang?.toUpperCase() ?? 'no lang']!.add(print);
      }

      // order map by key (language) with FR first and 'no lang' last
      printGroupsLang = Map.fromEntries(
        printGroupsLang.entries.toList()
          ..sort((a, b) {
            if (a.key == 'FR') {
              return -1;
            } else if (b.key == 'FR') {
              return 1;
            } else if (a.key == 'no lang') {
              return 1;
            } else if (b.key == 'no lang') {
              return -1;
            } else {
              return a.key.compareTo(b.key);
            }
          }),
      );

      return tmp;
    } else {
      isBusy = false;
      return [];
    }
  }

  Future<void> searchCardById(String? id) async {
    // search the card by id
    log('Searching card by id: $id');
    http.Response response =
        await http.get(Uri.parse('https://api.scryfall.com/cards/$id'));
    if (response.statusCode == 200) {
      // log(response.body);
      mtg.Card card = mtg.Card.fromRawJson(response.body);
      // add the card to the collection
      DBLogic().insertCard(mtg.CardQuantity(quantity: 1, card: card));
    }
  }
}
