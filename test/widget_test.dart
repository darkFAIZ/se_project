// This is a basic Flutter widget test for Terra-Karsa.

import 'package:flutter_test/flutter_test.dart';
import 'package:se_project/main.dart';

void main() {
  testWidgets('Terra-Karsa marketplace smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const TerraKarsaApp()); // FIXED: Replaced MyApp with TerraKarsaApp

    // Verify that the Terra-Karsa header renders properly
    expect(find.text('Terra-Karsa Marketplace'), findsOneWidget);

    // Verify that default category chips exist
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Vegetables'), findsOneWidget);
  });
}