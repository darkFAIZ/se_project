// This is a basic Flutter widget test for Terra-Karsa.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:se_project/main.dart';
import 'package:se_project/screens/checkout_screen.dart';

void main() {
  testWidgets('Terra-Karsa marketplace smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const TerraKarsaApp());

    expect(find.text('Kebunku'), findsOneWidget);
    expect(find.text('Google'), findsOneWidget);
  });

  testWidgets('checkout form validates required billing information', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CheckoutScreen(
            cartItems: const [
              {
                'title': 'Fresh Organic Tomatoes',
                'price': 15000,
                'category': 'Vegetables',
                'farmer': 'Pak Tani',
                'origin': 'BOGOR',
                'stock': '50.0 kg',
                'quantity': 1,
              }
            ],
          ),
        ),
      ),
    );

    await tester.ensureVisible(find.text('Confirm Order'));
    await tester.tap(find.text('Confirm Order'));
    await tester.pump();

    expect(find.text('Please fill in all required information.'), findsOneWidget);
    expect(find.text('Payment Method'), findsOneWidget);
  });
}