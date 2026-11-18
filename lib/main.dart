import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/docukit_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const DocuKitApp());
}
