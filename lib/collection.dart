import 'package:flutter/material.dart';
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/cards_list.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection> {
  var collection = <CardQuantity>[];

  bool isBusy = false;

  @override
  void initState() {
    super.initState();
    getCollection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              await DBLogic()
                  .deleteById('4de03000-796a-44cc-bdba-2328fe2445ac');
              getCollection();
            },
            child: const Icon(Icons.delete_rounded),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              await DBLogic().deleteAll();
              getCollection();
            },
            child: const Icon(Icons.delete_forever_rounded),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () async {
              var card = await DBLogic()
                  .getCardById('4de03000-796a-44cc-bdba-2328fe2445ac');
              print(card?.card?.name);
            },
            child: const Icon(Icons.get_app_rounded),
          ),
        ],
      ),
      body: Center(
        child: isBusy == true
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: collection.length,
                itemBuilder: (context, index) {
                  final card = collection[index];
                  if (card.card == null) {
                    return null;
                  }
                  return ListTile(
                    leading: Image.network(card.card!.imageUris.normal),
                    title: Text(card.card?.name ?? ''),
                    subtitle: Text('Quantity: ${card.quantity}'),
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
