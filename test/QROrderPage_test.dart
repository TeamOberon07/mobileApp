import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/QROrderPage.dart';
import 'package:mobile_app_poc/stateContext.dart';

void main() {
  testWidgets('QROrderPage', (WidgetTester tester) async {
    var state = stateContext.getState();
    state.setAccount("0x90fc8a77e3a62a20f73cacaaa04c3a2c22452b62");
    state.setBarcodeResult("0x90fc8a77e3a62a20f73cacaaa04c3a2c22452b62:94");
    await tester.pumpWidget(MaterialApp(home: QROrderPage()));
  });

  testWidgets('QROrderPage', (WidgetTester tester) async {
    var state = stateContext.getState();
    state.setAccount("0x90fc8a77e3a62a20f73cacaa62");
    state.setBarcodeResult("0x90fc8a77e3a62a20f73cacaaa04c3a2c22452b62:94");
    await tester.pumpWidget(MaterialApp(home: QROrderPage()));
    final btnHP =  find.byKey(ValueKey("homepage"));
    await tester.tap(btnHP);
  });

  testWidgets('OrdersPage one order', (WidgetTester tester) async {
    var state = stateContext.getState();
    state.setAccount("0x90fc8a77e3a62a20f73cacaa62");
    state.setBarcodeResult("0x90fc8a77e3a62a20f73cacaaa04c3a2c22452b62:94");
    await tester.pumpWidget(MaterialApp(home: QROrderPage()));
    await tester.pumpAndSettle();
    
  });
  //Barcode  oggetto barcode vero in QR
  //result Stringa del QR
}