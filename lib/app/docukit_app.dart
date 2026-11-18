import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'bindings/initial_binding.dart';
import '../core/constants/app_routes.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';

class DocuKitApp extends StatelessWidget {
  const DocuKitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DocuKit',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
