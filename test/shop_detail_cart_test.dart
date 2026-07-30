import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:se_project/models/user_session.dart';
import 'package:se_project/screens/shop_detail_screen.dart';

void main() {
  testWidgets('adding from shop detail adds item to the shared cart', (WidgetTester tester) async {
    UserSession().logout();
    final registered = UserSession().registerAccount(
      name: 'Test User',
      email: 'shop.detail@test.com',
      authType: 'email',
    );

    expect(registered, isTrue);

    await tester.pumpWidget(
      const MaterialApp(
        home: ShopDetailScreen(shop: {'name': 'Green Valley Farm'}),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Add to Cart').first);
    await tester.tap(find.text('Add to Cart').first);
    await tester.pump();

    expect(UserSession().currentUser?.cartItems.length, 1);
    expect(UserSession().currentUser?.cartItems.first.product['title'], 'Fresh Red Apple');
  });
}
