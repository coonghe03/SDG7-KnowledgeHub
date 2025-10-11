import 'package:flutter_test/flutter_test.dart';

import 'package:sdg7_app/main.dart';

void main() {
  testWidgets('App builds without errors', (WidgetTester tester) async {
    // Build your actual app widget
    await tester.pumpWidget(const SDG7App());

    // Verify that the home page title appears
    expect(find.text('SDG7 – Knowledge Hub'), findsOneWidget);

    // You can also check one of the navigation buttons
    expect(find.text('Educational Videos'), findsOneWidget);
  });
}
