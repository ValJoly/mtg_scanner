import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mtg_scanner/utils/collection_manager.dart';
import 'package:mtg_scanner/widgets/collection_card.dart';

class Collection extends StatefulWidget {
  const Collection({super.key});

  @override
  State<Collection> createState() => _CollectionState();
}

class _CollectionState extends State<Collection>
    with AutomaticKeepAliveClientMixin {
  final _collectionSearchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await CollectionManager.instance.getCollection();
      setState(() {});
      CollectionManager.instance.collectionNotifier.addListener(() {
        log('Collection updated, new length: ${CollectionManager.instance.collection.length}');

        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    CollectionManager.instance.collectionNotifier.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: CupertinoTextField(
                placeholder: 'Search in collection (Not yet implemented)',
                controller: _collectionSearchTextController,
                clearButtonMode: OverlayVisibilityMode.editing,
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                bottom: 8.0,
                right: 16.0,
              ),
              child: Text(
                'Uniques : ${CollectionManager.instance.collectionUniqueSize}\nTotal       : ${CollectionManager.instance.collectionTotalSize}',
              ),
            ),
            Expanded(
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  HapticFeedback.mediumImpact();
                  await CollectionManager.instance.getCollection();
                  setState(() {});
                },
                child: Scrollbar(
                  child: ListView.builder(
                    itemCount: _collectionSearchTextController.text.isEmpty
                        ? CollectionManager.instance.collection.length
                        : CollectionManager.instance.collection
                            .where((element) {
                            // filter the collection based on the search text in the card name, printedName, oracleText, set name or collector number
                            final card = element.card;
                            if (card == null) {
                              return false;
                            }
                            return card
                                    .name
                                    .toLowerCase()
                                    .contains(
                                        _collectionSearchTextController
                                            .text
                                            .toLowerCase()) ||
                                (card.printedName ?? '').toLowerCase().contains(_collectionSearchTextController
                                    .text
                                    .toLowerCase()) ||
                                (card
                                            .oracleText ??
                                        '')
                                    .toLowerCase()
                                    .contains(
                                        _collectionSearchTextController
                                            .text
                                            .toLowerCase()) ||
                                card.setName.toLowerCase().contains(
                                    _collectionSearchTextController.text
                                        .toLowerCase()) ||
                                card.collectorNumber.toLowerCase().contains(
                                    _collectionSearchTextController.text
                                        .toLowerCase());
                          }).length,
                    itemBuilder: (context, index) {
                      final card = _collectionSearchTextController.text.isEmpty
                          ? CollectionManager.instance.collection[index]
                          : CollectionManager.instance.collection
                              .where((element) {
                              final card = element.card;
                              if (card == null) {
                                return false;
                              }
                              return card
                                      .name
                                      .toLowerCase()
                                      .contains(
                                          _collectionSearchTextController
                                              .text
                                              .toLowerCase()) ||
                                  (card.printedName ?? '').toLowerCase().contains(
                                      _collectionSearchTextController
                                          .text
                                          .toLowerCase()) ||
                                  (card
                                              .oracleText ??
                                          '')
                                      .toLowerCase()
                                      .contains(
                                          _collectionSearchTextController
                                              .text
                                              .toLowerCase()) ||
                                  card.setName.toLowerCase().contains(
                                      _collectionSearchTextController.text
                                          .toLowerCase()) ||
                                  card.collectorNumber.toLowerCase().contains(
                                      _collectionSearchTextController.text
                                          .toLowerCase());
                            }).elementAt(index);
                      return CollectionCard(
                        card: card,
                      );
                    },
                    // dismiss the keyboard when scrolling
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
