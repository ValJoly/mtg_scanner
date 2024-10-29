import 'dart:developer';

import 'package:sembast/sembast.dart';

import '/database/database.dart';
import '../models/cards_list.dart';

class DBLogic {
  static String STORE = 'cards';
  Future<Database> get db async => await CardDB.instance.db;
  final _cards = intMapStoreFactory.store(STORE);

  Future insertCard(CardQuantity card) async {
    // Check if card already exists in the database, if so, update the quantity (add 1)
    final finder = Finder(
      filter: Filter.custom((record) {
        // log('beep boop: ${record.value}');
        if (record.value == null) {
          log('Record value is null');
          return false;
        }
        log('Record value is not null');
        // create a card quantity object from the record value
        var tmp2 = CardQuantity.fromJson(record.value as Map<String, dynamic>);
        log('card id: ${tmp2.card?.id}');
        return tmp2.card?.id == card.card?.id;
      }),
    );
    final snapshot = await _cards.findFirst(await db, finder: finder);
    if (snapshot != null) {
      log('Card already exists in the database, updating quantity');
      final cardQuantity = CardQuantity.fromJson(snapshot.value);
      cardQuantity.quantity += 1;
      await update(cardQuantity);
      return;
    } else {
      log('Card does not exist in the database, adding card');
      await _cards.add(await db, card.toJson());
    }
  }

  Future update(CardQuantity card) async {
    if (card.card?.id == null) {
      throw Exception('Cannot update card without id');
    }
    final finder = Finder(filter: Filter.custom((record) {
      // log('beep boop: ${record.value}');
      if (record.value == null) {
        log('Record value is null');
        return false;
      }
      log('Record value is not null');
      // create a card quantity object from the record value
      var tmp2 = CardQuantity.fromJson(record.value as Map<String, dynamic>);
      log('card id: ${tmp2.card?.id}');
      return tmp2.card?.id == card.card?.id;
    }));

    await _cards.update(
      await db,
      card.toJson(),
      finder: finder,
    );
  }

  Future delete(CardQuantity card) async {
    if (card.card?.id == null) {
      throw Exception('Cannot delete card without id');
    }
    final finder = Finder(
      filter: Filter.custom((record) {
        // log('beep boop: ${record.value}');
        if (record.value == null) {
          log('Record value is null');
          return false;
        }
        log('Record value is not null');
        // create a card quantity object from the record value
        var tmp2 = CardQuantity.fromJson(record.value as Map<String, dynamic>);
        log('card id: ${tmp2.card?.id}');
        return tmp2.card?.id == card.card?.id;
      }),
    );

    await _cards.delete(
      await db,
      finder: finder,
    );
  }

  Future deleteById(String id) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        // log('beep boop: ${record.value}');
        if (record.value == null) {
          log('Record value is null');
          return false;
        }
        log('Record value is not null');
        // create a card quantity object from the record value
        var tmp2 = CardQuantity.fromJson(record.value as Map<String, dynamic>);
        log('card id: ${tmp2.card?.id}');
        return tmp2.card?.id == id;
      }),
    );

    await _cards.delete(
      await db,
      finder: finder,
    );
  }

  Future<List<CardQuantity>> getAllCards() async {
    final snapshot = await _cards.find(await db);
    return snapshot.map((e) => CardQuantity.fromJson(e.value)).toList();
  }

  Future deleteAll() async {
    await _cards.delete(await db);
  }

  Future<CardQuantity?> getCardById(String id) async {
    final finder = Finder(
      filter: Filter.custom((record) {
        // log('beep boop: ${record.value}');
        if (record.value == null) {
          log('Record value is null');
          return false;
        }
        log('Record value is not null');
        // create a card quantity object from the record value
        var tmp2 = CardQuantity.fromJson(record.value as Map<String, dynamic>);
        log('card id: ${tmp2.card?.id}');
        return tmp2.card?.id == id;
      }),
    );
    final snapshot = await _cards.findFirst(await db, finder: finder);
    if (snapshot == null) {
      return null;
    }
    return CardQuantity.fromJson(snapshot.value);
  }

  Future<List<CardQuantity>> getCardsBySet(String set) async {
    final finder = Finder(
        filter: Filter.custom(
            (record) => (record.value as CardQuantity).card?.CardSet == set));
    final snapshot = await _cards.find(await db, finder: finder);
    return snapshot.map((e) => CardQuantity.fromJson(e.value)).toList();
  }
}
