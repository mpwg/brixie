import 'package:flutter_test/flutter_test.dart';
import 'package:brixie/main.dart';

void main() {
  testWidgets('Brixie app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BrixieApp());

    // Verify that the app title is displayed
    expect(find.text('Brixie'), findsOneWidget);
    
    // Verify that the home text is displayed
    expect(find.text('This is home Fragment'), findsOneWidget);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that the snackbar message appears
    expect(find.text('Replace with your own action'), findsOneWidget);
  });
}