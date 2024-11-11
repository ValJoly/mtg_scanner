import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/router/routes.dart';
import 'package:mtg_scanner/utils/collection_manager.dart';
import 'package:mtg_scanner/widgets/mana_cost.dart';

class CollectionCard extends StatefulWidget {
  const CollectionCard({
    super.key,
    required this.card,
  });

  final mtg.CardQuantity card;

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 137, 66, 158),
                      Color.fromARGB(255, 137, 66, 158),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: const Icon(
                            Icons.remove_outlined,
                            color: Colors.white,
                          ),
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            // Decrease the quantity of the card
                            widget.card.quantity--;

                            // Update the card in the database
                            DBLogic().update(widget.card);
                            if (widget.card.quantity == 0) {
                              // Delete the card from the database
                              CollectionManager.instance
                                  .removeCard(widget.card);
                            }
                            // Update the UI
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.card.quantity.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child: const Icon(
                            Icons.add_outlined,
                            color: Colors.white,
                          ),
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            // Increase the quantity of the card
                            widget.card.quantity++;
                            // Update the card in the database
                            DBLogic().update(widget.card);
                            // Update the UI
                            setState(() {});
                          },
                        ),
                      ],
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
            child: GestureDetector(
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
              onTap: () async {
                HapticFeedback.mediumImpact();
                // Delete the card from the database
                await DBLogic().delete(widget.card.card!);
                // Update the UI
                await CollectionManager.instance.removeCard(widget.card);
                setState(() {});
              },
            ),
          ),
        ],
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: ListTile(
          leading: Image.network(widget.card.card?.imageUris.normal ?? ''),
          title: Text(
              widget.card.card?.printedName ?? widget.card.card?.name ?? ''),
          subtitle: Text('Quantity: ${widget.card.quantity}'),
          trailing: ManaCost(widget.card.card?.manaCost ?? ''),
          onTap: () {
            // vibrate the device to give feedback
            HapticFeedback.mediumImpact();

            // go to the card details page
            context.push(Routes.cardDetails, extra: widget.card.card);
          },
        ),
      ),
    );
  }
}
