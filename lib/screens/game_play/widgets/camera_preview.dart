// This file is part of Parlera.
//
// Parlera is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version. As an additional permission under
// section 7, you are allowed to distribute the software through an app
// store, even if that store has restrictive terms and conditions that
// are incompatible with the AGPL, provided that the source is also
// available under the AGPL with or without this permission through a
// channel without those restrictive terms and conditions.
//
// Parlera is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Parlera.  If not, see <http://www.gnu.org/licenses/>.
//
// This file is derived from work covered by the following license notice:
//
//   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
//
//   Licensed under the Apache License, Version 2.0 (the "License");
//   you may not use this file except in compliance with the License.
//   You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in writing, software
//   distributed under the License is distributed on an "AS IS" BASIS,
//   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//   See the License for the specific language governing permissions and
//   limitations under the License.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:parlera/helpers/pictures.dart';

class CameraPreviewScreen extends StatefulWidget {
  const CameraPreviewScreen({Key? key}) : super(key: key);

  @override
  CameraPreviewScreenState createState() => CameraPreviewScreenState();
}

class CameraPreviewScreenState extends State<CameraPreviewScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const pictureInterval = 8;

  CameraController? controller;
  Directory? pictureDir;
  Timer? pictureTimer;
  FileSystemEntity? lastImage;

  AnimationController? imageAnimationController;
  Animation<double>? imageAnimation;
  late double lastImageOpacity;
  Duration opacityAnimationDuration = const Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    startTimer();
    initCamera();
    initAnimations();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    controller?.dispose();
    imageAnimationController?.dispose();
    stopTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        initCamera();
      }
    }
  }

  initCamera() async {
    if (controller != null) {
      await controller!.dispose();
    }

    pictureDir = await PicturesHelper.getDirectory(context);
    var frontCamera = await PicturesHelper.getCamera();

    controller = CameraController(
      frontCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    controller!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    try {
      await controller!.initialize();
    } on CameraException {
      print("Camera initialization exception");
    }

    if (mounted) {
      setState(() {});
    }
  }

  initAnimations() {
    imageAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    imageAnimation =
        Tween<double>(begin: 0, end: 1).animate(imageAnimationController!)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                lastImageOpacity = 0;
                Future.delayed(opacityAnimationDuration).then((_) {
                  imageAnimationController!.reset();
                });
              });
            }
          });
  }

  startTimer() {
    pictureTimer =
        Timer.periodic(const Duration(seconds: pictureInterval), savePicture);
  }

  stopTimer() {
    pictureTimer?.cancel();
  }

  savePicture(Timer timer) {
    if (controller == null) {
      return false;
    }

    controller!
        .takePicture(); // todo check: does this still save the picture? if not, save to ${pictureDir.path}/${DateTime.now().millisecondsSinceEpoch}.png

    Future.delayed(const Duration(seconds: 1)).then((_) async {
      List<FileSystemEntity?> files = await PicturesHelper.getFiles(context);
      setState(() {
        lastImageOpacity = 1;
        lastImage = files.last;
        imageAnimationController!.forward();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Container();
    }

    return Center(
      child: RotatedBox(
        quarterTurns: 1,
        child: Stack(
          children: [
            CameraPreview(controller!),
            if (lastImage != null)
              Positioned(
                right: 0,
                top: 0,
                child: AnimatedOpacity(
                  opacity: lastImageOpacity,
                  duration: opacityAnimationDuration,
                  child: ScaleTransition(
                    scale: imageAnimationController!,
                    child: Image.file(
                      lastImage as File,
                      fit: BoxFit.cover,
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
