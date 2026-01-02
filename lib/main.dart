import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goal_nepal/app/app.dart';
import 'package:goal_nepal/core/services/hive/hive_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb) {
    final hiveService = HiveService();
    await hiveService.init();
    await hiveService.openBoxes();
  }

  runApp(ProviderScope(child: App()));
}
