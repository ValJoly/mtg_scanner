import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ocr_scan_text/ocr_scan_text.dart';

import 'scan_all_module.dart';

class OcrScan extends StatefulWidget {
  const OcrScan({super.key});

  @override
  State<OcrScan> createState() => _OcrScanState();
}

class _OcrScanState extends State<OcrScan> {
  var scanModules = [ScanAllModule()];

  bool scanning = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        // toggle scan process
        if (!scanning) {
          for (var element in scanModules) {
            element.start();
          }
          scanning = true;
        } else {
          for (var element in scanModules) {
            element.stop();
          }
          scanning = false;
        }
      }),
      body: Center(
          child: LiveScanWidget(
        scanModules: scanModules,
        ocrTextResult: scanResult,
        respectRatio: true,
      )),
    );
  }

  scanResult(OcrTextRecognizerResult ocrTextResult) {
    ocrTextResult.mapResult.forEach((module, result) {
      log('Module: ${module.label}');
      for (var element in result) {
        log('Text: ${element.cleanedText}');
        log('Element: ${element.text}');
      }
    });
  }
}
