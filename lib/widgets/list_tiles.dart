import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/router/routes.dart';
import 'package:mtg_scanner/utils/collection_manager.dart';
import 'package:mtg_scanner/widgets/mana_cost.dart';

Widget smallcardListTile(BuildContext context, mtg.Card card) {
  return Slidable(
    startActionPane: ActionPane(
      // A motion is a widget used to control how the pane animates.
      motion: const ScrollMotion(),
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF99CC),
                    Color(0xFFFF99CC),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),

    // The end action pane is the one at the right or the bottom side.
    endActionPane: ActionPane(
      motion: const ScrollMotion(),
      children: [
        Expanded(
          child: InkWell(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFC15471),
                      Color(0xFFC15471),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              print("balalal~~~");
            },
          ),
        ),
      ],
    ),
    child: Card(
      // border radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(card.printedName ?? card.name),
        subtitle: ManaCost(card.manaCost),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(2.0),
          child: Image.network(card.imageUris.normal),
        ),
        trailing: GestureDetector(
          child: const Icon(Icons.add_circle_outline_rounded),
          onTap: () async {
            print("Add to collection");
            // vibrate the device when the card is added to the collection to give feedback
            HapticFeedback.mediumImpact();
            // add the card to the database
            await DBLogic()
                .insertCard(mtg.CardQuantity(quantity: 1, card: card));
            CollectionManager.instance
                .addCard(mtg.CardQuantity(quantity: 1, card: card));
            // update the collection
            // await CollectionManager.instance.getCollection();
          },
        ),
        onTap: () {
          HapticFeedback.mediumImpact();
          context.push(Routes.cardDetails, extra: card);
        },
      ),
    ),
  );
}

Widget bigcardWidget(BuildContext context, mtg.Card card) {
  return Card(
    margin: const EdgeInsets.all(16),
    // elevation: 4,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(card.imageUris.normal),
            ),
            Text(
              card.printedName ?? card.name,
              textAlign: TextAlign.left,
            ),
            ManaCost(card.manaCost),
            Text(card.typeLine),
            Text(card.oracleText ?? ''),
          ],
        ),
        onTap: () {
          HapticFeedback.mediumImpact();
          // navigate to the card details page
          context.push(Routes.cardDetails, extra: card);
        },
      ),
    ),
  );
}

Widget cardList(List<mtg.Card> cards, {bool small = true}) {
  // return a list of cards with the choice to show a small or big card
  return Expanded(
    child: ListView.builder(
      itemCount: cards.length,
      itemBuilder: (context, index) {
        return small
            ? smallcardListTile(context, cards[index])
            : bigcardWidget(context, cards[index]);
      },
    ),
  );
}
