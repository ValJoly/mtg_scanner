import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:mtg_scanner/database/database.dart';
import 'package:mtg_scanner/database/logic.dart';
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:permission_handler/permission_handler.dart';

import '../database/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _bulkImportController = TextEditingController();

  bool isBusyBulkImport = false;
  double progress = 0.0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              // export collection to file
              ListTile(
                title: const Text('Choose sync location'),
                trailing: const Icon(Icons.upload_file),
                onTap: syncPath,
              ),
              // import collection from file
              ListTile(
                title: const Text('Import collection'),
                trailing: const Icon(Icons.download_rounded),
                onTap: importDB,
              ),
              ListTile(
                title: const Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bullk load'),
                    Text(
                      'Format : X name (SET) number',
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
                // text box in subtitle
                subtitle: SizedBox(
                  height: 200,
                  child: CupertinoTextField(
                    controller: _bulkImportController,
                    maxLines: null, // Set this
                    expands: true, // and this
                    keyboardType: TextInputType.multiline,
                    placeholder: '1 card name (SET) number',
                    clearButtonMode: OverlayVisibilityMode.always,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                trailing: const Icon(Icons.search),
                onTap: () {
                  log('Search print by collector number');
                  // open
                },
              ),
              ListTile(
                title: const Text('search'),
                onTap: () {
                  _parseData(_bulkImportController.text);
                },
              ),
              ListTile(
                title: const Text('Clear collection',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Clear collection'),
                        content: const Text(
                            'Are you sure you want to clear your collection?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Annuler'),
                          ), // cancel
                          TextButton(
                            onPressed: () {
                              context.pop();
                              DBLogic().deleteAll();
                            },
                            child: const Text('Confirmer'),
                          ), // confirm
                        ],
                      );
                    },
                  );
                },
                trailing: const Icon(Icons.delete, color: Colors.red),
              ),
            ],
          ),
          if (isBusyBulkImport)
            Container(
              color: Colors.black.withOpacity(0.1),
            ),
          if (isBusyBulkImport)
            Center(
              child: LinearProgressIndicator(
                // progress bar
                value: progress,
              ),
            )
        ],
      ),
    );
  }

  Future<void> syncPath() async {
    var storageStatus = await Permission.storage.status;
    if (storageStatus != PermissionStatus.granted) {
      storageStatus = await Permission.storage.request();
      if (storageStatus != PermissionStatus.granted) {
        return;
      }
    }
    log('Exporting collection');
    log('Storage permission status: $storageStatus');

    // final Directory appDocumentsDir =
    //     await getApplicationDocumentsDirectory();

    // log(appDocumentsDir.path);
    // copyCollectionTo(appDocumentsDir.path);

    // var syncPath = await FilePicker.platform.getDirectoryPath();
    // if (syncPath == null) {
    //   return;
    // }
    log('Selected sync path: $syncPath');
    await FilePicker.platform.saveFile(
      dialogTitle: 'Save collection',
      fileName: 'mtg_card.db',
      bytes: File((await CardDB.instance.db).path).readAsBytesSync(),
      // type: FileType.custom,
      // allowedExtensions: ['db'],
    );
  }

  Future<void> importDB() async {
    FilePickerResult? dpath = await FilePicker.platform.pickFiles();
    if (dpath == null) {
      return;
    }
    if (dpath.files.isEmpty) {
      return;
    }
    if (dpath.files.first.path == null) {
      return;
    }
    log('Selected file path: ${dpath.files.first.path}');

    // store the path in shared preferences
    SharedPrefs.instance.setSyncPath(dpath.files.first.path!);
  }

  Future<void> _parseData(String bulkData) async {
    final List<mtg.CardQuantity> bulkCardList = [];
    List<String> notFound = [];
    progress = 0.0;
    isBusyBulkImport = true;
    setState(() {});

    // get line number in bulkData
    int count = bulkData.split('\n').length;
    log('Line count: $count');
    var invalidLines = 0;
    for (var line in bulkData.split('\n')) {
      // split line by space
      List<String> parts = line.split(' ');
      if (parts.length < 3) {
        log('Invalid line: $line');
        invalidLines++;
        continue;
      }
      // get quantity
      var quantity = parts[0];
      // get card name
      String name = parts.sublist(1, parts.length - 2).join(' ');
      // log('Name: $name');
      // get set
      String set = parts[parts.length - 2];
      // remove brackets
      set = set.substring(1, set.length - 1);
      // log('Set: $set');
      // get number
      String collectorNumber = parts[parts.length - 1];
      // log('Number: $collectorNumber');
      // add a third of a step to progress
      progress += 1 / count / 3;
      if (progress > 1) {
        progress = 1;
      }
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 100));
      // search for card
      _searchCardAsync(
        name,
        set,
        collectorNumber,
      ).then((card) {
        if (card != null) {
          bulkCardList.add(
            mtg.CardQuantity(
              quantity: int.parse(quantity),
              card: card,
            ),
          );
        } else {
          notFound.add(line);
        }

        // add a third of a step to progress
        progress += 2 / count / 3;
        if (progress > 1) {
          progress = 1;
        }
        setState(() {});
      });
    }
    log('count: $count');
    while ((bulkCardList.length + notFound.length) < (count - invalidLines)) {
      log('Waiting for requests to finish');
      await Future.delayed(const Duration(milliseconds: 100));
      log(
        'Bulk card list length: ${bulkCardList.length}'
        'Not found length: ${notFound.length}',
      );
    }
    isBusyBulkImport = false;
    setState(() {});
    // show dialog with number of cards found
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bulk import'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                Text('Found ${bulkCardList.length} cards \n'),
                if (notFound.isNotEmpty)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Failed to load the following cards:\n',
                        style: TextStyle(color: Colors.red),
                      ),
                      for (var card in notFound) Text('- $card'),
                    ],
                  ),
                const Text('\nDo you want to add them to your collection?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
                addCardsToDB(bulkCardList);
              },
              child: const Text('Ajouter'),
            ), // add
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Annuler'),
            ), // cancel
          ],
        );
      },
    );
  }

  Future<mtg.Card?> _searchCardAsync(
    String name,
    String set,
    String number,
  ) async {
    var response = await http.get(
      Uri.parse(
        'https://api.scryfall.com/cards/named?fuzzy=$name&set=$set',
      ),
    );
    if (response.statusCode == 200) {
      try {
        var card = mtg.Card.fromRawJson(response.body);
        var setNumberLangResponse = await http.get(
          Uri.parse(
            'https://api.scryfall.com/cards/${set.toLowerCase()}/${number.toLowerCase()}/${card.lang.toLowerCase()}',
          ),
        );
        if (setNumberLangResponse.statusCode == 200) {
          var card = mtg.Card.fromRawJson(setNumberLangResponse.body);
          return card;
        } else {
          log('Failed to load card: $name');
          log('Response: ${setNumberLangResponse.body}');
          return null;
        }
      } catch (e) {
        log('Failed to parse card: $name');
        log('Response: ${response.body}');
        log('Error paring mtg.card', error: e);

        return null;
      }
    } else {
      log('Failed to load card: $name');
      log('Response: ${response.body}');
      return null;
    }
  }

  Future<void> addCardsToDB(List<mtg.CardQuantity> cards) async {
    isBusyBulkImport = true;
    progress = 0.0;
    setState(() {});
    for (var card in cards) {
      await DBLogic().insertCard(card);
      progress += 1 / cards.length;
      if (progress > 1) {
        progress = 1;
      }
      setState(() {});
    }
    isBusyBulkImport = false;
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
}
