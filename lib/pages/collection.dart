import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/pages/card_details.dart';
import 'package:mtg_scanner/widgets/collection_card.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  var collection = <mtg.CardQuantity>[];

  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isBusy == true
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: collection.length,
                itemBuilder: (context, index) {
                  final card = collection[index];
                  return InkWell(
                    child: CollectionCard(card: card),
                    onTap: () {
                      // vibrate the device to give feedback
                      HapticFeedback.mediumImpact();
                      // go to the card details page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return CardDetails(card.card!);
                        }),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  // Add a method to get the collection from the database
  Future<void> getCollection() async {
    isBusy = true;
    setState(() {});
    // Get the collection from the database
    final collection = await DBLogic().getAllCards();
    // Do something with the collection
    setState(() {
      this.collection = collection;
      isBusy = false;
    });
  }
}
