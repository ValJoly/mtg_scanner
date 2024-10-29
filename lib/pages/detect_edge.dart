import 'dart:developer';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/widgets/list_tiles.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'scan_all_module.dart';

class DetectEdge extends StatefulWidget {
  const DetectEdge({super.key});

  @override
  State<DetectEdge> createState() => _DetectEdgeState();
}

class _DetectEdgeState extends State<DetectEdge>
    with AutomaticKeepAliveClientMixin {
  String? currentImageUri;

  String currentName = '';
  mtg.CardsList? resultCardsList;
  String? findImageUrl;

  bool isBusy = false;

  var selectedSegment = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
              heroTag: 'fullAuto',
              onPressed: fullAuto,
              child: const Icon(Icons.auto_awesome)),
          // const SizedBox(height: 16),
          // FloatingActionButton(
          //   heroTag: 'deleteImage',
          //   onPressed: () {
          //     setState(() {
          //       currentImageUri = null;
          //       currentName = '';
          //       findImageUrl = null;
          //     });
          //   },
          //   child: const Icon(Icons.delete_forever),
          // ),

          // FloatingActionButton(
          //   onPressed: () {
          //     http
          //         .get(Uri.parse(
          //             'https://api.scryfall.com/cards/search?q=Désinvocation&include_multilingual=true&pretty=true'))
          //         .then((response) {
          //       log('Response status: ${response.statusCode}');
          //       log('Response body: ${response.body}');
          //     });
          //   },
          //   child: const Icon(Icons.search),
          // ),
          // FloatingActionButton(
          //   heroTag: 'searchCard',
          //   onPressed: search,
          //   child: const Icon(Icons.search),
          // ),
          // const SizedBox(height: 16),
          // FloatingActionButton(
          //   heroTag: 'cropImageHalf',
          //   onPressed: cropImageHalf,
          //   child: const Icon(Icons.crop),
          // ),
          // const SizedBox(height: 16),
          // FloatingActionButton(
          //   onPressed: read,
          //   child: const Icon(Icons.document_scanner_rounded),
          // ),
          // const SizedBox(height: 16),
          // FloatingActionButton(
          //   heroTag: 'detectEdge',
          //   onPressed: doTheThing,
          //   child: const Icon(Icons.camera_alt_rounded),
          // ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 16,
              ),
              // segmented control to switch between small and big cards
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CupertinoSlidingSegmentedControl(
                        children: const {
                          0: Icon(Icons.list_alt_rounded),
                          1: Icon(Icons.image_outlined),
                        },
                        onValueChanged: (int? val) {
                          if (val == null) {
                            return;
                          }
                          selectedSegment = val;
                          setState(() {});
                        },
                        groupValue: selectedSegment,
                      ),
                    ),
                  ),
                ],
              ),
              cardList(
                context,
                resultCardsList?.data ?? [],
                small: selectedSegment == 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> doTheThing() async {
    // Check permissions and request its
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return;
    }

// Generate filepath for saving
    String imagePath = join((await getApplicationSupportDirectory()).path,
        "${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.jpeg");
    findImageUrl = null;
// Use below code for live camera detection with option to select from gallery in the camera feed.

    try {
      //Make sure to await the call to detectEdge.
      bool success = await EdgeDetection.detectEdge(
        imagePath,
        canUseGallery: true,
        androidScanTitle: 'Scanning', // use custom localizations for android
        androidCropTitle: 'Crop',
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
      if (success) {
        currentImageUri = imagePath;
        setState(() {});
        log(imagePath);
        // read();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> detectEdgeFromGalery(String imagePath) async {
    // Use below code for selecting directly from the gallery.

    try {
      //Make sure to await the call to detectEdgeFromGallery.
      bool success = await EdgeDetection.detectEdgeFromGallery(
        imagePath,
        androidCropTitle: 'Crop', // use custom localizations for android
        androidCropBlackWhiteTitle: 'Black White',
        androidCropReset: 'Reset',
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> read() async {
    // Use the imagePath to read text from the image with OcrScanText
    if (currentImageUri == null) {
      return;
    }
    log('Reading text from image: $currentImageUri');
    String text = '';
    var scanModules = [ScanAllModule()];
    OcrScanService(scanModules)
        .startScanProcess(File(currentImageUri!))
        .asStream()
        .listen((event) {
      // log(event?.mapResult.toString() ?? 'No result');
      event?.mapResult.forEach((module, result) {
        log('Module: ${module.label}');
        for (var element in result) {
          log('Text: ${element.cleanedText}');
          text += '${element.cleanedText} ';
        }
        log('Text: $text');
        // search for number in text and remove it and everything after
        var number = RegExp(r'\d+');
        var match = number.firstMatch(text);
        if (match != null) {
          text = text.substring(0, match.start);
        }

        currentName = text;
        for (var element in scanModules) {
          element.stop();
        }
      });
    });
    for (var element in scanModules) {
      element.start();
    }
    while (scanModules.any((element) => element.started)) {
      await Future.delayed(const Duration(milliseconds: 100));
      log('Waiting for scan to finish');
    }
    getApplicationSupportDirectory().then((value) {
      var dir = Directory(value.path);
      dir.list().listen((event) {
        if (event.path.endsWith('.jpeg') || event.path.endsWith('.jpg')) {
          log('Deleting: ${event.path}');
          event.delete();
        }
      });
    });
  }

  Future<void> cropImageHalf({
    String? imagePath,
  }) async {
    if (imagePath == null) {
      if (currentImageUri == null) {
        return;
      } else {
        imagePath = currentImageUri;
      }
    }
    log('Cropping image: $imagePath');
    var decodedImage =
        await decodeImageFromList(File(imagePath!).readAsBytesSync());
    print('decode width ${decodedImage.width}');
    print('decode height ${decodedImage.height}');

    // choose the smallest dimension and crop the otherone in half
    bool isWidthSmaller = decodedImage.width < decodedImage.height;

    final imageBytes = img.decodeImage(File(imagePath).readAsBytesSync())!;

    img.Image cropOne = img.copyCrop(
      imageBytes,
      x: 0,
      y: 0,
      width: isWidthSmaller ? decodedImage.width : decodedImage.width ~/ 5,
      height: isWidthSmaller ? decodedImage.height ~/ 5 : decodedImage.height,
    );
    print('cropOne width ${cropOne.width}');
    print('cropOne height ${cropOne.height}');

    // bool success = await img.encodeImageFile(imagePath, cropOne);
    // write the cropped image to a file
    // get path to right directory
    var pathToCrop = File(imagePath).parent;
    File('${pathToCrop.path}/_crop.jpg')
        .writeAsBytesSync(img.encodeJpg(cropOne));
    // check if the file was written
    if (File('${pathToCrop.path}/_crop.jpg').existsSync()) {
      currentImageUri = '${pathToCrop.path}/_crop.jpg';
      log('Cropped image: $currentImageUri');
      setState(() {});
    } else {
      log('Error writing file');
    }
  }

  Future<void> search() async {
    log('searching');
    http
        .get(Uri.parse(
            'https://api.scryfall.com/cards/search?q=$currentName&unique=cards&include_multilingual=true'))
        .then((response) {
      log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');

      mtg.CardsList cardsList = mtg.CardsList.fromRawJson(response.body);
      if (cardsList.data.isNotEmpty) {
        findImageUrl = cardsList.data.first.imageUris.large.toString();
        resultCardsList = cardsList;
        for (var element in cardsList.data) {
          log('Card name: ${element.name}');
          log('Card id: ${element.id}');
        }
        setState(() {});
      }
    });
  }

  Future<void> fullAuto() async {
    setState(() {
      isBusy = true;
      currentImageUri = null;
      findImageUrl = null;
      currentName = '';
    });
    await doTheThing();
    await cropImageHalf();
    await read();
    // await Future.delayed(const Duration(milliseconds: 700));
    await search();
    log('rssult card list length: ${resultCardsList!.data.length}');
    if (resultCardsList?.data.length == 1) {
      selectedSegment = 1;
      addToDB(resultCardsList!.data.first);
    }
    setState(() {
      isBusy = false;
    });
  }

  void addToDB(mtg.Card card) {
    log('Adding card to database');
    log('Card id: ${card.id}');

    // add card to database with a quantity of 1 or increment the quantity
    // use sembast to store the data
  }

  @override
  bool get wantKeepAlive => true;
}
