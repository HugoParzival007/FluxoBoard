// FluxoBoard widget tests

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fluxo_board/main.dart';

void main() {
  testWidgets('App builds and shows FluxoBoard title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FluxoBoardApp(),
      ),
    );

    expect(find.text('FluxoBoard'), findsOneWidget);
  });
}
