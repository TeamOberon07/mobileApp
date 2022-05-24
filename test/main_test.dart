import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app_poc/main.dart';

void main() {
  testWidgets('Visualizzazione home', (WidgetTester tester) async {
  // TODO: Implement test
    await tester.pumpWidget(MyApp());
  });
}