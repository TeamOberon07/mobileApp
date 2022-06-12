import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/OrdersPage.dart';
import 'package:mobile_app_poc/stateContext.dart';

void main() {
  testWidgets('OrdersPage timeout', (WidgetTester tester) async {

    await tester.pumpWidget(MaterialApp(home: OrdersPage()));
    await tester.pumpAndSettle(Duration(milliseconds: 1000));
  });

  testWidgets('OrdersPage one order', (WidgetTester tester) async {

    var orderPage = OrdersPage();
    orderPage.getOrders(jump:true);
    await tester.pumpWidget(MaterialApp(home: orderPage));
    
  });
}