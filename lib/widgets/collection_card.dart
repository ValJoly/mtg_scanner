import 'package:flutter/material.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/widgets/mana_cost.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.card,
  });

  final mtg.CardQuantity card;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: Image.network(card.card?.imageUris.normal ?? ''),
        title: Text(card.card?.name ?? ''),
        subtitle: Text('Quantity: ${card.quantity}'),
        trailing: ManaCost(card.card?.manaCost ?? ''),
      ),
    );
  }
}
