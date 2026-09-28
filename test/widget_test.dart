import 'package:flutter_test/flutter_test.dart';
import 'package:fixu_app/main.dart';

void main() {
  testWidgets('FixU App load test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FixUApp());

    // Verify that login screen or app elements exist.
    expect(find.text('FixU'), findsOneWidget);
  });
}
