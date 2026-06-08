import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:catch_the_cat/app.dart';

void main() {
  testWidgets('Game renders hex grid', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: CatchTheCatApp()));

    expect(find.text('围住小猫'), findsOneWidget);
    expect(find.text('点击小圆点，围住小猫'), findsOneWidget);
    expect(find.text('悔棋'), findsOneWidget);
    expect(find.text('重开'), findsOneWidget);
  });
}
