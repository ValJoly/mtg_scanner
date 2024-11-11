import 'dart:developer';
import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mtg_scanner/models/cards_list.dart' as mtg;
import 'package:mtg_scanner/widgets/list_tiles.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/scan_all_module.dart';

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
  String? currentBottomImageUri;

  bool isBusy = false;

  var selectedSegment = 0;

  String? currentSetName;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'fullAuto',
            onPressed: isBusy ? null : () => fullAuto(context),
            child: const Icon(Icons.auto_awesome),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoTextField(
                  enabled: false,
                  placeholder: 'Search for card (Not yet implemented)',
                  controller: TextEditingController(text: currentName),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
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
                resultCardsList?.data ?? [],
                small: selectedSegment == 0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> doTheThing() async {
    // Check permissions and request its
    bool isCameraGranted = await Permission.camera.request().isGranted;
    if (!isCameraGranted) {
      isCameraGranted =
          await Permission.camera.request() == PermissionStatus.granted;
    }

    if (!isCameraGranted) {
      // Have not permission to camera
      return false;
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
        return true;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
    return false;
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
    log('Scan name finished');

    if (currentBottomImageUri == null) {
      return;
    }
    log('Reading text from image: $currentImageUri');
    String bottomText = '';
    scanModules.clear();
    scanModules = [ScanAllModule()];
    OcrScanService(scanModules)
        .startScanProcess(File(currentBottomImageUri!))
        .asStream()
        .listen((event) {
      // log(event?.mapResult.toString() ?? 'No result');
      event?.mapResult.forEach((module, result) {
        log('Module: ${module.label}');
        for (var element in result) {
          log('Text: ${element.cleanedText}');
          bottomText += '${element.cleanedText} ';
        }
        log('Text: $bottomText');
        // search for number in text and remove it and everything after
        // var number = RegExp(r'\d+');
        // var match = number.firstMatch(text);
        // if (match != null) {
        //   bottomText = bottomText.substring(0, match.start);
        // }

        currentSetName = bottomText;
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

  Map<String, dynamic> getBottomScanResult(String bottomText) {
    // format : U0118 FDN • FR or U0118 FDN FR or U0118 FDN . FR or U0118 FDN * FR

    // remove • or . or * from the text
    bottomText = bottomText.replaceAll(RegExp(r'[•\.\*]'), '');

    // split by space
    var split = bottomText.split(' ');
    // remove empty strings
    split.removeWhere((element) => element.isEmpty);
    // // remove special characters
    // split = split.map((e) => e.replaceAll(RegExp(r'[^\w\s]'), '')).toList();

    // separate the set code name from the collector number from the language
    // set code name is always 3 characters
    // language is always 2 characters
    // collector number is 4 digits may have leading zeros and may have a letter at the start that need to be remove

    // get the last element which is the language
    var language = split.last;
    // remove the language from the list
    split.removeLast();
    // get the set code name
    var setCode = split.last;
    // remove the set code name from the list
    split.removeLast();
    // get the collector number
    var collectorNumber = split.join('');
    // remove spaces
    collectorNumber = collectorNumber.replaceAll(RegExp(r'\s+'), '');
    // remove leading non digits
    collectorNumber = collectorNumber.replaceAll(RegExp(r'^\D+'), '');
    // remove trailing non digits
    collectorNumber = collectorNumber.replaceAll(RegExp(r'\D+$'), '');
    // remove things after / if any
    collectorNumber = collectorNumber.split('/').first;
    return {
      'language': language,
      'setCode': setCode,
      'collectorNumber': collectorNumber,
    };
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
    cropBottomLeftCorner(imagePath: imagePath);
  }

  Future<void> cropBottomLeftCorner({String? imagePath}) async {
    if (imagePath == null) {
      if (currentBottomImageUri == null) {
        return;
      } else {
        imagePath = currentBottomImageUri;
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
      y: isWidthSmaller
          ? (decodedImage.height ~/ 10) * 9
          : (decodedImage.height ~/ 4) * 3,
      width:
          isWidthSmaller ? decodedImage.width ~/ 5 : decodedImage.width ~/ 10,
      height:
          isWidthSmaller ? decodedImage.height ~/ 10 : decodedImage.height ~/ 5,
    );
    print('cropOne width ${cropOne.width}');
    print('cropOne height ${cropOne.height}');

    // bool success = await img.encodeImageFile(imagePath, cropOne);
    // write the cropped image to a file
    // get path to right directory
    var pathToCrop = File(imagePath).parent;
    File('${pathToCrop.path}/_cropBottom.jpg')
        .writeAsBytesSync(img.encodeJpg(cropOne));
    // check if the file was written
    if (File('${pathToCrop.path}/_cropBottom.jpg').existsSync()) {
      currentBottomImageUri = '${pathToCrop.path}/_cropBottom.jpg';
      log('Cropped image: $currentBottomImageUri');
      setState(() {});
    } else {
      log('Error writing file');
    }
  }

  Future<void> search(BuildContext context) async {
    log('searching');
    Map<String, dynamic> bottomLeftScanResult =
        getBottomScanResult(currentSetName!);
    // check if collector number is only digits

    // check if set code is 3 characters long
    // check if language is 2 characters long
    if (!(RegExp(r'\D').hasMatch(bottomLeftScanResult['collectorNumber']) ||
        bottomLeftScanResult['setCode'].length != 3 ||
        bottomLeftScanResult['language'].length != 2)) {
      log('Scan result : $bottomLeftScanResult');
      // we are good to go with the search
      // /cards/:code/:number(/:lang)
      // remove leading zeros from collector number
      var collectorNumber = bottomLeftScanResult['collectorNumber'];
      bottomLeftScanResult['collectorNumber'] =
          collectorNumber.replaceAll(RegExp(r'^0+'), '');

      var uri = Uri.parse(
        'https://api.scryfall.com/cards/${bottomLeftScanResult['setCode'].toString().toLowerCase()}/${bottomLeftScanResult['collectorNumber']}/${bottomLeftScanResult['language'].toString().toLowerCase()}',
      );
      log('Uri: $uri');
      http.get(uri).then((response) {
        log('Response status: ${response.statusCode}');
        // log('Response body: ${response.body}');

        if (response.statusCode == 200) {
          mtg.Card card = mtg.Card.fromRawJson(response.body);
          findImageUrl = card.imageUris.large.toString();
          currentName = card.name;
          setState(() {});
          log('Find card from scan: ${uri.toString()}');
          return;
        }
      });
    } else {}

    http
        .get(Uri.parse(
            'https://api.scryfall.com/cards/search?q=$currentName&unique=cards&include_multilingual=true'))
        .then((response) {
      log('Response status: ${response.statusCode}');
      // log('Response body: ${response.body}');

      if (response.statusCode != 200) {
        // show error message to user
        context.push(
          '/show_dialog/Error/Failed to search card',
        );
        return;
      }
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

  Future<void> fullAuto(BuildContext context) async {
    setState(() {
      isBusy = true;
      currentImageUri = null;
      findImageUrl = null;
      currentName = '';
    });
    bool success = await doTheThing();
    if (!success) {
      setState(() {
        isBusy = false;
      });
      return;
    }
    await cropImageHalf();
    await read();
    if (currentName.isEmpty) {
      setState(() {
        isBusy = false;
      });
      return;
    }
    if (currentSetName != null) {
      log('currentSetName: ${getBottomScanResult(currentSetName!)}');
    }

    await search(context);
    log('result card list length: ${resultCardsList?.data.length}');
    if (resultCardsList?.data.length == 1) {
      selectedSegment = 1;
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  bool get wantKeepAlive => true;
}
