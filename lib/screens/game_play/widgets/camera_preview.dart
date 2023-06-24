// // This file is part of Parlera.
// //
// // Parlera is free software: you can redistribute it and/or modify
// // it under the terms of the GNU Affero General Public License as published by
// // the Free Software Foundation, either version 3 of the License, or
// // (at your option) any later version. As an additional permission under
// // section 7, you are allowed to distribute the software through an app
// // store, even if that store has restrictive terms and conditions that
// // are incompatible with the AGPL, provided that the source is also
// // available under the AGPL with or without this permission through a
// // channel without those restrictive terms and conditions.
// //
// // Parlera is distributed in the hope that it will be useful,
// // but WITHOUT ANY WARRANTY; without even the implied warranty of
// // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// // GNU Affero General Public License for more details.
// //
// // You should have received a copy of the GNU Affero General Public License
// // along with Parlera.  If not, see <http://www.gnu.org/licenses/>.
// //
// // This file is derived from work covered by the following license notice:
// //
// //   Copyright 2021 Kamil Rykowski, Kamil Lewandowski, and Ewa Osiecka
// //
// //   Licensed under the Apache License, Version 2.0 (the "License");
// //   you may not use this file except in compliance with the License.
// //   You may obtain a copy of the License at
// //
// //       http://www.apache.org/licenses/LICENSE-2.0
// //
// //   Unless required by applicable law or agreed to in writing, software
// //   distributed under the License is distributed on an "AS IS" BASIS,
// //   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// //   See the License for the specific language governing permissions and
// //   limitations under the License.

// TODO CAMERA: Make it work and work well

// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:parlera/helpers/pictures.dart';

// class CameraPreviewScreen extends StatefulWidget {
//   const CameraPreviewScreen({Key? key}) : super(key: key);

//   @override
//   CameraPreviewScreenState createState() => CameraPreviewScreenState();
// }

// class CameraPreviewScreenState extends State<CameraPreviewScreen>
//     with TickerProviderStateMixin, WidgetsBindingObserver {
//   static const _pictureInterval = 8;

//   late CameraController _controller;
//   late Directory _pictureDir;
//   Timer? _pictureTimer;
//   FileSystemEntity? _lastImage;

//   late final AnimationController _imageAnimationController;
//   Animation<double>? _imageAnimation;
//   late double _lastImageOpacity;
//   final Duration _opacityAnimationDuration = const Duration(milliseconds: 1000);

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//     _initCamera();
//     _initAnimations();
//     WidgetsBinding.instance!.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance!.removeObserver(this);
//     _controller.dispose();
//     _imageAnimationController.dispose();
//     _stopTimer();
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.inactive) {
//       _controller.dispose();
//     } else if (state == AppLifecycleState.resumed) {
//       _initCamera();
//     }
//   }

//   void _initCamera() async {
//     if (_controller != null) {
//       await _controller.dispose();
//     }

//     _pictureDir = await PicturesHelper.getDirectory(context);
//     var frontCamera = await PicturesHelper.getCamera();

//     _controller = CameraController(
//       frontCamera,
//       ResolutionPreset.high,
//       enableAudio: false,
//     );
//     _controller.addListener(() {
//       if (mounted) {
//         setState(() {});
//       }
//     });

//     try {
//       await _controller.initialize();
//     } on CameraException {
//       print("Camera initialization exception");
//     }

//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void _initAnimations() {
//     _imageAnimationController = AnimationController(
//         vsync: this, duration: const Duration(milliseconds: 1500));
//     _imageAnimation =
//         Tween<double>(begin: 0, end: 1).animate(_imageAnimationController)
//           ..addStatusListener((status) {
//             if (status == AnimationStatus.completed) {
//               setState(() {
//                 _lastImageOpacity = 0;
//                 Future.delayed(_opacityAnimationDuration).then((_) {
//                   _imageAnimationController.reset();
//                 });
//               });
//             }
//           });
//   }

//   void _startTimer() {
//     _pictureTimer =
//         Timer.periodic(const Duration(seconds: _pictureInterval), _savePicture);
//   }

//   void _stopTimer() {
//     _pictureTimer?.cancel();
//   }

//   void _savePicture(Timer timer) async {
//     final XFile picture = await _controller
//         .takePicture(); // todo check: does this still save the picture? if not, save to ${pictureDir.path}/${DateTime.now().millisecondsSinceEpoch}.png
//     picture.saveTo(
//         '${_pictureDir.path}/${DateTime.now().millisecondsSinceEpoch}.png');

//     Future.delayed(const Duration(seconds: 1)).then((_) async {
//       //TODO test if can't just do directly, without delay
//       List<FileSystemEntity?> files = await PicturesHelper.getFiles(context);
//       setState(() {
//         _lastImageOpacity = 1;
//         _lastImage = files.last;
//         _imageAnimationController.forward();
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: RotatedBox(
//         quarterTurns: 1,
//         child: Stack(
//           children: [
//             CameraPreview(_controller),
//             if (_lastImage != null)
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: AnimatedOpacity(
//                   opacity: _lastImageOpacity,
//                   duration: _opacityAnimationDuration,
//                   child: ScaleTransition(
//                     scale: _imageAnimationController,
//                     child: Image.file(
//                       _lastImage as File,
//                       fit: BoxFit.cover,
//                       width: 100,
//                       height: 100,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
