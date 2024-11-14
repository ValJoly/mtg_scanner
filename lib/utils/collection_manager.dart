import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/cards_list.dart';

class CollectionManager {
  // singleton
  CollectionManager._internal();
  static CollectionManager get instance => _singleton;
  static final CollectionManager _singleton = CollectionManager._internal();

  ValueNotifier<List<CardQuantity>> collectionNotifier = ValueNotifier([]);

  List<CardQuantity> get collection => collectionNotifier.value;

  int get collectionUniqueSize => collectionNotifier.value.length;
  int get collectionTotalSize => collectionNotifier.value
      .fold<int>(0, (prev, element) => prev + element.quantity);

  /// Add a method to remove a card from the collection
  /// if a context is provided, show a snackbar with the message 'Card removed from collection'
  Future<void> removeCard(CardQuantity card, {BuildContext? context}) async {
    log('Removing card from collection');
    // Update the collectionNotifier
    collectionNotifier.value = collectionNotifier.value
        .where((element) => element.card.id != card.card.id)
        .toList();
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Card removed from collection'),
        ),
      );
    }
  }

  /// Add a method to get the collection from the database
  /// if the context is provided, show a snackbar with the message 'Collection updated'
  Future<void> getCollection() async {
    log('Getting collection from database');
    // Get the collection from the database
    final collection = await DBLogic().getAllCards();

    // Update the collectionNotifier
    collectionNotifier.value = collection;
  }

  /// Add a method to add a card to the collection
  /// Update the collectionNotifier
  /// if the context is provided, show a snackbar with the message 'Card added to collection'
  void addCard(CardQuantity cardQuantity) {
    log('Adding card to collection');
    // verify if the card is already in the collection
    final cardIndex = collectionNotifier.value.indexWhere(
      (element) => element.card.id == cardQuantity.card.id,
    );
    if (cardIndex != -1) {
      // if the card is already in the collection, increase the quantity
      collectionNotifier.value[cardIndex].quantity += cardQuantity.quantity;
    } else {
      // if the card is not in the collection, add it
      collectionNotifier.value.add(cardQuantity);
    }
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    collectionNotifier.notifyListeners();
  }
}
