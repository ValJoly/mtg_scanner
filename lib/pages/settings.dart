import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mtg_scanner/database/database.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
}
