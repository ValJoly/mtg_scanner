import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mtg_scanner/detect_edge.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scryfall_api/scryfall_api.dart';

import 'ocr_scan.dart';

void main() {
  runApp(const MaterialApp(home: MainApp()));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  var currentImage;
  String? currentImageUri;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'detectEdge',
              onPressed: detectEdge,
              child: const Icon(Icons.camera_alt_rounded),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'scanCard',
              onPressed: scanCard,
              child: const Icon(Icons.image_search_rounded),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'requestCard',
              onPressed: requestCard,
              child: const Icon(Icons.file_download_outlined),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              currentImage != null
                  ? Image.memory(currentImage)
                  : currentImageUri != null
                      ? Image.network(currentImageUri!)
                      : Container(),
              const Text('beep boop!'),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> requestCard() async {
    final apiClient = ScryfallApiClient();
    apiClient.getCardByNameAsImage('Lightning Bolt').then((value) {
      setState(() {
        // currentImage = value;
      });
    });
    try {
      MtgCard card = await apiClient.getCardByName(
        'emrakul le monde',
        searchType: SearchType.fuzzy,
      );

      log('${card.cmc} - ${card.keywords}');
      log('${card.name} - ${card.imageUris?.borderCrop}');
      currentImageUri = card.imageUris?.large.toString();
      setState(() {});
    } catch (e) {
      log((e as ScryfallException).details);
    }
  }

  Future<void> scanCard() async {
    // ask for camera permission
    var status = await Permission.camera.status;
    log('Permission status: $status');
    if (!status.isGranted) {
      var permission = await Permission.camera.request();

      if (!permission.isGranted) {
        log('Permission not granted');
        log('Permission status: $permission');
        return;
      }
    }

    // open Live OCR Scanner
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const OcrScan()));
  }

  void detectEdge() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetectEdge()),
    );
  }
}
