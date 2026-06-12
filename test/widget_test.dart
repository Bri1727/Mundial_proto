import 'package:flutter_test/flutter_test.dart';

import 'package:mundialflutter2026/main.dart';

void main() {
  testWidgets('App se inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MundialApp());
    await tester.pumpAndSettle();

    expect(find.text('Mundial 2026'), findsOneWidget);
  });
}
