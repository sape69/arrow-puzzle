import 'package:flutter_test/flutter_test.dart';

import 'package:arrow_puzzle/main.dart';

void main() {
  testWidgets('Arrow Puzzle opens', (tester) async {
    await tester.pumpWidget(const ArrowPuzzleApp());

    expect(find.text('ARROW PUZZLE'), findsOneWidget);
  });
}