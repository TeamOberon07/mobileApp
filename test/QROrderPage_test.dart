import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/QROrderPage.dart';

void main() {
     testWidgets('QROrderPage', (WidgetTester tester) async {
  // TODO: Implement test

    await tester.pumpWidget(MaterialApp(home: QROrderPage()));
  });
}