import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mtg_scanner/models/cards_list.dart' as mtg;

class CardDetails extends StatefulWidget {
  final mtg.Card card;
  const CardDetails(this.card, {super.key});

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  List<mtg.Card> prints = [];

  var isBusy = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.card.name),
      ),
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(widget.card.imageUris.large),
            ),
            Text(widget.card.name),
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
            ),
            ExpansionTile(
              title: const Text('Prints'),
              children: [
                isBusy == true
                    ? const CircularProgressIndicator()
                    : GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: 0.6,
                        crossAxisCount: 2,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          for (var print in prints)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  Image.network(
                                    print.imageUris.normal,
                                    fit: BoxFit.fitHeight,
                                  ),
                                  Text(print.setName),
                                ],
                              ),
                            ),
                        ],
                      ),
              ],
              onExpansionChanged: (value) async {
                if (value == true && prints.isEmpty) {
                  // get the prints
                  // print url : widget.card.printsSearchUri;

                  prints = await getPrints(widget.card.printsSearchUri);
                  setState(() {});
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<List<mtg.Card>> getPrints(String printsSearchUri) async {
    isBusy = true;
    // get the prints from the printsSearchUri
    http.Response response = await http.get(Uri.parse(printsSearchUri));
    if (response.statusCode == 200) {
      isBusy = false;
      return mtg.CardsList.fromRawJson(response.body).data;
    } else {
      isBusy = false;
      return [];
    }
  }
}
