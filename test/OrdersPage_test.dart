import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/OrdersPage.dart';

void main() {
  testWidgets('OrdersPage', (WidgetTester tester) async {
  // TODO: Implement test

    await tester.pumpWidget(MaterialApp(home: OrdersPage()));
  });
}