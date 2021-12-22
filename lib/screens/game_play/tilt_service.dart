import 'dart:async';

import 'package:sensors_plus/sensors_plus.dart';

class TiltService {
  late StreamSubscription<AccelerometerEvent> _rotateSubscription;
  final Function() handleValid;
  final Function() handleInvalid;
  final bool Function() isPlaying;

  TiltService(
      {required this.isPlaying,
      required this.handleValid,
      required this.handleInvalid}) {
    bool safePosition = true;
    double rotationBorder = 9.5;

    _rotateSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      if (isPlaying()) {
        return;
      }

      if (event.z > rotationBorder) {
        if (safePosition) {
          safePosition = false;
          handleInvalid();
        }
      } else if (event.z < -rotationBorder) {
        if (safePosition) {
          safePosition = false;
          handleValid();
        }
      } else if (event.z.abs() > rotationBorder / 2) {
        safePosition = true;
      }
    });
  }

  void dispose() {
    _rotateSubscription.cancel();
  }
}
