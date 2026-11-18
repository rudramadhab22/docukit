import 'package:docukit/app/docukit_app.dart';
import 'package:docukit/core/constants/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Home shows DocuKit brand and tools', (tester) async {
    await tester.pumpWidget(const DocuKitApp());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.appTagline), findsOneWidget);
    expect(find.text('Word to PDF'), findsOneWidget);
    expect(find.text('Convert'), findsOneWidget);
  });
}
