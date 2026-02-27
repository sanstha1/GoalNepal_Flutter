import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';

final shakeServiceProvider = Provider<ShakeService>((ref) {
  return ShakeService();
});

class ShakeService {
  static const double _shakeThreshold = 15.0;
  static const int _shakeMinInterval = 1000; // ms between shakes

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShakeTime;
  VoidCallback? _onShake;

  void start({required VoidCallback onShake}) {
    _onShake = onShake;
    _subscription = accelerometerEventStream().listen((event) {
      final magnitude = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (magnitude > _shakeThreshold) {
        final now = DateTime.now();
        if (_lastShakeTime == null ||
            now.difference(_lastShakeTime!).inMilliseconds >
                _shakeMinInterval) {
          _lastShakeTime = now;
          _onShake?.call();
        }
      }
    });
  }

  void stop() {
    _subscription?.cancel();
    _subscription = null;
  }
}

typedef VoidCallback = void Function();
