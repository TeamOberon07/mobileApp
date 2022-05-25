
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/MyHomePage.dart';
import 'package:mobile_app_poc/stateContext.dart';


void main() {
  testWidgets('Connect Wallet', (WidgetTester tester) async {
  // TODO: Implement test
    final btnConnect = find.byKey(ValueKey("ConnectWallet"));

    await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'ShopChain Mobile')));
    await tester.tap(btnConnect);
  });

   testWidgets('Orders', (WidgetTester tester) async {
  // TODO: Implement test

    var state = stateContext.getState();
    state.setAccount("e5b197d91ad002a18917ab4fdc6b6e0126797482");

    await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'ShopChain Mobile')));

    final btnOrders =  find.byKey(ValueKey("Orders"));
    await tester.tap(btnOrders);
  });

   testWidgets('Scan QR', (WidgetTester tester) async {
  // TODO: Implement test
     var state = stateContext.getState();
    state.setAccount("0xe5b197d91ad002a18917ab4fdc6b6e0126797482");

    await tester.pumpWidget(MaterialApp(home: MyHomePage(title: 'ShopChain Mobile')));

    final btnQR =  find.byKey(ValueKey("QR"));
    await tester.tap(btnQR);
  });
}